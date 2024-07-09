local wezterm = require("wezterm")
local io = require("io")
local os = require("os")
local act = wezterm.action

local config = {}

config.enable_wayland = false

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_domain = "WSL:NixOS"
	config.window_background_opacity = 0.98
	-- config.window_background_opacity = 0.7
	-- config.win32_system_backdrop = "Acrylic"
	config.allow_win32_input_mode = false
end

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		-- return "catppuccin-frappe"
		-- return "tokyonight_storm"
		return "sweetie_dark"
	else
		-- return "catppuccin-latte"
		-- return "tokyonight_day"
		return "sweetie_light"
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.window_background_opacity = 0.95
config.macos_window_background_blur = 30
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.colors = {
	cursor_bg = "#838ba7",
	cursor_fg = "#232634",
	cursor_border = "#c6d0f5",

	tab_bar = {
		-- The color of the strip that goes along the top of the window
		-- (does not apply when fancy tab bar is in use)
		background = "#303446",

		-- The active tab is the one that has focus in the window
		active_tab = {
			-- The color of the background area for the tab
			bg_color = "#414559",
			-- The color of the text for the tab
			fg_color = "#c6d0f5",

			-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
			-- label shown for this tab.
			-- The default is "Normal"
			intensity = "Normal",

			-- Specify whether you want "None", "Single" or "Double" underline for
			-- label shown for this tab.
			-- The default is "None"
			underline = "None",

			-- Specify whether you want the text to be italic (true) or not (false)
			-- for this tab.  The default is false.
			italic = false,

			-- Specify whether you want the text to be rendered with strikethrough (true)
			-- or not for this tab.  The default is false.
			strikethrough = false,
		},

		-- Inactive tabs are the tabs that do not have focus
		inactive_tab = {
			bg_color = "#292c3c",
			fg_color = "#c6d0f5",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over inactive tabs
		inactive_tab_hover = {
			bg_color = "#51576d",
			fg_color = "#c6d0f5",
			italic = false,

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab_hover`.
		},

		-- The new tab button that let you create new tabs
		new_tab = {
			bg_color = "#292c3c",
			fg_color = "#c6d0f5",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		new_tab_hover = {
			bg_color = "#51576d",
			fg_color = "#c6d0f5",
			italic = false,

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab_hover`.
		},
	},
}
-- config.force_reverse_video_cursor = true
config.cursor_blink_rate = 0
config.default_cursor_style = "SteadyBar"
config.font = wezterm.font("Fira Code")
config.font_size = 13.0

config.window_close_confirmation = "NeverPrompt"
config.enable_kitty_keyboard = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.switch_to_last_active_tab_when_closing_tab = true

config.enable_kitty_graphics = true

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "CTRL|SHIFT" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end
local function fuzzy_session_picker(window, pane)
	local cmd = [[
		echo "$({
			  find ~/Development ~/Projects -mindepth 1 -maxdepth 1 -type d 2>/dev/null
		})"
	]]
	local file = io.popen(cmd)
	if file == nil then
		return
	end
	local output = file:read("*a")
	file:close()

	local choices = {}
	for directory in string.gmatch(output, "([^\n]+)") do
		table.insert(choices, { label = directory })
	end

	window:perform_action(
		act.InputSelector({
			title = "Workspaces",
			fuzzy = true,
			choices = choices,
			action = wezterm.action_callback(function(window, pane, id, label)
				if label then
					window:perform_action(
						act.SwitchToWorkspace({
							name = label:match("([^/]+)$"),
							spawn = {
								cwd = label,
							},
						}),
						pane
					)
				end
			end),
		}),
		pane
	)
end

local SpawnCommandInTabNext = function(opts)
	local function active_tab_index(window)
		for _, item in ipairs(window:mux_window():tabs_with_info()) do
			if item.is_active then
				return item.index
			end
		end
	end

	return function(win, pane)
		local prev_active_tab_index = active_tab_index(win)
		win:perform_action(
			act.SpawnCommandInNewTab({
				args = { "zsh", "-c", opts.cmd },
			}),
			pane
		)
		win:perform_action(act.MoveTab(prev_active_tab_index + 1), pane)
	end
end

-- config.debug_key_events = true
config.leader = { key = "a", mods = "CTRL" }
config.keys = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = act.SendKey({ key = "a", mods = "CTRL" }),
	},

	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
	{
		key = "\\",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "!",
		mods = "LEADER | SHIFT",
		action = wezterm.action_callback(function(_win, pane)
			local tab, _window = pane:move_to_new_tab()
			tab:activate()
		end),
	},

	{
		key = "o",
		mods = "LEADER",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	{ key = "Tab", mods = "LEADER", action = wezterm.action.SwitchWorkspaceRelative(1) },
	{ key = "Tab", mods = "LEADER | SHIFT", action = wezterm.action.SwitchWorkspaceRelative(-1) },
	{
		key = "f",
		mods = "LEADER",
		action = wezterm.action_callback(fuzzy_session_picker),
	},
	{
		key = "R",
		mods = "SHIFT|SUPER",
		action = wezterm.action_callback(fuzzy_session_picker),
	},

	{
		key = "v",
		mods = "LEADER",
		action = act.EmitEvent("trigger-vim-with-scrollback"),
	},
	{
		key = "g",
		mods = "LEADER",
		action = wezterm.action_callback(SpawnCommandInTabNext({ cmd = "lazygit" })),
	},
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action_callback(SpawnCommandInTabNext({ cmd = "gh dash" })),
	},
	{
		key = "b",
		mods = "LEADER",
		action = wezterm.action_callback(SpawnCommandInTabNext({ cmd = "yazi" })),
	},
	{ key = "p", mods = "LEADER", action = act.PasteFrom("Clipboard") },
	{ key = "Insert", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "Insert", mods = "SHIFT", action = act.PasteFrom("Clipboard") },
	{ key = "-", mods = "CTRL", action = act.DisableDefaultAssignment },
}

for i = 1, 9 do
	-- LEADER + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
	-- table.insert(config.keys, {
	-- 	key = tostring(i),
	-- 	mods = "CTRL",
	-- 	action = act.ActivateTab(i - 1),
	-- })
end

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(wezterm.format({
		{ Background = { AnsiColor = "Blue" } },
		{ Foreground = { Color = "#232634" } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = " " .. window:active_workspace() .. " " },
	}))
end)

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
	-- Retrieve the text from the pane
	local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

	-- Create a temporary file to pass to vim
	local name = os.tmpname()
	local f = io.open(name, "w+")
	if f == nil then
		return
	end
	f:write(text)
	f:flush()
	f:close()

	-- Open a new window running vim and tell it to open the file
	window:perform_action(
		act.SpawnCommandInNewTab({
			args = { "nvim", name },
		}),
		pane
	)

	-- Wait "enough" time for vim to read the file before we remove it.
	-- The window creation and process spawn are asynchronous wrt. running
	-- this script and are not awaitable, so we just pick a number.
	--
	-- Note: We don't strictly need to remove this file, but it is nice
	-- to avoid cluttering up the temporary directory.
	wezterm.sleep_ms(1000)
	os.remove(name)
end)

return config

-- vim: ts=2 sts=2 sw=2 et
