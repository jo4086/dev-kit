local map = vim.keymap.set
local window_mappings = {
	-- Move
	h = { "<C-w>h", "[H] - move to Left [W]indow" },
	j = { "<C-w>j", "[J] - move to Lower [W]indow" },
	k = { "<C-w>k", "[K] - move to Upper [W]indow" },
	l = { "<C-w>l", "[L] - move to Right [W]indow" },

	-- Split
	s = { "<C-w>s", "[S]plit horizontally" },
	v = { "<C-w>v", "split [V]ertically" },

	-- Write and Quit
	q = { ":q<CR>", "[Q]uit to [W]indow" },
	w = { ":wq<CR>", "[W]rite and quit to [W]indow" },

	-- Terminal open
	t = { ":terminal<CR>", "open [T]erminal" },
}

local buffer_mappings = {
	d = { ":bd<CR>", "[B]uffer [D]elete" },
	w = { ":w | bd<CR>", "[B]uffer [W]rite and delete" },
	p = { ":bp<CR>", "[B]uffer [P]rev" },
	n = { ":bn<CR>", "[B]uffer [N]ext" },
	l = { ":buffers<CR>", "[B]uffer [L]ist" },
	h = { ":w | hide<CR>", "[B]uffer [H]ide" },
	a = {
		function()
			vim.cmd("wa")

			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(bufnr) then
					local bufname = vim.api.nvim_buf_get_name(bufnr)
					if not bufname:match("^term://") then
						vim.api.nvim_buf_delete(bufnr, {})
					end
				end
			end
		end,
		"[B]uffer [A]ll save and close (except terminals)",
	},
}

for key, value in pairs(window_mappings) do
	map("n", "<leader>w" .. key, value[1], { desc = value[2], silent = true })
end

for key, value in pairs(buffer_mappings) do
	map("n", "<leader>b" .. key, value[1], { desc = value[2], silent = true })
end

return true
