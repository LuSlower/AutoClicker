#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=ico.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=AutoClicker
#AutoIt3Wrapper_Res_Fileversion=0.0.0.0
#AutoIt3Wrapper_Res_ProductName=AutoClicker
#AutoIt3Wrapper_Res_ProductVersion=0.0.0.0
#AutoIt3Wrapper_Res_CompanyName=AutoClicker
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © LuSlower
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <TrayConstants.au3>
#include <WinAPIProc.au3>
#include <Misc.au3>
#include <Restart.au3>
#include <HotKeyInput.au3>
#include <HotKey_21b.au3>

_Singleton("AutoClicker.exe")

#Region ;INI Params
$INI = @ScriptDir & "\AutoClicker.ini"
$save_key_init = IniRead($INI, "Delay", "KeyInit", "114") ;F3 KEY DEFAULT
$save_speed = IniRead($INI, "Config", "SpeedClick", "0")
$save_sleep = IniRead($INI, "Config", "Sleep", "10")
$save_counts = IniRead($INI, "Config", "ClicksCount", "1")
$save_click_delay = IniRead($INI, "Config", "ClickDelay", "0")
$save_click_downdelay = IniRead($INI, "Config", "ClickDownDelay", "0")
$save_button = IniRead($INI, "Config", "MouseButton", "left")
$save_start = IniRead($INI, "Config", "AutoStart", "4")
#EndRegion ;INI Params

Opt("MouseClickDelay", $save_click_delay) ;delete KeyDelay
Opt("MouseClickDownDelay", $save_click_downdelay) ;delete DownDelay
Opt("TrayMenuMode", 3) ;enable tray personalizado
Opt("TrayOnEventMode", 1) ;enable tray event mode
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode
TraySetClick(8) ;solo clic derecho

;Tray Group
TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_close")
TraySetState($TRAY_ICONSTATE_SHOW)
Opt("GUIOnEventMode", 1)

$_stop = True

;Main
$main = GUICreate("AutoClicker | LuSlower", 385, 301)

;Activation
GUICtrlCreateGroup("Activation", 8, 8, 145, 105)
GUICtrlCreateLabel("On/Off Key", 57, 30, 58, 17)
Local $_init = _GUICtrlHKI_Create(0, 65, 50, 50, 21)
_GUICtrlHKI_SetHotKey($_init, $save_key_init)
$vk_key = "0x" & Hex(_GUICtrlHKI_GetHotKey($_init), 2)
$save = GUICtrlCreateButton("Save Changes", 48, 80)
GUICtrlSetOnEvent(-1, "_save")

;Delay
GUICtrlCreateGroup("Delay", 160, 8, 217, 105)
GUICtrlCreateLabel("ClickDelay (0 - 10)", 185, 26, 50, 30)
$_delay = GUICtrlCreateCombo("", 264, 23, 73, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|")
GUICtrlSetData(-1, $save_click_delay)
GUICtrlCreateLabel("ClckDownDelay (0 - 10)", 180, 72, 80, 30)
$_downdelay = GUICtrlCreateCombo("", 264, 67, 73, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|")
GUICtrlSetData(-1, $save_click_downdelay)

;Buttons
GUICtrlCreateGroup("Buttons", 8, 112, 370, 57)
$_left = GUICtrlCreateRadio("Left", 30, 136, 65, 17)
$_mid = GUICtrlCreateRadio("Mid", 100, 136, 65, 17)
$_right = GUICtrlCreateRadio("Righ", 170, 136, 65, 17)
$_b4 = GUICtrlCreateRadio("Button4", 240, 136, 65, 17)
$_b5 = GUICtrlCreateRadio("Button5", 310, 136, 65, 17)

;ReadButton
Switch $save_button
	Case "left"
		GUICtrlSetState($_left, 1)
		$button = $MOUSE_CLICK_LEFT
	Case "right"
		GUICtrlSetState($_right, 1)
		$button = $MOUSE_CLICK_RIGHT
	Case "middle"
		GUICtrlSetState($_right, 1)
		$button = $MOUSE_CLICK_MIDDLE
	Case "x4"
		GUICtrlSetState($_b4, 1)
		$button = $MOUSE_CLICK_PRIMARY
	Case "x5"
		GUICtrlSetState($_b5, 1)
		$button = $MOUSE_CLICK_SECONDARY
EndSwitch

;Click Rate - Speed Click
GUICtrlCreateGroup("Click  Rate - Speed Click", 8, 176, 369, 121)
$_count = GUICtrlCreateInput("", 45, 224, 50, 21, $ES_NUMBER)
GUICtrlSetData(-1, $save_counts)
$_sCount = GUICtrlRead($_count)
GUICtrlCreateLabel("Clicks per Second", 24, 200, 90, 17)

;CheckBox
$_start = GUICtrlCreateCheckbox("Start With Windows", 22, 264, Default, 17)
GUICtrlSetState(-1, $save_start)

;Speed
GUICtrlCreateLabel("Speed (0 - 100)", 215, 195)
$_speed = GUICtrlCreateSlider(136, 215, 230, 45)
GUICtrlSetData(-1, $save_speed)
GUICtrlSetLimit(-1, 100, 0)
$_sSpeed = GUICtrlRead(-1)
GUICtrlCreateLabel("Sleep (10 - 300)", 185, 265)
$_sleep = GUICtrlCreateInput("", 270, 263, 50, 21, $ES_NUMBER)
GUICtrlSetData(-1, $save_sleep)
GUICtrlSetLimit(-1, 3, 0)
$_sSleep = GUICtrlRead(-1)


;GUI EVENTS
GUISetOnEvent($GUI_EVENT_CLOSE, "_close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "_hide")
TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "_show")
_HotKey_Assign($vk_key, '_init', BitOr($HK_FLAG_NOBLOCKHOTKEY, $HK_FLAG_NOUNHOOK))

GUISetState()
_WinAPI_EmptyWorkingSet()

Switch $save_start
	Case 1
		_hide()
	Case Else
		_show()
EndSwitch

While True
	Sleep(10)
WEnd

Func _init()
	If GUICtrlRead($_sleep) < 10 Or GUICtrlRead($_sleep) > 300 Then
		MsgBox(16, "Error", "Porfavor escriba un número valido para Sleep (10 - 300)")
		Return
	EndIf
	;Init
	Switch $_stop
	Case True
		$_stop = False
		_ClickCursor()
	Case Else
		$_stop = True
	EndSwitch

EndFunc   ;==>_init

Func _ClickCursor()
	While True
		Switch $_stop
			Case True
		ExitLoop
			Case Else
			MouseClick($button, Default, Default, $_sCount, $_sSpeed)
			Sleep($_sSleep)
		EndSwitch
	WEnd
EndFunc   ;==>_ClickCursor

Func _close()
	GUIDelete()
	Exit
EndFunc   ;==>_close

Func _show()
	_WinAPI_EmptyWorkingSet()
	GUISetState(@SW_ENABLE)
	GUISetState(@SW_UNLOCK)
	GUISetState(@SW_SHOW)
EndFunc   ;==>_show

Func _hide()
	_WinAPI_EmptyWorkingSet()
	GUISetState(@SW_DISABLE)
	GUISetState(@SW_LOCK)
	GUISetState(@SW_HIDE)
EndFunc   ;==>_hide

Func _save()
	If GUICtrlRead($_sleep) < 10 Or GUICtrlRead($_sleep) > 300 Then
		MsgBox(16, "Error", "Porfavor escriba un número valido para Sleep (10 - 300)")
		Return
	EndIf
	$save_vk_key = "0x" & Hex(_GUICtrlHKI_GetHotKey($_init), 2)
	IniWrite($INI, "Delay", "KeyInit", $save_vk_key)
	IniWrite($INI, "Config", "SpeedClick", GUICtrlRead($_speed))
	IniWrite($INI, "Config", "Sleep", GUICtrlRead($_sleep))
	IniWrite($INI, "Config", "ClicksCount", GUICtrlRead($_count))
	IniWrite($INI, "Config", "ClickDelay", GUICtrlRead($_delay))
	IniWrite($INI, "Config", "ClickDownDelay", GUICtrlRead($_downdelay))

	Select
		Case GUICtrlRead($_left) = 1
			Local $button = "left"
		Case GUICtrlRead($_right) = 1
			Local $button = "right"
		Case GUICtrlRead($_mid) = 1
			Local $button = "middle"
		Case GUICtrlRead($_b4) = 1
			Local $button = "x4"
		Case GUICtrlRead($_b5) = 1
			Local $button = "x5"
	EndSelect

	IniWrite($INI, "Config", "MouseButton", $button)
	Local $key_run = "HKLM64\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
	Local $value = GUICtrlRead($_start)
	Switch $value
		Case 1
			RegWrite($key_run, "AutoClicker", "reg_sz", @ScriptFullPath)
			IniWrite($INI, "Start", "Windows", $value)
		Case 4
			RegDelete($key_run, "AutoClicker")
			IniWrite($INI, "Start", "Windows", $value)
	EndSwitch
	MsgBox(64, "Hecho", "Cambios guardados correctamente")
	_ScriptRestart()
EndFunc   ;==>_save
