# 国内实验课、教材与论文

先用国内实验说明确认课程在考什么，再用目标 MATLAB release 的文档决定语法与兼容性。高校讲义中的数据、代码和插图仍适用原出处的使用条款。此仓库的复现值、脚本和备份由项目自行编写。

## 国内实验课

| 来源 | 在技能中查什么 |
| --- | --- |
| 华南理工大学计算机科学与工程学院《计算方法》实验大纲 | 线性和非线性方程组、插值、拟合、积分、ODE 等教学范围与 MATLAB 上机要求。 [大纲](https://www2.scut.edu.cn/cs/2019/0909/c23109a332942/page.htm) |
| 华南师范大学《基于MATLAB的〈数值分析〉之实验教程》 | 带主元高斯消元、拟合、欧拉与 RK 法和 `ode45` 对照。课程站部分内容可能需要登录。 [课程页](https://moodle.scnu.edu.cn/course/view.php?id=11484&lang=zh_cn) |
| 内江师范学院数值仿真与数学实验教学示范中心 | 数值分析实验配套讲义与案例，可与不同学校要求互相对照。 [实验讲义](https://szfzsy.njtc.edu.cn/info/1038/1069.htm) |
| 中国矿业大学多项式最小二乘拟合实验 | 对同一组六个观测点比较不同次数，观察样本点之间的波动。使用旧语法时对照本机 MATLAB 文档。 [拟合讲义 PDF](https://math.cumt.edu.cn/_upload/article/files/eb/2e/9640c2ca4250a6147459fe80e552/5fbb03a6-121b-4a05-a526-da72f8eaaca2.pdf) |
| 大连理工大学《信号与系统实验》 | 采样、频域分析和仿真题型，确认学生目标是频谱、采样验证还是系统响应。 [实验大纲 PDF](https://teach.dlut.edu.cn/20171106002.pdf) |
| 重庆大学电工电子国家级实验教学示范中心《信号与系统实验》 | FFT、截断与离散影响。页面可能触发站点防护。 [教学大纲](https://eelab.cqu.edu.cn/info/1039/1113.htm) |
| 山东农业大学《数字图像处理实验》 | `imread`、显示和二值化的老讲义，及二维频域实验。 [实验大纲](https://xinxi.sdau.edu.cn/jszx/2018/0831/c9469a133982/page.htm) |
| 天津理工大学《自动控制原理实验讲义》 | 阶跃、脉冲及低阶模型参数影响，保留了旧版调用形式用于版本排查。 [讲义 PDF](https://ydq.tjut.edu.cn/__local/9/3D/05/7ECC05F988144B6CF79D8827C6F_591DEC40_52678.pdf) |

## 教材与使用指南

- 《MATLAB数学实验与建模》，清华大学出版社，ISBN `9787302215271`。基于 MATLAB R2009a。矩阵、数据建模、程序与图形几章适合追踪早期教材的接口。 [出版社目录](https://www.tup.tsinghua.edu.cn/booksCenter/book_03538302.html)
- 《MATLAB 数学实验（第 2 版）》，胡良剑、孙晓君，高等教育出版社，2014。用于核对国内数学实验课程的教材线索。 [北方工业大学参考书目](https://jwc.ncut.edu.cn/DG7087101.pdf)
- Cleve Moler，*Numerical Computing with MATLAB*。推荐按问题查看 Linear Equations、Least Squares、Ordinary Differential Equations 或 Fourier Analysis。电子版可依原页条款阅读。 [章节与代码](https://www.mathworks.com/moler/chapters.html)
- Tobin A. Driscoll 与 Richard J. Braun，*Fundamentals of Numerical Computation*。数值条件、误差和解法验证可查作者配套 MATLAB 版。 [作者教材站](https://fncbook.com/matlab/)
- MathWorks 的 *MATLAB Primer* 与编程及调试帮助适合核实命令、数组、工作区和脚本。版本分界以函数 Version History、目标版档案和本机帮助为准。 [Primer](https://www.mathworks.com/help/pdf_doc/matlab/learn_matlab.pdf) · [调试指南](https://www.mathworks.com/help/matlab/matlab_prog/debugging-process-and-features.html) · [版本档案](https://www.mathworks.com/help/doc-archives.html)

## 原始论文及实验教学研究

| 论文 | 对实验诊断的用途 |
| --- | --- |
| Lawrence F. Shampine、Mark W. Reichelt，*The MATLAB ODE Suite*，1997 | 查自适应步长、容差及刚性求解器背景。现行接口仍查对应 release。 [论文 PDF](https://www.mathworks.com/help/pdf_doc/otherdocs/ode_suite.pdf) |
| James W. Cooley、John W. Tukey，*An Algorithm for the Machine Calculation of Complex Fourier Series*，1965 | 追溯快速计算 DFT 的算法出处。实际的单边幅值、频率轴和数据形状使用 `fft` 文档与合成输入验证。 [原文扫描件](https://www.cs.jhu.edu/~misha/ReadingSeminar/Papers/Cooley65.pdf) |
| Nobuyuki Otsu，*A Threshold Selection Method from Gray-Level Histograms*，1979 | 解释自动阈值的来源，帮助区分固定阈值实验和根据直方图选阈值的实验。 [IEEE DOI](https://doi.org/10.1109/TSMC.1979.4310076) |
| 《最小二乘法研究性实验的设计与实现》 | 国内实验案例，帮助设计拟合质量、欠拟合与过拟合的核对方法。 [期刊原文页](https://www.sy.uestc.edu.cn/cn/article/id/53b34176-66f5-49f8-b963-dc46f3e1b698) |
| 《“信号分析与处理”线上线下同步过程化实验教学方法》 | 国内信号实验课设置的例子，结合课程实际区分 DFT/FFT 和后续滤波题型。 [期刊 DOI](https://doi.org/10.12179/1672-4550.20220506) |
