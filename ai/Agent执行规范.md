# Agent 执行规范（通用）

> 适用：Cursor / Claude Code 等 AI 辅助全栈项目  
> 与项目专属 `AGENTS.md`、`constraints.md` 配合使用

---

## 1. 角色分工

| 角色 | 职责 |
|------|------|
| **主 Agent** | 理解需求、实现、构建、汇总交付 |
| **explore** | 只读探索代码库、找入口 |
| **\*-build-resolver** | 修编译/构建错误，最小 diff |
| **\*-reviewer** | 改完业务代码后审查 |
| **security-reviewer** | JWT、权限、敏感面改动 |
| **architect / planner** | 大功能规划、架构 |
| **doc-sync** | 契约与 docs 同步 |

**原则**：大面积改代码前先探索或读项目文档索引，勿臆造路径。

常见模式对照（路由、并行、eval、handoff）：[智能体模式.md](./智能体模式.md)

---

## 2. Skill 使用时机（模板）

项目应在 `.cursor/skills/` 定义 Skill；通用建议：

| 场景 | 动作 |
|------|------|
| 新功能 / 大改 API | 读 **scope-check** → **requirements-refinement** |
| 提需求、需求不完整 | **requirements-refinement**（定稿后再 plan/implement） |
| 本地联调 401/403 | 读 **local-dev** Skill |
| 构建失败 | **build-fix** → 对应 build-resolver 子代理 |
| 交付 / PR 前 | **verification-gate** / DoD 清单 |
| 加新依赖 | **search-first**（先搜仓库再引入） |
| 改 `.cursor/` 驾驭层 | **agent-harness-construction** |
| 并行、加快、多 lane | **parallel-execution**（大任务配合 `plan-workflow`） |
| 跨会话、handoff | **dynamic-workflow-mode** |
| 新功能 eval 标准 | **eval-harness** |

不确定走哪条工作流 → 先读 **workflow-triggers**。

全局 Skill（`~/.cursor/skills-cursor/`、`~/.cursor/skills/`）：`review-bugbot`、`parallel-execution-optimizer`、`agentic-engineering` 等按需。见 [智能体模式.md §6](./智能体模式.md#6-与-ecc-全局-skill-对照)。

---

## 3. Cursor 推荐布局

```
.cursor/
├── rules/           # *.mdc，globs 或 alwaysApply
├── skills/          # */SKILL.md
├── agents/          # 可选，@ 引用子代理
├── hooks/           # hooks.json（可选）
├── constraints.md   # 硬约束速查
└── README.md
AGENTS.md            # 仓库根，Agent 总索引
docs/standards/      # 人类可读规范
```

| Rule 类型 | 示例 |
|-----------|------|
| alwaysApply | 项目核心约束、AI 执行、工作流触发 |
| globs | `backend/**` → Spring；`frontend/**` → React |
| 契约 | controller、dto、api 客户端 |

---

## 4. 后端修改后重启（Spring Boot）

凡改 `backend/**`（Java、Flyway、配置），交付前：

1. 停旧进程（常见 8080）
2. `mvnw spring-boot:run`
3. Flyway 无失败
4. HTTP 冒烟改动接口

仅改 frontend/docs **不必**重启后端。

---

## 5. 标准实施流程

```
1. 范围核对     → capability / Phase / scope-check
2. 需求沉淀     → requirements-refinement（多轮文档 → 已定稿）
3. 读设计文档   → 需求包 + API、数据模型
4. 规划（大任务）→ plan-workflow
5. 后端         → migration → 分层 → compile/test → 重启 → 冒烟
6. 前端         → types → api → pages → build
7. 文档         → 契约同步
8. 审查（建议） → *-reviewer
9. 交付说明     → 端点、路由、迁移版本、手测步骤、已知限制
```

---

## 6. 完成定义（DoD）模板

- [ ] 范围符合项目 capability / 路线图
- [ ] backend compile/test 通过；若改 backend 则已重启并冒烟
- [ ] frontend build 通过
- [ ] 契约变更已更新 design 文档
- [ ] 未提交密钥、本地库文件
- [ ] 用户未要求时不 commit/push

---

## 7. 通用禁止

- 跳过 migration 手改库
- 用 refresh token 当 access token（若项目用 JWT 双 token）
- 后端改完不重启即声称「已验证 API」
- 未更新文档就改 API 响应
- 擅自扩大已声明 OUT OF SCOPE 的能力

---

## 8. 相关文档

- [README.md](./README.md) — AI 文档导航、SSOT 约定
- [智能体模式](./智能体模式.md) — 路由、编排、并行、eval、反模式
- [Cursor项目配置指南](./Cursor项目配置指南.md)
- [验证门禁-DoD](./验证门禁-DoD.md)
- [外部规范参考-ECC](./外部规范参考-ECC.md)
