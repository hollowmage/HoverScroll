; SPDX-License-Identifier: GPL-3.0-or-later
﻿; =============================================================================
; Name: HoverScroll
; Author: HollowMage <email address hidden>
; Description: Use the mouse wheel to scroll even without the keyboard focus.
; Useful in Windows XP, not sure about 7, 8, and so forth...
; =============================================================================
;
; Copyright (C) 2026  Hollow Mage (aka Paulo Alexandre)
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.

#NoEnv
#SingleInstance Force
SetBatchLines, -1

icl := A_ScriptDir . "\icons2.icl"
haveIcons := FileExist(icl)

Menu, Tray, NoStandard
Menu, Tray, Add, Disabl&e, ToggleActive
Menu, Tray, Default, Disabl&e
Menu, Tray, Add, &Reload, DoReload
Menu, Tray, Add, &About, DoAbout
Menu, Tray, Add,
Menu, Tray, Add, E&xit, DoQuit
Menu, Tray, Tip, HoverScroll Enabled
if (haveIcons)
	Menu, Tray, Icon, %icl%, 0, 1

*WheelUp::
*WheelDown::
	CoordMode, Mouse, Screen
	MouseGetPos, x, y, win_hwnd, ctrl_hwnd, 2
	target := ctrl_hwnd ? ctrl_hwnd : win_hwnd
	if (target) {
		; The value 120 is for standard mice. Change as needed.
		w_param := (A_ThisHotkey = "*WheelUp") ? (120 << 16) : (-120 << 16)
		l_param := (y << 16) | (x & 0xFFFF)
		PostMessage, 0x020A, %w_param%, %l_param%, , ahk_id %target% ; 0x020A is WM_MOUSEWHEEL
	}
return

ToggleActive:
	Suspend, Toggle
	if (A_IsSuspended) {
		if (haveIcons)
			Menu, Tray, Icon, %icl%, 2, 1
		Menu, Tray, Tip, HoverScroll Disabled
		Menu, Tray, Rename, Disabl&e, Enabl&e
	}
	else {
		if (haveIcons)
			Menu, Tray, Icon, %icl%, 1, 1
		Menu, Tray, Tip, HoverScroll Enabled
		Menu, Tray, Rename, Enabl&e, Disabl&e
	}
return

DoReload:
	Reload
return

DoQuit:
	ExitApp
return

DoAbout:
	MsgBox, 64, HoverScroll, % "When active, this application allows the mouse wheel to also work on controls and applications that don't have the keyboard focus (there might be exceptions though).`nOriginally intended for Windows XP."
return
