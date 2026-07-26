# 目录结构（规范库 vs 业务项目）

> 规范库**无** `.cursor/` 包装层；Bootstrap 或手动复制时，将运行时目录放入目标项目的 `.cursor/`。

---

## 规范库（本仓库）

```
项目规范/
├── rules/ skills/ agents/ hooks/ workflows/ evals/   # 通用运行时
├── domains/            # 业务域配置包（按需合并，见 domains/README.md）
├── constraints.md.template
├── templates/          # Bootstrap 占位符 + docs-standards/
├── scripts/
└── STRUCTURE.md · README.md · AGENTS.md
```

**Cursor 不会自动扫描规范库根目录** — 根下的 `agents/`、`skills/`、`domains/` 等仅供维护与版本管理，不是运行时路径。

### 业务域配置包

| 路径 | 说明 |
|------|------|
| `domains/<domain-id>/` | 仅该业务域需要的 rules/skills/agents/… |
| `domains/_template/` | 新建域包脚手架（不可 `-Domain` 安装） |

Bootstrap / `apply-domain-pack.ps1` 将域包**扁平合并**进目标 `.cursor/`（同名目录覆盖合并）。详见 [domains/README.md](./domains/README.md)。

---

## Cursor 如何发现配置（业务项目）

Cursor **只**在业务项目根目录的 **`.cursor/`** 下加载下列内容：

| 路径 | Cursor 行为 | 斜杠命令 / `@` |
|------|-------------|----------------|
| `.cursor/rules/*.mdc` | Settings → Rules 自动注入 | 否（按 glob 自动） |
| `.cursor/skills/*/SKILL.md` | Agent 按需读取 Skill | **是** — Skill 名即路由入口 |
| `.cursor/agents/*.md` | 子代理定义 | **是** — 聊天 `@name` 或 Task `subagent_type` |
| `.cursor/hooks/hooks.json` | Hook 执行 | 否 |
| `AGENTS.md`（项目根） | 项目级 Agent 指引 | 否 |

**不会被 Cursor 扫描的路径：**

| 路径 | 说明 |
|------|------|
| 规范库根 `agents/`、`skills/`、`domains/` | 未在 `.cursor/` 下 → **不会**出现在 `@` 列表 |
| 业务项目根 `agents/`（无点前缀） | 同上 |
| `.agents/skills/`（`npx skills` CLI 暂存） | **不是** Cursor 官方布局；规范库复制到 `skills/` 后 Bootstrap 到 `.cursor/skills/` |
| `docs/standards/` | 人类可读规范，由 Skill/Rule **引用**，非自动加载 |

### 结论

1. **扁平规范库**本身 Cursor 找不到 — 这是预期；复制到 `<项目>/.cursor/agents/` 后才可被 `@backend-dev` 等调用。
2. **斜杠命令**（如 `/review-bugbot`、`/tdd-workflow`）来自 Cursor 内置或已安装 Skill，不是扫描 `agents/` 目录；本项目在 `workflow-triggers` 中映射到 `docs/standards/` 与 `@tdd-guide` / `bugbot` subagent。
3. **`workflows/`、`evals/`** 不在 Cursor Settings 自动项中，由 Skill 正文链接引用。

---

## 业务项目（复制后布局）

| 路径 | 说明 |
|------|------|
| `.cursor/rules/*.mdc` | `description` + `globs` 或 `alwaysApply`（含 `react-*`、`react-native-*`、`web-*`） |
| `.cursor/skills/*/SKILL.md` | Skills（工作流 + ECC P0–P2 + 第三方） |
| `.cursor/agents/*.md` | 子代理（含 `frontend-rn-dev`） |
| `.cursor/hooks/hooks.json` | Hooks |
| `AGENTS.md` | 项目根（Bootstrap 生成） |
| `docs/standards/` | 工作流索引、代码审查、TDD、Bugbot 等（Bootstrap 从模板生成） |

扩展（Skill 引用，非 Settings 自动项）：

| 路径 | 用途 |
|------|------|
| `.cursor/workflows/` | 需求/设计/开发/交付剧本 |
| `.cursor/evals/` | EDD eval 示例 |
| `.cursor/constraints.md` | 硬约束（由 template 生成；域包可追加 overlay） |
| `.cursor/domain-packs/<id>.md` | 已应用域包的戳记（人类可读，非 Cursor 扫描项） |

栈 Rule 须用 `globs:`，勿用 ECC 旧字段 `paths:`。修复：`scripts/fix-cursor-rule-frontmatter.ps1`。

---

## 复制方式

1. **脚本**：`scripts/bootstrap-project.ps1`（推荐；可选 `-Domain <id>`）
2. **叠加域包**：`scripts/apply-domain-pack.ps1 -Domain <id>`（已有 `.cursor/`）
3. **手动**：将根 `rules/`、`skills/`、`agents/`、`hooks/`、`workflows/`、`evals/` 移入 `<项目>/.cursor/`；域内容从 `domains/<id>/` 合并进同名子目录（勿整夹复制 `domains/`）
