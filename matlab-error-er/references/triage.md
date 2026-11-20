# MATLAB 通用排障

## 截图里先找什么

- **命令窗口**。有时最上面一条红字是原因，后面的 `Error in … (line …)` 给堆栈。优先找出错表达式，再沿调用检查其输入。报错格式随语言、版本、编辑器和运行入口变化，可同时用函数名、英文错误片段和错误 ID 查文档。
- **编辑器或 Live Editor**。区分代码分析器提示和实际运行错误。检查保存状态、运行的是整个文件还是当前节、输入变量是否由前面的单元格初始化。改了同名文件却没有生效时，核对 MATLAB 实际运行的路径。
- **曲线或表格**。先找课题要求的单位、参考趋势和坐标轴。只凭截图判断不出采样率、数组形状或模型参数时，给一个对应的检查，并保留当前已能确定的结论。

## 最短检查路径

| 现象或英文关键词 | 先检查 | 对应修改 |
| --- | --- | --- |
| `Unrecognized function or variable`、`Undefined function` | 识别名字应是变量、函数、脚本还是模块所提供的函数。变量用 `whos`，函数用 `which 名称 -all`。路径用 `pwd`，必要时检查版本和工具箱。 | 改大小写或拼写，先运行初始化节，用正确入口调用函数，或把共享函数放到项目搜索路径。遇名称冲突时重命名学生自己的同名文件，并按实际调用更新。 |
| `Incorrect dimensions for matrix multiplication`、`Matrix dimensions must agree`、`Arrays have incompatible sizes` | 在出错表达式的同一个工作区查看两侧的 `size`。辨别矩阵乘法与逐元素运算，以及较新版本隐式扩展后生成的意外外积。 | 改成与公式对应的 `*` 或 `.*`。对成对样本且长度相等的行、列向量，用 `x(:)`、`y(:)` 统一方向。核对广播后目标形状。 |
| `Index exceeds …`、`Index in position … exceeds array bounds`、`Array indices must be positive integers or logical values` | `size(A)`、`numel(A)`、`class(idx)`。对非空数字索引再看 `min(idx(:))` 和 `max(idx(:))`。注意 MATLAB 从 1 开始，逻辑索引要匹配预期维度。 | 用 `size(A,dim)` 设维度上界。FFT 的物理频点编号从 0 开始，读数组时加 1。浮点时间值用来查匹配或者插值。 |
| `Not enough input arguments`、`Too many input arguments`、脚本无法当函数执行 | `which 名称 -all` 后对照函数声明或本机 `help 名称`。看是否点了编辑器 Run 来运行需要输入的函数。 | 从命令窗口用课题值传参，或修正调用签名。函数工作区的数据显式通过参数传入。 |
| `Invalid expression`、`Invalid use of operator`、无法解析文件 | 从指示符附近以及上一行开始查成对引号、括号、续行 `...` 和全角字符。MATLAB 续行一般使用 ASCII 三个点。 | 给出整条替换语句，保留字符串中的中文内容。旧版编辑器读源文件异常时确认文件编码及源文件中的实际字符。 |
| 无报错但曲线像空图或数据全平 | 查看数据范围、`size`、非有限值、轴限和单位。实数数组可检查 `min(y(:))`、`max(y(:))` 和 `sum(~isfinite(y(:)))`。空数组先查导入与筛选条件。 | 修数据或可视化参数。先检查第一个偏离参考的中间变量，给一个可判断正误的预期值。 |

## 在出错现场查看局部变量

在**命令窗口**输入以下命令并重新运行刚才的入口。`dbstatus` 用于先查看现有断点。停在 `K>>` 后用 `dbstack` 看调用栈，用 `whos` 或 `size(报错行里的实际变量)` 检查该函数工作区。

```matlab
dbstatus
dbstop if error
```

一般可用 `dbquit` 结束这次调试。如果本次临时新增了错误断点，调试结束可运行 `dbclear if error` 撤掉。原本就配置了这类断点时保留它。文件解析失败通常直接修语法，条件断点只捕获可以进入调试器的执行错误。看到工具箱内部栈时回到第一个由学生控制的调用点。

可复现的入口、原始报错首行、出错行及最相关的变量尺寸通常足够。若截图带学号、账号或个人路径，请学生截取必要区域。作业要求实现特定算法时，使用 MATLAB 内置函数或解析式交叉验证，保留对该算法错误的解释。

[MathWorks 调试代码](https://www.mathworks.com/help/matlab/matlab_prog/debugging-process-and-features.html) · [查找函数与文件 `which`](https://www.mathworks.com/help/matlab/ref/which.html) · [数组与矩阵运算](https://www.mathworks.com/help/matlab/matlab_prog/array-vs-matrix-operations.html)
