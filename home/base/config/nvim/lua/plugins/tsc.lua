return {
	{
		"dmmulroy/tsc.nvim",
		-- ft = { "typescript", "typescriptreact" },
		cmd = { "TSC" },
		config = function()
			require("tsc").setup({
				auto_open_qflist = true,
				use_trouble_qflist = true,
				pretty_errors = true,
			})
		end,
	},
}
