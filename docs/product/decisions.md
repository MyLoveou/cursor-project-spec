# 项目决策记忆（压缩）

> 跨会话先读最近条 + `facts.md`。每条 ≤8 行。

## 有效决策

### D-20260923-02 · 全局 Skill 双目录

- **决定**：`install-global-skills.ps1` 同时覆盖 `~/.cursor/skills` 与 `~/.agents/skills`
- **不选**：只装一侧导致 Cursor 与 Agents 目录漂移
- 状态：有效

### D-20260923-01 · 实现可按 UI/功能/算法拆，页面为组合根

- 场景：进化 project-spec
- **决定**：关注点分离 + 能力组合；依赖 `UI → 功能 → 算法`；组合进主路径才算交付
- **不选**：微服务/微前端；把一个用户能力拆成多个发版
- **落点**：`project-spec` L2 §组合式、`设计.md` §5.2–5.3
- 状态：有效

### D-20260917-01 · 复杂需求必须先过 L2 设计

- **决定**：模型/交互/模块/拆分/抽象写入 `设计.md`，确认前不得 L3/apply（G1a）
- **不选**：用文件清单冒充设计；用 `project-spec-design` 做能力设计
- 状态：有效

### D-20260912-01 · Skill 名用 project-spec，不用官方 openspec

- **决定**：Skill 目录与 yaml `name` 为 `project-spec*`；CLI 与 `openspec/` 目录名不变
- 状态：有效

## 已撤销 / 被取代

（无）
