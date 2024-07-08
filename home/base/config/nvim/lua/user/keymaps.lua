---@diagnostic disable: redundant-parameter
local utils = require 'user.utils'

local M = {}

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'q:', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Keep cursor location when joining lines
vim.keymap.set('n', 'J', 'mzJ`z', { silent = true })

-- Center screen after jump and search
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })
vim.keymap.set('n', 'n', 'nzzzv', { silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = true })
vim.keymap.set('n', '{', '{zz', { noremap = true, silent = true })
vim.keymap.set('n', '}', '}zz', { noremap = true, silent = true })
vim.keymap.set('n', '%', '%zz', { noremap = true, silent = true })
vim.keymap.set('n', '*', '*zz', { noremap = true, silent = true })
vim.keymap.set('n', '#', '#zz', { noremap = true, silent = true })

-- Paste over visual selection, but don't yank it
vim.keymap.set('x', 'p', '"_dP', { silent = true })
-- Don't yank x
vim.keymap.set({ 'n', 'v', 'x' }, 'x', '"_x', { silent = true, noremap = true })
-- copying and pasting to/from system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = '[Y]ank system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', [["+p]], { desc = '[P]aste system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>Y', ':YankBank<cr>', { desc = '[Y]ank bank' })

vim.keymap.set('n', 'Q', '@qj', { desc = 'Replay @q' })
vim.keymap.set('x', 'Q', ':norm @q<CR>', { desc = 'Replay @q' })

-- vertical split
vim.keymap.set('n', '<C-\\>', ':vsplit<CR>')

-- Swap between last two buffers
vim.keymap.set('n', "<leader>'", '<C-^>', { desc = 'Switch to last buffer' })

M.bufjump = {
  {
    '<S-Up>',
    function()
      require('bufjump').forward()
    end,
    { noremap = true, silent = true, desc = 'Jump File Forward' },
  },
  {
    '<S-Down>',
    function()
      require('bufjump').backward()
    end,
    { noremap = true, silent = true, desc = 'Jump File Backward' },
  },
  {
    '<S-Right>',
    function()
      require('bufjump').forward_same_buf()
    end,
    { noremap = true, silent = true, desc = 'Jump In File Forward' },
  },
  {
    '<S-Left>',
    function()
      require('bufjump').backward_same_buf()
    end,
    { noremap = true, silent = true, desc = 'Jump In File Backward' },
  },
}

vim.keymap.set({ 'n', 'x' }, '<leader>sr', function()
  require('rip-substitute').sub()
end, { desc = '[S]earch and [R]eplace in file' })
vim.keymap.set('n', '<leader>sR', function()
  require('grug-far').grug_far()
end, { desc = '[S]earch and [R]eplace in workspace' })
vim.keymap.set('n', '<leader>sa', function()
  require('grug-far').grug_far { prefills = { search = vim.fn.expand '<cword>' } }
end, { desc = '[S]earch and Replace word' })
vim.keymap.set('x', '<leader>sa', function()
  require('grug-far').with_visual_selection()
end, { desc = '[S]earch and Replace selection' })
vim.keymap.set('n', '<leader>sA', function()
  require('grug-far').grug_far { prefills = { search = vim.fn.expand '<cword>', flags = vim.fn.expand '%' } }
end, { desc = '[S]earch and Replace word in file' })
vim.keymap.set('x', '<leader>sA', function()
  require('grug-far').with_visual_selection { prefills = { flags = vim.fn.expand '%' } }
end, { desc = '[S]earch and Replace selection in file' })
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('extra-grug-far-keybinds', { clear = true }),
  pattern = { 'grug-far' },
  callback = function()
    vim.keymap.set('n', '<localleader>w', function()
      require('grug-far').toggle_flags { '--fixed-strings' }
    end, { buffer = true })
  end,
})

vim.keymap.set('n', '<leader>b', '<cmd>!wezterm cli spawn --cwd $PWD -- zsh -c yazi<CR><CR>', { desc = '[B]rowse' })

vim.keymap.set('n', '<leader>or', ':OverseerRun<CR>', { desc = '[O]verseer [R]un' })
vim.keymap.set('n', '<leader>oc', ':OverseerRunCmd<CR>', { desc = '[O]verseer [R]un' })
vim.keymap.set('n', '<leader>ot', ':OverseerToggle<CR>', { desc = '[O]verseer [T]oggle' })
vim.keymap.set('n', '<leader>oT', ':OverseerToggle!<CR>', { desc = '[O]verseer [T]oggle' })

M.recall = {
  {
    '<leader>mm',
    function()
      require('recall').toggle {}
    end,
    { noremap = true, silent = true },
    desc = 'Toggle [M]ark',
  },
  {
    '<leader>mj',
    function()
      require('recall').goto_next {}
    end,
    { noremap = true, silent = true },
    desc = 'Goto next mark',
  },
  {
    '<leader>mk',
    function()
      require('recall').goto_prev {}
    end,
    { noremap = true, silent = true },
    desc = 'Goto previous mark',
  },
  {
    '<leader>mc',
    function()
      require('recall').clear {}
    end,
    { noremap = true, silent = true },
    desc = 'Clear marks',
  },
  { '<leader>ml', ':Telescope recall<CR>', { noremap = true, silent = true }, desc = 'List Marks' },
}

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = utils.find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
      additional_args = function()
        return { '--hidden' }
      end,
    }
  end
end
vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader><space>', function()
  require('telescope.builtin').oldfiles {}
end, { desc = '[ ] Find recently opened files' })
vim.keymap.set('n', '<leader>?', function()
  require('telescope.builtin').buffers {}
end, { desc = '[?] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find()
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sF', function()
  require('telescope.builtin').git_files {}
end, { desc = 'Search Git [F]iles' })
vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').find_files { hidden = true }
end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', ':Telescope git_file_history<cr>', { desc = '[S]earch file [H]istory' })
vim.keymap.set('n', '<leader>sH', function()
  require('telescope.builtin').help_tags {}
end, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', function()
  require('telescope.builtin').grep_string {}
end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', function()
  require('telescope.builtin').live_grep {}
end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>ss', function()
  require('telescope.builtin').lsp_document_symbols {}
end, { desc = '[S]earch Document [S]ymbols' })
vim.keymap.set('n', '<leader>sS', function()
  require('telescope.builtin').lsp_dynamic_workspace_symbols {}
end, { desc = '[S]earch Workspace [S]ymbols' })
vim.keymap.set('n', '<leader>sd', function()
  require('telescope.builtin').diagnostics {}
end, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sc', function()
  require('telescope.builtin').resume {}
end, { desc = '[C]ontinue Search' })
vim.keymap.set('n', '<leader>s/', function()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>st', function()
  require('telescope.builtin').builtin {}
end, { desc = '[S]earch Select [T]elescope' })

-- Git keymaps
vim.keymap.set('n', '<leader>gb', function()
  require('telescope.builtin').git_branches {}
end, { desc = '[G]it [B]ranches' })
M.neogit = {
  { '<leader>gS', ':Neogit kind=auto<cr>', desc = 'Neo[G]it [S]tatus' },
  { '<leader>gc', ':Neogit commit<cr>', desc = '[G]it [C]ommit' },
}
vim.keymap.set('n', '<leader>sd', function()
  require('telescope.builtin').git_status {}
end, { desc = '[S]earch Git [D]iff' })
M.lazygit = {
  { '<leader>gg', ':LazyGit<cr>', desc = '[G]it [G]ui' },
}
M.git_worktree = {
  {
    '<leader>gw',
    function()
      require('telescope').extensions.git_worktree.git_worktrees()
    end,
    desc = '[G]it [W]orktrees',
  },
  {
    '<leader>gW',
    function()
      require('telescope').extensions.git_worktree.create_git_worktree()
    end,
    desc = 'Create Worktree',
  },
}
M.octo = {
  { '<leader>go', '<cmd>Octo<cr>', desc = 'GitHub PRs' },
}
M.gh_addressed = {
  { '<leader>gc', '<cmd>GhReviewComments<cr>', desc = 'GitHub Review Comments' },
}
M.gh_blame = {
  { '<leader>gB', '<cmd>GhBlameCurrentLine<cr>', desc = 'GitHub PR Blame Current Line' },
}
vim.keymap.set('n', '<leader>gh', '<cmd>!wezterm cli spawn --cwd $PWD -- zsh -c "gh dash"<CR><CR>', { desc = '[G]it [H]ub dash' })

M.map_gitsigns_keybinds = function(bufnr)
  vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

  -- don't override the built-in and fugitive keymaps
  local gs = package.loaded.gitsigns

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end
  -- Navigation
  map({ 'n', 'v' }, ']c', function()
    if vim.wo.diff then
      return ']c'
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Jump to next hunk' })
  map({ 'n', 'v' }, '[c', function()
    if vim.wo.diff then
      return '[c'
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Jump to previous hunk' })
  -- Actions
  -- visual mode
  map('v', '<leader>hs', function()
    gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = 'stage git hunk' })
  map('v', '<leader>hr', function()
    gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = 'reset git hunk' })
  -- normal mode
  map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
  map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
  map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
  map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
  map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
  map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
  map('n', '<leader>hb', function()
    gs.blame_line { full = false }
  end, { desc = 'git blame line' })
  map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
  map('n', '<leader>hD', function()
    gs.diffthis '~'
  end, { desc = 'git diff against last commit' })
  -- Toggles
  map('n', '<leader>tb', ':BlameToggle<CR>', { desc = 'toggle git blame' })
  map('n', '<leader>tB', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
  map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })
  map('n', '<leader>to', '<cmd>Outline<CR>', { desc = 'toggle outline' })
  map('n', '<leader>ti', function()
    ---@diagnostic disable-next-line: missing-parameter
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = 'toggle inline hints' })
  map('n', '<leader>tu', ':UndotreeToggle<CR>', { desc = 'toggle undo tree' })
  -- Text object
  map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
end

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev {}
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next {}
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Go to previous error' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Go to next error' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', ':TroubleToggle<CR>', { desc = 'Open diagnostics list' })
M.actions_preview = {
  {
    '<leader>-',
    function()
      require('actions-preview').code_actions {}
    end,
    desc = 'Code actions',
    silent = true,
    noremap = true,
  },
}

M.map_lsp_keybinds = function(bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, 'Refactor Re[n]ame')
  nmap('<leader>.', vim.lsp.buf.code_action, 'Code Action')

  nmap('gd', function()
    require('telescope.builtin').lsp_definitions {}
  end, '[G]oto [D]efinition')
  nmap('gr', function()
    require('telescope.builtin').lsp_references {}
  end, '[G]oto [R]eferences')
  nmap('gI', function()
    require('telescope.builtin').lsp_implementations {}
  end, '[G]oto [I]mplementation')
  nmap('gD', function()
    require('telescope.builtin').lsp_type_definitions {}
  end, '[G]oto Type [D]efinition')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation', noremap = true, silent = true, buffer = bufnr })

  -- Lesser used LSP functionality
  nmap('gC', vim.lsp.buf.declaration, '[G]oto De[C]laration')
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap('<leader>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'FormatLSP', function(_)
    vim.lsp.buf.format {}
  end, { desc = 'LSP: Format current buffer with LSP' })
end
M.conform = {
  {
    '<leader>f',
    function()
      require('conform').format { async = true, lsp_fallback = true }
    end,
    mode = '',
    desc = 'Format buffer',
  },
}

-- Refactoring
vim.keymap.set('x', '<leader>re', ':Refactor extract ')
vim.keymap.set('x', '<leader>rf', ':Refactor extract_to_file ')
vim.keymap.set('x', '<leader>rv', ':Refactor extract_var ')
vim.keymap.set({ 'n', 'x' }, '<leader>ri', ':Refactor inline_var')
vim.keymap.set('n', '<leader>rI', ':Refactor inline_func')
vim.keymap.set('n', '<leader>rb', ':Refactor extract_block')
vim.keymap.set('n', '<leader>rbf', ':Refactor extract_block_to_file')

-- Vim Illuminate keybinds
vim.keymap.set('n', ']r', function()
  require('illuminate').goto_next_reference()
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Illuminate: Goto next reference' })
vim.keymap.set('n', '[r', function()
  require('illuminate').goto_prev_reference()
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Illuminate: Goto previous reference' })

M.package_info = {
  -- Show dependency versions
  {
    '<LEADER>ns',
    function()
      require('package-info').show {}
    end,
    desc = '[N]pm [S]how',
    silent = true,
    noremap = true,
    ft = { 'json' },
  },
  -- Hide dependency versions
  {
    '<LEADER>nc',
    function()
      require('package-info').hide {}
    end,
    desc = '[N]pm [C]lear',
    silent = true,
    noremap = true,
    ft = { 'json' },
  },
  -- Toggle dependency versions
  {
    '<LEADER>nt',
    function()
      require('package-info').toggle {}
    end,
    desc = '[N]pm [T]oggle',
    silent = true,
    noremap = true,
    ft = { 'json' },
  },
  -- Update dependency on the line
  {
    '<LEADER>nu',
    function()
      require('package-info').update {}
    end,
    desc = '[N]pm [U]pdate',
    silent = true,
    noremap = true,
    ft = { 'json' },
  },
  -- Delete dependency on the line
  {
    '<LEADER>nd',
    function()
      require('package-info').delete {}
    end,
    desc = '[N]pm [D]elete',
    silent = true,
    noremap = true,
    ft = { 'json' },
  },
  -- Install a new dependency
  {
    '<LEADER>ni',
    function()
      require('package-info').install {}
    end,
    desc = '[N]pm [I]nstall',
    silent = true,
    noremap = true,
    ft = { 'json' },
  },
  -- Install a different dependency version
  {
    '<LEADER>nc',
    function()
      require('package-info').change_version {}
    end,
    desc = '[N]pm [C]hange version',
    silent = true,
    noremap = true,
    ft = { 'json' },
  },
}
-- Neotree
M.neotree = {
  { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  { '<leader>gs', ':Neotree float git_status<CR>', desc = '[G]it [S]tatus' },
}

-- Neotest
M.neotest = {
  {
    '<leader>Tt',
    function()
      require('neotest').run.run()
    end,
    desc = 'Run nearest test',
  },
  {
    '<leader>Tf',
    function()
      require('neotest').run.run(vim.fn.expand '%:p')
    end,
    desc = 'Run tests in current file',
  },
  {
    '<leader>Td',
    function()
      ---@diagnostic disable-next-line: missing-fields
      require('neotest').run.run { strategy = 'dap' }
    end,
    desc = 'Debug nearest test',
  },
  {
    '<leader>TS',
    function()
      require('neotest').run.stop()
    end,
    desc = 'Stop nearest test',
  },
  {
    '<leader>Tm',
    function()
      require('neotest').summary.run_marked()
    end,
    desc = 'Run marked tests',
  },
  {
    '<leader>Ts',
    function()
      require('neotest').summary.toggle()
    end,
    desc = 'Toggle panel',
  },
  {
    '<leader>Tw',
    "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
    desc = 'Jest [W]atch mode',
  },
}

-- Terminal
-- Enter normal mode while in a terminal
vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Smart Splits
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set('n', '<A-h>', function()
  require('smart-splits').resize_left {}
end)
vim.keymap.set('n', '<A-j>', function()
  require('smart-splits').resize_down {}
end)
vim.keymap.set('n', '<A-k>', function()
  require('smart-splits').resize_up {}
end)
vim.keymap.set('n', '<A-l>', function()
  require('smart-splits').resize_right {}
end)
-- moving between splits
vim.keymap.set('n', '<C-h>', function()
  require('smart-splits').move_cursor_left {}
end)
vim.keymap.set('n', '<C-j>', function()
  require('smart-splits').move_cursor_down {}
end)
vim.keymap.set('n', '<C-k>', function()
  require('smart-splits').move_cursor_up {}
end)
vim.keymap.set('n', '<C-l>', function()
  require('smart-splits').move_cursor_right {}
end)
-- swapping buffers between windows
-- vim.keymap.set('n', '<leader><leader>h', function()
--   require('smart-splits').swap_buf_left {}
-- end)
-- vim.keymap.set('n', '<leader><leader>j', function()
--   require('smart-splits').swap_buf_down {}
-- end)
-- vim.keymap.set('n', '<leader><leader>k', function()
--   require('smart-splits').swap_buf_up {}
-- end)
-- vim.keymap.set('n', '<leader><leader>l', function()
--   require('smart-splits').swap_buf_right {}
-- end)

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
  -- ['<leader>H'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
  ['<leader>m'] = { name = '[M]arks', _ = 'which_key_ignore' },
  ['<leader>o'] = { name = '[O]verseer', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]efactor', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]oggles', _ = 'which_key_ignore' },
  ['<leader>T'] = { name = '[T]ests', _ = 'which_key_ignore' },
  -- ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

return M
