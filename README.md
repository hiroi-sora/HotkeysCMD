# 通过快捷键调用命令行

一个使用 [AutoHotkey](https://www.autohotkey.com/) 编写的小工具。点击键盘或鼠标快捷键，发送命令行指令，调用系统功能或别的软件。

跟 [Quicker](https://getquicker.net/) 等工具的某些功能相似。但本项目旨在提供一个更轻量的方式来实现该功能。

- 1.2MB 大小
- 无需安装
- 支持设定开机自启
- 无GUI界面，仅需简单编写配置文件

## 快速使用

1. 在 [Releases](https://github.com/hiroi-sora/Umi-OCR/releases) 下载 `HotkeysCMD.exe`
2. 首次运行，同目录下会生成一个 `HotkeysCMD_KeyMap.txt`
3. 编辑该文件，添加快捷键与命令行指令。

## 配置按键映射 `HotkeysCMD_KeyMap.txt`

### 示例：

```
#F2 calc
^F3 start msedge.exe github.com
F4 umi-ocr --screenshot

AutoStart

####################
```

### 说明：

- `####` 之后的内容是注释，不会被解析。
- `#F2 calc` 表示 `Win+F2` 打开calc（计算器）。
- `^F3 start msedge.exe github.com` 表示 `Ctrl+F3` 打开edge（浏览器）并转到Github网站。
- `F4 umi-ocr --screenshot` 表示 `F4` 运行当前目录下的 [Umi-OCR.exe](https://github.com/hiroi-sora/Umi-OCR) ，并传入`--screenshot`参数。
- `AutoStart` 表示设定开机自启。删掉这行，即可取消开机自启。

### 按键映射规则

配置文件中，每行填写一条指令，格式为：
```
快捷键 CMD命令行指令
```
中间用空格隔开即可。

快捷键支持 [AutoHotkey 语法](https://wyagd001.github.io/v2/docs/KeyList.htm#keyboard) 。以下是常见的修饰符：

| 符号 | 对应的按键 |
| ---- | ---------- |
| `#`  | `Win`      |
| `^`  | `Ctrl`     |
| `+`  | `Shift`    |
| `!`  | `Alt`      |

可以多个修饰符和普通按键，组成一组快捷键。如 `^+F8` 表示按键组合 `Ctrl+Shift+F8` 。

命令行指令部分，等价于在当前目录下，调用系统的 `cmd.exe` 发送指令。您应该先在系统命令行窗口中测试指令可行，再将指令填入 `HotkeysCMD_KeyMap.txt` 。

工具本身不会解析双引号`"`。指令中如果包含双引号，则双引号会原样地传入 `cmd` 。