# 变更记录

## 2026-07-27（enterprise-cert 纳入能力四件套）

- 域包明确挂载：`knowledge-capture` + `codebase-inventory` + `codebase-conventions` + `continuous-learning-v2`
- `bundle.manifest` 增加 continuous-learning-v2 与 conventions 模板；triggers / DOMAIN / SDD 阶段 0 已索引

## 2026-07-27（codebase-conventions：从代码提炼工程规范）

- 新增 Skill `codebase-conventions`：采样证据 →【规范待决断】→ 写入 `coding-conventions` 台账（可再收成短 Rule）
- 模板：`templates/docs-standards/coding-conventions.md.template`、`conventions-pending.md.template`
- 与 inventory / knowledge-capture / continuous-learning-v2 分工写入 workflow-triggers；enterprise-cert bundle 已纳入

## 2026-07-27（摸底防漏：codebase-inventory）

- 新增根 Skill `codebase-inventory`：四轮检索、路径证据、对抗复核、【摸底自检】、人核实门禁
- 加固 `domain-enterprise-cert-codebase-map` + 模板 + Rule `inventory-gate`；bundle 纳入该 Skill

## 2026-07-27（域包自包含 bundle）

- `bundle.manifest.json` + `scripts/sync-domain-bundle.ps1`：把依赖 Skill/Rule/Agent/Workflow 复制进 `domains/<id>/bundle/`
- `scripts/install-domain-pack.ps1`：仅持有域包目录即可装入业务仓 `.cursor/`
- `apply-domain-pack`：先合并 bundle 再合并域原生；enterprise-cert 已声明 SDD 依赖清单

## 2026-07-27（清理 AI 臆造业务事实）

- `core.mdc` 去掉未提供的状态机/审计/敏感字段/权限联动等「假不变量」
- glossary / taboos / business-rules / ui-interactions：撤销无来源「已确认」；仅保留复盘可溯源项
- DOMAIN / constraints / site-diff 标明占位 globs 与「流程≠现状」

## 2026-07-27（企业认证知识捕获 · 开放发现入库）

- 纠正：不以固定信号表穷尽业务；改为开放发现业务规则/领域知识/UI 交互
- Skill `domain-enterprise-cert-knowledge-capture`：【知识待决断】→ 人决断 → 写入活文档
- 活文档：`business-rules.md`、`ui-interactions.md`、`pending-decisions.md`；glossary/taboos 改为可追加台账
- Rule `confirm` 改为「表是结果不是边界」协议

## 2026-07-27（企业认证主动确认 Rule）

- 新增 `domain-enterprise-cert-confirm.mdc`：对照 taboos/glossary 信号主动输出【待确认上报】并 STOP
- `taboos.md` / `glossary.md` 标明详表 vs Rule 执行分工；triggers / sdd-gates / DOMAIN 已挂接

## 2026-07-27（企业认证 SDD 实践包）

- `domains/enterprise-cert`：glossary、taboos、site-diff/sdd-gates Rules
- Skills：`domain-enterprise-cert-sdd`、`codebase-map`、`tech-design`；templates（疑问表/摸底/方案/变更/切片验收）
- `apply-domain-pack`：域文档与 templates 复制到 `.cursor/domain-packs/<id>/`
- 触发表挂载「企业认证 SDD」口令

## 2026-07-27（业务域：企业认证）

- 新增域包 `domains/enterprise-cert`（企业认证）：核心 Rule、触发表 Skill、constraints overlay
- 根 `workflow-triggers` 登记企业认证口令 / 路径 → `domain-enterprise-cert-triggers`

## 2026-07-27（业务域配置包）

- 新增 `domains/`：按业务域隔离的 Cursor 配置包（源端组织，落地扁平合并）
- 脚手架：`domains/_template/`（DOMAIN.md、示例 rule/skill、constraints.overlay）
- Bootstrap 支持 `-Domain <id>[,id…]`；新增 `scripts/apply-domain-pack.ps1` 对已有 `.cursor/` 叠加
- 文档：`domains/README.md`、`STRUCTURE.md`、`BOOTSTRAP.md`、`README.md`、`AGENTS.md`

## 2026-06-19（ECC P0–P2）

- **P0 React PC**：`frontend-patterns`、`react-performance`、`frontend-a11y`、`nextjs-turbopack`；`web-*.mdc`（7）
- **P0 React App**：`react-native-patterns` + `react-native-*.mdc`（8）+ `frontend-react-native.mdc` + `@frontend-rn-dev`
- **P1 大型项目**：`orch-*`、`plan-orchestrate`、`team-agent-orchestration`、`architecture-decision-records`、`agent-architecture-audit`、`hexagonal-architecture`、`parallel-execution-optimizer`、`autonomous-loops`、`continuous-agent-loop`、`production-audit`
- **P2**：`cost-aware-llm-pipeline`、`cost-tracking`、`documentation-lookup`、`api-design`、`backend-patterns`、`strategic-compact`、`continuous-learning-v2`
- 新增 `scripts/sync-ecc-github-rules.ps1`；扩展 `sync-ecc-bundle.ps1` / `workflow-triggers`

## 2026-06-19（第三方 UI Skills）

- 从笔记软件 `.agents/skills/` vendoring：`frontend-design`、`ui-ux-pro-max`、`web-design-guidelines`
- `skills-lock.json` 合并四项第三方 Skill；`sync-vendor-skills.ps1` 支持整目录复制

## 2026-06-19（agent-browser）

- vendoring `agent-browser` Skill（[vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser)）→ `skills/agent-browser/`
- 新增 `skills-lock.json`、`scripts/sync-vendor-skills.ps1`；`.agents/` 为 CLI 暂存（gitignore）

## 2026-06-19（同步笔记软件实践）

- 从 `笔记软件/.cursor` 合并：L1+L3 动工门禁、TDD、Bugbot、code-review 流水线
- 新增 `templates/docs-standards/`（工作流索引、代码审查、TDD、Bugbot、版本门禁）
- 新增 `templates/docs-implementation-plan.md.template`（L3 方案）
- `STRUCTURE.md` 补充 Cursor 对 `.cursor/` vs 扁平目录的发现说明

## 2026-06-19（扁平化）

- **移除 `.cursor/` 包装层**：`rules/`、`skills/`、`agents/` 等提升至规范库根目录
- 业务项目复用时移入 `<项目>/.cursor/`；Bootstrap 脚本已适配
- 删除 `.cursor/README.md`（内容并入 `STRUCTURE.md`）

## 2026-06-19（清理）

- **移除人类可读规范**：删除根目录 `ai/`、`coding/`、`backend/`、`frontend/`、`api/`、`standards/` 及 `.cursor/STANDARDS-LINK.md`
- 约定全部落在 `.cursor/`（rules、skills、workflows、agents）
- Bootstrap 模板迁至仓库根 `templates/`（不再置于 `.cursor/templates/`）
- 修复 `templates/rules/*.mdc.template` 引用，指向 `.cursor/rules/` 而非外部规范目录

## 2026-06-19

### 结构

- 规范库根目录改为 `.cursor/`（符合 Cursor 标准布局）；`rules/*.mdc.template` 置于 `.cursor/rules/`
- 新增 `BOOTSTRAP.md` 作为唯一接入步骤
- `workflow-triggers.mdc` 改为极简 Rule；详表唯一来源为 Skill
- 新增 `backend/README.md`、`frontend/README.md`、`api/README.md`、`ai/README.md`
- 路径占位符 `{SPEC_ROOT}` 替代硬编码绝对路径（模板内）

### 工作流

- 路径触发：新 Controller/migration 须 `requirements-refinement` 已定稿
- 新增 `.cursor/evals/_example-requirements-handoff.md.template`

### 去项目专属引用

- 移除特定业务项目的路径、对照表与 hooks 说明
- 修复 `..cursor` 路径笔误为 `.cursor`
- 目录 `cursor/` 重命名为 `.cursor/`；Rule 模板扁平化到 `.cursor/rules/`

### ECC vendoring（同日）

- `.cursor/agents/`：19 个 ECC agents + 5 个项目角色 agents（运行时 `*.md`）
- `.cursor/rules/`：25 条 ECC rules + 7 条项目 rules（运行时 `*.mdc`）
- `.cursor/evals/`：`_example-feature.md`、`_example-requirements-handoff.md`
- `scripts/sync-ecc-bundle.ps1`：从 `~/.cursor` 刷新 ECC 副本
- 占位符版移至 `.cursor/templates/`；BOOTSTRAP 改为整包复制 `.cursor`

### 产品/设计/Vue（同日）

- vendored Skills：`market-research`、`deep-research`、`product-capability`、`blueprint`、`frontend-design-direction`、`ui-to-vue`、`make-interfaces-feel-better`、`research-ops`
- Agents：`marketing-agent`、`a11y-architect`；Vue：`vue-reviewer`、`vue-build-resolver`、`frontend-vue-dev`
- Rules：`vue-*.mdc`（5 条）、`frontend-vue.mdc`

### 结构（2026-06-19 晚）

- 人类规范合并：`ai/`、`coding/`、`backend/`、`frontend/`、`api/` → **`standards/`**
- 业务项目**只复制** `.cursor/`；新增 `scripts/bootstrap-project.ps1`
- 新增 `.cursor/STANDARDS-LINK.md` 说明链接模式

### 工作流剧本（同日）

- `.cursor/workflows/`：需求、设计、开发、交付四条主流程
- Skill：`workflow-playbooks`；`agent-patterns.md` 对接智能体模式

### 智能体模式（同日）

- `requirements-refinement`、`parallel-execution`、`智能体模式.md`

## 2026-06-12

- 初版从业务项目实践抽离为通用库
