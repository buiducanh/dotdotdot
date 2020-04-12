#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
#Persistent

mintty := "C:\Users\bduca\AppData\Local\wsltty\bin\mintty.exe"
params := " --WSL= --configdir=""C:\Users\bduca\AppData\Roaming\wsltty"" -~ -"
execTarget := mintty params
SplitPath, mintty, minttyPath

IsWindowVisible(pProcessName,pID) {      
    DetectHiddenWindows, On
    static WS_VISIBLE := 0x10000000
    WinGet, Style, Style, ahk_exe %pProcessName% ahk_pid %pID%
    return (Style & WS_VISIBLE)
}

^!Space:: ; open wsltty
Process, Exist, mintty.exe
If (ErrorLevel = 0) {
    Run % execTarget,,, pID1   
    WinWait, ahk_pid %pID1%
}
Else {
    pID1 := ErrorLevel
}

WinGet, active_pid, PID, A
If (IsWindowVisible(minttyPath,pID1))  {
    If (active_pid = pID1) {
        WinHide, % "ahk_pid " pID1
    }
    Else {
        WinActivate, % "ahk_pid " pID1
    }
}
Else  {
    WinShow, % "ahk_pid " pID1
    WinActivate, % "ahk_pid " pID1
}
return

!`::    ; Next window
    WinGet, ActiveExe, ProcessName, A
    WinSet, Bottom,, A
    WinActivate, ahk_exe %ActiveExe%
return

!~::    ; Last window
    WinGet, ActiveExe, ProcessName, A
    WinActivateBottom, ahk_exe %ActiveExe%
return