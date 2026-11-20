# 版本与工具箱

## 先读学生的环境

学生在命令窗口运行 `version -release`。如果该参数不受支持，再运行 `version`。`ver` 用来列出已安装产品，`which 函数名 -all` 用来确认实际解析到的代码，`help 函数名` 用来查看本机签名。`license('test',特征名)` 检查对应授权是否存在，特征名需按产品确认。即使返回 1，实际签出仍可能因授权已被占用而失败，是否安装也要另看 `ver`。 [MathWorks `license`](https://www.mathworks.com/help/matlab/ref/license.html)

有版本截图时直接使用该 release。未知版本时先给经文档支持的基础写法。只有改法要跨版本分支时才问版本号。老版本、本机文档与当前网页有差异时，优先使用目标 release 的文档、该版 `help` 和本机复现。归档缺实证时明确兼容性待核对。

## 首版常遇到的版本分界

| 写法 | 版本条件 | 给学生的改法 |
| --- | --- | --- |
| 兼容尺寸数组的隐式扩展，例如 `A + row` | R2016b 起适用于支持隐式扩展的运算 | R2007a 至 R2016a 可写 `bsxfun(@plus,A,row)`。更早版本在确知 `row` 是 `1×size(A,2)` 时，用 `A + repmat(row,size(A,1),1)`。成对样本先改成同方向，防止算出矩阵。 [隐式扩展](https://blogs.mathworks.com/loren/2016/10/24/matlab-arithmetic-expands-in-r2016b/) · [`bsxfun`](https://www.mathworks.com/help/matlab/ref/bsxfun.html) |
| 脚本中写局部函数 | MATLAB 自 R2016b 支持脚本局部函数。R2024a 之前放在脚本最后一条脚本语句后面 | 若要兼容更老版本，把函数放入独立 `.m` 文件，保证主函数名与文件名一致，调用时显式传入数据。 [在脚本中定义函数](https://www.mathworks.com/help/matlab/matlab_prog/local-functions-in-scripts.html) |
| `readmatrix` / `readtable` | 分别自 R2019a / R2013b 起。不同文件与参数另有版本条件 | 纯数字 CSV 可按文件约定用 `dlmread`。字段固定的文本用 `textscan`。旧版 Excel 可查本机 `xlsread` 的格式与平台支持。附导入行列和缺失值检查。 [`readmatrix`](https://www.mathworks.com/help/matlab/ref/readmatrix.html) · [`readtable`](https://www.mathworks.com/help/matlab/ref/readtable.html) · [`xlsread`](https://www.mathworks.com/help/matlab/ref/xlsread.html) |
| `imbinarize` | R2016a 起，依赖 Image Processing Toolbox | 确认是固定阈值还是 Otsu。对于归一化灰度和固定阈值 `0.5`，`I > 0.5` 直接给出逻辑掩膜。旧讲义的 `im2bw(I)` 使用默认固定阈值 `0.5`，新版对应 `imbinarize(I,0.5)`。 [`im2bw`](https://www.mathworks.com/help/images/ref/im2bw.html) · [`imbinarize`](https://www.mathworks.com/help/images/ref/imbinarize.html) |
| `tf` / `step` 用于控制 | 依赖 Control System Toolbox，旧讲义的调用和多输出顺序需按版本确认 | `sys = tf(num,den); [y,tOut] = step(sys,t);` 使用显式等间距时间向量，核对本机 `help step`。现代文档的双元素时间区间语法自 R2023b 起。 [`step`](https://www.mathworks.com/help/control/ref/dynamicsystem.step.html) |
| `Simulink.exportToVersion` | 模型导出函数自 R2016a 起。可选目标范围与项目支持因版本而异 | 在较新的 MATLAB/Simulink 中用 GUI 或该版支持的 API 从副本另存旧版，随后用目标版实跑并查模型引用和不兼容的块。 [导出函数](https://www.mathworks.com/help/simulink/slref/simulink.exporttoversion.html) |

修改示例需要兼容老讲义时，选基本 `.m` 文件、字符向量和传统名称值对。涉及 `tiledlayout`、`arguments`、字符串标量、脚本局部函数或新名称值语法时查函数页面的 Version History。候选命令与实际验收分别写清。Octave 的测试信息可以验证一部分语法和数值，MATLAB release 和 Simulink 专属行为需在 MATLAB 确认。

[MATLAB `version`](https://www.mathworks.com/help/matlab/ref/version.html) · [MATLAB `ver`](https://www.mathworks.com/help/matlab/ref/ver.html) · [历史版本文档](https://www.mathworks.com/help/doc-archives.html) · [MATLAB 发布说明](https://www.mathworks.com/help/matlab/release-notes.html)
