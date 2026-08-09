# 前端约定（React Native / Expo）

> 栈规则：`.cursor/rules/react-native-*.mdc`、`typescript-*.mdc`  
> 深模式：Skill `react-native-patterns`  
> Web React 另见 `frontend-react.mdc`（勿与 RN 混用 `web-*.mdc` 中的 DOM 假设）

## 栈

- React Native · Expo（推荐）· TypeScript
- 路由：Expo Router（`app/`）或 React Navigation
- 校验：Zod（与 TypeScript rules 一致）

## 目录（建议）

- 路由薄层：`app/**`
- 屏幕：`screens/` 或 `features/<name>/`
- 共享组件：`components/`
- 平台后缀：`*.native.tsx` / `*.ios.tsx` / `*.android.tsx`

## 交付前

- 读 `react-native-patterns` Skill
- 对照 `react-native-production.mdc`、`react-native-performance.mdc`
- 无障碍：`react-native-accessibility.mdc` + `frontend-a11y`（若有 Web 共享包）

## 验收

`{MOBILE_TEST_CMD}`（如 `npx expo test` / `pnpm test`）· 真机或模拟器冒烟改动路径
