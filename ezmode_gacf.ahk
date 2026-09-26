; Copyright (C) 2026  kipperz

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU Affero General Public License as
; published by the Free Software Foundation, version 3 of the License.
; Alternatively, this software may be used under a commercial license;
; contact business@kipperz.gg for details.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
; GNU Affero General Public License for more details.

VERSION := "v0.6"

#Warn
#Requires AutoHotkey v2.0
#SingleInstance Force

SendMode "Event"
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Screen"


; =====================================================================
; INITIALIZATION
; =====================================================================


#Include lib/config.ahk
#Include lib/settings.ahk
LoadSettings()
SaveSettings()

#Include lib/FindText.ahk
#Include lib/functions.ahk
#Include lib/gui.ahk
InitializeGui()

#Include lib/arena.ahk
#Include lib/rebirth.ahk
#Include lib/events.ahk

#Include lib/hotkeys.ahk