---
id: coding-style
category: common
description: "ECC coding style: immutability, file organization, error handling, validation"
alwaysApply: true
---

# Coding Style

> 注释规范见 `rules/common/comments.md`（中文、讲意图不复述代码）。

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate existing ones:

```
// Pseudocode
WRONG:  modify(original, field, value) → changes original in-place
CORRECT: update(original, field, value) → returns new copy with change
```

Rationale: Immutable data prevents hidden side effects, makes debugging easier, and enables safe concurrency.

## File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large modules
- Organize by feature/domain, not by type

> `scan: yes` → `scripts/scan/rules/file-size.ps1`（800 行上限确定性扫描）

## 组合根（页面/入口文件）

> `scan: yes` → `scripts/scan/rules/no-implementation-in-pages.ps1`

页面文件、入口文件、控制器文件**默认只做函数调用与组装**，不写函数实现：

1. **禁止**：页面/入口文件内出现业务函数声明（含业务名词 + 副作用调用）
2. **豁免**：纯视图逻辑（局部 state、格式化、无副作用派生计算、JSX 内联箭头）
3. **判断标准**：该逻辑是否会被复用？是否含副作用？是否跨模块依赖？
4. **实现位置**：业务规则/算法/数据访问 → service/domain/hook 模块；页面只负责装配与数据流入

## 调试残留

> `scan: yes` → `scripts/scan/rules/no-console.ps1`

- 禁止提交 `console.log` / `console.debug` / `debugger` / `TODO` 标记
- 交付前扫描必须为零；确需保留的调试输出须加豁免注释 `// scan-ignore: reason`

## Error Handling

ALWAYS handle errors comprehensively:
- Handle errors explicitly at every level
- Provide user-friendly error messages in UI-facing code
- Log detailed error context on the server side
- Never silently swallow errors

## Input Validation

ALWAYS validate at system boundaries:
- Validate all user input before processing
- Use schema-based validation where available
- Fail fast with clear error messages
- Never trust external data (API responses, user input, file content)

## Code Quality Checklist

Before marking work complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No hardcoded values (use constants or config)
- [ ] No mutation (immutable patterns used)
