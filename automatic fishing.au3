### size: 960x540 ###
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <AutoItConstants.au3>
#include <WinAPI.au3>
#include <Color.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("AUTO by KATON v4.0", 363, 273, 192, 124)
$Group1 = GUICtrlCreateGroup("", 8, 0, 345, 153)
$Label1 = GUICtrlCreateLabel("tên giả lập", 56, 19, 53, 17)
$name_window = GUICtrlCreateInput("", 120, 16, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$adjust = GUICtrlCreateButton("căn chỉnh", 24, 48, 83, 41)
$complete = GUICtrlCreateButton("hoàn tất", 24, 96, 83, 41)

$Group2 = GUICtrlCreateGroup("", 120, 40, 121, 97)
$LbX = GUICtrlCreateLabel("X", 128, 56, 18, 20)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$LbY = GUICtrlCreateLabel("Y", 128, 104, 16, 20)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$PositionX = GUICtrlCreateInput("480", 152, 56, 73, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$PositionY = GUICtrlCreateInput("185", 152, 104, 73, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group3 = GUICtrlCreateGroup("", 247, 10, 100, 97)
$PdX = GUICtrlCreateLabel("paddingX", 255, 30, 45, 20)
$InputPaddingX = GUICtrlCreateInput("0", 305, 27, 40, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$PdY = GUICtrlCreateLabel("paddingY", 255, 70, 45, 20)
$InputPaddingY = GUICtrlCreateInput("-32", 305, 67, 40, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$reste = GUICtrlCreateButton("reset", 256, 96, 83, 41)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$start = GUICtrlCreateButton("bắt đầu", 24, 168, 83, 41)
$pause = GUICtrlCreateButton("dừng", 24, 215, 83, 41)
$Label5 = GUICtrlCreateLabel("số cá câu được", 136, 207, 90, 20)
$dem_ca_cau = GUICtrlCreateInput(0, 232, 207, 50, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))

GUICtrlSetState($reste, $GUI_DISABLE)
GUICtrlSetState($PositionX, $GUI_DISABLE)
GUICtrlSetState($PositionY, $GUI_DISABLE)
GUICtrlSetState($complete, $GUI_DISABLE)
GUICtrlSetState($pause, $GUI_DISABLE)
GUICtrlSetState($InputPaddingX, $GUI_DISABLE)
GUICtrlSetState($InputPaddingY, $GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $title = ""
Global $tRect
Global $padding_X
Global $padding_Y

#Region Định nghĩa và gán các Button muốn dùng để ngắt vòng lặp
$Interrupt = 0
GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND_BUTTON")
Func _WM_COMMAND_BUTTON($hWnd, $Msg, $wParam, $lParam)
	Switch BitAND($wParam, 0x0000FFFF)
		Case $pause
			WinSetOnTop($title, "", $WINDOWS_NOONTOP)
			$Interrupt = 1
	EndSwitch
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>_WM_COMMAND_BUTTON
#EndRegion Định nghĩa và gán các Button muốn dùng để ngắt vòng lặp

#Region Tắt GUI khi vẫn còn đang chạy vòng lặp
GUIRegisterMsg($WM_SYSCOMMAND, "_WM_COMMAND_CLOSEBUTTON")
Func _WM_COMMAND_CLOSEBUTTON($hWnd, $Msg, $wParam, $lParam)
	If BitAND($wParam, 0x0000FFFF) = 0xF060 Then
		WinSetOnTop($title, "", $WINDOWS_NOONTOP)
		Exit
	EndIf
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>_WM_COMMAND_CLOSEBUTTON
#EndRegion Tắt GUI khi vẫn còn đang chạy vòng lặp

Func _WinAPI_DrawRect($start_x, $start_y, $iWidth, $iHeight, $iColor)
	Local $hDC = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
	$tRect = DllStructCreate($tagRECT)
	DllStructSetData($tRect, 1, $start_x)
	DllStructSetData($tRect, 2, $start_y)
	DllStructSetData($tRect, 3, $iWidth + $start_x) ;  x-coordinate of the lower-right corner of the rectangle
	DllStructSetData($tRect, 4, $iHeight + $start_y) ;  y-coordinate of the lower-right corner of the rectangle
	Local $hBrush = _WinAPI_CreateSolidBrush($iColor)

	_WinAPI_FrameRect($hDC, DllStructGetPtr($tRect), $hBrush)

	; clear resources
	_WinAPI_DeleteObject($hBrush)
	_WinAPI_ReleaseDC(0, $hDC)
EndFunc   ;==>_WinAPI_DrawRect

While 1
	$title = GUICtrlRead($name_window)
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $adjust
			GUICtrlSetState($reste, $GUI_ENABLE)
			GUICtrlSetState($PositionX, $GUI_ENABLE)
			GUICtrlSetState($PositionY, $GUI_ENABLE)
			GUICtrlSetState($InputPaddingX, $GUI_ENABLE)
			GUICtrlSetState($InputPaddingY, $GUI_ENABLE)
			GUICtrlSetState($complete, $GUI_ENABLE)
			GUICtrlSetState($start, $GUI_DISABLE)
			GUICtrlSetState($pause, $GUI_DISABLE)
			GUICtrlSetState($adjust, $GUI_DISABLE)
			While 1
				$pos = WinGetPos($title)
				_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), $tRect, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN))
				_WinAPI_DrawRect($pos[0] + GUICtrlRead($PositionX) - 30, $pos[1] + GUICtrlRead($PositionY) + 12, 5, 5, 0x0000FF)
				_WinAPI_DrawRect($pos[0] + GUICtrlRead($PositionX), $pos[1] + GUICtrlRead($PositionY), 5, 25, 0x0000FF)
				_WinAPI_DrawRect($pos[0] + GUICtrlRead($PositionX) + 30, $pos[1] + GUICtrlRead($PositionY) + 12, 5, 5, 0x0000FF)
				Switch GUIGetMsg()
					Case $complete
						GUICtrlSetState($complete, $GUI_DISABLE)
						GUICtrlSetState($adjust, $GUI_ENABLE)
						ExitLoop
					Case $reste
						GUICtrlSetData($PositionX, '480')
						GUICtrlSetData($PositionY, '185')
						GUICtrlSetData($InputPaddingX, '0')
						GUICtrlSetData($InputPaddingY, '-32')
				EndSwitch
			WEnd
			GUICtrlSetState($reste, $GUI_DISABLE)
			GUICtrlSetState($PositionX, $GUI_DISABLE)
			GUICtrlSetState($PositionY, $GUI_DISABLE)
			GUICtrlSetState($InputPaddingX, $GUI_DISABLE)
			GUICtrlSetState($InputPaddingY, $GUI_DISABLE)
			GUICtrlSetState($start, $GUI_ENABLE)
		Case $start
			$Interrupt = 0
			$padding_X = GUICtrlRead($InputPaddingX)
			$padding_Y = GUICtrlRead($InputPaddingY)
			GUICtrlSetState($pause, $GUI_ENABLE)
			GUICtrlSetState($start, $GUI_DISABLE)
			GUICtrlSetState($adjust, $GUI_DISABLE)
			GUICtrlSetState($dem_ca_cau, $GUI_DISABLE)
			GUICtrlSetState($name_window, $GUI_DISABLE)
			GUICtrlSetState($InputPaddingX, $GUI_DISABLE)
			GUICtrlSetState($InputPaddingY, $GUI_DISABLE)
			WinActivate($title)
			WinSetOnTop($title, "", $WINDOWS_ONTOP)
			While $Interrupt == 0
				$pos = WinGetPos($title)
				$a = Hex(_ColorGetRed(PixelGetColor($pos[0] + GUICtrlRead($PositionX) + 30, $pos[1] + GUICtrlRead($PositionY) + 1)), 2)
				$b1 = Hex(_ColorGetRed(PixelGetColor($pos[0] + GUICtrlRead($PositionX) + 3, $pos[1] + GUICtrlRead($PositionY) + 5)), 2)
				$b2 = Hex(_ColorGetRed(PixelGetColor($pos[0] + GUICtrlRead($PositionX) + 3, $pos[1] + GUICtrlRead($PositionY) + 20)), 2)
				$c = Hex(_ColorGetRed(PixelGetColor($pos[0] + GUICtrlRead($PositionX) - 30, $pos[1] + GUICtrlRead($PositionY) + 1)), 2)
				$bao_quan = PixelSearch($pos[0] + 740, $pos[1] + 450, $pos[0] + 810, $pos[1] + 460, '0x41C5F3')
				$ba_lo = PixelSearch($pos[0] + 920, $pos[1] + 330, $pos[0] + 940, $pos[1] + 345, '0xE44142')
				Select
					Case IsArray($bao_quan)
						Sleep(700)
						$khoe = PixelSearch($pos[0] + 790, $pos[1] + 450, $pos[0] + 810, $pos[1] + 460, '0xFFC71D')
						If IsArray($khoe) Then
							GUICtrlSetData($dem_ca_cau, GUICtrlRead($dem_ca_cau) + 1)
						EndIf
						ControlClick($title, "", "", 'left', 1, 751 + $padding_X, 458 + $padding_Y)
						Sleep(1500)
					Case IsArray(PixelSearch($pos[0]+300,$pos[1]+200, $pos[0]+302,$pos[1]+202, '0xFFFFFF')) And IsArray(PixelSearch($pos[0]+660,$pos[1]+200, $pos[0]+662,$pos[1]+202, '0xFFFFFF'))
						While IsArray(PixelSearch($pos[0] + 490, $pos[1] + 420, $pos[0] + 520, $pos[1] + 440, '0xFFFFFF'))
							ControlClick($title, "", "", 'left', 1, 492 + $padding_X, 438 + $padding_Y)
							Sleep(2000)
						WEnd
					Case IsArray($ba_lo)
						ControlClick($title, "", "", 'left', 1, 766 + $padding_X, 361 + $padding_Y)
						Sleep(2000)
					Case (($b1 <> $a) And ($b1 <> $c) And ($b1 == $b2)) And Not IsArray($ba_lo)
						ControlClick($title, "", "", 'left', 1, 845 + $padding_X, 500 + $padding_Y)
						Sleep(2000)
				EndSelect
			WEnd
			GUICtrlSetState($start, $GUI_ENABLE)
			GUICtrlSetState($pause, $GUI_DISABLE)
			GUICtrlSetState($adjust, $GUI_ENABLE)
			GUICtrlSetState($dem_ca_cau, $GUI_ENABLE)
			GUICtrlSetState($name_window, $GUI_ENABLE)
	EndSwitch
WEnd
