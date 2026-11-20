# 数值计算实验

每节先判断学生卡在读入数据、调用语言语法还是算法要求。以下自建例子和高校实验课主题对应，变量和数值可直接用于最小复现。

## 线性方程组与矩阵运算

**截图常见线索**。求 `Ax=b` 的代码写了 `A\b`，但 `size(A)` 显示 `2×2`，`size(b)` 显示 `1×2`。这是右端向量方向问题。若看到 `A.*x`，先确认目标是逐项运算还是用矩阵乘法核查方程。旧版可能立即报尺寸错误，新版的隐式扩展可能让逐项乘法产生整个矩阵。

**在命令窗口复现**。数值明确时可以运行以下代码。适用条件是实验只有一个长度为 `size(A,1)` 的右端向量。若有多组右端，保留 `B` 的列结构并检查 `size(B,1)`。

```matlab
A = [3 1; 1 2];
b = [5 5];
x = A\b(:);
size(x)
norm(A*x-b(:), inf)
```

预期 `size(x)` 为 `[2 1]`，解为 `[1;2]`，无穷范数残差接近零。若学生遇到近奇异警告，小残差仍可能与较大的解误差并存，继续查看 `rcond(A)`、方程缩放和题目给定条件。方阵求解用 `A\b`。课上要求手写带主元消元时，检查选主元、换行是否也作用于右端、回代索引，再用 `A\b` 做对照。矩形系统可能对应最小二乘，不能套用方阵的零残差判据。

[华南理工大学《计算方法》](https://www2.scut.edu.cn/cs/2019/0909/c23109a332942/page.htm) · [MathWorks `mldivide` 的警告和结果说明](https://www.mathworks.com/help/matlab/ref/double.mldivide.html)

## CSV、Excel 与多项式拟合

**先查导入**。看到找不到 `readmatrix`，在命令窗口运行 `version -release` 和 `which readmatrix -all`。看到打不开文件，先核对 `pwd` 与实际文件位置。运行包内例子时让 Current Folder 指向 `assets/repro/`，或使用实际绝对路径。

| 数据文件 | 可用的导入方式 |
| --- | --- |
| `fit_numeric.csv`，只有两列数字 | R2019a 起可用 `D = readmatrix('fit_numeric.csv');`。旧版用 `D = dlmread('fit_numeric.csv',',');`。 |
| `fit_header.csv`，一行列名加两列数字 | 支持 `readtable` 的目标版先试 `T = readtable('fit_header.csv');`，确认 `size(T,2)` 为 2 且两列均为数值，再用 `D = T{:,:};`。对已确认只有一行表头、无引号、无缺失值的固定格式，可用 `D = dlmread('fit_header.csv',',',1,0);`。复杂文本按分隔符、字段类型和缺失值规则配置导入。 |
| 带工作表选择或混合类型的 Excel | 先对照表头、工作表名和列范围，再用目标版本支持的 `readtable`、`readmatrix` 或 `xlsread`。较旧 `xlsread` 的平台、Excel 引擎及文件格式限制按本机帮助确认。 |

在命令窗口用 `type fit_header.csv` 预览这类小 CSV 并核对原始记录数。`size(D)` 应等于原始数据行数和列数。样例应为 `[6 2]`，首行 `[0 2.1]`，末行 `[5 11.9]`，六行可逐条核对。`sum(~isfinite(D),1)` 应为 `[0 0]`。自己实验的数据以原始记录为准。若行数、数值或列类型不符，先修文件选择与导入选项，再决定是否需要处理缺失值。

**在编辑器替换拟合段**。这里使用两个等长实数列、样例无缺失且至少两个不同横坐标。把 `d` 改成实验要求的次数，先确认 `0 <= d <` 有限样本中不同横坐标的个数。不同横坐标太少时检查重复测量的处理规则。

```matlab
x = D(:,1);
y = D(:,2);
d = 1;
[p,S,mu] = polyfit(x,y,d);
yHat = polyval(p,x,S,mu);
rmse = sqrt(mean((y-yHat).^2));
plot(x,y,'o',x,yHat,'-')
```

`p` 对应以 `mu` 中心化和缩放后的横坐标。计算预测时把 `mu` 一起传给 `polyval`，不要把归一化系数直接当原坐标多项式系数。若实验需要画平滑曲线，构造 `xq = linspace(min(x),max(x),200);`，用相同的 `mu` 计算查询点。样例 RMSE 小于 `0.2`。高阶拟合后只看到平滑连接时，检查采样点之间的曲线、残差分布和留出的数据点。课题要求插值时才把通过每个样本点当验收条件。

[中国矿业大学多项式最小二乘实验](https://math.cumt.edu.cn/_upload/article/files/eb/2e/9640c2ca4250a6147459fe80e552/5fbb03a6-121b-4a05-a526-da72f8eaaca2.pdf) · [MathWorks `polyfit`](https://www.mathworks.com/help/matlab/ref/polyfit.html) · [MathWorks `polyval`](https://www.mathworks.com/help/matlab/ref/polyval.html)

## `ode45`、初值与课程指定算法

**检查入口**。`ode45(rhs(t,y),...)` 先计算了导数，传给求解器的就成了数值。传入函数句柄 `@rhs` 或 `@(t,y) ...`。运行 `size(y0)`，再用症状对应的初始时刻在命令窗口试算 `dy0 = rhs(t0,y0); size(dy0)`。状态是列向量，回调应返回长度相同的导数列向量。二阶方程先写出状态定义和对应的一阶方程组。

**可以直接运行的二阶例子**。这里求 `x''=-x`，初始位移为 1、速度为 0，因而解析解是 `cos(t)`。

```matlab
rhs = @(t,y) [y(2); -y(1)];
y0 = [1; 0];
opt = odeset('RelTol',1e-8,'AbsTol',1e-10);
[t,Y] = ode45(rhs,[0 pi/2],y0,opt);
abs(Y(end,1)-cos(t(end)))
abs(Y(end,2)+sin(t(end)))
plot(t,Y(:,1))
```

预期两项误差均小于 `1e-6`，约在 `pi/2` 时位移到零、速度到 `-1`。`Y` 每列对应一个状态。若要比较欧拉法、RK4 和 `ode45`，使用共同的时间点或插值后再比较。`ode45` 仍可通过自适应内部步长计算结果。课堂指定显式算法时，先查步长、右端求值时刻和中间状态更新，最后用解析解或 `ode45` 核对。出现步长过小或无法达到容差的警告时，先查参数单位、分母、初值和不连续点，再依据方程性质考虑刚性求解器如 `ode15s`。

[华南理工大学实验大纲](https://www2.scut.edu.cn/cs/2019/0909/c23109a332942/page.htm) · [华南师范大学实验教程，可能要求登录](https://moodle.scnu.edu.cn/course/view.php?id=11484&lang=zh_cn) · [MathWorks `ode45`](https://www.mathworks.com/help/matlab/ref/ode45.html) · [Shampine 与 Reichelt 原论文](https://www.mathworks.com/help/pdf_doc/otherdocs/ode_suite.pdf)
