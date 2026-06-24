# 外部规范参考 · ECC（通用）

> [affaan-m/ECC](https://github.com/affaan-m/ECC) — Agent 驾驭层：rules、agents、skills、hooks  
> 本文不含具体产品约束；项目落地见各仓库 `docs/standards/`

---

## 1. ECC 是什么

- 跨 **Claude Code / Cursor / Codex / OpenCode** 的配置与最佳实践集合
- 核心：**8 套 common rules** + 语言扩展（typescript、python、java…）
- v1.8+ 强调 **harness performance**（可靠性、handoff、eval）

---

## 2. 八套 Rule 摘要

| Rule | 优先级 | 核心 |
|------|--------|------|
| Security | P0 | 无硬编码 secret；边界校验；错误不泄露 |
| Coding Style | P0 | 不可变；小文件；KISS/DRY/YAGNI |
| Testing | P0 | 80% 覆盖；TDD；单测+集成+E2E |
| Git Workflow | P1 | Conventional Commits；PR test plan |
| Agents | P1 | 子代理分工 |
| Performance | P1 | 上下文/token 管理 |
| Patterns | P2 | Repository；统一 API 信封 |
| Hooks | P2 | PreToolUse 拦截；自动化门禁 |

本地副本：

- [coding/编码风格.md](../coding/编码风格.md) ← coding-style
- [coding/安全规范.md](../coding/安全规范.md) ← security
- [coding/Git与PR.md](../coding/Git与PR.md) ← git-workflow
- **运行时整包**：`.cursor/rules/common-*.mdc` 等（vendored 自 ECC，见 `.cursor/ecc-manifest.md.template`）

---

## 3. 建议采纳矩阵（任意新项目）

| 项 | 建议 | 说明 |
|----|------|------|
| 编码风格 common | ✅ 采纳 | 低成本高收益 |
| Security common | ✅ 采纳 | 密钥、校验、全局异常 |
| Git workflow | ✅ 采纳 | commit/PR 格式 |
| API 信封 Patterns | ✅ 若 REST | 见 [REST-API-契约](../api/REST-API-契约.md) |
| Agents 分工 | ✅ 适配 | 2–8 个子代理即可，不必全量 |
| Testing 80% | ⚠️ 分阶段 | 先 build + 关键单测，再提覆盖率 |
| 全量 hooks | ⚠️ 按需 | 需 ECC 插件或自写脚本 |
| 非栈 agents | ❌ 跳过 | 如 django-* 用于 Java 项目 |

---

## 4. Rules 分层（ECC 设计）

```
rules/common/          # 语言无关
rules/typescript/      # 扩展 common，paths: **/*.ts
rules/…/               # 项目可自建 rules/java/
```

**原则**：specific overrides general（语言规则覆盖 common）。

---

## 5. 业界 REST / React（ECC 外）

| 主题 | 文档 |
|------|------|
| Spring Boot REST | [backend/Spring-Boot-REST.md](../backend/Spring-Boot-REST.md) |
| React 目录 | [frontend/React-TypeScript-目录结构.md](../frontend/React-TypeScript-目录结构.md) |
| React 实践 | [frontend/React-TypeScript-实践.md](../frontend/React-TypeScript-实践.md) |

外部链接：

- [BackendBytes Spring REST](https://backendbytes.com/articles/spring-boot-rest-microservice-patterns/)
- [Code & Cadence REST 清单](https://blog.codecadence.se/2025/09/03/bad-rest/)
- [React TS 2025](https://dev.to/harshdeepsingh13/react-typescript-best-practices-in-2025-what-actually-matters-22dn)

---

## 6. 安装注意（ECC 官方）

- **不要混用** plugin install + manual full install（易重复 skills）
- Claude Code v2.1+ 自动加载 plugin `hooks/hooks.json`，勿在 plugin.json 重复声明
- Codex：靠 `AGENTS.md`，无 hook 执行时需手动跑 DoD

---

## 7. 维护

- ECC 大版本：对照 [rules/common/](https://github.com/affaan-m/everything-claude-code/tree/main/rules/common) 更新本库 `coding/`、`ai/`
- 单项目：在 `ecc-manifest.md` 记录 DAILY / LIBRARY / 刻意不引入
