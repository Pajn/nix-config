return {
  {
    "RRethy/vim-illuminate",
    event = 'LspAttach',
    config = function()
      require("illuminate").configure({
        under_cursor = false,
        filetypes_denylist = {
          "DressingSelect",
          "Outline",
          "TelescopePrompt",
          "alpha",
          "harpoon",
          "toggleterm",
          "neo-tree",
          "Spectre",
          "reason",
        },
      })
    end,
  },
}
