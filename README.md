# 项目规范（通用库）

> 从全栈项目实践中抽离的**可跨项目复用**规范，与具体产品/业务解耦。  
> 来源：全栈项目实践抽离 + ECC + 业界 Spring Boot / React 实践。  
> 最后更新：2026-06-19

---

## 用途

| 场景 | 做法 |
|------|------|
| 新项目起步 | 按 [BOOTSTRAP.md](./BOOTSTRAP.md) 复制 `.cursor/` 到目标项目 |
| 现有项目对齐 | 对照 `backend/`、`frontend/`、`api/` 写入项目 `docs/standards/` |
| Agent / Cursor | 本库 `.cursor/` + 项目 `AGENTS.md`、capability 文档 |

**分层原则**：

```
项目规范/
├── .cursor/           ← Cursor 标准目录（Rules/Skills/Agents/Hooks）
├── ai/ coding/ …      ← 人类可读规范
└── BOOTSTRAP.md       ← 新项目接入步骤
    ↓ 复制 .cursor/
<项目>/.cursor/        ← 运行时配置
<项目>/docs/standards/ ← 项目专属
```

---

## 快速入口

| 文档 | 内容 |
|------|------|
| **[BOOTSTRAP.md](./BOOTSTRAP.md)** | 复制 `.cursor/`、生成 rules |
| [CHANGELOG.md](./CHANGELOG.md) | 变更记录 |
| **[.cursor/README.md](./.cursor/README.md)** | Skills 索引、目录说明 |

---

## 目录索引

### 编码与文档

| 路径 | 内容 |
|------|------|
| [coding/编码风格.md](./coding/编码风格.md) | KISS/DRY/YAGNI、不可变、命名 |
| [coding/安全规范.md](./coding/安全规范.md) | 密钥、校验、鉴权 |
| [coding/Git与PR.md](./coding/Git与PR.md) | Conventional Commits、PR |
| [coding/文档维护.md](./coding/文档维护.md) | docs 结构、需求先行 |

### 技术栈

| 路径 | 内容 |
|------|------|
| [backend/README.md](./backend/README.md) | Spring Boot 导航 |
| [frontend/README.md](./frontend/README.md) | React 导航 |
| [api/README.md](./api/README.md) | REST 契约导航 |

### Agent

| 路径 | 内容 |
|------|------|
| [ai/README.md](./ai/README.md) | AI 文档导航 |
| [ai/Agent执行规范.md](./ai/Agent执行规范.md) | 实施流程 |
| [ai/智能体模式.md](./ai/智能体模式.md) | 路由、编排、并行 |
| [.cursor/skills/workflow-triggers/SKILL.md](./.cursor/skills/workflow-triggers/SKILL.md) | **工作流触发表** |

---

## 维护

- 新增 Skill：只改 `.cursor/skills/workflow-triggers/SKILL.md`
- 结构变更：更新 [CHANGELOG.md](./CHANGELOG.md)
