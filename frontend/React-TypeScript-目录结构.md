# React + TypeScript 目录结构（通用 · pages-first）

> 适用：React Router + Vite/CRA；与 [Feature-First](https://github.com/mlane/react-typescript-feature-style-guide) 互补  
> 策略：**路由页 = 功能边界**；页内 co-locate 私有组件

---

## 1. 原则

1. **页面**：`pages/<PageName>/` 独立目录，入口 `index.tsx`，样式 `<PageName>.css`
2. **组件**：每个组件**独立目录**，`index.tsx` + 同名 `.css`
3. **页面私有**：仅单页（及其子树）使用 → `pages/<PageName>/components/<ComponentName>/`
4. **共享**：≥2 页使用 → `src/components/<ComponentName>/`

---

## 2. 目录树

```
src/
├── pages/
│   ├── UserListPage/
│   │   ├── index.tsx
│   │   ├── UserListPage.css
│   │   └── components/
│   │       └── UserFilterPanel/
│   │           ├── index.tsx
│   │           └── UserFilterPanel.css
│   └── SettingsPage/
│       ├── index.tsx
│       └── SettingsPage.css
├── components/              # 跨页共享
│   ├── Layout/
│   │   ├── index.tsx
│   │   └── Layout.css
│   └── Modal/
│       ├── index.tsx
│       └── Modal.css
├── api/
├── types/
├── utils/
├── hooks/
├── stores/
├── App.tsx
├── main.tsx
└── index.css
```

---

## 3. 归属判断

| 场景 | 位置 |
|------|------|
| 仅 `UserListPage` 使用 | `pages/UserListPage/components/` |
| 列表页 + 详情页使用 | `components/` |
| 某共享组件的子部件且仅其使用 | `components/Parent/components/Child/` |

---

## 4. 导入路径深度

| 从 | 到 `src/types` | 到 `components/Modal` |
|----|----------------|-------------------------|
| `pages/Foo/index.tsx` | `../../types` | `../../components/Modal` |
| `pages/Foo/components/Bar/index.tsx` | `../../../../types` | `../../../../components/Modal` |
| `components/Foo/index.tsx` | `../types` | `../Modal` |

- 兄弟组件：`../ComponentName`
- 本组件 CSS：`./ComponentName.css`
- 兄弟组件 CSS：`../Other/Other.css`

可选：配置 `@/` alias（`vite.config.ts` + `tsconfig paths`）减少深度。

---

## 5. 禁止

- `components/Foo.tsx` + `Foo.css` **平铺**（应 `Foo/index.tsx`）
- 页面私有组件放进 `src/components/`（除非已确认复用）
- 全局 `components/index.ts` barrel（易循环依赖）；每组件目录独立 export

---

## 6. 与 feature-first 的取舍

| 模式 | 适用 |
|------|------|
| **pages-first**（本文） | 路由清晰的中大型 SPA |
| **features/** | 无 1:1 路由的功能域、多端复用模块 |

可混用：共享 `components/` + 按页 `pages/*/components/`。

---

## 7. 迁移检查

- [ ] 每组件独立目录 + `index.tsx`
- [ ] import 路径深度已修正
- [ ] CSS 与组件同目录或显式引用兄弟路径
- [ ] `npm run build` 通过
