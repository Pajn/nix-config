---@diagnostic disable: missing-fields
local function is_not_recording()
  local reg = vim.fn.reg_recording()
  return reg == ''
end

return {
  {
    'willothy/savior.nvim',
    dependencies = { 'j-hui/fidget.nvim' },
    event = { 'InsertEnter', 'TextChanged' },
    config = function()
      local savior = require 'savior'

      savior.setup {
        conditions = {
          savior.conditions.is_file_buf,
          ---@diagnostic disable-next-line: assign-type-mismatch
          savior.conditions.not_of_filetype {
            'gitcommit',
            'gitrebase',
          },
          savior.conditions.is_named,
          savior.conditions.file_exists,
          savior.conditions.has_no_errors,
          is_not_recording,
        },
      }
    end,
  },
}
