# dev-flow — Claude Code 全流程开发工作流 Skill

一个给单人开发者用的 Claude Code skill：把任何开发任务（新项目、加功能、修 bug）纳入一条**立项 → 方案 → 测试设计 → 开发 → 验收 → 发布 → 收尾**的完整流水线。

## 核心设计

**出方案的 ≠ 挑毛病的 ≠ 判定完成的。**

- 方案、审查、测试设计、开发、裁判由五类互相看不到对方上下文的独立子代理承担，靠文件交接
- 审查代理拿到的方案被伪装成"隔壁同事做的"，避免护短
- 验收测试由独立代理**只看需求和接口约定**黑盒编写，动工前锁定（commit hash 落盘），开发代理只能跑不能改——防止"自己出题自己判卷"
- 五个人工卡点：方案定稿、测试清单锁定、验收结果、发布前、用户实测终审
- 任务分级：微任务不入流程，小任务走轻量档，标准任务走完整七阶段

## 安装

```bash
git clone https://github.com/wsxwj123/dev-flow.git
cp -R dev-flow/dev-flow ~/.claude/skills/
```

新开一个 Claude Code 会话，说一句开发需求（如"帮我做个批量重命名工具"）即可自动触发。

## 结构

```
dev-flow/
├── SKILL.md              调度器：任务分级 + 阶段路由 + 铁律
└── references/
    ├── 01-立项.md        问工作文件夹、拷问需求到极致、定测试策略
    ├── 02-方案.md        调研 → 方案 → 盲审 → 定稿
    ├── 03-测试设计.md    黑盒验收测试编写与锁定
    ├── 04-开发.md        feature 分支开发 + 白盒单测
    ├── 04-并行worktree.md 多模块并行：worktree 隔离 + 模块测试循环 + PROJECT.md 状态账本
    ├── 05-验收.md        独立裁判判定 + 防作弊核查
    ├── 05.5-安全审计.md   独立安全审计：外部攻击面 + 内部数据安全
    ├── 06-发布.md        GitHub 仓库 + README + PR + Actions
    ├── 07-收尾.md        用户实测 + 知识同步 + 清理
    └── rules.md          开发通用规则
```

## 强制入口 hook（可选，让 AI 不漏走流程）

`hooks/dev-flow-reminder.sh` 是一个 `UserPromptSubmit` hook：检测到开发意图的消息时，自动往对话里注入一句"先走 dev-flow"提醒。只提醒不阻断，非开发消息（写邮件、做总结、解释代码）静默放过。它对抗的是"长会话里 AI 凭记忆跳过流程"。

安装：
```bash
mkdir -p ~/.claude/hooks
cp hooks/dev-flow-reminder.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/dev-flow-reminder.sh
```
然后在 `~/.claude/settings.json` 的 `hooks.UserPromptSubmit` 数组里追加一条：
```json
{ "hooks": [{ "type": "command", "command": "/Users/<你>/.claude/hooks/dev-flow-reminder.sh" }] }
```
撤销：删掉 settings.json 里这条 + 删脚本即可。

## 依赖

宿主为 Claude Code。流程中引用的技能（grilling、neat-freak、frontend-design 等）缺失时对应步骤会降级为手动执行，不影响主干。
