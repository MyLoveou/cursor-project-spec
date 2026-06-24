# Cursor 项目配置指南（通用）

> 从 ECC [affaan-m/ECC](https://github.com/affaan-m/ECC) 与全栈实践抽离  
> 目标：新项目快速搭建 `.cursor/` + `AGENTS.md`

---

## 1. 三层文档

```
{SPEC_ROOT}/            ← 通用规范库（克隆路径）
<项目>/docs/standards/  ← 项目专属
<项目>/.cursor/rules/   ← 从 .cursor/rules/ 生成
<项目>/AGENTS.md
```

接入步骤见 [BOOTSTRAP.md](../BOOTSTRAP.md)。

**冲突优先级**（建议）：产品 capability > 设计文档 > 项目 standards > 通用库 > ECC default

---

## 2. 推荐 `.cursor/` 结构

```
.cursor/
├── README.md              # 目录说明
├── constraints.md         # 硬约束、DoD、常见陷阱
├── ecc-manifest.md        # 可选：ECC DAILY vs LIBRARY 选型
├── rules/
│   ├── project-core.mdc       # alwaysApply：栈、不变量
│   ├── ai-execution.mdc       # alwaysApply：重启、DoD、子代理
│   ├── workflow-triggers.mdc  # 可选：消息/路径 → Skill
│   ├── backend-spring.mdc     # globs: backend/**/*
│   ├── frontend-react.mdc       # globs: frontend/**/*
│   ├── api-contracts.mdc        # 改 API 时
│   └── docs-maintenance.mdc      # globs: docs/**/*
├── skills/
│   ├── local-dev/SKILL.md
│   ├── build-fix/SKILL.md
│   ├── verification-gate/SKILL.md
│   └── search-first/SKILL.md
├── agents/                # 可选
│   ├── backend-dev.md
│   ├── frontend-dev.md
│   └── java-reviewer.md
└── hooks/
    └── hooks.json           # 可选：stop DoD 提醒
```

---

## 3. Rule（.mdc）编写要点

```yaml
---
description: 简短说明
globs: backend/**/*          # 或 alwaysApply: true
alwaysApply: false
---

# 标题
…正文…
```

- **alwaysApply 宜少**：2–3 个（core + ai-execution + 可选 workflow）
- **globs 宜细**：按目录触发 backend/frontend/docs
- 正文控制在 **可扫描**（表格、清单、反模式示例）

模板见 [.cursor/templates/](../.cursor/templates/)。`workflow-triggers.mdc` 保持极简，详表在 Skill。

---

## 4. Skill 编写要点

```markdown
---
name: verification-gate
description: >-
  交付前验证。触发：验收、DoD、PR、build 通过后结束。
---

# 标题
## 何时使用
## 步骤（可含 powershell 命令）
## 失败时 STOP
```

- `description` 写清**触发词**，便于 Agent 路由
- 步骤可执行、可验证
- 项目特有路径写在 Skill，通用 DoD 引用 `项目规范/ai/验证门禁-DoD.md`
- 智能体模式对照：`项目规范/ai/智能体模式.md`

---

## 5. Agents（子代理）

两种来源：

| 类型 | 说明 |
|------|------|
| **项目原创** | `backend-dev`、`frontend-dev`、`doc-sync` |
| **ECC 衍生** | `java-reviewer`、`react-reviewer`、`security-reviewer` |

ECC 安装：**只选一种安装路径**（plugin 或 manual），避免重复 skills。

各项目选型：见 `ecc-manifest.md`（DAILY 落地 / LIBRARY 按需）。

---

## 6. Hooks（可选）

ECC 全量 hooks（secret 扫描、禁改 linter）依赖插件环境。轻量替代：

```json
{
  "version": 1,
  "hooks": {
    "stop": [{ "type": "prompt", "prompt": "交付前是否完成 build、后端重启、文档同步？" }]
  }
}
```

---

## 7. 新项目 bootstrap

见 [BOOTSTRAP.md](../BOOTSTRAP.md)（复制清单、占位符 `{SPEC_ROOT}` 等）。

---

## 8. ECC 资源链接

| 资源 | URL |
|------|-----|
| 仓库 | https://github.com/affaan-m/ECC |
| common rules | https://github.com/affaan-m/everything-claude-code/tree/main/rules/common |
| typescript rules | https://github.com/affaan-m/everything-claude-code/tree/main/rules/typescript |
| agents | https://github.com/affaan-m/everything-claude-code/tree/main/agents |
