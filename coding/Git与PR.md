# Git 与 Pull Request（通用）

> 来源：ECC [rules/common/git-workflow.md](https://github.com/affaan-m/everything-claude-code/blob/main/rules/common/git-workflow.md)

---

## 1. Commit 消息格式

```
<type>: <description>

<optional body>
```

| type | 用途 |
|------|------|
| `feat` | 新功能 |
| `fix` | 缺陷修复 |
| `refactor` | 重构（无行为变化） |
| `docs` | 仅文档 |
| `test` | 测试 |
| `chore` | 构建、依赖、杂项 |
| `perf` | 性能 |
| `ci` | CI 配置 |

**原则**：说明 **why**，聚焦变更目的；用户未要求时不自动 commit。

---

## 2. 禁止提交

- `.env`、密钥、证书私钥
- 本地数据库文件（如 `*.db`、`backend/data/`）
- 含真实 token 的测试配置

---

## 3. Pull Request 流程

1. 查看 **完整** commit 历史（非仅最新一条）
2. `git diff [base]...HEAD` 理解全部变更
3. PR 描述含：**Summary**（1–3 条）+ **Test plan**（可勾选清单）
4. 新分支首次 push：`git push -u origin HEAD`
5. 使用 `gh pr create` 或平台等价物

---

## 4. 禁止的 Git 操作（除非用户明确要求）

- `git push --force` 到 main/master
- `git commit --amend`（条件苛刻，见团队约定）
- `--no-verify` 跳过 hooks
- 修改 `git config`（Agent 自动化时）

---

## 5. 多仓 / Monorepo

- 各子仓或模块**分别 PR**，便于审查
- PR 标题/描述标明影响范围（`backend` / `frontend` / `docs`）

---

## 6. 与 DoD 的关系

PR 合并前应满足项目 [验证门禁-DoD](../ai/验证门禁-DoD.md)（构建通过、契约同步等）。
