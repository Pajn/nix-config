return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  main = 'ibl',
  keys = {
    { "<leader>tl", "<cmd>IBLToggle<cr>", mode = "n", desc = "[T]oggle indentation [L]ines" },
  },
  opts = {
    enabled = false,
    indent = {
      char = '▏'
    },
  }
}
