local keymaps = require 'user.keymaps'
return {
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    keys = keymaps.octo,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('octo').setup()
    end,
  },
  {
    'dlvhdr/gh-addressed.nvim',
    cmd = 'GhReviewComments',
    keys = keymaps.gh_addressed,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'folke/trouble.nvim',
    },
  },
  {
    'dlvhdr/gh-blame.nvim',
    cmd = 'GhBlameCurrentLine',
    keys = keymaps.gh_blame,
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
  },
}
-- return {
--   -- "ldelossa/gh.nvim",
--   "tochamateusz/gh.nvim",
--   branch = "feat/use_token_for_remote_url",
--   dependencies = {
--     {
--       "ldelossa/litee.nvim",
--       config = function()
--         require("litee.lib").setup()
--       end,
--     },
--   },
--   event = "VeryLazy",
--   config = function()
--     require("litee.gh").setup()
--     local wk = require("which-key")
--     wk.register({
--       g = {
--         name = "+Git",
--         h = {
--           name = "+Github",
--           c = {
--             name = "+Commits",
--             c = { "<cmd>GHCloseCommit<cr>", "Close" },
--             e = { "<cmd>GHExpandCommit<cr>", "Expand" },
--             o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
--             p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
--             z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
--           },
--           i = {
--             name = "+Issues",
--             p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
--           },
--           l = {
--             name = "+Litee",
--             t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
--           },
--           r = {
--             name = "+Review",
--             b = { "<cmd>GHStartReview<cr>", "Begin" },
--             c = { "<cmd>GHCloseReview<cr>", "Close" },
--             d = { "<cmd>GHDeleteReview<cr>", "Delete" },
--             e = { "<cmd>GHExpandReview<cr>", "Expand" },
--             s = { "<cmd>GHSubmitReview<cr>", "Submit" },
--             z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
--           },
--           p = {
--             name = "+Pull Request",
--             c = { "<cmd>GHClosePR<cr>", "Close" },
--             d = { "<cmd>GHPRDetails<cr>", "Details" },
--             e = { "<cmd>GHExpandPR<cr>", "Expand" },
--             o = { "<cmd>GHOpenPR<cr>", "Open" },
--             p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
--             r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
--             t = { "<cmd>GHOpenToPR<cr>", "Open To" },
--             z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
--           },
--           t = {
--             name = "+Threads",
--             c = { "<cmd>GHCreateThread<cr>", "Create" },
--             n = { "<cmd>GHNextThread<cr>", "Next" },
--             t = { "<cmd>GHToggleThread<cr>", "Toggle" },
--           },
--         },
--       },
--     }, { prefix = "<leader>" })
--   end,
-- }
