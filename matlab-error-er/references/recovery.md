# MATLAB 脚本和 Simulink 模型恢复

优先在副本上处理，保留原件、修改时间和依赖文件。打开来历不明的脚本或模型前，先核实来源。恢复脚本先查看文本，恢复模型先确认来源和回调。遇到坏文件或新旧版本不兼容时，把“恢复文件”“转换版本”“运行并核对模型”分成三步。

## `.asv` 脚本备份

MATLAB Editor 启用备份且写入成功时，可能留下 `.asv`。在文件管理器复制这份备份到一个独立目录，用编辑器查看，另存为合适的 `.m` 文件。和仍存在的原件比较最近改动。若文件第一行是函数声明，恢复出来的主函数文件名应与声明一致。若备份早于丢失的修改，继续看版本控制、系统备份和本机编辑器历史。

**练习样本**。将[原创 `recovery_gain.m.asv`](../assets/recovery/recovery_gain.m.asv) 的副本另存为 `recovery_gain.m`。它是普通文本脚本。检查源码后在 MATLAB 把 Current Folder 切到副本所在目录，输入 `recovery_gain`。命令窗口应输出 `[2 4 6]`，备份副本继续保留。Windows 建议显示文件扩展名，确认文件以 `.m` 结尾。

[MathWorks 异常退出后恢复编辑器文件](https://www.mathworks.com/help/matlab/matlab_env/recovering-data-after-an-abnormal-termination.html)

## `.slx.autosave`、`.mdl.autosave` 与 `.original`

- 官方设置文档描述的模型自动保存副本一般与原模型同目录，例如 `course.slx.autosave`。发现它时先同时复制原模型、备份和依赖文件到独立目录，保留原模型和备份的对应文件名。是否可生成和触发恢复取决于版本、设置、修改状态和文件可写性。
- 在兼容版本打开副本。如果弹出 Model Recovery，先确认备份确实更新，再选 **Restore**，有选项时同时勾选保留原模型。Restore 会在工作副本目录用备份覆盖原模型并消耗该自动保存文件，保存原件的选项可能生成 `.slx.original` 或 `.mdl.original`。选择 Ignore 可先检查当下打开的模型。
- 没有提示时先核对版本、本机设置、文件时间和命名。若只剩一份已确认来自可信模型的备份，依据目标版本的指导从备份副本恢复同类型文件，保留原复合扩展名文件。不要把二进制 `.slx` 当成文本 `.mdl`。也可能有 `course.slx.R20XXx` 一类的跨版本覆盖备份，处理前看该 release 的说明。
- 用[自建模型](control.md#从零复现块尺寸错误)练习时，先另存到临时实验目录，再根据本机版本在 Simulink 设置中启用 **Save before updating or simulating the model**。编辑块参数、保持未手动保存，更新模型后检查实验目录和自动保存行为。正常关闭修改中的模型可能删除 `.autosave`，发现样本文件后可先复制再关闭。本包提供创建这类模型的源码和可执行步骤，自动保存文件由本机 Simulink 生成。

[MathWorks Simulink 自动保存和恢复设置](https://www.mathworks.com/help/simulink/slref/simulinksettings.html#SimulinkSettings-SaveBeforeUpdatingOrSimulatingTheModel)

## 模型版本与未知 `.bkp`

旧版 MATLAB 打不开课程下发的新版模型时，优先让具备较新 Simulink 的制作者对副本执行 **Export Model to Previous Version**。可选目标版本查看导出菜单或对应版文档。R2016a 起可以按本机支持的签名使用 `Simulink.exportToVersion`。导出后在目标版检查涉及的工具箱、模型引用、字典和替换块，运行课题给定工况比较输出。

看到单独一个 `.bkp` 时，先记录完整后缀，询问由哪款软件产生并保留原件。只有格式和来源确认为 MATLAB/Simulink 工作流时才按相应文档恢复。对辨认不出的文件，优先查创建软件文档。扩展名由其他软件或个人手工命名时，避免用改后缀猜格式。

[MathWorks 导出旧版模型](https://www.mathworks.com/help/simulink/slref/simulink.exporttoversion.html)
