local M = {}

---@class SurrealqlOpts
---@field url? string Override parser repository URL
---@field branch? string Override parser branch (default: "main")
---@field override_highlights? boolean Replace shipped highlights.scm with custom one
---@field highlights? string Custom highlights.scm content (used with override_highlights)
---@field override_folds? boolean Replace shipped folds.scm with custom one
---@field folds? string Custom folds.scm content
---@field override_indents? boolean Replace shipped indents.scm with custom one
---@field indents? string Custom indents.scm content
---@field override_injections? boolean Replace shipped injections.scm with custom one
---@field injections? string Custom injections.scm content

--- Setup tree-sitter-surrealql parser for SurrealDB v3+
---
--- Configures filetype detection, registers the parser with nvim-treesitter,
--- and optionally sets up query overrides.
---
--- The parser is sourced from overrealdb/tree-sitter-surrealql which targets
--- SurrealDB 3+ exclusively and ships with comprehensive query files
--- (highlights, folds, indents, injections).
---@param opts SurrealqlOpts|nil
function M.setup(opts)
	opts = opts or {}

	-- Filetype detection: .surql and .surrealql files
	vim.filetype.add({
		extension = {
			surql = "surrealql",
			surrealql = "surrealql",
		},
	})

	-- Register filetype → language mapping for Neovim's built-in tree-sitter
	vim.treesitter.language.register("surrealql", "surrealql")

	-- Register parser with nvim-treesitter for :TSInstall surrealql
	local ok, parsers = pcall(require, "nvim-treesitter.parsers")
	if ok then
		parsers.surrealql = {
			install_info = {
				url = opts.url or "https://github.com/overrealdb/tree-sitter-surrealql.git",
				files = { "src/parser.c" },
				branch = opts.branch or "main",
			},
			filetype = "surrealql",
			queries = "queries",
		}
	end

	-- Write custom query overrides to cache if provided
	local query_overrides = {
		{ enabled = opts.override_highlights, content = opts.highlights, path = "queries/surrealql/highlights.scm" },
		{ enabled = opts.override_folds, content = opts.folds, path = "queries/surrealql/folds.scm" },
		{ enabled = opts.override_indents, content = opts.indents, path = "queries/surrealql/indents.scm" },
		{ enabled = opts.override_injections, content = opts.injections, path = "queries/surrealql/injections.scm" },
	}

	local runtime_path = vim.fn.stdpath("cache")
	vim.opt.runtimepath:append(runtime_path)

	for _, query in ipairs(query_overrides) do
		if query.enabled and query.content then
			local full_path = runtime_path .. "/" .. query.path
			vim.fn.mkdir(vim.fn.fnamemodify(full_path, ":h"), "p")
			local file = io.open(full_path, "w")
			if file then
				file:write(query.content)
				file:close()
			end
		end
	end
end

return M