# 开发规则（从 CLAUDE.md 原文照搬，未改动措辞）

> 本文件是 dev-flow 全阶段的通用开发规则。方案代理、开发代理、审查代理的输入都应包含本文件。
> 摘录自全局 CLAUDE.md，摘录日期 2026-07-15。全局 CLAUDE.md 的开发规则若有更新，需手动同步本文件（不会自动跟随）。

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## 代码风格
- 变量和函数名必须清晰、有描述性（驼峰或蛇形，按语言惯例）
- 不过度工程化：优先线性逻辑，除非逻辑复用 ≥3 次，不拆分小组件/Hook
- 默认匹配现有代码风格；仅在项目已采用或用户明确要求时使用最现代语法（ES2022+、React 19+、Python 3.12+ 等）
- 考虑边界条件，必要处提供类型声明或简洁注释

## 代码与工作流规范（开发相关条目）
- 所有涉及代码的部分都必须用代码块包裹输出
- 所有涉及代码项目的修改，必须查询官方文档说明，不要自行打补丁避免引入新的 Bug

## 验证与质量
- 每次修改后必须验证，最小改动，一次改一个，改完就测
- 发现明显冗余代码时，提出精简建议并说明理由，经用户确认后再重写
- 删除任何东西前，说清楚它为什么存在。说不清就别动
- 测试必须覆盖真实行为，不用 mock 替代核心逻辑验证
- 优先编辑已有文件，而非创建新文件

## 风险评估
- 对涉及多文件/删除/数据库/安全时的任何非纯机械改动，必须列出至少 1 个具体失败模式 + 缓解措施，对于高风险改动（数据/安全/多文件重构）：列出 ≥2 个失败模式
- 如果你说不出失败模式，那你就没理解，必须停下来并继续调查
- 提案结构：**What**（改什么）→ **Why**（为什么）→ **Where**（影响文件）→ **Risk**（失败模式+缓解）→ **How**（改动前后对比）

## 操作确认规范

### 通用原则
- 不暴露、不记录密钥、令牌、凭证或敏感环境变量
- 用户要求停止时，立即停止
- 不做与需求无关的删除/重写；允许清理因本次改动产生的无用代码

### 🔴 必须确认（阻断执行，等待用户明确同意）

#### Git 危险操作
- `git push --force` / `git push -f`
- `git reset --hard`
- `git rebase`（交互式或强制）
- `git clean -fd`
- 删除远程分支 `git push origin --delete`

#### 文件删除
- `rm -rf` 任何目录
- 删除配置文件（.env, .config 等）
- 删除数据库文件
- 批量删除（5+ 文件）

#### 数据库操作
- `DROP DATABASE` / `DROP TABLE`
- `TRUNCATE`
- 批量 `DELETE`
- Schema 迁移

#### 关键配置修改
- package.json（依赖版本变更）
- tsconfig.json / jsconfig.json
- .env / .env.production
- docker-compose.yml
- nginx.conf / apache.conf

#### 依赖操作
- 第三方库安装：涉及 npm install 或 yarn add 新包时必须确认（防止引入危险、无用或体积巨大的库）。
- 升级主要版本依赖（major version）
- `npm uninstall` 现有依赖
- `yarn upgrade` / `pnpm update`

#### 构建/部署
- 修改 CI/CD 配置（.github/workflows, .gitlab-ci.yml）
- 修改构建脚本
- 生产环境部署命令

## Git 规范
- 一个逻辑变更一个 commit，commit message 描述变更目的和影响。
