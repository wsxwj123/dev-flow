# snippets：派子代理时照抄的片段（跨阶段共用）

只放多个阶段都要用的三样：预算块、security-review 前置命令、测试摘要生成命令。各阶段自己的逐字禁令仍在各阶段文件里，不搬过来。

## 1. 预算块（派任何子代理都贴进 prompt，按角色填数）

照抄这段，把 N / M / K 换成下表的数：

> 预算：工具调用不超过 N 次；测试用例不超过 M 条；最终报告不超过 K 字，固定四段：结论 / 改了什么 / 测试数字 / 问题与疑问。只做本 prompt 列出的几处，没要求的事不做：不为了验证测试本身去搭假服务、不做变异验证（裁判除外）、不额外加用例、不通读大文件。快到上限还没做完，就停下来交中间报告，说清做到哪、还差什么。

| 角色 | 工具调用上限 N | 测试条数上限 M | 报告上限 K |
|---|---|---|---|
| 调研+方案（中档合成一个代理） | 120 | 最小实验只跑直接相关的 1–2 个测试文件 | 4000 字 |
| 方案盲审 | 60 | 不写测试 | 4000 字 |
| 测试设计（只有标准档派） | 100 | 默认 30，超出要在 TEST-PLAN 里写理由 | 4000 字 |
| 开发（每个代理） | 轻档 60 / 中档 120 / 标准档 200 | 轻档 15 | 3000 字 |
| 裁判 | 60 | 不写测试 | 3000 字 |
| 安全审计 | 60 | 不写测试 | 4000 字 |

为什么限的是工具调用次数不是 token：代理自己数不准用了多少 token，但每次调用都数得清。token 由主会话在代理返回后，按工具报回来的用量记进 `.devflow/HISTORY.md`。

**整个任务的总闸**（主会话记账）：所有代理合计，轻档超过 300 次调用或 60 万 token、中档超过 600 次或 150 万、标准档超过 1500 次或 400 万，就停下向用户汇报，再决定继续还是收手。以上全是初始值，记账两周后按实际用量校准。

## 2. 跑内置 security-review 之前，先补 origin/HEAD

内置 security-review 靠 `git diff origin/HEAD...` 找改动。这个引用只有 clone 来的仓库自带，本地起家的仓没有，缺了它技能一行 diff 都拿不到，直接报"有歧义的参数 origin/HEAD"。跑之前先执行：

```bash
git rev-parse -q --verify origin/HEAD >/dev/null || { git remote get-url origin >/dev/null 2>&1 && git fetch -q origin && git remote set-head origin -a; } || git symbolic-ref refs/remotes/origin/HEAD refs/heads/master
```

有远端就 fetch 后建真引用（一次永久）；没远端或网络被拦，就造一个指向本地主分支的替身（`master` / `main` 按实际填），diff 基线一样正确。造过替身的，06 建仓 push 后跑一次 `git remote set-head origin -a` 归正。

## 3. 测试摘要怎么生成（裁判只看摘要，不看几千行原始输出）

先让测试框架出机器可读的报告，再从报告里取数。主会话不手写数字，手写等于多出一个要被信任的环节。

```bash
# pytest
pytest tests/acceptance -q --junitxml=.devflow/junit-<任务名>.xml 2>&1 | tee .devflow/test-output-<任务名>.txt
# jest
npx jest --json --outputFile=.devflow/jest-<任务名>.json
# playwright
npx playwright test --reporter=json > .devflow/pw-<任务名>.json
```

摘要文件 `.devflow/test-summary-<任务名>.md` 固定五段：
1. 通过 / 失败 / 跳过各几条
2. 失败用例清单：用例名 + 断言信息各一行
3. 每条跳过的用例和它的跳过原因（一条都不许省，跳过是最容易藏问题的地方）
4. 锁定核查结果：LOCK 那次提交是否在当前 HEAD 的历史里、`tests/acceptance/` 的 diff 是否为空、测试运行环境（conftest / pytest.ini / package.json 的 test 脚本等）有没有被改
5. 实点 / 真调结果

末尾附原始输出文件路径，裁判按需 grep，并抽一处计数和原始输出对一对。
