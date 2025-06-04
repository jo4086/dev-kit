local map = vim.keymap.set
local feed = vim.api.nvim_feedkeys
local replace = vim.api.nvim_replace_termcodes
local schedule = vim.schedule

local left = "<Left>"
local down = "<Down>"
local up = "<Up>"
local right = "<Right>"
local co = "<C-o>"
local ll = left .. left

local comman_mappings = {
	["<M-a>"] = { left, "[ h (ins)]: Left cursor" },
	["<M-s>"] = { down, "[ j (ins)]: Down cursor" },
	["<M-w>"] = { up, "[ k (ins)]: Up cursor" },
	["<M-d>"] = { right, "[ l (ins)]: Right cursor" },
	["<M-e>"] = { co .. "w", "[ w (ins)]: move next word" },
	["<M-q>"] = { co .. "b", "[ e (ins)]: move to word end" },
	["<M-r>"] = { co .. "e", "[ b (ins)]: move prev word" },
	["<M-1>"] = { co .. "{", "[ { (ins)]: move prev paragraph" },
	["<M-2>"] = { co .. "}", "[ } (ins)]: move next paragraph" },
}

local auto_set_mappings = {
	["<M-'>"] = { ": ''," .. ll, 'Insert : "", and move cursor inside' },
	["<M-]>"] = { ": []," .. ll, "Insert : [], and move cursor inside" },
	["<M-;>"] = { ": ;" .. left, "Insert : ; and move cursor inside" },
	["<M-o>"] = { ": {}," .. ll, "Insert : {}, and move cursor inside" },
}

local line_mappings = {
	["<C-d>"] = { "<Esc>", "o", "Insert: newline below" },
	["<C-a>"] = { "<Esc>", "O", "Insert: newline above" },
}

for key, value in pairs(comman_mappings) do
	map("i", key, value[1], { desc = value[2] })
end

for key, value in pairs(auto_set_mappings) do
	map("i", key, function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(value[1], true, false, true), "i", true)
	end, { desc = value[2], noremap = true, silent = true })
end

for key, value in pairs(line_mappings) do
	map("i", key, function()
		feed(replace(value[1], true, false, true), "n", false)

		schedule(function()
			feed(replace(value[2], true, false, true), "n", false)
		end)
	end, { desc = value[3], noremap = true, silent = true })
end

return true
