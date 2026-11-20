# 信号、采样与数字图像实验

## FFT 峰值频率与幅值

**先看数据和题目**。从采集记录确认采样率 `Fs` 的单位是 Hz。`N` 用选定通道的样本数。输入是矩阵时先确认样本沿哪一维、哪一列是要分析的通道。实数单边谱、复信号双边谱和功率谱密度的尺度不同，按实验要求选择。看不到 `Fs` 时可以先纠正频点编号，并请用户补采样间隔。

**替换实数单通道的单边幅值谱片段**。`N` 样本对应的时刻从 `0` 到 `(N-1)/Fs`。用 `linspace(0,N/Fs,N)` 会包含多余的终点，实际采样间隔就变了。

```matlab
Fs = 1024;
N = 256;
t = (0:N-1)/Fs;
x = 0.75*sin(2*pi*64*t);
Y = fft(x);
last = floor(N/2)+1;
P = abs(Y(1:last))/N;
if mod(N,2) == 0
    P(2:end-1) = 2*P(2:end-1);
else
    P(2:end) = 2*P(2:end);
end
f = (0:last-1)*Fs/N;
[peak,k] = max(P);
disp([f(k) peak])
plot(f,P)
```

预期峰在 `64 Hz`，幅值为 `0.75`。实数输入的直流和偶数长度的奈奎斯特分量不成对，两个频点不翻倍。奇数长度没有奈奎斯特频点。改成 `N=255` 又想验证精确幅值时，用整 DFT 频点 `16*Fs/N` 生成正弦。采样值来自文件时从实际长度计算 `N`，补零增加读图网格密度。记录长度和窗函数仍影响分辨能力及幅值。出现低于预期的峰先排查混叠、频谱泄漏和加窗增益，再检查绘图。

[大连理工大学《信号与系统实验》](https://teach.dlut.edu.cn/20171106002.pdf) · [MathWorks FFT 单边幅值示例](https://www.mathworks.com/help/matlab/ref/fft.html)

## 图像全黑、灰度通道和老版二值化

**先在命令窗口确认格式**。变量名已知为 `I` 时可运行 `size(I)`、`class(I)`、`min(I(:))`、`max(I(:))`。三通道数组、二维灰度图和索引图的处理不同。怀疑索引图时，要从原文件的 `imread` 同时接收图像和色表，按色表解释像素。对 RGB 做灰度处理前先确认题目要求的变换。阈值处理前统一尺度。

**可复制例子**。下面验证固定阈值 `0.5`，输入明确为 `uint8` 灰度图。直接把 `uint8` 样本转成 `double` 会保留 `0–255` 的数值，`double` 图像按 `[0,1]` 显示时会发生截断。下面的换算只适用于这类 8 位无符号灰度输入。

```matlab
I = uint8([0 127; 128 255]);
G = double(I)/255;
BW = G > 0.5;
disp(BW)
```

预期 `BW` 是逻辑矩阵 `[0 0; 1 1]`。提供 `imshow` 的版本与安装上可用 `imshow(BW)` 查看结果。仅需预览二维数值时可以用 `imagesc(G); axis image off; colormap(gray(256)); colorbar`，注意 `imagesc` 通常会按数据范围自动调整色限。不同图需要可比时统一色限。

**老讲义迁移**。`im2bw(I)` 使用默认固定阈值 `0.5`。有 Image Processing Toolbox 的 R2016a 及更新版本可用 `imbinarize(I,0.5)` 保留这个阈值。`imbinarize(I)` 默认用全局 Otsu 阈值，差异会直接改变实验结果。题目要比较 RGB 与灰度或要求特定滤波函数时，保留转换步骤，根据 `ver` 和 `which 函数名 -all` 确认依赖。一些旧版工具箱函数在新版本中仍可调用。看到迁移提示时先核对文档。

[山东农业大学《数字图像处理实验》](https://xinxi.sdau.edu.cn/jszx/2018/0831/c9469a133982/page.htm) · [MathWorks `im2bw`](https://www.mathworks.com/help/images/ref/im2bw.html) · [MathWorks `imbinarize`](https://www.mathworks.com/help/images/ref/imbinarize.html) · [Otsu 原论文](https://doi.org/10.1109/TSMC.1979.4310076)
