### size: 960x540 ###
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <AutoItConstants.au3>
#include <ComboConstants.au3>
#include <WinAPI.au3>
#include <Color.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("AUTO by KATON v6.0", 363, 273, 192, 124)
$Group1 = GUICtrlCreateGroup("", 8, 0, 345, 153)
$Label1 = GUICtrlCreateLabel("tên cửa sổ", 56, 19, 53, 17)
$nameWindow = GUICtrlCreateInput("", 120, 16, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$adjust = GUICtrlCreateButton("căn chỉnh", 24, 48, 83, 41)
$complete = GUICtrlCreateButton("hoàn tất", 24, 96, 83, 41)

$Group2 = GUICtrlCreateGroup("", 120, 40, 121, 97)
$up = GUICtrlCreateButton("🠽", 165, 50, 30, 30)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$down = GUICtrlCreateButton("🠿", 165, 102, 30, 30)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$left = GUICtrlCreateButton("🠼", 135, 75, 30, 30)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$right = GUICtrlCreateButton("🠾", 195, 75, 30, 30)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group3 = GUICtrlCreateGroup("", 247, 10, 100, 97)
$tSimulator = GUICtrlCreateLabel("loại giả lập", 273, 40, 55, 20)
$typeSimulator  = GUICtrlCreateCombo("LDPlayer", 251, 60, 90, 21, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL,$WS_BORDER), $WS_EX_STATICEDGE)
GUICtrlSetData($typeSimulator, "NOX")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$reste = GUICtrlCreateButton("reset", 256, 96, 83, 41)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$start = GUICtrlCreateButton("bắt đầu", 24, 168, 83, 41)
$pause = GUICtrlCreateButton("dừng", 24, 215, 83, 41)
$Label5 = GUICtrlCreateLabel("số cá câu được", 136, 207, 90, 20)
$demCaCau = GUICtrlCreateInput(0, 232, 204, 50, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))

GUICtrlSetState($typeSimulator, $GUI_DISABLE)
GUICtrlSetState($complete, $GUI_DISABLE)
GUICtrlSetState($reste, $GUI_DISABLE)
GUICtrlSetState($pause, $GUI_DISABLE)
GUICtrlSetState($up, $GUI_DISABLE)
GUICtrlSetState($down, $GUI_DISABLE)
GUICtrlSetState($left, $GUI_DISABLE)
GUICtrlSetState($right, $GUI_DISABLE)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $title = ""
Global $tRect
Global $paddingX
Global $paddingY
Global $positionX = 480
Global $positionY = 185
Global $interrupt = 0

Func up()
	$positionY = ($positionY <= 0) ? 0 : $positionY - 2
EndFunc

Func down()
	$positionY = ($positionY >= 540) ? 540 : $positionY + 2
EndFunc

Func left()
	$positionX = ($positionX <= 0) ? 0 : $positionX - 2
EndFunc

Func right()
	$positionX = ($positionX >= 960) ? 960 : $positionX + 2
EndFunc

#Region Định nghĩa và gán các Button muốn dùng để ngắt vòng lặp
GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND_BUTTON")
Func _WM_COMMAND_BUTTON($hWnd, $Msg, $wParam, $lParam)
	Switch BitAND($wParam, 0x0000FFFF)
		Case $pause
			WinSetOnTop($title, "", $WINDOWS_NOONTOP)
			$interrupt = 1
	EndSwitch
	Return 'GUI_RUNDEFMSG'
EndFunc
#EndRegion

#Region Tắt GUI khi vẫn còn đang chạy vòng lặp
GUIRegisterMsg($WM_SYSCOMMAND, "_WM_COMMAND_CLOSEBUTTON")
Func _WM_COMMAND_CLOSEBUTTON($hWnd, $Msg, $wParam, $lParam)
	If BitAND($wParam, 0x0000FFFF) = 0xF060 Then
		WinSetOnTop($title, "", $WINDOWS_NOONTOP)
		Exit
	EndIf
	Return 'GUI_RUNDEFMSG'
EndFunc
#EndRegion

Func _WinAPI_DrawRect($start_x, $start_y, $iWidth, $iHeight, $iColor)
	Local $hDC = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
	$tRect = DllStructCreate($tagRECT)
	DllStructSetData($tRect, 1, $start_x)
	DllStructSetData($tRect, 2, $start_y)
	DllStructSetData($tRect, 3, $iWidth + $start_x) ;  x-coordinate of the lower-right corner of the rectangle
	DllStructSetData($tRect, 4, $iHeight + $start_y) ;  y-coordinate of the lower-right corner of the rectangle
	Local $hBrush = _WinAPI_CreateSolidBrush($iColor)
	_WinAPI_FrameRect($hDC, DllStructGetPtr($tRect), $hBrush)
	_WinAPI_DeleteObject($hBrush)
	_WinAPI_ReleaseDC(0, $hDC)
EndFunc

While 1
	$title = GUICtrlRead($nameWindow)
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $adjust
			GUICtrlSetState($typeSimulator, $GUI_ENABLE)
			GUICtrlSetState($complete, $GUI_ENABLE)
			GUICtrlSetState($adjust, $GUI_DISABLE)
			GUICtrlSetState($start, $GUI_DISABLE)
			GUICtrlSetState($pause, $GUI_DISABLE)
			GUICtrlSetState($reste, $GUI_ENABLE)
			GUICtrlSetState($up, $GUI_ENABLE)
			GUICtrlSetState($down, $GUI_ENABLE)
			GUICtrlSetState($left, $GUI_ENABLE)
			GUICtrlSetState($right, $GUI_ENABLE)
			HotKeySet("{UP}", "up")
			HotKeySet("{DOWN}", "down")
			HotKeySet("{LEFT}", "left")
			HotKeySet("{RIGHT}", "right")
			While 1
				$pos = WinGetPos($title)
				_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), $tRect, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN))
				_WinAPI_DrawRect($pos[0] + $positionX - 30, $pos[1] + $positionY + 12, 5, 5, 0x0000FF)
				_WinAPI_DrawRect($pos[0] + $positionX, $pos[1] + $positionY, 5, 25, 0x0000FF)
				_WinAPI_DrawRect($pos[0] + $positionX + 30, $pos[1] + $positionY + 12, 5, 5, 0x0000FF)
				Switch GUIGetMsg()
					Case $up
						$positionY = ($positionY <= 0) ? 0 : $positionY - 2
					Case $down
						$positionY = ($positionY >= 540) ? 540 : $positionY + 2
					Case $left
						$positionX = ($positionX <= 0) ? 0 : $positionX - 2
					Case $right
						$positionX = ($positionX >= 960) ? 960 : $positionX + 2
					Case $complete
						GUICtrlSetState($complete, $GUI_DISABLE)
						GUICtrlSetState($adjust, $GUI_ENABLE)
						ExitLoop
					Case $reste
						GUICtrlSetData($typeSimulator, 'LDPlayer')
						$positionX = 480
						$positionY = 185
				EndSwitch
			WEnd
			HotKeySet("{UP}")
			HotKeySet("{DOWN}")
			HotKeySet("{LEFT}")
			HotKeySet("{RIGHT}")
			GUICtrlSetState($typeSimulator, $GUI_DISABLE)
			GUICtrlSetState($reste, $GUI_DISABLE)
			GUICtrlSetState($start, $GUI_ENABLE)
			GUICtrlSetState($up, $GUI_DISABLE)
			GUICtrlSetState($down, $GUI_DISABLE)
			GUICtrlSetState($left, $GUI_DISABLE)
			GUICtrlSetState($right, $GUI_DISABLE)
		Case $start
			WinActivate($title)
			WinSetOnTop($title, "", $WINDOWS_ONTOP)
			$interrupt = 0
			$paddingX = (GUICtrlRead($typeSimulator)=='LDPlayer') ? 0 : 0
			$paddingY = (GUICtrlRead($typeSimulator)=='LDPlayer') ? -32 : 0
			GUICtrlSetState($typeSimulator, $GUI_DISABLE)
			GUICtrlSetState($nameWindow, $GUI_DISABLE)
			GUICtrlSetState($demCaCau, $GUI_DISABLE)
			GUICtrlSetState($adjust, $GUI_DISABLE)
			GUICtrlSetState($start, $GUI_DISABLE)
			GUICtrlSetState($pause, $GUI_ENABLE)
			While $interrupt == 0
				$pos = WinGetPos($title)
				$topColor = Hex(_ColorGetRed(PixelGetColor($pos[0] + $positionX + 3, $pos[1] + $positionY + 5)), 2)
				$bottomColor = Hex(_ColorGetRed(PixelGetColor($pos[0] + $positionX + 3, $pos[1] + $positionY + 20)), 2)
				$leftColor = Hex(_ColorGetRed(PixelGetColor($pos[0] + $positionX - 30, $pos[1] + $positionY + 1)), 2)
				$rightColor = Hex(_ColorGetRed(PixelGetColor($pos[0] + $positionX + 30, $pos[1] + $positionY + 1)), 2)
				$baoQuan = PixelSearch($pos[0] + 740, $pos[1] + 450, $pos[0] + 810, $pos[1] + 460, '0x41C5F3')
				$baLo = PixelSearch($pos[0] + 920, $pos[1] + 330, $pos[0] + 940, $pos[1] + 345, '0xE44142')
				Select
					Case IsArray($baoQuan)
						Sleep(700)
						$khoe = PixelSearch($pos[0] + 790, $pos[1] + 450, $pos[0] + 810, $pos[1] + 460, '0xFFC71D')
						If IsArray($khoe) Then
							GUICtrlSetData($demCaCau, GUICtrlRead($demCaCau) + 1)
						EndIf
						ControlClick($title, "", "", 'left', 1, 751 + $paddingX, 458 + $paddingY)
						Sleep(1500)
					Case IsArray(PixelSearch($pos[0]+300,$pos[1]+200, $pos[0]+302,$pos[1]+202, '0xFFFFFF')) And IsArray(PixelSearch($pos[0]+660,$pos[1]+200, $pos[0]+662,$pos[1]+202, '0xFFFFFF'))
						If IsArray(PixelSearch($pos[0] + 490, $pos[1] + 420, $pos[0] + 520, $pos[1] + 440, '0xFFFFFF')) Then
							ControlClick($title, "", "", 'left', 1, 492 + $paddingX, 438 + $paddingY)
							Sleep(2000)
						EndIf
					Case IsArray($baLo)
						ControlClick($title, "", "", 'left', 1, 766 + $paddingX, 361 + $paddingY)
						Sleep(2000)
					Case (($topColor <> $rightColor) And ($topColor <> $leftColor) And ($topColor == $bottomColor)) And Not IsArray($baLo)
						ControlClick($title, "", "", 'left', 1, 845 + $paddingX, 500 + $paddingY)
						Sleep(2000)
				EndSelect
			WEnd
			GUICtrlSetState($nameWindow, $GUI_ENABLE)
			GUICtrlSetState($demCaCau, $GUI_ENABLE)
			GUICtrlSetState($pause, $GUI_DISABLE)
			GUICtrlSetState($adjust, $GUI_ENABLE)
			GUICtrlSetState($start, $GUI_ENABLE)
	EndSwitch
WEnd