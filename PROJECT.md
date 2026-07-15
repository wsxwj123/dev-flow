# PROJECT 状态账本 — dev-flow skill 自身开发

> 唯一写者：主会话。这是 dev-flow skill 项目自己的状态账本（吃自己狗粮）。
> GitHub: https://github.com/wsxwj123/dev-flow（公开，SSH 别名 github.com-wsxwj123 推送）
> 同步铁规：改 skill → commit → `cp -R dev-flow/. ~/.claude/skills/dev-flow/` → push

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
- **V1 抗遗忘无强制**：每阶段重读 reference 是自律，长会话可能跳过。缓解=铁律自查+反模式清单；根治=hook（待用户决定）
- **V2 隔离靠说服**：审查/裁判子代理带工具，物理上能越界读实现。缓解=禁令+反模式+可选 Explore只读agent；根治=沙箱/受限工具集
- 第五道 hook 暂不上，先观察四道防线是否够用
- ponytail 子代理不一定继承，靠 rules.md 保证精简原则
