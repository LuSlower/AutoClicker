#SingleInstance Force
#NoEnv
SendMode, Input
;@Ahk2Exe-SetCompanyName LuSlower
;@Ahk2Exe-SetDescription AutoClicker
;@Ahk2Exe-SetCopyright Copyright © LuSlower
;@Ahk2Exe-SetFileVersion 0.0.0.0
;@Ahk2Exe-SetProductName AutoClicker
;@Ahk2Exe-SetProductVersion 0.0.0.0
;@Ahk2Exe-SetVersion 0.0.0.0

;INI Section
global INI := a_scriptdir "\AutoClicker.ini"
IniRead, _save_key_init, %INI%, Config, KeyInit, F3
IniRead, _save_speed,  %INI%, Config, SpeedClick, 0
IniRead, _save_sleep, %INI%, Config, Sleep, 10
IniRead, _save_counts, %INI%, Config, ClickCounts, 100
IniRead, _save_button, %INI%, Config, Button, LEFT
IniRead, _save_start, %INI%, Config, Start, 0
IniRead, _save_delay, %INI%, Delay, ClickDelay, 10
IniRead, _save_keydelay, %INI%, Delay, KeyDelay, 10
IniRead, _save_keydowndelay, %INI%, Delay, KeyDownDelay, 10

;SetDelay
SetMouseDelay, %_save_delay%
SetKeyDelay, %_save_keydelay%

_stop := true

;Main Section
;Activation
Gui, Add, GroupBox, x2 y3 w140 h100, Activation
Gui, Add, Text, x34 y18 w100 h20, On / Off HotKey
Gui, Add, Hotkey, x45 y39 w50 h20 vInit, %_save_key_init%
GuiControlGet, ChoseInit, ,Init
If (ChoseInit) {
    Hotkey, %ChoseInit%, start
}
Gui, Add, Button, x21 y71 w112 h23 vSave, Save Changes
;Buttons
Gui, Add, GroupBox, x2 y102 w360 h60, Buttons
Gui, Add, Radio, x22 y119 w70 h20 vLeft, LeftButton
Gui, Add, Radio, x142 y119 w80 h20 vMid, MiddleButton
Gui, Add, Radio, x272 y119 w80 h20 vRight, RightButton
;Delay
Gui, Add, GroupBox, x152 y3 w210 h100, Delay
Gui, Add, Text, x180 y20 w80 h30, ClickDelay
Gui, Add, Text, x180 y45 w80 h30, KeyDelay
Gui, Add, Text, x170 y70 w80 h30, KeyDownDelay
Gui, Add, DropDownList, x262 y15 w80 vDelay, 0|1|2|3|4|5|6|7|8|9|10
GuiControl, ChooseString, Delay, %_save_delay%
Gui, Add, DropDownList, x262 y40 w80 vKeyDelay, 0|1|2|3|4|5|6|7|8|9|10
GuiControl, ChooseString, KeyDelay, %_save_keydelay%
Gui, Add, DropDownList, x262 y65 w80 vKeyDownDelay, 0|1|2|3|4|5|6|7|8|9|10
GuiControl, ChooseString, KeyDownDelay, %_save_keydowndelay%
;ClickRate
Gui, Add, GroupBox, x2 y162 w360 h130, Click Rate - Speed Click
Gui, Add, Text, x32 y189 w90 h20, Clicks per second
Gui, Add, Edit, x32 y219 w80 h20 +Number Limit3 vCounts, %_save_counts%
GuiControlGet, _count, , Counts
Gui, Add, CheckBox, x15 y257 w110 h20 vStart, Start With Windows
GuiControl, , Start, %_save_start%
Gui, Add, Slider, x132 y199 w220 h50 vSpeed range0-100 tickinterval10, %_save_speed%
GuiControlGet, _speed, , Speed
Gui, Add, Text, x206 y177 w110 h20, Speed (0 - 100)
Gui, Add, Text, x153 y251 w80 h20, Sleep (10 - 300)
Gui, Add, Edit, x242 y249 w70 h20 +Number +Limit3 vSleep, %_save_sleep%
GuiControlGet, _sleep, , Sleep
switch _save_button
{
    case "LEFT":
        GuiControl, , Left, 1
        _save_button := "LEFT"
    case "MIDDLE":
        GuiControl, , Mid, 1
        _save_button := "MIDDLE"
    case "RIGHT":
        GuiControl, , Right, 1
        _save_button := "RIGHT"
}

Gui, Show, w365 h295, AutoClicker | LuSlower
return

start:
If (_stop) {
	global _stop := false
	LoopClicks()
}
return

esc::
if (!_stop) {
	global _stop := true
}
return

LoopClicks() {
    while (!_stop) {
        MouseClick, %_save_button%, , , %_count%, %_speed%
        Sleep, %_sleep%
    }
}

buttonsavechanges:
GuiControlGet, _key, , Init
IniWrite, %_key%, %INI%, Config, KeyInit
GuiControlGet, _speed, , Speed
IniWrite, %_speed%,  %INI%, Config, SpeedClick
GuiControlGet, _sleep, , Sleep
IniWrite, %_sleep%, %INI%, Config, Sleep
GuiControlGet, _count, , Counts
IniWrite, %_count%, %INI%, Config, ClickCounts
;button check
GuiControlGet, _left, , Left
GuiControlGet, _mid, , Mid
GuiControlGet, _right, , Right
If (_left = 1) {
    IniWrite, LEFT, %INI%, Config, Button
    _save_button := "LEFT"
}
If (_mid = 1) {
    IniWrite, MIDDLE, %INI%, Config, Button
    _save_button := "MIDDLE"
}
If (_right = 1) {
    IniWrite, RIGHT, %INI%, Config, Button
    _save_button := "RIGHT"
}
key_run := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
GuiControlGet, _start, , Start
switch _start
{
    case 1:
        RegWrite, REG_SZ, %key_run%, AutoClicker, %A_ScriptFullPath%
        IniWrite, %_start%, %INI%, Start, Windows
    case 0:
        RegDelete, %key_run%, AutoClicker
        IniWrite, %_start%, %INI%, Start, Windows
}
GuiControlGet, _delay, , Delay
IniWrite, %_delay%, %INI%, Delay, ClickDelay
GuiControlGet, _keydelay, , KeyDelay
IniWrite, %_keydelay%, %INI%, Delay, KeyDelay
GuiControlGet, _keydowndelay, , KeyDownDelay
IniWrite, %_keydowndelay%, %INI%, Delay, KeyDownDelay
MsgBox, 64, Info, Cambios guardados correctamente
Reload ;reiniciar script

GuiClose:
ExitApp