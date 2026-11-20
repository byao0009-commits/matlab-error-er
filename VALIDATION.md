# 验证记录

## 2026-11-20 首版

| 项目 | 验证结果 |
| --- | --- |
| 技能格式 | 通过 skill-creator 的 `quick_validate.py`。 |
| MATLAB 源码与用法 | 用 MATLAB 语法解析器检查随包 `.m`、合成 `.asv` 和文档中的 MATLAB 代码块。独立核算六类基础案例的预期数值和两个 CSV 的内容。 |
| 学生场景 | 用 R2018a 的 `readmatrix` 截图转录进行独立前向测试，核对版本、命令的放置位置和数据是否读全。测试后为带表头 CSV 补齐列数、首末行和缺失值校验。 |
| 发布结构 | 核对 Markdown 本地链接、ZIP 内容、Git 忽略规则，在本地模拟提交和推送。 |
| MATLAB/Simulink 实机 | 这台机器配置的 R2026a 缺少 `MATLAB.exe`，连接启动失败。以上验证没有在 MATLAB 执行 `.m`，也没有在 Simulink 更新或运行模型。历史版本按官方文档比较。 |

有 MATLAB 的机器可在 `matlab-error-er/assets/repro/` 运行 `matlab_er_verify`。其中带表头和纯数字 CSV 会按当前版本可用的导入函数进行额外检查。安装 Control System Toolbox 后可再运行 `matlab_er_verify('toolbox')`。Simulink 的手动验收见[块尺寸案例](matlab-error-er/references/control.md#从零复现块尺寸错误)。
