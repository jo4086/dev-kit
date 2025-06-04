local M = {}

function M.insert_git_commit_template(typeText)
	local bufnr = vim.api.nvim_get_current_buf()

	-- 날짜 생성
	local today = os.date("[%Y-%m-%d]")

	-- 템플릿 라인 구성
	local lines = {
		"[" .. typeText .. "]  ",
		"",
		today,
		"# ┌────────── Footer (optional) ─────────┐",
		"# │      solve       │     reference     │",
		"# ├──────────────────┼───────────────────┤",
		"# │  Closes   : 종료 │  Ref       : 참고 │",
		"# │  Fixes    : 수정 │  RelatedTo : 관련 │",
		"# │  Resolves : 해결 │  SeeAlso   : 참고 │",
		"# └──────────────────┴───────────────────┘",
		"#",
	}

	-- 라인 삽입
	vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)

	-- 커서 위치: 2번째 줄의 끝 (Lua는 1-indexed)
	vim.api.nvim_win_set_cursor(0, { 1, #lines[1] })

	-- Insert 모드 진입
	vim.cmd("startinsert")
end

-- 명령어 등록
local types = {
	"Docs",
	"Test",
	"Refactor",
	"Fix",
	"Feat",
	"Design",
	"Chore",
	"HOTFIX",
	"Rename",
	"Remove",
	"Comment",
	"BREAKING CHANGE",
	"Style",
	"WIP",
}

for _, typeText in ipairs(types) do
	local cmd = typeText:gsub("[^%w]", "") -- 명령어 이름에 특수문자 제거
	vim.api.nvim_create_user_command(cmd, function()
		M.insert_git_commit_template(typeText)
	end, {})
end

--[[ local footer_keywords = {
  Fixes = true,
  Ref = true,
  RelatedTo = true,
  Closes = true,
  Resolves = true,
  SeeAlso = true,
} ]]

local footer_keywords = {
	Fixes = "Fixes",
	Ref = "Ref",
	RelatedTo = "Related To",
	Closes = "Closes",
	Resolves = "Resolves",
	SeeAlso = "See also",
}

for keyword, label in pairs(footer_keywords) do
	vim.api.nvim_create_user_command(keyword, function(opts)
		local bufnr = vim.api.nvim_get_current_buf()
		local arg = opts.args ~= "" and ("#" .. opts.args) or ""
		local footer_line = label .. ": " .. arg

		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		local insert_index = nil

		for i, line in ipairs(lines) do
			if line:match("^%[%d%d%d%d%-%d%d%-%d%d%]") then
				insert_index = i
				break
			end
		end

		if not insert_index then
			print("⚠️ Date line not found.")
			return
		end

		-- 날짜 아래 줄이 공백이면 그 자리에 삽입, 아니면 한 줄 더 아래
		local target_line = insert_index - 1
		local insert_line
		if lines[target_line] and lines[target_line]:match("^%s*$") then
			insert_line = target_line
		else
			insert_line = target_line
		end

		-- 중복 방지: 이미 같은 키워드 있는 경우 무시 (원하면 제거 가능)
		for _, l in ipairs(lines) do
			if l:match("^" .. vim.pesc(label) .. ":") then
				print("⚠️ Already added: " .. label)
				return
			end
		end

		-- 삽입 및 커서 이동
		vim.api.nvim_buf_set_lines(bufnr, insert_line, insert_line, false, { footer_line })
		vim.api.nvim_win_set_cursor(0, { insert_line + 1, #footer_line })
	end, {
		nargs = "?",
		force = true,
	})
end

return M
