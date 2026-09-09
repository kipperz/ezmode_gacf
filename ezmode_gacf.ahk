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


#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Event"
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Screen"


; =====================================================================
; CONFIG
; =====================================================================

ROBLOX_WINDOW := "ahk_exe RobloxPlayerBeta.exe"
INI_FILE := "ezmode_gacf.ini"
GUI_TITLE := "EZ Mode"
VERSION := "v0.4"

GUI_SETTINGS := {
    IDLE: {
        WIN_TITLE: GUI_TITLE,
        BACK_COLOR: "202020",
        HEADER_FONT_STYLE: "cWhite s12 W800",
        HEADER_FONT_FACE: "Segoe UI",
        HEADER_LABEL: "Grow a Chicken Fighter " VERSION,
        STATUS_LABEL_FONT_STYLE: "Q5 cWhite s9 W400",
        STATUS_LABEL_FONT_FACE: "Segoe UI",
        STATUS_LABEL: "Made by kipperz",
        REBIRTH_BUTTON: true,
        ARENA_BUTTON: true,
        SETTINGS_BUTTON: true,
        COUNTDOWN_FONT_STYLE: "Q5 cWhite s9 W400",
        COUNTDOWN_FONT_FACE: "Segoe UI"
    },
    RUNNING: {
        WIN_TITLE: GUI_TITLE " - Running",
        BACK_COLOR: "F5B041" ,
        HEADER_FONT_STYLE: "Q5 cBlack s12 W800",
        HEADER_FONT_FACE: "Segoe UI",
        HEADER_LABEL: "🟡 Automation in control",
        STATUS_LABEL_FONT_STYLE: "Q5 cBlack s9 W400",
        STATUS_LABEL_FONT_FACE: "Segoe UI",
        STATUS_LABEL: "Avoid mouse/keyboard input",
        CANCEL_BUTTON: true,
        COUNTDOWN_FONT_STYLE: "cBlack s9 W400",
        COUNTDOWN_FONT_FACE: "Segoe UI"
    },
    WAITING: {
        WIN_TITLE: GUI_TITLE " - Waiting",
        BACK_COLOR: "2ECC71",
        HEADER_FONT_STYLE: "Q5 cBlack s12 Bold",
        HEADER_FONT_FACE: "Segoe UI",
        HEADER_LABEL: "🟢 Safe to multitask",
        STATUS_LABEL_FONT_STYLE: "Q5 cBlack s9 W400",
        STATUS_LABEL_FONT_FACE: "Segoe UI",
        STATUS_LABEL: "Keep progress bar visible",
        CANCEL_BUTTON: true
    },
    INTERRUPTED: {
        WIN_TITLE: GUI_TITLE " - Paused",
        BACK_COLOR: "E74C3C",
        HEADER_FONT_STYLE: "Q5 cBlack s12 Bold ",
        HEADER_FONT_FACE: "Segoe UI",
        HEADER_LABEL: "🔴 Automation paused",
        STATUS_LABEL_FONT_STYLE: "Q5 cBlack s9 W400",
        STATUS_LABEL_FONT_FACE: "Segoe UI",
        STATUS_LABEL: " ",
        CANCEL_BUTTON: true
    },
    ARENA: {
        WIN_TITLE: GUI_TITLE " - Arena",
        BACK_COLOR: "2ECC71",
        HEADER_FONT_STYLE: "Q5 cBlack s12 Bold ",
        HEADER_FONT_FACE: "Segoe UI",
        HEADER_LABEL: "Arena Assist",
        STATUS_LABEL_FONT_STYLE: "Q5 cBlack s9 W400",
        STATUS_LABEL_FONT_FACE: "Segoe UI",
        STATUS_LABEL: " ",
        BATTLE_BUTTON: true,
        REROLL_BUTTON: true,
        BACK_BUTTON: true
    }
}

COLORS := {
    KNOCKOUT:         {HEX: 0xf21b22, VAR: 20},
    HIDDEN_KNOCKOUT:  {HEX: 0x05320a, VAR: 5},
    REBIRTH_BAR:      {HEX: 0x14cd28, VAR: 5},
    REBIRTH_BUTTON:   {HEX: 0x31BC40, VAR: 20},
    NOT_YET_BUTTON:   {HEX: 0xab7a49, VAR: 20},
    PURCHASE_AD:      {HEX: 0xffffff, VAR: 10},
    SKIP_TO_FRONTIER: {HEX: 0xcea639, VAR: 10},
    SKIP_TO_WARMUP:   {HEX: 0xa67645, VAR: 10},
    VICTORY_SCREEN:   {HEX: 0x1ab2fe, VAR: 5},
    DEFEAT_SCREEN:    {HEX: 0x1ab2fe, VAR: 5},
}

CLICK_COORDS := {
    TOWER_ICON:              {X: 592,  Y: 641},
    TOWER_SKIP_TO_FRONTIER:  {X: 696,  Y: 362},
    TOWER_SKIP_TO_WARMUP:    {X: 643,  Y: 305},
    TOWER_START_FROM_BOTTOM: {X: 767,  Y: 380}, ; verify this
    KEEP_CLIMBING_OFFER:     {X: 603,  Y: 473},
    REBIRTH_ICON:            {X: 1140, Y: 416},
    REBIRTH_WINDOW_CLOSE:    {X: 819,  Y: 70},
    REBIRTH_BUTTON:          {X: 598,  Y: 501},
    PURCHASE_AD:             {X: 767,  Y: 380}, ; verify
    ARENA_ICON:              {X: 1140, Y: 470},
    GO_TO_BATTLE:            {X: 600,  Y: 500},
    EXIT_ARENA:              {X: 66,   Y: 55},
    ARENA_BACK:              {X: 952,  Y: 136},
    EDIT_TEAM:               {X: 902,  Y: 255},
    SAVE_TEAM:               {X: 706,  Y: 506},
}

SEARCH_COORDS := {
    KNOCKOUT_WINDOW:  {X1: 555, Y1: 152, X2: 560, Y2: 157},
    HIDDEN_KNOCKOUT:  {X1: 335, Y1: 505, X2: 340, Y2: 510},
    REBIRTH_BAR:      {X1: 430, Y1: 204, X2: 435, Y2: 209},
    REBIRTH_BUTTON:   {X1: 484, Y1: 460, X2: 704, Y2: 512},
    NOT_YET_BUTTON:   {X1: 484, Y1: 460, X2: 704, Y2: 512},
    PURCHASE_AD:      {X1: 767, Y1: 380, X2: 772, Y2: 385},
    SKIP_TO_FRONTIER: {X1: 643, Y1: 367, X2: 648, Y2: 372},
    SKIP_TO_WARMUP:   {X1: 643, Y1: 305, X2: 648, Y2: 310},
    VICTORY_SCREEN:   {X1: 698, Y1: 499, X2: 708, Y2: 509},
    DEFEAT_SCREEN:    {X1: 698, Y1: 475, X2: 708, Y2: 485},
}

TIMINGS := {
    TOWER_ENTRY_WAIT:      3500,
    FEEDER_UPGRADE_DELAY:  175,
    RETREAT_WAIT:          4500,
    UI_RESPONSE:           50,
    ANTI_AFK_INTERVAL:     240000,
    FEED_TIME_SINGLE:      6000,   ; milliseconds for feeding with one upgraded feeder
    FEED_TIME_DOUBLE:      12000,  ; milliseconds for feeding with two upgraded feeders
    TIMEOUTS: { ; ms
        TRY_REBIRTH:       20000,
        TOWER_RUN_INITIAL: 120000,
        TOWER_RUN_LOOPED:  180000,
        KNOCKED_OUT_POPUP: 10000,
    }
}

antiAfkToggle := false
hotkeyGotoBattle := "F7"
hotkeyReroll := "F8"
noticeMessage := ""


; =====================================================================
; SETTINGS
; =====================================================================

LoadSettings() {
    global

    savedX := IniRead(INI_FILE, "Window", "X", "")
    savedY := IniRead(INI_FILE, "Window", "Y", "")

    feederUpgradeMethod := IniRead(INI_FILE, "Settings", "feederUpgradeMethod", "single")
        ; "single" - 1 feeder
        ; "turn" - 2 feeders upgraded by turning the camera
        ; "strafe" 2 feeders upgraded by strafing
    initialFeedTime := IniRead(INI_FILE, "Settings", "initialFeedTime", 2) ; Time in seconds for feeding before first run (2 for one feeding, 16 for two)
    initialRetreatTime := IniRead(INI_FILE, "Settings", "initialRetreatTime", 0) ; Time in seconds to retreat during the first run

    ufoNotifications := IniRead(INI_FILE, "Settings", "ufoNotifications", 1)
    ufoCountdown := IniRead(INI_FILE, "Settings", "ufoCountdown", 1)
}

SaveSettings() {
    global
    IniWrite(initialFeedTime, INI_FILE, "Settings", "initialFeedTime")
    IniWrite(initialRetreatTime, INI_FILE, "Settings", "initialRetreatTime")
    IniWrite(feederUpgradeMethod, INI_FILE, "Settings", "feederUpgradeMethod")
    IniWrite(ufoNotifications, INI_FILE, "Settings", "ufoNotifications")
    IniWrite(ufoCountdown, INI_FILE, "Settings", "ufoCountdown")
}

SaveWindowPosition(*) {
    WinGetPos(&x, &y, , , mainGui.Hwnd)
    IniWrite(x, INI_FILE, "Window", "X")
    IniWrite(y, INI_FILE, "Window", "Y")
}


; =====================================================================
; KEYBINDS
; =====================================================================

^F12::ReloadScript()
^F8::AntiAfk()
Hotkey(hotkeyGotoBattle, GoToBattle, "Off")
Hotkey(hotkeyReroll, RerollMatch, "Off")


; =====================================================================
; INITIALIZATION
; =====================================================================

if !WinExist(ROBLOX_WINDOW) {
    MsgBox "Please start Roblox first."
    ExitApp
}
WinMove , , 1200, 702, ROBLOX_WINDOW

LoadSettings()
SaveSettings()

SetTimer(CheckInterval, 1000)

InitializeGui()


; =====================================================================
; GUI
; =====================================================================

InitializeGui() {
    guiWidth := 275
    marginX := 10
    contentWidth := guiWidth - (marginX * 2)
    buttonRowY := 75
    twoButtonWidth := (guiWidth - (marginX * 3)) // 2
    threeButtonWidth := twoButtonWidth - marginX * 2

    global mainGui := Gui("+AlwaysOnTop", GUI_SETTINGS.IDLE.WIN_TITLE)
    mainGui.BackColor := GUI_SETTINGS.IDLE.BACK_COLOR
    mainGui.MarginX := marginX

    mainGui.SetFont(GUI_SETTINGS.IDLE.HEADER_FONT_STYLE, GUI_SETTINGS.IDLE.HEADER_FONT_FACE)
    global headerLabel := mainGui.AddText("w" contentWidth " Center", GUI_SETTINGS.IDLE.HEADER_LABEL)

    ; Button Row 1
    mainGui.SetFont(GUI_SETTINGS.IDLE.STATUS_LABEL_FONT_STYLE, GUI_SETTINGS.IDLE.STATUS_LABEL_FONT_FACE)
    global buttonRebirth := mainGui.AddButton("x" marginX " y+10 w" threeButtonWidth, "Rebirth")
    buttonRebirth.OnEvent("Click", ShowRebirthGui)

    global buttonArena := mainGui.AddButton("x+10 w" threeButtonWidth, "Arena")
    buttonArena.OnEvent("Click", ShowArenaGui)

    global buttonSettings := mainGui.AddButton("x+" marginX " w30", "⚙️")
    buttonSettings.OnEvent("Click", ShowSettingsGui)

    global buttonCancel := mainGui.AddButton("x" marginX " yp w" contentWidth, "Cancel")
    buttonCancel.OnEvent("Click", ReloadScript)
    buttonCancel.Visible := false

    global buttonBattle := mainGui.AddButton("x" marginX " yp w" threeButtonWidth, "Battle (" hotkeyGotoBattle ")")
    buttonBattle.OnEvent("Click", GoToBattle)
    buttonBattle.Visible := false

    global buttonReroll := mainGui.AddButton("x+10 w" threeButtonWidth, "Reroll (" hotkeyReroll ")")
    buttonReroll.OnEvent("Click", RerollMatch)
    buttonReroll.Visible := false
    
    global buttonBack := mainGui.AddButton("x+" marginX " w30", "↩️")
    buttonBack.OnEvent("Click", ArenaBackToIdle)
    buttonBack.Visible := false

    mainGui.SetFont(GUI_SETTINGS.IDLE.STATUS_LABEL_FONT_STYLE, GUI_SETTINGS.IDLE.STATUS_LABEL_FONT_FACE)
    global statusLabel := mainGui.AddText("x" marginX " y+12 w" twoButtonWidth + 35, GUI_SETTINGS.IDLE.STATUS_LABEL)

    mainGui.SetFont("Q5 cWhite s9 W400", "Segoe UI")
    global countdownLabel := mainGui.AddText("x+" marginX " w" twoButtonWidth - 35 " right", CreateStatusLabel())

    mainGui.OnEvent("Close", CloseGui)

    if (savedX == "" || savedY == "") {
        mainGui.Show("Center") 
    } else {
        mainGui.Show("x" . savedX . " y" . savedY)
    }
}

SwitchGui(guiSetting) {
    mainGui.title := guiSetting.WIN_TITLE
    mainGui.BackColor := guiSetting.BACK_COLOR

    headerLabel.SetFont(guiSetting.HEADER_FONT_STYLE, guiSetting.HEADER_FONT_FACE)
    headerLabel.Text := guiSetting.HEADER_LABEL

    statusLabel.SetFont(guiSetting.STATUS_LABEL_FONT_STYLE, guiSetting.STATUS_LABEL_FONT_FACE)
    statusLabel.Text := guiSetting.STATUS_LABEL

    if (guiSetting.HasOwnProp("REBIRTH_BUTTON"))
        buttonRebirth.Visible := guiSetting.REBIRTH_BUTTON
    else
        buttonRebirth.Visible := false

    if (guiSetting.HasOwnProp("ARENA_BUTTON"))
        buttonArena.Visible := guiSetting.ARENA_BUTTON
    else
        buttonArena.Visible := false

    if (guiSetting.HasOwnProp("SETTINGS_BUTTON"))
        buttonSettings.Visible := guiSetting.SETTINGS_BUTTON
    else
        buttonSettings.Visible := false

    if (guiSetting.HasOwnProp("CANCEL_BUTTON"))
        buttonCancel.Visible := guiSetting.CANCEL_BUTTON
    else
        buttonCancel.Visible := false

    if (guiSetting.HasOwnProp("BATTLE_BUTTON"))
        buttonBattle.Visible := guiSetting.BATTLE_BUTTON
    else
        buttonBattle.Visible := false

    if (guiSetting.HasOwnProp("REROLL_BUTTON"))
        buttonReroll.Visible := guiSetting.REROLL_BUTTON
    else
        buttonReroll.Visible := false

    if (guiSetting.HasOwnProp("BACK_BUTTON"))
        buttonBack.Visible := guiSetting.BACK_BUTTON
    else
        buttonBack.Visible := false

    if (guiSetting.HasOwnProp("COUNTDOWN_FONT_STYLE"))
        countdownLabel.SetFont(guiSetting.COUNTDOWN_FONT_STYLE, guiSetting.COUNTDOWN_FONT_FACE)
    else
        countdownLabel.SetFont(GUI_SETTINGS.RUNNING.COUNTDOWN_FONT_STYLE, GUI_SETTINGS.RUNNING.COUNTDOWN_FONT_FACE)
}

ShowSettingsGui(*) {
    settingsW := 260
    titleW := 140
    inputW := 90

    ; Create Settings GUI
    global settingsGui := Gui("+AlwaysOnTop", "Script Settings")
    settingsGui.SetFont("s10", "Segoe UI")


    ; Feeder Upgrade Method
    settingsGui.SetFont("Q5 c000000 s10 W800", "Segoe UI")
    settingsGui.AddText("x10 y+20 w" titleW, "Upgrade Method:")

    settingsGui.SetFont("Q5 c000000 s8 W400", "Segoe UI")
    methodList := ["single", "strafe", "turn"]
    selectedIdx := 1
    for idx, val in methodList {
        if (val == feederUpgradeMethod) {
            selectedIdx := idx
            break
        }
    }
    feederUpgradeMethodInput := settingsGui.AddDropDownList("x+10 yp-3 w" inputW " Choose" selectedIdx, methodList)

    settingsGui.SetFont("c1b1b1b s8 W400", "Segoe UI")
    settingsGui.AddText("x10 y+2", "single = 1 feeder")
    settingsGui.AddText("x10 y+5", "strafe = 2 feeders upgraded by strafing")
    settingsGui.AddText("x10 y+5", "turn = 2 feeders upgraded by turning")


    ; Initial Feedings
    settingsGui.SetFont("Q5 c000000 s10 W800", "Segoe UI")
    settingsGui.AddText("x10 y+20 w" titleW, "Initial Feed Time (s):")

    settingsGui.SetFont("Q5 c000000 s10 W400", "Segoe UI")
    initialFeedTimeInput := settingsGui.AddEdit("x+10 yp-5 w" inputW, initialFeedTime)

    settingsGui.SetFont("Q5 c000000 s8 W400", "Segoe UI")
    settingsGui.AddText("x10 y+0", "Allows time for feeding before first run")
    settingsGui.AddText("x10 y+5", "Set 2 for one feeding, 16 for two feedings")


    ; Initial Recall
    settingsGui.SetFont("Q5 c000000 s10 W800", "Segoe UI")
    settingsGui.AddText("x10 y+20 w" titleW, "Initial Recall Time (s):")

    settingsGui.SetFont("Q5 c000000 s10 W400", "Segoe UI")
    initialRetreatTimeInput := settingsGui.AddEdit("x+10 yp-5 w" inputW, initialRetreatTime)

    settingsGui.SetFont("Q5 c000000 s8 W400", "Segoe UI")
    settingsGui.AddText("x10 y+0", "Retreat after X seconds on initial run")
    

    ; UFO Event
    settingsGui.SetFont("Q5 c000000 s10 W800", "Segoe UI")
    settingsGui.AddText("x10 y+20 w" titleW, "UFO Event")

    
    twoButtonWidth := (settingsW - (10 * 3)) // 2

    settingsGui.SetFont("Q5 c000000 s10 W400", "Segoe UI")
    ufoNotificationsInput := settingsGui.Add("CheckBox", "x10 y+5 w" twoButtonWidth " " (ufoNotifications == 1 ? "Checked" : ""), "Notification")
    ufoCountdownInput := settingsGui.Add("CheckBox", "x+10 " (ufoCountdown == 1 ? "Checked" : ""), "Countdown")

    ; Save Button
    btnSave := settingsGui.AddButton("w150 h30 x" (settingsW // 2) - (150 // 2) " y+20 Default", "Save")
    btnSave.OnEvent("Click", SaveSettingsGui.Bind(feederUpgradeMethodInput, initialFeedTimeInput, initialRetreatTimeInput, ufoNotificationsInput, ufoCountdownInput))
    
    ; Set coords and show GUI
    mainGui.GetPos(&mainX, &mainY)
    mainGui.GetClientPos(, , &mainW, &mainH)
    
    settingsGui.Show("x" CalcXForCenter(mainX, mainW, settingsW) " y" mainY + 35 " w" settingsW)
}

SaveSettingsGui(feederUpgradeMethodInput, initialFeedTimeInput, initialRetreatTimeInput, ufoNotificationsInput, ufoCountdownInput, *) {
    global 
    
    feederUpgradeMethod := feederUpgradeMethodInput.Text
    initialFeedTime := initialFeedTimeInput.Value
    initialRetreatTime := initialRetreatTimeInput.Value
    ufoNotifications := ufoNotificationsInput.Value
    ufoCountdown := ufoCountdownInput.Value

    SaveSettings()
    settingsGui.Destroy()

    ReloadScript()
}

ShowRebirthGui(*) {
    global selectionGui := Gui("+AlwaysOnTop", " ")

    buttonRunTowerUpgrades := selectionGui.Add("Button", "x15 y10 w150 h30", "Start")
    buttonRunTowerUpgrades.OnEvent("Click", SelectOption.Bind(StepOne))

    buttonRunTower := selectionGui.Add("Button", "x15 y+5 w150 h30", "Continue")
    buttonRunTower.OnEvent("Click", SelectOption.Bind(CheckRebirth))

    buttonUpgradeFeeders := selectionGui.Add("Button", "x15 y+5 w150 h30", "Upgrade Feeder(s)")
    buttonUpgradeFeeders.OnEvent("Click", SelectOption.Bind(ShowFeederUpgradeGui))

    mainGui.GetPos(&mainX, &mainY)
    mainGui.GetClientPos(, , &mainW, &mainH)

    selectionW := 180
    selectionGui.Show("x" CalcXForCenter(mainX, mainW, selectionW) " y" mainY + 35 " w" selectionW)
}

ShowArenaGui(*) {
    global selectionGui := Gui("+AlwaysOnTop", " ")

    buttonBattle := selectionGui.Add("Button", "x15 y+5 w150 h30", "Assist")
    buttonBattle.OnEvent("Click", SelectOption.Bind(ArenaAssist))

    buttonBattle := selectionGui.Add("Button", "x15 y+5 w150 h30", "Auto")
    buttonBattle.OnEvent("Click", SelectOption.Bind(ArenaAuto))

    buttonDerank := selectionGui.Add("Button", "x15 y+5 w150 h30", "Derank")
    buttonDerank.OnEvent("Click", SelectOption.Bind(DeRank))

    mainGui.GetPos(&mainX, &mainY)
    mainGui.GetClientPos(, , &mainW, &mainH)
    selectionW := 180
    selectionGui.Show("x" CalcXForCenter(mainX, mainW, selectionW) " y" mainY + 35 " w" selectionW)
}

ShowFeederUpgradeGui() {
    mainGui.GetPos(&mainX, &mainY, &mainW, &mainH)

    selectionW := 180

    selectionX := (mainW - selectionW) // 2 + mainX
    selectionY := mainY + 35

    global feederUpgradeGui := Gui("+AlwaysOnTop", " ")

    button1 := feederUpgradeGui.Add("Button", "x15 y10 w150 h30", "x20")
    button1.OnEvent("Click", UpgradeOption.Bind(20))

    button2 := feederUpgradeGui.Add("Button", "x15 y+5 w150 h30", "x30")
    button2.OnEvent("Click", UpgradeOption.Bind(30))

    button3 := feederUpgradeGui.Add("Button", "x15 y+5 w150 h30", "x40")
    button3.OnEvent("Click", UpgradeOption.Bind(40))

    button4 := feederUpgradeGui.Add("Button", "x15 y+5 w150 h30", "x50")
    button4.OnEvent("Click", UpgradeOption.Bind(50))

    feederUpgradeGui.Show("x" selectionX " y" selectionY " w" selectionW)
}

SelectOption(clickedFunction, *) {
    selectionGui.Destroy()
    ActivateRoblox()
    clickedFunction()
}

UpgradeOption(count, *) {
    feederUpgradeGui.Destroy()
    ActivateRoblox()
    UpgradeFeeder(count)
}

ReloadScript(*) {
    SaveWindowPosition()
    Reload()
}

CloseGui(*) {
    ExitApp()
}

CalcXForCenter(mainX, mainW, newW) {
    return (mainW - newW) // 2 + mainX
}

CreateStatusLabel(ufoText := "🛸 Calculating...") {
    global statusLabelText := ""
    if antiAfkToggle
        statusLabelText := "🕛"
    if ufoCountdown
        statusLabelText := statusLabelText ufoText
    return statusLabelText
}


; =====================================================================
; GAME CONTROL
; =====================================================================

MovePlayer(key, seconds) {
    CheckActiveWindow()
    Send "{" key " down}"
    Sleep seconds * 1000

    CheckActiveWindow()
    Send "{" key " up}" 
}

ClickAt(objectOrTargetX, y := 0, speed := 5, clickDelayMs := 100) {
    if IsObject(objectOrTargetX) && objectOrTargetX.HasProp("X") {
        targetX := objectOrTargetX.X
        targetY := objectOrTargetX.Y
    } else {
        targetX := objectOrTargetX
        targetY := y
    }

    CheckActiveWindow()
    MouseMove targetX, targetY, speed
    Sleep clickDelayMs
    Click targetX, targetY
}

ClickAtPercent(x, y, speed := 5, clickDelayMs := 100) {
    WinGetClientPos(, , &robloxW, &robloxH, ROBLOX_WINDOW)

    targetX := robloxW * x
    targetY := robloxH * y

    CheckActiveWindow()
    MouseMove targetX, targetY, speed
    Sleep clickDelayMs
    Click targetX, targetY
}


; =====================================================================
; UTILITIES
; =====================================================================

ActivateRoblox() {
    if !WinExist(ROBLOX_WINDOW) {
        MsgBox "Roblox is not open.", , 262144
        return
    }

    ; Bring Roblox to the foreground and wait briefly for activation.
    WinActivate ROBLOX_WINDOW
    if !WinWaitActive(ROBLOX_WINDOW, , 2) {
        MsgBox "Could not activate the Roblox window.", , 262144
        return
    }
    Sleep TIMINGS.UI_RESPONSE
}

CheckActiveWindow() {
    if !WinActive(ROBLOX_WINDOW) {
        SwitchGui(GUI_SETTINGS.INTERRUPTED)

        result := MsgBox(noticeMessage "`n`nWould you like to continue?" , "AutoRebirth Paused", "YesNo T120 Iconi 0x40000")
        if result = "No" {
            ReloadScript()
        } else
            SwitchGui(GUI_SETTINGS.RUNNING)
            ActivateRoblox()
    }
}

PixelSearchRobloxClient(x1, y1, x2, y2, colorId, variation) {
    WinGetClientPos(&robloxX, &robloxY, , , ROBLOX_WINDOW)
    if PixelSearch(&foundX, &foundY, robloxX + x1, robloxY + y1, robloxX + x2, robloxY + y2, colorId, variation)
        return true

    return false
}

PixelSearchRoblox(coords, color) { ; not used
    WinGetClientPos(&robloxX, &robloxY, , , ROBLOX_WINDOW)

    if PixelSearch(
        &foundX, &foundY,
        robloxX + coords.X1, robloxY + coords.Y1,
        robloxX + coords.X2, robloxY + coords.Y2,
        color.HEX, color.VAR
    )
        return true
    else
        return false
}

ImageSearchRobloxClient(location) {
    WinGetClientPos(&x, &y, &w, &h, ROBLOX_WINDOW)

    if ImageSearch(
        &foundX,
        &foundY,
        x,
        y,
        x + w,
        y + h,
        "*100 " location
    )
        return {x: foundX, y: foundY}
}

ClearMousePos(dist := 50) {
    MouseMove dist, dist, 0, "R"
}

GetCurrentUnixTime() {
    return DateDiff(A_NowUTC, "19700101000000", "Seconds")
}


; =====================================================================
; GAME STATE
; =====================================================================

CheckForKnockout() {
    s := SEARCH_COORDS.KNOCKOUT_WINDOW
    c := COLORS.KNOCKOUT
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, c.HEX, c.VAR)
}

CheckForHiddenKnockout() {
    s := SEARCH_COORDS.HIDDEN_KNOCKOUT
    c := COLORS.HIDDEN_KNOCKOUT
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, c.HEX, c.VAR)
}

CheckRebirthBar() {
    s := SEARCH_COORDS.REBIRTH_BAR
    c := COLORS.REBIRTH_BAR
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, c.HEX, c.VAR)
}

CheckRebirthButton() {
    s := SEARCH_COORDS.REBIRTH_BUTTON
    c := COLORS.REBIRTH_BUTTON
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, c.HEX, c.VAR)
}

CheckNotYetButton() {
    s := SEARCH_COORDS.NOT_YET_BUTTON
    c := COLORS.NOT_YET_BUTTON
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, c.HEX, c.VAR)
}

CheckForPurchaseAd() {
    s := SEARCH_COORDS.PURCHASE_AD
    c := COLORS.PURCHASE_AD
    if PixelSearchRobloxClient(S.X1, S.Y1, S.X2, S.Y2, C.HEX, C.VAR)
        ClickAt(CLICK_COORDS.PURCHASE_AD)
}

CheckForVictoryScreen() {
    s := SEARCH_COORDS.VICTORY_SCREEN
    c := COLORS.VICTORY_SCREEN
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, c.HEX, c.VAR)
}

CheckForDefeatScreen() {
    s := SEARCH_COORDS.DEFEAT_SCREEN
    c := COLORS.DEFEAT_SCREEN
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, c.HEX, c.VAR)
}


; =====================================================================
; ARENA
; =====================================================================

DeRank(*) {
    result := MsgBox("Deranking will auto forfeit arena matches to lower your rank`n`nWould you like to continue?" , "WARNING", "YesNo Icon! 0x40000")
    if result = "Yes" {
        
        global noticeMessage := "Auto Deranking"

        if (mainGui.Title != GUI_SETTINGS.RUNNING.WIN_TITLE)
            SwitchGui(GUI_SETTINGS.RUNNING)

        while (1 != 2) {
            ClickAt(CLICK_COORDS.ARENA_ICON)
            Sleep TIMINGS.UI_RESPONSE

            ClickAt(CLICK_COORDS.GO_TO_BATTLE)
            Sleep TIMINGS.UI_RESPONSE

            ClickAt(CLICK_COORDS.GO_TO_BATTLE)
            Sleep 1000

            ClickAt(CLICK_COORDS.EXIT_ARENA)
            Sleep 1000
        }
    }
}

ArenaAuto(*) {
    result := MsgBox("Current matchmaking is broken. Auto battling will likely result in more losses than wins.`n`nWould you like to continue?" , "WARNING", "YesNo Icon! 0x40000")
    if result = "Yes" {
        
        global noticeMessage := "Auto Arena Battle"

        if (mainGui.Title != GUI_SETTINGS.RUNNING.WIN_TITLE)
            SwitchGui(GUI_SETTINGS.RUNNING)

        ClickAt(CLICK_COORDS.ARENA_ICON)
        Sleep TIMINGS.UI_RESPONSE

        while (1 != 2) {
            ClickAt(CLICK_COORDS.GO_TO_BATTLE)
            Sleep TIMINGS.UI_RESPONSE

            ClickAt(CLICK_COORDS.GO_TO_BATTLE)
            Sleep TIMINGS.UI_RESPONSE

            startTime := A_TickCount
            while (A_TickCount - startTime < 60000) {
                if CheckForDefeatScreen()
                    break

                if CheckForVictoryScreen()
                    break
            }

            ClickAt(CLICK_COORDS.GO_TO_BATTLE)
        }
    }
}

GoToBattle(*) {
    ActivateRoblox
    ClickAtPercent(0.5, 0.76)
}

RerollMatch(*) {
    ActivateRoblox

    ; ClickAt(2443, 309)
    ClickAt(CLICK_COORDS.ARENA_BACK)
    Sleep TIMINGS.UI_RESPONSE

    ; ClickAt(2354, 574)
    ClickAt(CLICK_COORDS.EDIT_TEAM)
    Sleep TIMINGS.UI_RESPONSE

    ; ClickAt(1950, 1086)
    ClickAt(CLICK_COORDS.SAVE_TEAM)
    Sleep 1500

    GoToBattle()
}

ArenaBackToIdle(*) {
    Hotkey(hotkeyGotoBattle, GoToBattle, "Off")
    Hotkey(hotkeyReroll, RerollMatch, "Off")
    SwitchGui(GUI_SETTINGS.IDLE)
}

ArenaAssist(*) {
    SwitchGui(GUI_SETTINGS.ARENA)
    Hotkey(hotkeyGotoBattle, GoToBattle, "On")
    Hotkey(hotkeyReroll, RerollMatch, "On")
    ClickAt(CLICK_COORDS.ARENA_ICON)
    Sleep TIMINGS.UI_RESPONSE
    ClickAt(CLICK_COORDS.GO_TO_BATTLE)
}


; =====================================================================
; REBIRTH 
; =====================================================================

StepOne(*) {
    global noticeMessage := "Starting initial Tower run"
    if (mainGui.Title != GUI_SETTINGS.RUNNING.WIN_TITLE)
        SwitchGui(GUI_SETTINGS.RUNNING)

    UpgradeFeeder(1)

    Sleep initialFeedTime * 1000
    StepTwo()
}

StepTwo() {
    global noticeMessage := "Upgrading feeders"
    if (mainGui.Title != GUI_SETTINGS.RUNNING.WIN_TITLE)
        SwitchGui(GUI_SETTINGS.RUNNING)

    SendToTower()
    Sleep TIMINGS.TOWER_ENTRY_WAIT

    startTime := A_TickCount
    knockedOut := false
    recalled := false

    while (A_TickCount - startTime < TIMINGS.TIMEOUTS.TOWER_RUN_INITIAL) {
        if (initialRetreatTime && initialRetreatTime * 1000 - TIMINGS.TOWER_ENTRY_WAIT < A_TickCount - startTime){
            ; MsgBox "Initial Retreat time triggered after " A_TickCount - startTime " milliseconds"
            recalled := true
            Retreat()
            break
        }
        
        if (feederUpgradeMethod == "strafe")
            UpgradeFeedersStrafe()
        else if (feederUpgradeMethod == "turn")
            UpgradeFeedersTurn()
        else {
            CheckActiveWindow()
            Send "e"
            Sleep 500 ; sleep hard code
        }

        if CheckForKnockout() {
            noticeMessage := "Knocked Out"
            knockedOut := true
            break
        }
    }

    if knockedOut {
        ClickAt(CLICK_COORDS.KEEP_CLIMBING_OFFER)

        if (feederUpgradeMethod == "single")
            Sleep TIMINGS.FEED_TIME_SINGLE
        else
            Sleep TIMINGS.FEED_TIME_DOUBLE
        
        StepThree()
    } else if recalled {
        if (feederUpgradeMethod == "single")
            Sleep TIMINGS.FEED_TIME_SINGLE
        else
            Sleep TIMINGS.FEED_TIME_DOUBLE

        StepThree()
    } else {
        ; Timed out looking for knockout window
        ; Move mouse off Tower icon and rerun
        ClearMousePos()
        StepTwo()
    }
}

StepThree(*) {
    global noticeMessage := "Starting Tower Run Loop"

    if (mainGui.Title = GUI_SETTINGS.RUNNING.WIN_TITLE)
        CheckActiveWindow()
    else
        SwitchGui(GUI_SETTINGS.RUNNING)

    CheckForPurchaseAd()
    SendToTower()

    if (mainGui.Title != GUI_SETTINGS.WAITING.WIN_TITLE)
        SwitchGui(GUI_SETTINGS.WAITING)

    result := GetTowerRunResult()
    if result.rebirthReady {
        noticeMessage := "Rebirth is ready"
        Retreat()
        
        StepFour()
    } else if result.knockedOut {
        noticeMessage := "Knocked out"
        CloseRebirthWindow()
        Sleep TIMINGS.UI_RESPONSE
        ClickAt(CLICK_COORDS.KEEP_CLIMBING_OFFER)
    
        if (feederUpgradeMethod == "single")
            Sleep TIMINGS.FEED_TIME_SINGLE
        else
            Sleep TIMINGS.FEED_TIME_DOUBLE
        
        StepThree()
    } else {
        ; Timed out looking for knockout window
        ; Move mouse off Tower icon and rerun
        Send "{Space}" 
        ClearMousePos()
        StepThree()
    }
}

StepFour() { ; rebirth is ready, just wait for rebirth button to be available
    startTime := A_TickCount
    buttonReady := false

    while (A_TickCount - startTime < TIMINGS.TIMEOUTS.KNOCKED_OUT_POPUP) {
        if CheckRebirthButton() {
           buttonReady := true
           break
        }

        if CheckForHiddenKnockout() {
            CloseRebirthWindow()
            Sleep TIMINGS.UI_RESPONSE

            ClickAt(CLICK_COORDS.KEEP_CLIMBING_OFFER)
            Sleep TIMINGS.UI_RESPONSE

            ClickAt(CLICK_COORDS.REBIRTH_ICON)
            Sleep TIMINGS.UI_RESPONSE
        }

        sleep 100 ; sleep hard code
    }

    if buttonReady {
        if TryRebirth()
            StepOne()
        else
            StepOne()
            ; MsgBox "could not click button?"
    } else {
            CloseRebirthWindow()
            Sleep TIMINGS.UI_RESPONSE
            ClickAt(CLICK_COORDS.KEEP_CLIMBING_OFFER)
            Sleep TIMINGS.UI_RESPONSE
            ClickAt(CLICK_COORDS.REBIRTH_ICON)
            StepFour()
    }
}


SendToTower() {
    ClickAt(CLICK_COORDS.TOWER_ICON)
    Sleep TIMINGS.UI_RESPONSE

    s := SEARCH_COORDS.SKIP_TO_FRONTIER
    c := COLORS.SKIP_TO_FRONTIER
    if PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, c.HEX, c.VAR) {
        ClickAt(CLICK_COORDS.TOWER_SKIP_TO_FRONTIER)
        return
    }

    s := SEARCH_COORDS.SKIP_TO_WARMUP
    c := COLORS.SKIP_TO_WARMUP
    if PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, c.HEX, c.VAR) {
        ClickAt(CLICK_COORDS.TOWER_SKIP_TO_WARMUP)
        return
    }

    ; ClickAt(CLICK_COORDS.TOWER_START_FROM_BOTTOM)
    ; Disabled for now, need to do pixel search so it doesn't click not enough cash purchase
}

Retreat() {
    ClickAt(CLICK_COORDS.TOWER_ICON)
    Sleep TIMINGS.RETREAT_WAIT
}

UpgradeFeedersTurn() {
    MovePlayer("Right", 0.5)

    CheckActiveWindow()
    Send "e"

    MovePlayer("Left", 0.5)

    CheckActiveWindow()
    Send "e"
}

UpgradeFeedersStrafe() {
    MovePlayer("d", 1)

    CheckActiveWindow()
    Send "e"
    Sleep TIMINGS.FEEDER_UPGRADE_DELAY

    CheckActiveWindow()
    Send "e"

    MovePlayer("a", 1)

    CheckActiveWindow()
    Send "e"
    Sleep TIMINGS.FEEDER_UPGRADE_DELAY

    CheckActiveWindow()
    Send "e"
}

UpgradeFeeder(count) {
    global noticeMessage := "Upgrading feeders"

    if (mainGui.Title != GUI_SETTINGS.RUNNING.WIN_TITLE) {
        SwitchGui(GUI_SETTINGS.RUNNING)
        returnState := GUI_SETTINGS.IDLE
    } else 
        returnState := GUI_SETTINGS.RUNNING

    Loop count {
        CheckActiveWindow()
        Send "{e}"

        if (A_Index < count)
            Sleep TIMINGS.FEEDER_UPGRADE_DELAY
    }

    SwitchGui(returnState)
}

TryRebirth() { ; click rebirth until it works
    startTime := A_TickCount
    while (A_TickCount - startTime < TIMINGS.TIMEOUTS.TRY_REBIRTH)
    {
        CheckForPurchaseAd() ; do not confuse with purchase offer

        ClickAt(CLICK_COORDS.REBIRTH_BUTTON)

        if !CheckRebirthButton()
           return true
 
        sleep 1000 ; sleep hard code
    }

    return false
}

CheckRebirth(*) {
    ClickAt(CLICK_COORDS.REBIRTH_ICON)
    Sleep TIMINGS.UI_RESPONSE

    startTime := A_TickCount
    rebirthReady := false

    while (A_TickCount - startTime < TIMINGS.TIMEOUTS.KNOCKED_OUT_POPUP) {
        if CheckRebirthButton() {
            rebirthReady := true
            break
        }
        if CheckNotYetButton() {
            rebirthReady := false
            break
        }
        sleep 50 ; sleep hard code
    }

    if rebirthReady {
        if TryRebirth() {
            StepOne()
        }
    } else {
        StepThree()
    }
}

CloseRebirthWindow() {
    ClickAt(CLICK_COORDS.REBIRTH_WINDOW_CLOSE)
    ; Sleep 500 ; sleep hard code
    ; ClickAt(CLICK_COORDS.REBIRTH_WINDOW_CLOSE)
    ; add search to confirm it is closed
}

GetTowerRunResult() { ; watch for tower floor progress bar completion or hidden knockedout window
    ClickAt(CLICK_COORDS.REBIRTH_ICON)

    if (mainGui.Title != GUI_SETTINGS.WAITING.WIN_TITLE)
        SwitchGui(GUI_SETTINGS.WAITING)   

    startTime := A_TickCount
    rebirthReady := false
    knockedOut := false

    while (A_TickCount - startTime < TIMINGS.TIMEOUTS.TOWER_RUN_LOOPED) {
        if CheckRebirthBar() {
            rebirthReady := true
            break
        }
        if CheckForHiddenKnockout() {
            knockedOut := true
            break
        }
    }

    return {
        knockedOut: knockedOut,
        rebirthReady: rebirthReady
    }
}


; =====================================================================
; UFO EVENT
; =====================================================================

CheckInterval() {
    global countdownLabel

    static LastTriggeredInterval := -1
    
    currentUnix := GetCurrentUnixTime()
    elapsedSeconds := currentUnix - 1788548400
    
    if (elapsedSeconds < 0) {
        if IsSet(countdownLabel)
            countdownLabel.Text := CreateStatusLabel("🛸 Pending")
        return 
    }
    
    intervalSeconds := 40 * 60
    currentInterval := Floor(elapsedSeconds / intervalSeconds)
    
    nextMarkSeconds := (currentInterval + 1) * intervalSeconds
    timeUntilNextMark := nextMarkSeconds - elapsedSeconds
    
    ; Calculate if we are within 3 minutes (180s) of the most recent interval mark
    lastMarkSeconds := currentInterval * intervalSeconds
    secondsSinceLastMark := elapsedSeconds - lastMarkSeconds
    
    if (secondsSinceLastMark <= 180) {
        if IsSet(countdownLabel)
            countdownLabel.Text := CreateStatusLabel("🛸 RIGHT NOW!")
    } else if IsSet(countdownLabel) {
        ; Standard countdown if event isn't running
        mins := Floor(timeUntilNextMark / 60)
        secs := Mod(timeUntilNextMark, 60)
        countdownLabel.Text := CreateStatusLabel("🛸 in " . Format("{:02d}:{:02d}", mins, secs))
    }
    ; --------------------------------------------

    if (timeUntilNextMark <= 60 && timeUntilNextMark > 0 && currentInterval > LastTriggeredInterval && ufoNotifications) {
        TrayTip("UFO Event", "Starts in the next minute!")
        LastTriggeredInterval := currentInterval
    }
}


; =====================================================================
; ANTI-AFK
; =====================================================================

AntiAfk(*) {
    global antiAfkToggle := !antiAfkToggle
    global countdownLabel
    countdownLabel.Text := CreateStatusLabel()
    
    if antiAfkToggle {
        SetTimer(Jump, TIMINGS.ANTI_AFK_INTERVAL)
        TrayTip("Anti-AFK", "Enabled")
    } else {
        SetTimer(Jump, 0)
        TrayTip("Anti-AFK", "Disabled")
    }
}

Jump() {
    if WinExist("ahk_exe RobloxPlayerBeta.exe") {
        WinActivate("ahk_exe RobloxPlayerBeta.exe")

        try WinWaitActive("ahk_exe RobloxPlayerBeta.exe", , 2)

        Send "{Space}"
        ClickAt(589, 467)
    }
}
