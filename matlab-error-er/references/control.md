# 自动控制与 Simulink 实验

## `step` 报错或输出变量接错

**先查模型和依赖**。在命令窗口运行 `version -release`、`which tf -all`、`which step -all`。缺函数时用 `ver` 看 Control System Toolbox 是否安装，再区分授权、路径遮蔽和调用签名。旧讲义可能用 `step(num,den)` 或写 `[y,x,t]`。看目标 release 的 `help step` 后再改。现行动态系统接口中，响应和时间用 `[y,tOut]`，需要状态轨迹时用状态空间模型和 `[y,tOut,x]`。

**有 Control System Toolbox 时，在命令窗口运行**。下面的分母系数按 `s` 的降幂排列，系统是 `G(s)=2/(3s+1)`，输入为单位阶跃。

```matlab
sys = tf(2,[3 1]);
t = (0:0.1:18)';
[y,tOut] = step(sys,t);
plot(tOut,y)
abs(y(end)-2*(1-exp(-tOut(end)/3)))
```

预期初值为零，稳态值为 `2`，`18 s` 时约为 `1.995`，末值和解析式之差应接近零。只调用 `step(sys,t)` 可让 MATLAB 直接绘制阶跃响应。接收输出后用 `plot` 自己绘制。修改时间向量时保持等间距。课题允许解析式对照且已确认是一阶稳定连续系统时，无工具箱也可运行 `y = 2*(1-exp(-t/3)); plot(t,y)`。若做二阶超调、根轨迹或离散系统，按原模型和采样时间分析。

[天津理工大学自动控制实验讲义](https://ydq.tjut.edu.cn/__local/9/3D/05/7ECC05F988144B6CF79D8827C6F_591DEC40_52678.pdf) · [MathWorks `step`](https://www.mathworks.com/help/control/ref/dynamicsystem.step.html)

## Simulink 块报错先定位首个原因

截图里只有一句“Simulation terminated”时，优先请学生在 **Diagnostic Viewer** 展开最早的具体 `Caused by`，点开块路径，提供那个块和前后一级连接的截图。不同 release 入口可能在仿真提示、状态栏或工具菜单。保存工作后使用模型更新 **Ctrl+D** 或按界面的 Update Model，缩小到编译错误。模型更新通过而仿真失败时，再看发生时间和输入变化。

| 看到的证据 | 检查和修改位置 | 验收 |
| --- | --- | --- |
| 端口维数不匹配，Gain 的乘法模式不对 | 找出报错端口、上游维数和块内部运算。若模型要做矩阵乘法 `K*u`，输入列向量长度应等于 `size(K,2)`。用元素相乘需确认题意。 | 更新模型通过，在 Display、Scope 或数据记录中核对这个块的实际输出。 |
| 块参数的工作区变量未定义 | 看具体参数引用的是模型工作区、数据字典还是基础工作区。查课程提供的初始化脚本和模型回调，按项目入口恢复真实值。 | 模型用正确的初始化流程可单独重开和运行，并核对参数数值。 |
| 连续与离散块采样时间冲突，或定步长报错 | 检查块 Sample time、模型求解器、定步长、信号的采样时间来源。确认接口是否需要 Rate Transition 或保持器，以及不同采样率的模型含义。 | 诊断消失，在明确的时间网格复查记录值和单位。 |
| 某时刻导数、状态或输出非有限 | 看出错时刻和最早出现 `Inf` 或 `NaN` 的块。检查分母过零、不合理初始状态、输入域和参数单位。 | 用同一输入在相同时段重跑，对照故障块之前和之后的数值。 |

## 从零复现块尺寸错误

安装 Simulink 的环境下，在 Current Folder 指向 `assets/repro/` 后，先在命令窗口运行 `model = matlab_er_simulink('broken');`。它创建一个独立的新模型。按 **Ctrl+D** 应出现 Gain 相关的维数错误，连接关系是 Constant `[1;2]` → Gain `2*eye(3)` → Display。Gain 使用 `Matrix(K*u)`。若没有运行到模型窗口，先检查产品和许可证。

在模型中的 Gain 块把 Gain 改为 `2*eye(2)`，保留矩阵乘法模式。重新按 **Ctrl+D**，再点 Run。预期 Display 给出 `2` 和 `4`。也可关闭示例后运行 `matlab_er_simulink('fixed')` 新建修好版。需要保留模型时另存进自己的实验目录。

[MathWorks Diagnostic Viewer](https://www.mathworks.com/help/simulink/slref/diagnosticviewer.html) · [Simulink Gain 参数](https://www.mathworks.com/help/simulink/slref/gain.html)
