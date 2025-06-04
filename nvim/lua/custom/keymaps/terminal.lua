local M = {}

function M.setup()
	local map = vim.keymap.set
	local terminal_mappings = {
		o = { ":terminal<CR>i", "[O]pen [T]erminal" },
		s = { ":split | terminal<CR>i", "[S]plit horizontally [T]erminal" },
		v = { ":vsplit | terminal<CR>i", "split [V]ertically [T]erminal " },
		t = { ":tabnew | terminal<CR>i", "[T]ab open [T]erminal" },
		d = { ":bd!<CR>", "[D]elete [T]erminal" },
	}

	for key, value in pairs(terminal_mappings) do
		map("n", "<leader>t" .. key, value[1], { desc = value[2], silent = true })
	end
end

return M
