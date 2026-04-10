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

## usage

The official extension for SurrealDB files is `.surql`. Files matching `*.surql` or `*.surrealql` are automatically detected.

### requirements

- [Neovim](https://neovim.io) 0.10+
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

### installation

_Lazy:_

```lua
{
  "mdrv/tree-sitter-surrealql.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("tree-sitter-surrealql").setup()
  end,
}
```

After installing, run:

```vim
:TSInstall surrealql
```

### setup

```lua
-- Minimal (uses shipped queries from the parser repo)
require("tree-sitter-surrealql").setup()

-- With custom overrides
require("tree-sitter-surrealql").setup({
  url = "https://github.com/overrealdb/tree-sitter-surrealql.git",
  branch = "main",
  override_highlights = true,
  highlights = [[
    (keyword_select) @keyword
    (keyword_from) @keyword
    -- ... custom highlights
  ]],
})
```

### options

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