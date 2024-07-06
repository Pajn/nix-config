return {
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup {}
    end,
  },
  {
    'chrisgrieser/nvim-rip-substitute',
    cmd = 'RipSubstitute',
  },
}
