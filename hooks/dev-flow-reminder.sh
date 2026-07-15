#!/bin/bash
# dev-flow 开发任务提醒 hook（UserPromptSubmit）
# 作用：检测到明确的开发意图时，注入一句提醒——第一步必须走 dev-flow 技能。
# 只提醒不阻断：命中就在上下文里加一行，模型自己判断是否真是开发任务；不命中静默退出。
# 安装：见 dev-flow 仓库 README「hook 安装」。

# 强制 UTF-8 locale：否则 grep 的 . 按字节数，一个中文字=3字节，.{0,N} 距离会失真（只影响本脚本子进程）
export LC_ALL=en_US.UTF-8

input=$(cat)
prompt=$(printf '%s' "$input" | python3 -c "import sys,json;print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null)

# 明确开发向的动词/词组 + 「动词+软件名词」组合；刻意不匹配「做个总结/写个邮件」这类万能词
if printf '%s' "$prompt" | grep -qiE \
  '写代码|开发|重构|部署|上线|bug|加.{0,8}功能|新功能|改需求|建(项目|仓库)|写脚本|发布(到|上|一)|(做|搭|整|写|建|开发|改|加|实现).{0,10}(工具|网站|网页|程序|脚本|应用|小程序|app|插件|技能|skill|系统|平台|接口|api|爬虫|命令行|cli|前端|后端|页面|dashboard|组件)|coding|refactor|\bdeploy|implement (a|the)|build (a|the|me)|create (a|the).{0,20}(tool|app|script|website|feature)'; then
  echo "⚙️ [dev-flow] 检测到可能的开发任务：若确属写代码/建项目/加功能/修bug/发布/部署等，第一步必须调用 dev-flow 技能做任务分级后再动手，禁止直接开写；若只是解释代码、概念问答或闲聊，忽略本提醒。"
fi
exit 0
