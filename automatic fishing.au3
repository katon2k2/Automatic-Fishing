#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\ICON\Ypf-Transformers-Document-write.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;size: 960x540
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <AutoItConstants.au3>
#include <Color.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("AUTO by KATON v3.0", 363, 273, 192, 124)
$Group1 = GUICtrlCreateGroup("", 8, 0, 345, 153)
$Label1 = GUICtrlCreateLabel("tên giả lập", 56, 19, 53, 17)
$name_window = GUICtrlCreateInput("", 120, 16, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
$adjust = GUICtrlCreateButton("căn chỉnh", 24, 48, 83, 41)
$complete = GUICtrlCreateButton("hoàn tất", 24, 96, 83, 41)

$Group2 = GUICtrlCreateGroup("", 120, 40, 121, 97)
$LbX = GUICtrlCreateLabel("X", 128, 56, 18, 20)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$LbY = GUICtrlCreateLabel("Y", 128, 104, 16, 20)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$PositionX = GUICtrlCreateInput("480", 152, 56, 73, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
$PositionY = GUICtrlCreateInput("85", 152, 104, 73, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group3 = GUICtrlCreateGroup("", 247, 10, 100, 97)
$PdX = GUICtrlCreateLabel("paddingX", 255, 30, 45, 20)
$InputPaddingX = GUICtrlCreateInput("0", 305, 27, 40, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
$PdY = GUICtrlCreateLabel("paddingY", 255, 70, 45, 20)
$InputPaddingY = GUICtrlCreateInput("0", 305, 67, 40, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$reste = GUICtrlCreateButton("reset", 256, 96, 83, 41)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$start = GUICtrlCreateButton("bắt đầu", 24, 168, 83, 41)
$pause = GUICtrlCreateButton("dừng", 24, 215, 83, 41)
$Label4 = GUICtrlCreateLabel("số lần sửa cần", 136, 181, 90, 20)
$dem_sua_can = GUICtrlCreateInput(0, 232, 177, 50, 24, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
$Label5 = GUICtrlCreateLabel("số cá câu được", 136, 229, 90, 20)
$dem_ca_cau = GUICtrlCreateInput(0, 232, 225, 50, 24, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))

GUICtrlSetState($reste, $GUI_DISABLE)
GUICtrlSetState($PositionX, $GUI_DISABLE)
GUICtrlSetState($PositionY, $GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $title = ""
Global $tRect
Global $check_hong_can = False
Global $padding_X
Global $padding_Y

#Region Định nghĩa và gán các Button muốn dùng để ngắt vòng lặp
    $Interrupt = 0
    GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND_BUTTON")
    Func _WM_COMMAND_BUTTON($hWnd, $Msg, $wParam, $lParam)
        Switch BitAND($wParam, 0x0000FFFF)
			Case $pause
				WinSetOnTop($title,"",$WINDOWS_NOONTOP)
                $Interrupt = 1
        EndSwitch
        Return 'GUI_RUNDEFMSG'
    EndFunc
#EndRegion

#Region Tắt GUI khi vẫn còn đang chạy vòng lặp
    GUIRegisterMsg($WM_SYSCOMMAND, "_WM_COMMAND_CLOSEBUTTON")
    Func _WM_COMMAND_CLOSEBUTTON($hWnd, $Msg, $wParam, $lParam)
        If BitAND($wParam, 0x0000FFFF) = 0xF060 Then
			WinSetOnTop($title,"",$WINDOWS_NOONTOP)
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
			While 1
				$pos = WinGetPos($title)
				_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), $tRect, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN))
				_WinAPI_DrawRect($pos[0]+GUICtrlRead($PositionX)-25,$pos[1]+GUICtrlRead($PositionY)+12, 5, 5, 0x0000FF)
				_WinAPI_DrawRect($pos[0]+GUICtrlRead($PositionX),$pos[1]+GUICtrlRead($PositionY), 5, 25, 0x0000FF)
				_WinAPI_DrawRect($pos[0]+GUICtrlRead($PositionX)+25,$pos[1]+GUICtrlRead($PositionY)+12, 5, 5, 0x0000FF)
				Switch GUIGetMsg()
					Case $complete
						ExitLoop
					Case $reste
						GUICtrlSetData($PositionX,'480')
						GUICtrlSetData($PositionY,'85')
						GUICtrlSetData($InputPaddingX,'0')
						GUICtrlSetData($InputPaddingY,'0')
				EndSwitch
			WEnd
			GUICtrlSetState($reste, $GUI_DISABLE)
			GUICtrlSetState($PositionX, $GUI_DISABLE)
			GUICtrlSetState($PositionY, $GUI_DISABLE)
		Case $start
			$Interrupt = 0
			$padding_X = GUICtrlRead($InputPaddingX)
			$padding_Y = GUICtrlRead($InputPaddingY)
			WinActivate($title)
			WinSetOnTop($title,"",$WINDOWS_ONTOP)
			While $Interrupt == 0
				$pos = WinGetPos($title)
				$a = Hex(_ColorGetRed(PixelGetColor($pos[0]+GUICtrlRead($PositionX)+25,$pos[1]+GUICtrlRead($PositionY)+1)),2)
				$b1 = Hex(_ColorGetRed(PixelGetColor($pos[0]+GUICtrlRead($PositionX)+3,$pos[1]+GUICtrlRead($PositionY)+5)),2)
				$b2 = Hex(_ColorGetRed(PixelGetColor($pos[0]+GUICtrlRead($PositionX)+3,$pos[1]+GUICtrlRead($PositionY)+20)),2)
				$c = Hex(_ColorGetRed(PixelGetColor($pos[0]+GUICtrlRead($PositionX)-25,$pos[1]+GUICtrlRead($PositionY)+1)),2)
				$bao_quan = PixelSearch($pos[0]+740,$pos[1]+450,$pos[0]+770,$pos[1]+460,'0x41C5F3')
				$ba_lo = PixelSearch($pos[0]+920,$pos[1]+330,$pos[0]+940,$pos[1]+345,'0xE44142')
				Select
					Case IsArray($bao_quan)
						$khoe = PixelSearch($pos[0]+790,$pos[1]+450,$pos[0]+810,$pos[1]+460,'0xFFC71D')
						If IsArray($khoe) Then
							GUICtrlSetData($dem_ca_cau,GUICtrlRead($dem_ca_cau)+1)
						EndIf
						ControlClick($title,"","",'left',1 ,751 + $padding_X, 458 + $padding_Y)
						Sleep(1500)
					Case $check_hong_can
						ControlClick($title,"","",'left',1 ,917 + $padding_X, 319 + $padding_Y)
						Sleep(2000)
						$nut_sua_2 = PixelSearch($pos[0]+700,$pos[1]+280,$pos[0]+745,$pos[1]+295,'0xF15E4E')
						If IsArray($nut_sua_2) Then
							ControlClick($title,"","",'left',1 ,730 + $padding_X, 270 + $padding_Y)
							Sleep(2000)
							$yes = PixelSearch($pos[0]+490,$pos[1]+420,$pos[0]+520,$pos[1]+440,'0xFFFFFF')
							If IsArray($yes) Then
								ControlClick($title,"","",'left',1 ,492 + $padding_X, 438 + $padding_Y)
								Sleep(2000)
								ControlClick($title,"","",'left',1 ,492 + $padding_X, 438 + $padding_Y)
								Sleep(2000)
								ControlClick($title,"","",'left',1 ,63, 287)
								Sleep(2000)
								$check_hong_can = False
								GUICtrlSetData($dem_sua_can,GUICtrlRead($dem_sua_can)+1)
							Else
								Exit
							EndIf
						Else
							ControlClick($title,"","",'left',1 ,63, 287)
							$check_hong_can = False
							Sleep(1500)
						EndIf
					Case IsArray($ba_lo)
						ControlClick($title,"","",'left',1 ,766 + $padding_X, 361 + $padding_Y)
						Sleep(3000)
						If IsArray(PixelSearch($pos[0]+920,$pos[1]+330,$pos[0]+940,$pos[1]+345,'0xE44142')) Then
							$check_hong_can = True
						EndIf
					Case (($b1 <> $a) And ($b1 <> $c) And ($b1 == $b2)) And Not IsArray($ba_lo)
						ControlClick($title,"","",'left',1 ,845 + $padding_X, 456 + $padding_Y)
						Sleep(4500)
				EndSelect
			WEnd
	EndSwitch
WEnd
