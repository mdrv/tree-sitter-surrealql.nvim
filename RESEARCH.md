# Parser Comparison & Research

Research notes for evaluating tree-sitter parsers for SurrealDB/SurrealQL.

## Candidates

| | [DariusCorvus/tree-sitter-surrealdb](https://github.com/DariusCorvus/tree-sitter-surrealdb) | [ForetagInc/tree-sitter-surrealql](https://github.com/ForetagInc/tree-sitter-surrealql) | [overrealdb/tree-sitter-surrealql](https://github.com/overrealdb/tree-sitter-surrealql) |
|---|---|---|---|
| **Targets** | SurrealDB v1 | v2+ | SurrealDB 3+ |
| **Last commit** | Feb 2024 | Active | Active |
| **Grammar size** | ~30KB | ~48KB (largest) | Large |
| **Shipped queries** | None in repo | `highlights.scm` (38 lines only) | `highlights.scm` (263 lines), `folds.scm`, `indents.scm`, `injections.scm` |
| **scanner.c** | No | No | No |
| **Highlights coverage** | Plugin had to bundle hardcoded SCM | Minimal (~38 lines) | Comprehensive (170+ named keywords) |
| **Neovim ready** | Needed bundled queries (now unmaintained) | Needs query files written from scratch | Production-ready out of the box |

## Decision: overrealdb/tree-sitter-surrealql

Chosen because:
- Only parser shipping production-ready query files (highlights, folds, indents, injections)
- Exclusively targets SurrealDB 3+
- Comprehensive highlights (263 lines, 170+ named keywords)
- Folds, indents, and Rust macro injections included

## Next Steps

- [ ] Deep grammar comparison: overrealdb vs ForetagInc rule coverage, error recovery
- [ ] Validate `.scm` files against `node-types.json` for missing highlights/folds/indents
- [ ] Real-world parse testing against SurrealDB v3 queries using `tree-sitter parse`
- [ ] Neovim integration testing: compilation, highlighting, folding, indentation, injections
- [ ] Monitor ForetagInc parser — its larger grammar may catch up on query file quality
