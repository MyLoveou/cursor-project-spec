# Bootstrap 模板（非 Cursor 自动加载）

> 下列文件**不会**被 Cursor 直接读取；bootstrap 时复制到项目约定位置。

| 模板 | 复制到 |
|------|--------|
| `AGENTS.md.template` | `<项目>/AGENTS.md` |
| `docs-requirements-feature.md.template` | `docs/requirements/features/<id>.md` |

| `agents/*.md.template` | 占位符版角色 agents（运行时见 `../agents/*.md`） |
| `rules/*.mdc.template` | 占位符版 rules（运行时见 `../rules/*.mdc`） |
| `evals/*.md.template` | 占位符版 eval（运行时见 `../evals/*.md`） |

运行时 agents / rules / evals 已在 `.cursor/` 根下，**无需** bootstrap 生成。仅 `constraints.md`、`AGENTS.md` 须从模板复制。见 [../README.md](../README.md)。
