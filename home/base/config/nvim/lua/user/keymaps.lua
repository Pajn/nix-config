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
vim.keymap.set({ 'n', 'v' }, '<leader>p', [["+p]], { desc = '[p]aste system clipboard' })
M.yankbank = {
  {
    '<leader>y',
    '<cmd>YankBank<CR>',
    mode = { 'n', 'v' },
    desc = '[y]ank bank',
  },
}

vim.keymap.set('n', 'Q', '@qj', { desc = 'Replay @q' })
vim.keymap.set('x', 'Q', '<cmd>norm @q<CR>', { desc = 'Replay @q' })

-- vertical split
vim.keymap.set('n', '<C-\\>', '<cmd>vsplit<CR>')

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

-- Search and Replace
M.rip_substitute = {
  {
    '<leader>sr',
    function()
      require('rip-substitute').sub()
    end,
    mode = { 'n', 'x' },
    desc = '[s]earch and [r]eplace in file',
  },
}
M.grug_far = {
  {
    '<leader>sR',
    function()
      require('grug-far').grug_far()
    end,
    desc = '[s]earch and [R]eplace in workspace',
  },
  {
    '<leader>sa',
    function()
      require('grug-far').grug_far { prefills = { search = vim.fn.expand '<cword>' } }
    end,
    desc = '[s]earch [a]nd Replace word',
  },
  {
    '<leader>sa',
    function()
      require('grug-far').with_visual_selection()
    end,
    desc = '[s]earch [a]nd Replace selection',
    mode = 'x',
  },
  {
    '<leader>sA',
    function()
      require('grug-far').grug_far { prefills = { search = vim.fn.expand '<cword>', flags = vim.fn.expand '%' } }
    end,
    desc = '[s]earch [A]nd Replace word in file',
  },
  {
    '<leader>sA',
    function()
      require('grug-far').with_visual_selection { prefills = { flags = vim.fn.expand '%' } }
    end,
    desc = '[s]earch [A]nd Replace selection in file',
    mode = 'x',
  },
}
M.grug_far_buffer = function()
  vim.keymap.set('n', '<localleader>w', function()
    require('grug-far').toggle_flags { '--fixed-strings' }
  end, { buffer = true })
end

vim.keymap.set('n', '<leader>b', '<cmd>!wezterm cli spawn --cwd $PWD -- zsh -c yazi<CR><CR>', { desc = '[b]rowse' })

M.overseer = {
  { '<leader>or', '<cmd>OverseerRun<CR>', desc = '[o]verseer [r]un' },
  { '<leader>oc', '<cmd>OverseerRunCmd<CR>', desc = '[o]verseer [c]ommand' },
  { '<leader>ot', '<cmd>OverseerToggle<CR>', desc = '[o]verseer [t]oggle' },
  { '<leader>oT', '<cmd>OverseerToggle!<CR>', desc = '[o]verseer [T]oggle' },
}

M.recall = {
  {
    'mm',
    function()
      require('recall').toggle {}
    end,
    { noremap = true, silent = true },
    desc = 'Toggle [M]ark',
  },
  {
    'mj',
    function()
      require('recall').goto_next {}
    end,
    { noremap = true, silent = true },
    desc = 'Goto next mark',
  },
  {
    'mk',
    function()
      require('recall').goto_prev {}
    end,
    { noremap = true, silent = true },
    desc = 'Goto previous mark',
  },
  {
    'mc',
    function()
      require('recall').clear {}
    end,
    { noremap = true, silent = true },
    desc = 'Clear marks',
  },
  { 'ml', '<cmd>Telescope recall<CR>', { noremap = true, silent = true }, desc = 'List Marks' },
}

-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}
M.telescope = {
  {
    '<leader><space>',
    function()
      require('telescope.builtin').oldfiles {}
    end,
    desc = '[ ] Find recently opened files',
  },
  {
    '<leader>?',
    function()
      require('telescope.builtin').buffers {}
    end,
    desc = '[?] Find existing buffers',
  },
  {
    '<leader>/',
    function()
      require('telescope.builtin').current_buffer_fuzzy_find()
    end,
    desc = '[/] Fuzzily search in current buffer',
  },
  {
    '<leader>sf',
    function()
      local builtin = require 'telescope.builtin'
      local opts = { hidden = true, show_untracked = true }

      local cwd = vim.fn.getcwd()
      if is_inside_work_tree[cwd] == nil then
        vim.fn.system 'git rev-parse --is-inside-work-tree'
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
      end

      if is_inside_work_tree[cwd] then
        builtin.git_files(opts)
      else
        builtin.find_files(opts)
      end
    end,
    desc = 'Search [f]iles',
  },
  {
    '<leader>sF',
    function()
      require('telescope.builtin').find_files { hidden = true }
    end,
    desc = '[s]earch all [F]iles',
  },
  {
    '<leader>sh',
    function()
      require('telescope.builtin').git_file_history {}
    end,
    desc = '[s]earch file [h]istory',
  },
  {
    '<leader>sH',
    function()
      require('telescope.builtin').help_tags {}
    end,
    desc = '[s]earch [H]elp',
  },
  {
    '<leader>sw',
    function()
      require('telescope.builtin').grep_string {}
    end,
    desc = '[s]earch current [w]ord',
  },
  {
    '<leader>sg',
    function()
      require('telescope.builtin').live_grep {}
    end,
    desc = '[s]earch by [g]rep',
  },
  {
    '<leader>sG',
    function()
      local git_root = utils.find_git_root()
      if git_root then
        require('telescope.builtin').live_grep {
          search_dirs = { git_root },
          additional_args = function()
            return { '--hidden' }
          end,
        }
      end
    end,
    desc = '[s]earch by [G]rep on Git Root',
  },
  {
    '<leader>ss',
    function()
      require('telescope.builtin').lsp_document_symbols {}
    end,
    desc = '[s]earch Document [s]ymbols',
  },
  {
    '<leader>sS',
    function()
      require('telescope.builtin').lsp_dynamic_workspace_symbols {}
    end,
    desc = '[s]earch Workspace [S]ymbols',
  },
  {
    '<leader>sD',
    function()
      require('telescope.builtin').diagnostics {}
    end,
    desc = '[s]earch [D]iagnostics',
  },
  {
    '<leader>sc',
    function()
      require('telescope.builtin').resume {}
    end,
    desc = '[c]ontinue Search',
  },
  {
    '<leader>s/',
    function()
      require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end,
    desc = '[s]earch [/] in Open Files',
  },
  {
    '<leader>st',
    function()
      require('telescope.builtin').builtin {}
    end,
    desc = '[s]earch Select [t]elescope',
  },

  {
    '<leader>gb',
    function()
      require('telescope.builtin').git_branches {}
    end,
    desc = '[g]it [b]ranches',
  },
}

-- Git keymaps
M.fugitive = {
  { '<leader>ga', '<cmd>Git add %<CR>', desc = '[g]it [a]dd curret file' },
}
M.gitlinker = { { '<leader>gy', '<cmd>GitLink remote=origin<CR>', mode = 'n', desc = 'Copy web link' } }
M.neogit = {
  { '<leader>gS', '<cmd>Neogit kind=auto<CR>', desc = 'Neo[g]it [S]tatus' },
  { '<leader>gc', '<cmd>Neogit commit<CR>', desc = '[g]it [c]ommit' },
}
vim.keymap.set('n', '<leader>sd', function()
  require('telescope.builtin').git_status {}
end, { desc = '[s]earch Git [d]iff' })
M.lazygit = {
  { '<leader>gg', '<cmd>LazyGit<CR>', desc = 'lazygit' },
}
M.git_worktree = {
  {
    '<leader>gw',
    function()
      require('telescope').extensions.git_worktree.git_worktrees()
    end,
    desc = '[g]it [w]orktrees',
  },
  {
    '<leader>gW',
    function()
      require('telescope').extensions.git_worktree.create_git_worktree()
    end,
    desc = 'Create [W]orktree',
  },
}
M.octo = {
  { '<leader>go', '<cmd>Octo<CR>', desc = 'GitHub PRs' },
}
M.gh_addressed = {
  { '<leader>gc', '<cmd>GhReviewComments<CR>', desc = 'GitHub Review Comments' },
}
M.gh_blame = {
  { '<leader>gB', '<cmd>GhBlameCurrentLine<CR>', desc = 'GitHub PR Blame Current Line' },
}
vim.keymap.set('n', '<leader>gh', '<cmd>!wezterm cli spawn --cwd $PWD -- zsh -c "gh dash"<CR><CR>', { desc = '[g]it [H]ub dash' })

M.gitsigns = function(bufnr)
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
  end, { expr = true, desc = 'Next hunk' })
  map({ 'n', 'v' }, '[c', function()
    if vim.wo.diff then
      return '[c'
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Previous hunk' })
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
  map('n', '<leader>tB', gs.toggle_current_line_blame, { desc = '[t]oggle git [B]lame line' })
  map('n', '<leader>td', gs.toggle_deleted, { desc = '[t]oggle git show [d]eleted' })
  -- Text object
  map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
end

-- Toggles
M.trouble = { { '<leader>tt', '<cmd>TroubleToggle<CR>', desc = '[t]oggle [t]rouble' } }
M.blame = { { '<leader>tb', '<cmd>BlameToggle<CR>', desc = '[t]oggle git [b]lame' } }
M.outline = { { '<leader>to', '<cmd>Outline<CR>', desc = '[t]oggle [O]utline' } }
vim.keymap.set('n', '<leader>ti', function()
  ---@diagnostic disable-next-line: missing-parameter
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = '[t]oggle [i]nline hints' })
M.undotree = { { mode = 'n', '<leader>tu', '<cmd>UndotreeToggle<CR>', desc = '[t]oggle [u]ndo tree' } }
vim.keymap.set('n', '<leader>tc', '<cmd>CccHighlighterToggle<CR>', { desc = '[t]oggle [c]olor highlights' })
vim.keymap.set('n', '<leader>cc', '<cmd>CccPick<CR>', { desc = '[c]olor pi[c]ker' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev {}
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Previous diagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next {}
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Next diagnostic message' })
vim.keymap.set('n', '[w', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Previous warning' })
vim.keymap.set('n', ']w', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Next warning' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Previous error' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Next error' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
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
  {
    '<leader>c-',
    function()
      require('actions-preview').code_actions {
        context = { only = { 'source' } },
      }
    end,
    desc = 'All code actions',
    silent = true,
    noremap = true,
  },
}

M.lsp = function(bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>cr', vim.lsp.buf.rename, '[c]ode [r]ename')
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
  nmap('gC', vim.lsp.buf.declaration, '[G]oto De[C]laration')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'FormatLSP', function(_)
    vim.lsp.buf.format {}
  end, { desc = 'LSP: Format current buffer with LSP' })
end
M.conform = {
  {
    '<leader>cf',
    function()
      require('conform').format { async = true, lsp_fallback = true }
    end,
    desc = 'Format buffer',
  },
}

-- Refactoring
vim.keymap.set('x', '<leader>ce', '<cmd>Refactor extract<CR>')
vim.keymap.set('x', '<leader>cf', '<cmd>Refactor extract_to_file<CR>')
vim.keymap.set('x', '<leader>cv', '<cmd>Refactor extract_var<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>ci', '<cmd>Refactor inline_var<CR>')
vim.keymap.set('n', '<leader>cI', '<cmd>Refactor inline_func<CR>')
vim.keymap.set('n', '<leader>cb', '<cmd>Refactor extract_block<CR>')
vim.keymap.set('n', '<leader>cB', '<cmd>Refactor extract_block_to_file<CR>')

-- Vim Illuminate keybinds
M.illuminate = {
  {
    ']r',
    function()
      require('illuminate').goto_next_reference()
      vim.api.nvim_feedkeys('zz', 'n', false)
    end,
    desc = 'Next reference',
  },
  {
    '[r',
    function()
      require('illuminate').goto_prev_reference()
      vim.api.nvim_feedkeys('zz', 'n', false)
    end,
    desc = 'Previous reference',
  },
}

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
  { '\\', '<cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  { '<leader>gs', '<cmd>Neotree float git_status<CR>', desc = '[g]it [S]tatus' },
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
    "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<CR>",
    desc = 'Jest [W]atch mode',
  },
}

-- Terminal
-- Enter normal mode while in a terminal
vim.keymap.set('t', '<C-esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

M.smart_splits = {
  -- resizing splits
  -- these keymaps will also accept a range,
  -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
  {
    '<A-h>',
    function()
      require('smart-splits').resize_left {}
    end,
  },
  {
    '<A-j>',
    function()
      require('smart-splits').resize_down {}
    end,
  },
  {
    '<A-k>',
    function()
      require('smart-splits').resize_up {}
    end,
  },
  {
    '<A-l>',
    function()
      require('smart-splits').resize_right {}
    end,
  },
  -- moving between splits
  {
    '<C-h>',
    function()
      require('smart-splits').move_cursor_left {}
    end,
  },
  {
    '<C-j>',
    function()
      require('smart-splits').move_cursor_down {}
    end,
  },
  {
    '<C-k>',
    function()
      require('smart-splits').move_cursor_up {}
    end,
  },
  {
    '<C-l>',
    function()
      require('smart-splits').move_cursor_right {}
    end,
  },
  -- swapping buffers between windows
  -- {'<leader><leader>h', function()
  --   require('smart-splits').swap_buf_left {}
  -- end},
  -- {'<leader><leader>j', function()
  --   require('smart-splits').swap_buf_down {}
  -- end},
  -- {'<leader><leader>k', function()
  --   require('smart-splits').swap_buf_up {}
  -- end},
  -- {'<leader><leader>l', function()
  --   require('smart-splits').swap_buf_right {}
  -- end},
}

-- document existing key chains
M.which_key = {
  {
    mode = { 'n', 'v' },
    { '<leader>T', group = '[T]ests' },
    { '<leader>c', group = '[c]ode' },
    { '<leader>g', group = '[g]it' },
    { '<leader>h', group = 'git [h]unks' },
    { '<leader>o', group = '[o]verseer' },
    { '<leader>s', group = '[s]earch' },
    { '<leader>t', group = '[t]oggles' },
    { '[', group = 'prev' },
    { ']', group = 'next' },
    { 'g', group = 'goto' },
    { 'z', group = 'fold' },
  },
}

return M
