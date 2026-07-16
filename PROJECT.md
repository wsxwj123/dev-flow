# PROJECT 状态账本 — dev-flow / task-flow skill 开发

> 唯一写者：主会话。本仓含两个姐妹 skill 项目：dev-flow（已发布）+ task-flow（开发中）。
> GitHub: https://github.com/wsxwj123/dev-flow（公开，SSH 别名 github.com-wsxwj123 推送）
> 同步铁规：改 skill → commit → `cp -R <skill目录>/. ~/.claude/skills/<skill名>/` → push

## task-flow 子项目（进行中）

### 阶段进度
- 方案讨论完成 @dea3cac：v1草案→fable盲审(20条)→v2→opus替代范式(5个)→v3定论（task-flow-设计/ 全链路留档）
- 01 立项：grilling 拷问完成（目录=同仓并列/名=task-flow/发布=推现仓/测试=6场景盲测），BRIEF.md 落盘
- 卡点0(BRIEF确认)已确认 @2026-07-16：用户补两点——立项须含 grilling+opus头脑风暴补遗(遗漏/没想到的/安全)；合同来源三层(用户要求>技能缺口>类型模板)最终用户签字。已改进 BRIEF

### 待办
- [x] #F1 卡点0:BRIEF 用户确认 → 进 02 方案
- [x] #F2 02 方案:方案代理产出+盲审(0致命6重要全修)+三轮用户修订(自包含/拆解计划/工作包颗粒度)。卡点1已确认 @2026-07-16
- [x] #F3 03 测试设计:34条盲测清单+守卫通过。卡点2已确认,LOCK=89ea8bb @2026-07-16
- [x] #F4 04 开发:fable代理写7文件587行(feature/task-flow);红队3回合/螺旋3圈/打回2轮落死
- [x] #F5 05 验收:双裁判盲判34/34全过第1轮,ACCEPT-REPORT落盘;code-review判不适用(纯markdown)。GitHub推送规则并入两份rules.md并推送(master=ac1b95c,feature已推) 卡点3已确认 @2026-07-16
- [ ] #F6 06 发布:README 更新 + 推送
- [ ] #F7 07 收尾:用户实测 + 复盘

## dev-flow 子项目（已发布 v6）

## 阶段进度
- v1（490db6e）：七阶段+五卡点+角色分离+rules 搬迁
- v2（6e7972a）：盲审修复——LOCK 落盘、conftest 绕过核查、任务分级、接口物理隔离
- v3（c618ee9）：并行 worktree、PROJECT.md 状态账本、05.5 安全审计、playwright 概念纠偏
- v4（本轮）：注入防护（rules.md 数据边界声明+测试输出结构化回传）、darwin 评估修复（反模式清单、隔离诚实说明、任务分级就高不就低、篡改清单本质判据、INTERFACE 错误契约 gate）

## 待办
- [x] #T1 darwin 评估 → 83.3/100，V1/V2 高危已缓解+诚实标注，V3-V10 已改或记入已知限制
- [x] #T2 提示词注入防护 → rules.md 加《数据与指令隔离声明》，04/04并行/05/05.5 引用+测试输出结构化
- [x] #T3 ponytail 与 rules 关系 → 同向冗余不冲突，rules.md 兜底子代理
- [x] #T4 冲突核查 → 无冲突
- [x] #T5 遵守保障 → 四道防线在，第五道 hook 待用户决定
- [x] #T6 GitHub/SSH 核实 → SSH 别名正常
- [ ] #T7 用真实小项目跑通完整流程实测（仍未做，最高优先）

## Bug 台账
| 编号 | 现象 | 状态 | 发现者 | 修复 commit |
|------|------|------|--------|------------|
| — | 暂无 | — | — | — |

## 已知限制（darwin 指出，无法靠 skill 文件根治，诚实记录）
- **V1 抗遗忘**：✅ 已上 hook 缓解——`hooks/dev-flow-reminder.sh`（UserPromptSubmit，检测开发意图注入提醒，装于 ~/.claude/hooks/，settings.json 已配，测 20/20）。仍是"提醒"非"阻断"，非硬强制
- **V2 隔离靠说服**：未根治（插件也解决不了：agent tools 白名单只限工具种类不限文件可见范围）。缓解=禁令+反模式+可选 Explore只读agent；根治需 permissions.deny 路径规则或 worktree，按需再上
- 评估过"改成插件"：结论没必要（单机自用，插件只解决分发不解决强制/隔离），维持 skill 形态
- ponytail 子代理不一定继承，靠 rules.md 保证精简原则
