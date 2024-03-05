; https://github.com/hiroi-sora/HotkeysCMD

; 文件名
FileName := StrReplace(StrReplace(A_ScriptName, ".ahk"), ".exe") ; 脚本名
KeyMapFileName := FileName . "_KeyMap.txt" ; 按键映射表文件名
; 设置工作目录为脚本实际路径
SetWorkingDir(A_ScriptDir)

; 生成模板配置文件
GenerateKeyMapFile() {
    Try {
        fileObj := FileOpen(KeyMapFileName, "w")
    } Catch as err {
        MsgBox("无法写入文件：" KeyMapFileName ""
        . "`n`n错误原因：`n" err.Extra " " err.Message)
        Return
    }
    defaultString := "#F2 calc`r`n"
    . "^F3 start msedge.exe github.com`r`n"
    . "F4 umi-ocr --screenshot`r`n"
    . "`r`n####################`r`n`r`n"
    . "请在###的上方填写快捷键及对应的命令行指令。每行一条指令，格式为：`r`n`r`n"
    . "快捷键 命令行指令`r`n`r`n"
    . "例：`r`n【#F2 calc】表示 Win+F2 打开calc（计算器）。`r`n"
    . "【^F3 start msedge.exe github.com】表示 Ctrl+F3 打开edge（浏览器）并转到Github网站。`r`n"
    . "【F4 umi-ocr --screenshot】表示 F4 运行当前目录下的Umi-OCR.exe，并传入--screenshot参数。`r`n`r`n"
    . "修饰键符号：`r`n"
    . "# 表示 Win`r`n"
    . "^ 表示 Ctrl`r`n"
    . "+ 表示 Shift`r`n"
    . "! 表示 Alt`r`n"
    . "更多支持的键值请参考AHK文档：`r`n"
    . "https://wyagd001.github.io/v2/docs/KeyList.htm#keyboard`r`n`r`n"
    . "开机自启：`r`n请在###的上方，单独一行，填写 AutoStart`r`n`r`n"
    . "取消开机自启：`r`n将 AutoStart 删除即可。`r`n`r`n"
    . "本项目地址：`r`nhttps://github.com/hiroi-sora/HotkeysCMD"
    fileObj.Write(defaultString)
    fileObj.Close()
    MsgBox("按键映射配置文件初始化：`n【"
    KeyMapFileName
    "】`n请编辑此文件，添加快捷键和对应的命令行指令。`n`n`""
    KeyMapFileName
    "`" Initialize. Please edit this file and add shortcut keys and corresponding cmd commands."
    )
}

; 加载按键配置文件。返回0成功，1无法读取，2无法格式化。
ReadKeyMapFile() {
    Try {
        text := FileRead(KeyMapFileName)
    } Catch Error as err {
        return 1
    }
    isAutoStart := False ; 是否设置开机自启
    Loop Parse, text, "`n", "`r" {
        ; 跳过空行
        If(StrLen(Trim(A_LoopField)) = 0) {
            Continue
        }
        ; ### 结束搜索
        If(InStr(A_LoopField, "###")==1) {
            Break
        }
        ; 开机自启
        If(A_LoopField == "AutoStart") {
            isAutoStart := True
            Continue
        }
        ; 解析一行
        Try {
            key_array := StrSplit(A_LoopField, A_Space, , 2)
            Hotkey(key_array[1], RunCmd.Bind(key_array[2])) ; 注册热键和对应的函数
        } Catch as err {
            MsgBox("快捷键解析错误：`n"
            A_LoopField 
            "`n`n错误原因：`n" err.Extra " " err.Message
            "`n`n您可以删除按键映射配置文件，重新运行脚本将自动创建模板文件：`n"
            KeyMapFileName
            )
            return 2
        }
    }
    SetAutoStart(isAutoStart)
    return 0
}

; 执行命令行指令
RunCmd(command, key) {
    Try {
        Run(A_ComSpec " /C " command, , "Hide")
    } Catch as err {
        MsgBox(key " 命令行执行失败：`n"
        command 
        "`n`n错误原因：`n" err.Extra " " err.Message
        )
    }
}

; 以管理员权限重启当前脚本
ReRun(tips := "") {
    res := MsgBox(tips "是否以管理员权限重试？", FileName, 4)
    If(res == "Yes") {
        Try {
            Run "*RunAs " A_ScriptFullPath
        } Catch Error as err {
            MsgBox(err.Extra " " err.Message "`n无法以管理员权限启动。")
        }
    }
    ExitApp()

}

; 设置开机自启
SetAutoStart(isAutoStart) {
    lnkPath := A_StartupCommon . "\" . FileName . ".lnk"
    lnkExist := FileExist(lnkPath)
    If(isAutoStart && !lnkExist) { ; 不存在，添加
        Try {
            FileCreateShortcut(A_ScriptFullPath, lnkPath)
            MsgBox("已添加开机自启：`n" lnkPath)
        } Catch Error as err {
            ReRun("无法添加开机自启：`n`n" err.Extra " " err.Message "`n`n")
        }
    }
    Else If(!isAutoStart && lnkExist) { ; 存在，移除
        Try {
            FileDelete(lnkPath)
            MsgBox("已移除开机自启：`n" lnkPath)
        } Catch Error as err {
            ReRun("无法移除开机自启：`n`n" err.Extra " " err.Message "`n`n")
        }
    }
}

; 读取配置
res := ReadKeyMapFile()
If(res == 1) { ; 读取失败，重新创建模板配置
    GenerateKeyMapFile()
    ExitApp()
}
Else If(res == 2) { ; 解析失败，直接退出
    ExitApp()
}

