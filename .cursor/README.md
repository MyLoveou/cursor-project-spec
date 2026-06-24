# Cursor 配置 · 可直接复制的运行时整包



> 本目录即 Cursor 标准布局。**整目录复制到目标项目根即可使用** agents / rules / skills / evals / hooks。  

> 接入步骤：仓库根 [BOOTSTRAP.md](../BOOTSTRAP.md)



---



## 与 ECC 的关系



| 来源 | 本库 `.cursor/` 中的形态 |

|------|-------------------------|

| ECC agents | `agents/*.md`（Java/React 栈 + `marketing-agent`、`a11y-architect`） |

| ECC rules | `common-*`、`java-*`、`react-*`、`typescript-*` |

| Vue（本库增补） | `vue-reviewer`、`vue-build-resolver`、`frontend-vue-dev` + `vue-*.mdc` |

| 产品/调研/设计 Skills | `market-research`、`deep-research`、`product-capability`、`blueprint`、`frontend-design-direction`、`ui-to-vue` 等 |

| ECC evals | **无整包**；用 `eval-harness` + `evals/_example-*.md` |



刷新：`powershell -File scripts/sync-ecc-bundle.ps1`（从 `~/.cursor` 拉 ECC；Vue agents/rules 为库内维护）。



---



## 目录（约）



```

.cursor/

├── rules/          # ~38 条 *.mdc（ECC + 项目 + Vue）

├── skills/         # 24 个 Skill

├── agents/         # ~28 个 *.md

├── evals/          # 示例 2 个

├── hooks/

└── templates/      # 占位符版，非自动加载

```



---



## Skill 矩阵



| 阶段 | Skill |

|------|-------|

| 元 | `workflow-triggers`、`workflow-playbooks`、`agent-harness-construction` |

| 发现 | `scope-check`、`requirements-refinement`、`search-first`、`plan-workflow` |

| 产品/调研 | `market-research`、`deep-research`、`research-ops`、`product-capability`、`blueprint` |

| 设计/UI | `frontend-design-direction`、`make-interfaces-feel-better`、`ui-to-vue` |

| 构建 | `implement-feature`、`parallel-execution`、`build-fix` |

| 验证 | `eval-harness`、`verification-gate`、`backend-verify`、`code-review-gate` |

| 运维 | `local-dev`、`split-prs`、`dynamic-workflow-mode` |



---



## Agents 速查



| 类型 | 示例 `@` |

|------|----------|

| 审查/修复 | `java-reviewer`、`react-reviewer`、`vue-reviewer`、`vue-build-resolver`、`security-reviewer` |

| 规划/探索 | `architect`、`code-architect`、`planner`、`code-explorer`、`doc-updater` |

| 产品/营销/无障碍 | `product-manager`、`marketing-agent`、`a11y-architect` |

| 项目角色 | `backend-dev`、`frontend-dev`、`frontend-vue-dev`、`qa-engineer`、`doc-sync` |



---



## 栈选型



| 前端栈 | Rules | Agents |

|--------|-------|--------|

| React | `frontend-react.mdc`、`react-*.mdc` | `@react-reviewer`、`@frontend-dev` |

| Vue 3 | `frontend-vue.mdc`、`vue-*.mdc` | `@vue-reviewer`、`@frontend-vue-dev`；设计稿 → `ui-to-vue` Skill |



---



## 四条主工作流（Playbooks）

口令 → 读 `workflow-playbooks` Skill → 打开 `workflows/<name>.md`：

| 工作流 | 文件 |
|--------|------|
| 需求 | `workflows/requirements.md` |
| 设计 | `workflows/design.md` |
| 开发 | `workflows/development.md` |
| 交付 | `workflows/delivery.md` |

模式对照：`workflows/agent-patterns.md`（路由/委派/并行/Eval/Handoff）

---

## 维护



- 新增 Skill：**只改** `skills/workflow-triggers/SKILL.md`

- 更新 ECC：`scripts/sync-ecc-bundle.ps1`


