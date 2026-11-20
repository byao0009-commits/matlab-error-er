# MATLAB 报错急诊室

给中国高校实验课用的 Agent Skill。把 MATLAB 或 Simulink 的报错截图、代码片段或异常曲线交给支持图片和 Agent Skills 的 AI，技能会定位问题，给出可以复制的命令、最小修改和实验验收方法。截图能读出多少，就先处理多少。

## 在 Codex 里使用

1. 下载仓库并解压。要安装的是内层 `matlab-error-er/`，该文件夹直接包含 `SKILL.md`。
2. 项目内使用时，把内层文件夹复制到项目根目录下的 `.agents/skills/`，得到 `.agents/skills/matlab-error-er/SKILL.md`。希望在个人项目间复用时，复制到 Windows 的 `%USERPROFILE%\.agents\skills\` 或 macOS/Linux 的 `~/.agents/skills/` 下。找不到技能时重新启动 Codex。其他 Agent 按各自的技能目录或导入方法安装。 [Codex Skills 文档](https://developers.openai.com/codex/skills/)
3. 在对话里附上截图，输入 `$matlab-error-er 帮我定位这张截图里的错误，给我能复制的命令和修改后的代码。` 知道版本的话，顺手补上 `version -release` 的输出。Simulink 建议附上 Diagnostic Viewer 展开后的第一条错误。

## 实验覆盖

| 实验课 | 首批案例 |
| --- | --- |
| 计算方法 | 线性方程组、矩阵和逐元素运算、残差与病态矩阵 |
| 数学实验 | CSV 和 Excel 导入、拟合阶数、中心化与残差图 |
| 常微分方程 | 函数句柄、导数列向量、解析解和课程指定算法 |
| 信号与系统 | FFT 频率轴、奇偶长度单边谱、采样率与采样端点 |
| 数字图像处理 | RGB 与灰度、`uint8` 尺度、旧版二值化语义 |
| 自动控制原理 | 阶跃响应、旧讲义的输出顺序、Simulink 块错误和采样时间 |

按用户安装的 MATLAB release 给写法。仓库附有[版本判定表](matlab-error-er/references/releases.md)、[脚本和模型备份恢复](matlab-error-er/references/recovery.md)及[国内课程、教材与论文索引](matlab-error-er/references/sources.md)。将学生报告、原始实验数据、截图和个人 MATLAB 备份留在自己的工作目录。

## 复现实验

在 MATLAB 里用 Current Folder 打开 `matlab-error-er/assets/repro/`，在命令窗口输入以下任一命令。样例脚本与数据是原创的，可以在自己的课件和排障练习里复用。

```matlab
matlab_er_demo('linear','broken')
matlab_er_demo('fft','fixed')
matlab_er_verify
```

`matlab_er_verify` 检查六类实验的基础数值结果，其中控制案例使用一阶模型解析式。安装 Control System Toolbox 后可运行 `matlab_er_verify('toolbox')`，额外检查 `tf` 和 `step`。安装 Simulink 后可用 `matlab_er_simulink('broken')` 和 `matlab_er_simulink('fixed')` 查看同一个模型的两种设置，详见[控制案例](matlab-error-er/references/control.md)。

运行环境和实际验证范围见[验证记录](VALIDATION.md)。

## 上传到 GitHub

上传仓库外层目录中的内容，确保 GitHub 首页能直接看到 `README.md`、`LICENSE`、`.gitignore`、`VALIDATION.md` 和内层目录 `matlab-error-er/`。请保留内层目录结构。

### 网页上传

1. 在 GitHub 创建仓库，例如 `matlab-error-er`，选择 Public 或 Private。网页路线可先勾选添加 README，用来创建初始分支。
2. 打开仓库，选 **Add file → Upload files**。把解压后外层目录中的文件和内层 `matlab-error-er/` 文件夹一起拖进去。确认上传清单包含 `.gitignore`。如果系统隐藏了点文件，可在 GitHub 用 **Add file → Create new file** 单独创建 `.gitignore`，粘贴随包提供的内容。
3. 选择提交到 `main` 并点 **Commit changes**。打开仓库首页确认 README 正常显示，再点进 `matlab-error-er/SKILL.md`，检查 `references/`、`assets/` 和 `agents/` 都在。 [GitHub 网页添加文件](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository)

### Windows PowerShell 或 Git 命令行

1. 在 GitHub 新建空仓库，跳过添加 README、许可证和 `.gitignore`。若尚未配置 Git 提交身份，可在 `git init` 后用 `git config user.name "你的显示名"` 和 `git config user.email "你的提交邮箱"` 为当前仓库设置。公开仓库可使用 GitHub 提供的 `noreply` 提交邮箱。
2. 在外层发布目录打开终端，执行前四条命令，并先检查暂存清单有没有意外的文件。

   ```powershell
   git init -b main
   git add --all
   git status --short
   git diff --cached --check
   ```

3. 将 `YOUR-ACCOUNT` 和 `YOUR-REPO` 换成你的 GitHub 用户名或组织名、仓库名，再提交和推送。根据 Git 提示完成 GitHub 认证。

   ```powershell
   git commit -m "发布 MATLAB 报错急诊室首版"
   git remote add origin https://github.com/YOUR-ACCOUNT/YOUR-REPO.git
   git push -u origin main
   ```

4. 刷新 GitHub 仓库页面，确认默认分支是 `main`，并检查主页和技能文件。如果远端已经有初始提交，先克隆远端仓库，再复制本套发布文件进去并提交。 [GitHub 命令行上传指南](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)

## 授权

本仓库原创文字、代码、样例数据和合成备份采用 [MIT 许可证](LICENSE)。参考文献、教材和课程链接指向原发布方，其内容适用原发布方的授权。
