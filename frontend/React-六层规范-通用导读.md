# React 六层规范 · 通用导读（跨项目）

> 来源：[React 代码编写规范大全](https://www.cnblogs.com/jzssuanfa/p/19223235)（jzssuanfa · 博客园）

---

## 六层

| 层 | 内容 |
|----|------|
| L1 | 命名、文件、JSX、Props 类型 |
| L2 | 组件拆分、组合、展示/容器 |
| L3 | State 放置、useReducer、全局状态 |
| L4 | CSS Modules / CSS-in-JS 选型 |
| L5 | memo、lazy、列表 key |
| L6 | features/ 目录、绝对路径导入 |

---

## 项目落地

在目标项目 `docs/standards/` 编写 **六层映射**（如 `React规范-六层体系.md`），并在 `.cursor/rules/` 或 Skill 中标注栈差异（Redux、CSS Modules 等）。

审查子代理（如 `react-reviewer`）从 ECC 或 `~/.cursor/skills/` 按需引入，写入项目 `ecc-manifest.md`。
