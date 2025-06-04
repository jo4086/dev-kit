local map = vim.keymap.set
local lsp = vim.lsp.buf

local nmaps = {
	gf = { lsp.definition, true, true },
}

for key, value in pairs(nmaps) do
	map("n", key, value[1], { noremap = value[2], silent = value[3] })
end

return true
