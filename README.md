# tree-sitter-surrealql.nvim

Neovim integration plugin for [SurrealQL](https://surrealdb.com/docs/surrealql) syntax highlighting, folding, and indentation via tree-sitter.

Targets **SurrealDB v3+** using the [overrealdb/tree-sitter-surrealql](https://github.com/overrealdb/tree-sitter-surrealql) parser.

## features

- Syntax highlighting (170+ keywords, operators, types, functions, properties, record IDs)
- Code folding (DML, DDL, control flow, subqueries, arrays, objects)
- Indentation (braces, parentheses, brackets)
- Injection support (Rust `surql_query!` / `surql_check!` macros)

## parser

This plugin uses [overrealdb/tree-sitter-surrealql](https://github.com/overrealdb/tree-sitter-surrealql) which targets SurrealDB 3+ exclusively and ships with comprehensive query files.

> **Note:** The previous parser ([DariusCorvus/tree-sitter-surrealdb](https://github.com/DariusCorvus/tree-sitter-surrealdb)) targeted SurrealDB v1 and has been unmaintained since February 2024.

## requirements

- [Neovim](https://neovim.io) 0.10+
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (main branch)
- A C compiler (for building the parser)

## installation

### lazy.nvim

The recommended approach is to list `tree-sitter-surrealql.nvim` as a dependency of `nvim-treesitter`, and call `setup()` inside nvim-treesitter's config:

```lua
{
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  dependencies = {
    "mdrv/tree-sitter-surrealql.nvim",
  },
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      -- add your other languages here
    },
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    -- Call surrealql setup AFTER nvim-treesitter but BEFORE starting treesitter
    require("tree-sitter-surrealql").setup()

    -- Start treesitter on already-open buffers.
    -- Required because Neovim may open files before plugin configs run,
    -- so custom filetype detection (.surql → surrealql) misses the initial
    -- FileType event. This re-evaluates filetype and kicks off highlighting.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local ft = vim.filetype.match({ buf = buf })
        if ft and ft ~= vim.bo[buf].filetype then
          vim.bo[buf].filetype = ft
        end
        pcall(vim.treesitter.start, buf)
      end
    end
  end,
}
```

After installing, run:

```vim
:TSInstall surrealql
```

### other plugin managers

```lua
use({
  "mdrv/tree-sitter-surrealql.nvim",
  requires = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("tree-sitter-surrealql").setup()
  end,
})
```

Then run `:TSInstall surrealql`.

## troubleshooting

### Highlighting doesn't work until I run `:e`

This happens when opening a `.surql` file at Neovim startup (e.g. `nvim file.surql`). The file is opened before plugins load, so the custom filetype detection (`vim.filetype.add`) hasn't registered yet. The buffer gets no filetype, and treesitter never starts.

**Fix:** Add the buffer-recovery loop shown in the lazy.nvim example above to your nvim-treesitter config. It re-evaluates filetype and starts treesitter on all open buffers after plugins load.

### `Parser not found` error

The parser `.so` file isn't compiled yet. Run:

```vim
:TSInstall surrealql
```

Verify it exists:

```vim
:echo nvim_get_runtime_file("parser/surrealql.so", v:true)
```

If empty, check `:TSInstallInfo` for build errors (usually a missing C compiler).

### `Query error: Invalid node type "macro_invocation"`

This was a bug in the upstream parser's `injections.scm`. The plugin automatically patches it on setup and after `:TSUpdate`. Make sure `setup()` is being called.

## options

```lua
require("tree-sitter-surrealql").setup({
  url = "https://github.com/overrealdb/tree-sitter-surrealql.git",
  branch = "main",
  override_highlights = false,
  highlights = nil,          -- custom highlights.scm content
  override_folds = false,
  folds = nil,                -- custom folds.scm content
  override_indents = false,
  indents = nil,              -- custom indents.scm content
  override_injections = false,
  injections = nil,           -- custom injections.scm content
})
```

| Option | Type | Default | Description |
|---|---|---|---|
| `url` | `string?` | `"https://github.com/overrealdb/tree-sitter-surrealql.git"` | Parser repository URL |
| `branch` | `string?` | `"main"` | Parser branch to use |
| `override_highlights` | `boolean?` | `false` | Replace shipped highlights with custom |
| `highlights` | `string?` | `nil` | Custom highlights.scm content |
| `override_folds` | `boolean?` | `false` | Replace shipped folds with custom |
| `folds` | `string?` | `nil` | Custom folds.scm content |
| `override_indents` | `boolean?` | `false` | Replace shipped indents with custom |
| `indents` | `string?` | `nil` | Custom indents.scm content |
| `override_injections` | `boolean?` | `false` | Replace shipped injections with custom |
| `injections` | `string?` | `nil` | Custom injections.scm content |

## file types

Files matching these patterns are automatically detected as `surrealql`:

- `*.surql`
- `*.surrealql`
