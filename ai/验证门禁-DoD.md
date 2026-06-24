# 验证门禁 · 完成定义（DoD）（通用）

> 来源：ECC verification-loop 精简版  
> 各项目可在 `.cursor/skills/verification-gate/SKILL.md` 中扩展路径与冒烟步骤

---

## 何时执行

- 功能或显著改动完成后
- 用户要求「验收」「DoD」「交付」
- 创建 PR 前
- 修改 backend 或 API 契约后

---

## 阶段 0：范围合规

- [ ] 符合项目 capability / 路线图（若有 scope-check Skill，先读）
- [ ] 未实现 OUT OF SCOPE 能力

---

## 阶段 1：前端构建

```powershell
cd frontend
npm run build
```

失败 → **STOP**，修复至通过。

---

## 阶段 2：后端构建

```powershell
cd backend
.\mvnw.cmd compile
```

建议：改动 Service/Repository 时运行 `.\mvnw.cmd test`。

失败 → **STOP**。

---

## 阶段 3：后端重启（若改了 backend/**）

1. 停止占用端口的旧进程（常见 **8080**）
2. `cd backend && .\mvnw.cmd spring-boot:run`
3. 日志无 `Migration failed`；新 Flyway 脚本已应用
4. 对改动接口至少一次 HTTP 冒烟（含写操作若新增）

仅改 frontend/docs → **跳过**本阶段。

---

## 阶段 4：契约与文档

若改了 API 或实体：

- [ ] API 设计文档
- [ ] 数据模型文档
- [ ] 前端 `types/` + `api/`
- [ ] ADR（若架构决策）

---

## 阶段 5：审查（建议）

- [ ] 后端业务改动：java-reviewer 或等价审查
- [ ] 前端改动：react-reviewer 或等价审查
- [ ] Security/JWT/权限：security-reviewer

---

## 阶段 6：交付说明

向用户/PR 提供：

- 改动摘要与原因
- 受影响端点、路由、migration 版本
- 手测步骤
- 已知限制

---

## 通用禁止

- [ ] 未提交密钥、`.env`、本地数据库文件
- [ ] 用户未要求时不 git commit / push
- [ ] 后端改完未重启却声称 API 已验证

---

## 项目扩展位

在项目 Skill 中填写：

| 占位 | 示例 |
|------|------|
| 测试账号文档 | `docs/dev-本地测试账号.md` |
| 冒烟 URL | `GET /api/...` |
| 多仓 PR | backend / frontend / docs 分 PR |
