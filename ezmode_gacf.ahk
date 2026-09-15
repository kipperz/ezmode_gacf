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
VERSION := "v0.5.1"


#Requires AutoHotkey v2.0
#SingleInstance Force
#Include lib/FindText.ahk
SendMode "Event"
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Screen"


; =====================================================================
; CONFIG
; =====================================================================

ROBLOX_WINDOW := "ahk_exe RobloxPlayerBeta.exe"
INI_FILE := "ezmode_gacf.ini"
GUI_TITLE := "EZ Mode"

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

CLICK_COORDS := {
    TOWER_ICON:              {X: 375 + 44 // 2, Y: 530 + 60 // 2, W: 44, H: 60},
    TOWER_SKIP_TO_FRONTIER:  {X: 459 + 88 // 2, Y: 288 + 32 // 2, W: 88, H: 32},
    TOWER_SKIP_TO_WARMUP:    {X: 459 + 88 // 2, Y: 227 + 32 // 2, W: 88, H: 32},
    TOWER_START_FROM_BOTTOM: {X: 356 + 88 // 2, Y: 396 + 32 // 2, W: 88, H: 32},
    KNOCKED_OUT_NO_THANKS:   {X: 356 + 88 // 2, Y: 428 + 24 // 2, W: 88, H: 24},
    REBIRTH_ICON:            {X: 734 + 54 // 2, Y: 243 + 48 // 2, W: 54, H: 48},
    REBIRTH_WINDOW_CLOSE:    {X: 588 + 30 // 2, Y: 50 + 30 // 2,  W: 30, H: 30},
    REBIRTH_BUTTON:          {X: 356 + 88 // 2, Y: 415 + 40 // 2, W: 88, H: 40},
    PURCHASE_AD:             {X: 562 + 40 // 2, Y: 309 + 44 // 2, W: 24, H: 24},
    ARENA_ICON:              {X: 55 + 40 // 2,  Y: 372 + 44 // 2, W: 40, H: 44},
    GO_TO_BATTLE:            {X: 356 + 88 // 2, Y: 396 + 24 // 2, W: 88, H: 24},
    EXIT_ARENA:              {X: 66, Y: 55},
    ARENA_BACK:              {X: 620 + 44 // 2, Y: 152 + 24 // 2, W: 44, H: 24},
    EDIT_TEAM:               {X: 592 + 44 // 2, Y: 234 + 16 // 2, W: 44, H: 16},
    SAVE_TEAM:               {X: 430 + 88 // 2, Y: 398 + 24 // 2, W: 88, H: 24},
}

PIXEL_SEARCH := {
    ; KNOCKOUT_WINDOW:  {HEX: 0xf21b22, VAR: 20, X1: 555, Y1: 152, X2: 560, Y2: 157},
    HIDDEN_KNOCKOUT:  {HEX: 0x05320a, VAR: 5,  X1: 138, Y1: 470, X2: 148, Y2: 480},
    REBIRTH_BAR:      {HEX: 0x14cc28, VAR: 5,  X1: 532, Y1: 186, X2: 537, Y2: 191},
    REBIRTH_BUTTON:   {HEX: 0x2fba3e, VAR: 20, X1: 315, Y1: 436, X2: 320, Y2: 441},
    NOT_YET_BUTTON:   {HEX: 0xab7a49, VAR: 20, X1: 315, Y1: 436, X2: 320, Y2: 441}, ; need update
    PURCHASE_AD:      {HEX: 0xffffff, VAR: 10, X1: 767, Y1: 380, X2: 772, Y2: 385},
    SKIP_TO_FRONTIER: {HEX: 0xcfa639, VAR: 10, X1: 453, Y1: 303, X2: 458, Y2: 308},
    SKIP_TO_WARMUP:   {HEX: 0xcdae20, VAR: 10, X1: 451, Y1: 244, X2: 456, Y2: 249},
    VICTORY_SCREEN:   {HEX: 0x1ab2fe, VAR: 5, X1: 698, Y1: 499, X2: 708, Y2: 509}, ; need update
    DEFEAT_SCREEN:    {HEX: 0x1ab2fe, VAR: 5, X1: 698, Y1: 475, X2: 708, Y2: 485}, ; need update
}

TIMINGS := {
    TOWER_ENTRY_WAIT:      3500,
    FEEDER_UPGRADE_DELAY:  175,
    RETREAT_WAIT:          4500,
    UI_RESPONSE:           50,
    FEED_TIME_SINGLE:      6000,   ; milliseconds for feeding with one upgraded feeder
    FEED_TIME_DOUBLE:      12000,  ; milliseconds for feeding with two upgraded feeders
    TIMEOUTS: { ; ms
        TRY_REBIRTH:       20000,
        TOWER_RUN_INITIAL: 120000,
        TOWER_RUN_LOOPED:  180000,
        KNOCKED_OUT_POPUP: 10000,
    }
}

EVENTS := [
    {name: "ANCIENT EGG",   offset: 0},
    {name: "GOLDEN GOOSE",  offset: 600},
    {name: "HOT EGG",       offset: 1200},
    {name: "UFO INVASION",  offset: 1800},
    {name: "CHICKEN BOSS",  offset: 2400}
]

hotkeyGotoBattle := "F7"
hotkeyReroll := "F8"
noticeMessage := ""
ROBLOX_AUTOMATION_WIDTH := 800
ROBLOX_AUTOMATION_HEIGHT := 600


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

    eventCountdown := IniRead(INI_FILE, "Settings", "eventCountdown", 1)

    ancientEggNotifications := IniRead(INI_FILE, "Notifications", "ancientEgg", 1)
    goldenGooseNotifications := IniRead(INI_FILE, "Notifications", "goldenGoose", 0)
    hotEggNotifications := IniRead(INI_FILE, "Notifications", "hotEgg", 0)
    ufoInvasionNotifications := IniRead(INI_FILE, "Notifications", "ufoInvasion", 1)
    chickenBossNotifications := IniRead(INI_FILE, "Notifications", "chickenBoss", 0)
}

LoadNotificationSettings() {
    global EVENTS
    EVENTS[1].notify := ancientEggNotifications
    EVENTS[2].notify := goldenGooseNotifications
    EVENTS[3].notify := hotEggNotifications
    EVENTS[4].notify := ufoInvasionNotifications
    EVENTS[5].notify := chickenBossNotifications
}

SaveSettings() {
    IniWrite(initialFeedTime, INI_FILE, "Settings", "initialFeedTime")
    IniWrite(initialRetreatTime, INI_FILE, "Settings", "initialRetreatTime")
    IniWrite(feederUpgradeMethod, INI_FILE, "Settings", "feederUpgradeMethod")
    IniWrite(eventCountdown, INI_FILE, "Settings", "eventCountdown")
    IniWrite(ancientEggNotifications, INI_FILE, "Notifications", "ancientEgg")
    IniWrite(goldenGooseNotifications, INI_FILE, "Notifications", "goldenGoose")
    IniWrite(hotEggNotifications, INI_FILE, "Notifications", "hotEgg")
    IniWrite(ufoInvasionNotifications, INI_FILE, "Notifications", "ufoInvasion")
    IniWrite(chickenBossNotifications, INI_FILE, "Notifications", "chickenBoss")

    LoadNotificationSettings()
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
Hotkey(hotkeyGotoBattle, GoToBattleMatchup, "Off")
Hotkey(hotkeyReroll, RerollMatch, "Off")


; =====================================================================
; INITIALIZATION
; =====================================================================

if !WinExist(ROBLOX_WINDOW) {
    MsgBox "Please start Roblox first."
    ExitApp
}

LoadSettings()
SaveSettings()
LoadNotificationSettings()

; SetTimer(CheckInterval, 1000)

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

    mainGui.SetFont(GUI_SETTINGS.IDLE.STATUS_LABEL_FONT_STYLE, GUI_SETTINGS.IDLE.STATUS_LABEL_FONT_FACE)
    global statusLabel := mainGui.AddText("x" marginX " y+12 w" contentWidth " Center", GUI_SETTINGS.IDLE.STATUS_LABEL)

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
    buttonBattle.OnEvent("Click", GoToBattleMatchup)
    buttonBattle.Visible := false

    global buttonReroll := mainGui.AddButton("x+10 w" threeButtonWidth, "Reroll (" hotkeyReroll ")")
    buttonReroll.OnEvent("Click", RerollMatch)
    buttonReroll.Visible := false
    
    global buttonBack := mainGui.AddButton("x+" marginX " w30", "↩️")
    buttonBack.OnEvent("Click", ArenaBackToIdle)
    buttonBack.Visible := false

    global countdownLabel := ""
    if eventCountdown == 1 {
        mainGui.SetFont("Q5 cWhite s9 W400", "Segoe UI")
        countdownLabel := mainGui.AddText("x" marginX " y+12 w" contentWidth " right", CreateStatusLabel())
    }

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
    

    ; Event Countdown
    settingsGui.SetFont("Q5 c000000 s10 W800", "Segoe UI")
    settingsGui.AddText("x10 y+20 w" titleW, "Event Countdown:")

    settingsGui.SetFont("Q5 c000000 s8 W400", "Segoe UI")
    
    eventCountdownOptions := ["On", "Off"]
    eventCountdownInput := settingsGui.AddDropDownList("x+10 yp-3 w" inputW " Choose" eventCountdown, eventCountdownOptions)


    ; Event Notifications
    settingsGui.SetFont("Q5 c000000 s10 W800", "Segoe UI")
    settingsGui.AddText("x10 y+20 w" titleW, "Event Notifications")
    
    twoButtonWidth := (settingsW - (10 * 3)) // 2

    settingsGui.SetFont("Q5 c000000 s10 W400", "Segoe UI")

    ancientEggNotificationsInput := settingsGui.Add("CheckBox", "x10 y+5 w" twoButtonWidth " " (ancientEggNotifications == 1 ? "Checked" : ""), "Ancient Egg")
    goldenGooseNotificationsInput := settingsGui.Add("CheckBox", "x+10 " (goldenGooseNotifications == 1 ? "Checked" : ""), "Golden Goose")
    hotEggNotificationsInput := settingsGui.Add("CheckBox", "x10 y+5 w" twoButtonWidth " " (hotEggNotifications == 1 ? "Checked" : ""), "Hot Egg")
    ufoInvasionNotificationsInput := settingsGui.Add("CheckBox", "x+10 " (ufoInvasionNotifications == 1 ? "Checked" : ""), "UFO Invasion")
    chickenBossNotificationsInput := settingsGui.Add("CheckBox", "x10 y+5 w" twoButtonWidth " " (chickenBossNotifications == 1 ? "Checked" : ""), "Chicken Boss")


    ; Save Button
    btnSave := settingsGui.AddButton("w150 h30 x" (settingsW // 2) - (150 // 2) " y+20 Default", "Save")

    btnSave.OnEvent(
        "Click",
        SaveSettingsGui.Bind(
            feederUpgradeMethodInput,
            initialFeedTimeInput,
            initialRetreatTimeInput,
            eventCountdownInput,
            ancientEggNotificationsInput,
            goldenGooseNotificationsInput,
            hotEggNotificationsInput,
            ufoInvasionNotificationsInput,
            chickenBossNotificationsInput
        )
    )
    
    ; Set coords and show GUI
    mainGui.GetPos(&mainX, &mainY)
    mainGui.GetClientPos(, , &mainW, &mainH)
    
    settingsGui.Show("x" CalcXForCenter(mainX, mainW, settingsW) " y" mainY + 35 " w" settingsW)
}

SaveSettingsGui(feederUpgradeMethodInput, initialFeedTimeInput, initialRetreatTimeInput, eventCountdownInput, ancientEggNotificationsInput, goldenGooseNotificationsInput, hotEggNotificationsInput, ufoInvasionNotificationsInput, chickenBossNotificationsInput, *) {
    global 
    
    feederUpgradeMethod := feederUpgradeMethodInput.Text
    initialFeedTime := initialFeedTimeInput.Value
    initialRetreatTime := initialRetreatTimeInput.Value
    eventCountdown := eventCountdownInput.Value

    ancientEggNotifications := ancientEggNotificationsInput.Value
    goldenGooseNotifications := goldenGooseNotificationsInput.Value
    hotEggNotifications := hotEggNotificationsInput.Value
    ufoInvasionNotifications := ufoInvasionNotificationsInput.Value
    chickenBossNotifications := chickenBossNotificationsInput.Value

    SaveSettings()
    settingsGui.Destroy()

    ReloadScript()
}

ShowRebirthGui(*) {
    global selectionGui := Gui("+AlwaysOnTop", " ")

    buttonRunTowerUpgrades := selectionGui.Add("Button", "x15 y10 w150 h30", "Start")
    buttonRunTowerUpgrades.OnEvent("Click", SelectOption.Bind(StartRebirthAutomation))

    buttonRunTower := selectionGui.Add("Button", "x15 y+5 w150 h30", "Continue")
    buttonRunTower.OnEvent("Click", SelectOption.Bind(ContinueRebirthAutomation))

    buttonUpgradeFeeders := selectionGui.Add("Button", "x15 y+5 w150 h30", "Upgrade Feeder(s)")
    buttonUpgradeFeeders.OnEvent("Click", SelectOption.Bind(ShowFeederUpgradeGui))

    mainGui.GetPos(&mainX, &mainY)
    mainGui.GetClientPos(, , &mainW, &mainH)

    selectionW := 180
    selectionGui.Show("x" CalcXForCenter(mainX, mainW, selectionW) " y" mainY + 35 " w" selectionW)
}

ShowArenaGui(*) {
    global selectionGui := Gui("+AlwaysOnTop", " ")

    buttonAssist := selectionGui.Add("Button", "x15 y+5 w150 h30", "Assist")
    buttonAssist.OnEvent("Click", SelectOption.Bind(StartArenaAssit))

    buttonAuto := selectionGui.Add("Button", "x15 y+5 w150 h30", "Auto")
    buttonAuto.OnEvent("Click", SelectOption.Bind(StartArenaAutomation))

    ; buttonDerank := selectionGui.Add("Button", "x15 y+5 w150 h30", "Derank")
    ; buttonDerank.OnEvent("Click", SelectOption.Bind(Derank))

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

CreateStatusLabel(countdown := "Calculating...") {
    global statusLabelText := ""

    if (eventCountdown == 1)
        statusLabelText := statusLabelText countdown

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

ClickAt(objectOrTargetX, y := 0, speed := 5, clickDelayMs := 100, variationX := 5, variationY := 5) {
    if IsObject(objectOrTargetX) && objectOrTargetX.HasProp("X") {
        targetX := objectOrTargetX.X
        targetY := objectOrTargetX.Y
    } else {
        targetX := objectOrTargetX
        targetY := y
    }

    if variationX
        targetX += Random(0, variationX)

    if variationY
        targetY += Random(0, variationY)

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

ResizeClient(x := unset, y := unset, desiredClientW := ROBLOX_AUTOMATION_WIDTH, desiredClientH := ROBLOX_AUTOMATION_HEIGHT, winTitle := ROBLOX_WINDOW) {
    if !hwnd := WinExist(winTitle)
        return false

    WinGetPos(&winX, &winY, &winW, &winH, hwnd)
    WinGetClientPos(, , &clientW, &clientH, hwnd)

    borderW := winW - clientW
    borderH := winH - clientH

    newWinW := desiredClientW + borderW
    newWinH := desiredClientH + borderH

    if (IsSet(x) && IsSet(y))
        WinMove(x, y, newWinW, newWinH, hwnd)
    if (IsSet(x) && !IsSet(y))
        WinMove(x, , newWinW, newWinH, hwnd)
    if (!IsSet(x) && IsSet(y))
        WinMove(, y, newWinW, newWinH, hwnd)
    else
        WinMove(, , newWinW, newWinH, hwnd)
    
    return true
}

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
        "*1 " location
    )
        return {x: foundX, y: foundY}
}

ClearMousePos(dist := 50) {
    MouseMove dist, dist, 0, "R"
}

GetCurrentUnixTime() {
    return DateDiff(A_NowUTC, "19700101000000", "Seconds")
}

CheckWindowSizeForAutomation() {
    WinGetClientPos(&clientX, &clientY, &clientW, &clientH, ROBLOX_WINDOW)
    if (clientW != ROBLOX_AUTOMATION_WIDTH || clientH != ROBLOX_AUTOMATION_HEIGHT)
        return {
            clientX: clientX,
            clientY: clientY,
            clientW: clientW,
            clientH: clientH
        }
}

SetWindowSizeForAutomation(clientPos) {
    result := MsgBox("The Roblox window will be resized for this automation`n`nWould you like to continue?" , "NOTICE", "YesNo T120 Iconi 0x40000")
    if (result == "No")
        return false

    ; WINDOW SIZE LOGIC
    WinGetPos(&windowX, &windowY, &windowW, &windowH, ROBLOX_WINDOW)

    clientX := clientPos.clientX
    clientY := clientPos.clientY
    clientW := clientPos.clientW
    clientH := clientPos.clientH

    decorationsW := windowW - clientW
    decorationsH := windowH - clientH

    newW := ROBLOX_AUTOMATION_WIDTH + decorationsW
    newH := ROBLOX_AUTOMATION_HEIGHT + decorationsH


    ; LOCATION LOGIC
    MonitorGetWorkArea(, &workAreaLeft, &workAreaTop, &workAreaRight, &workAreaBottom)
    
    newX := windowX
    newY := windowY

    ; Check if resizing would push window off the RIGHT edge
    if (windowX + newW > workAreaRight) {
        newX := workAreaRight - newW
    }

    ; Check if resizing would push window off the BOTTOM edge
    if (windowY + newW > workAreaBottom) {
        newY := workAreaBottom - newW
    }

    ; Ensure NewX/NewY aren't off the LEFT or TOP (prevent negative coordinates)
    if (newX < workAreaLeft)
        newX := workAreaLeft
    if (newY < workAreaTop)
        newY := workAreaTop


    ; Apply the movement and resize
    WinMove(newX, newY, newW, newH, ROBLOX_WINDOW)

    Sleep 1000

    return true
}


; =====================================================================
; GAME STATE
; =====================================================================

CheckForKnockout() {
    ; s := PIXEL_SEARCH.KNOCKOUT_WINDOW
    ; return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, s.HEX, s.VAR)    

    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 340
    searchY1 := robloxY + 115
    searchX2 := robloxX + 463
    searchY2 := robloxY + 159

    Text := "|<>*1$98.s0000yTzk01s00zzi00007zzw00000DzzU0000zsD000003kTs0000Ds0s00001k1y00001w0600000M0DU0800T01k0000C03s02003U0S0000700y00k00s03k0001k07U0S00600y0000w01s07U00U0Dk000T00S01w00807y000Tk0DU0TU0101zs00Ty03U"
    if FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0, 0, Text) {
        return true
    }
}

CheckForRebirthWindow() {
    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 209
    searchY1 := robloxY + 52
    searchX2 := robloxX + 339
    searchY2 := robloxY + 89

    Text:="|<>*1$110.k000C003k000w06000A0003U00w000701U0030001s07z0000k0M000k000q07zk0s0406000A000RU1zw0D0101U0030003M00303U0E0M000k0k0y000k0k000C060A0A07U00A000003U1U303U1s003000000s0Q0k0s0C000k00040C070A0C01U00A000103U1k203k0M0030000k0k0S0U0w02000k000A0A07U8"
    if FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0, 0, Text) {
        return true
    } else {
        return false
    }
}

CheckForHiddenKnockout() {
    s := PIXEL_SEARCH.HIDDEN_KNOCKOUT
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, s.HEX, s.VAR)
}

CheckRebirthBar() {
    s := PIXEL_SEARCH.REBIRTH_BAR
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, s.HEX, s.VAR)
}

CheckRebirthButton() {
    s := PIXEL_SEARCH.REBIRTH_BUTTON
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, s.HEX, s.VAR)
}

CheckNotYetButton() {
    s := PIXEL_SEARCH.NOT_YET_BUTTON
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, s.HEX, s.VAR)
}

CheckForPurchaseAd() {
    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 552
    searchY1 := robloxY + 296
    searchX2 := robloxX + 600
    searchY2 := robloxY + 349

    Text := "|<>**1$15.zzzDU0w070UsA21k0T07s0zUDw1zUDs0y07k0Q23Us8711w6DXzzw"
    if FindText(&x, &y, searchX1, searchY1, searchX2, searchY2, 0, 0, Text) {
        ClickAt(CLICK_COORDS.PURCHASE_AD)
    }
}

CheckForArenaWindow() {
    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 149
    searchY1 := robloxY + 152
    searchX2 := robloxX + 241
    searchY2 := robloxY + 189

    Text:="|<>*1$77.00003008300000008600k60000000E601UA0000A00UA030M00k8"
    if FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0, 0, Text) {
        return true
    } else {
        return false
    }
}

CheckForVictoryScreen() {
    s := PIXEL_SEARCH.VICTORY_SCREEN
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, s.HEX, s.VAR)
}

CheckForDefeatScreen() {
    s := PIXEL_SEARCH.DEFEAT_SCREEN
    return PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, s.HEX, s.VAR)
}


; =====================================================================
; ARENA
; =====================================================================

StartArenaAutomation(*) {
    result := MsgBox("Current matchmaking is broken. Auto battling will likely result in more losses than wins.`n`nWould you like to continue?" , "WARNING", "YesNo Icon! 0x40000")
    if result != "Yes"
        return

    needsResize := CheckWindowSizeForAutomation()
    if needsResize
        if (!SetWindowSizeForAutomation(needsResize))
            return

    if !OpenArenaWindow()
        return
}

StartArenaAssit(*) {
    result := MsgBox("Arena Assist allows you to go to battle and reroll your matchup with a press of a button.`n`nWould you like to continue?" , "WARNING", "YesNo Icon! 0x40000")
    if result != "Yes"
        return

    needsResize := CheckWindowSizeForAutomation()
    if needsResize
        if (!SetWindowSizeForAutomation(needsResize))
            return

    if !OpenArenaWindow()
        return

    SwitchGui(GUI_SETTINGS.ARENA)
    Hotkey(hotkeyGotoBattle, GoToBattleMatchup, "On")
    Hotkey(hotkeyReroll, RerollMatch, "On")

    ClickAt(CLICK_COORDS.GO_TO_BATTLE)
}

Derank() {
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

ArenaAuto() {
    global noticeMessage := "Auto Arena Battle"

    if (mainGui.Title != GUI_SETTINGS.RUNNING.WIN_TITLE)
        SwitchGui(GUI_SETTINGS.RUNNING)

    Loop {
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

RerollMatch(*) {
    ActivateRoblox

    ClickAt(CLICK_COORDS.ARENA_BACK)
    Sleep TIMINGS.UI_RESPONSE

    ClickAt(CLICK_COORDS.ARENA_ICON)
    Sleep TIMINGS.UI_RESPONSE

    ClickAt(CLICK_COORDS.EDIT_TEAM)
    Sleep TIMINGS.UI_RESPONSE

    ClickAt(CLICK_COORDS.SAVE_TEAM)
    Sleep TIMINGS.UI_RESPONSE

    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 389
    searchY1 := robloxY + 396
    searchX2 := robloxX + 485
    searchY2 := robloxY + 430

    Text:="|<>*1$77.00003008300000008600k60000000E601UA0000A00UA030M00k8|<>*1$64.U200E00000E0281U000010000200000400I0800000E00E0U00001000020000000080000000000U0A0q0M0E060100000100E000E080400000100U3k0000U40200000020E080000000100c000000E402U0000010E0+00000k2110c0000308040U0E67VkT0DUy2"
    if FindText(&x := "wait1", &y := "10", searchX1, searchY1, searchX2, searchY2, 0.2, 0.2, Text) {
        GoToBattle()
    } else {
        MsgBox "Could not find Go to Battle Button"
    }
}

GoToBattleMatchup(*) {
    GoToBattle()

    Sleep 20

    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 427
    searchY1 := robloxY + 470
    searchX2 := robloxX + 475
    searchY2 := robloxY + 526

    Text:="|<>**1$20.zzzwNgm6HAjVn8Mwnm7Awdn8PAnTzwzzzs|<>**1$21.zzzyAqMVYn5wCNVXnDYCMwdnABaNrzzDzzzU|<>**1$21.zzzyAqMVYn5wCNVXnDYCMwdnABaNrzzDzzzU"
    if FindText(&x := "wait1", &y := "50", searchX1, searchY1, searchX2, searchY2, 0.2, 0.2, Text) {
        GoToBattle()
    } else {
        MsgBox "Could not find victory screen"
        return
    }

    Sleep TIMINGS.UI_RESPONSE
    ClickAt(CLICK_COORDS.GO_TO_BATTLE)
}


; =====================================================================

GoToBattle() {
    ClickAt(CLICK_COORDS.GO_TO_BATTLE)
}

ArenaBackToIdle(*) {
    Hotkey(hotkeyGotoBattle, GoToBattleMatchup, "Off")
    Hotkey(hotkeyReroll, RerollMatch, "Off")
    SwitchGui(GUI_SETTINGS.IDLE)
}

OpenArenaWindow() {
    startTime := A_TickCount
    Loop {
        if CheckForArenaWindow()
            return true
        ClickAt(CLICK_COORDS.ARENA_ICON)
        Sleep TIMINGS.UI_RESPONSE
    } Until (A_TickCount - startTime > 5000)

    MsgBox "Timed out looking for Arena window"
    return false
}


; =====================================================================
; REBIRTH 
; =====================================================================

StartRebirthAutomation(*) {
    instructions := {
        single: "Stand in the back left corner of the coop, behind the feeder",
        strafe: "Stand in the back left corner of the coop, behind the feeder, facing the tower",
        turn: "Stand towards the back middle of the coop, facing the left feeder"
    }

    result := MsgBox("Upgrade Method: " feederUpgradeMethod "`n`n" instructions.%feederUpgradeMethod% "`n`n`nAre you in position?" , "Rebirth Automation", "YesNo 0x40000")
    if (result == "No")
        return

    needsResize := CheckWindowSizeForAutomation()
    if needsResize
        if (!SetWindowSizeForAutomation(needsResize))
            return

    if !OpenRebirthWindow()
        return

    if CheckRebirthButton() {
        success := TryRebirth()
        if !success
            return
    }
    else
        CloseRebirthWindow()

    StepOne()
}

ContinueRebirthAutomation(*) {
    if (needsResize := CheckWindowSizeForAutomation())
        if (!SetWindowSizeForAutomation(needsResize))
            return

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
        CloseRebirthWindow()
        StepThree()
    }
}

StepOne() {
    global noticeMessage := "Starting initial Tower run"
    if (mainGui.Title != GUI_SETTINGS.RUNNING.WIN_TITLE)
        SwitchGui(GUI_SETTINGS.RUNNING)

    UpgradeFeeder(1)

    Sleep initialFeedTime * 1000
    StepTwo()
}

StepTwo() {
    global noticeMessage := "Upgrading feeders"
    if (mainGui.Title == GUI_SETTINGS.RUNNING.WIN_TITLE)
        CheckActiveWindow()
    else
        SwitchGui(GUI_SETTINGS.RUNNING)

    SendToTower()
    Sleep TIMINGS.TOWER_ENTRY_WAIT
    
    result := GetInitialTowerRunResult()
    if result {
        if (feederUpgradeMethod == "single")
            Sleep TIMINGS.FEED_TIME_SINGLE
        else
            Sleep TIMINGS.FEED_TIME_DOUBLE
        StepThree()
    } else {
        result := MsgBox("No initial tower run results after " TIMINGS.TIMEOUTS.TOWER_RUN_INITIAL " seconds.`n`nWould you retry?" , "AutoRebirth Error", "YesNo T30 Icon! 0x40000")
        if result = "No" {
            ReloadScript()
        } else
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
    if !result
        return

    if result.rebirthReady {
        noticeMessage := "Rebirth is ready"
        CloseRebirthWindow()

        if CheckForKnockout()
            ClickAt(CLICK_COORDS.KNOCKED_OUT_NO_THANKS)
        else
            Retreat()

        StepFour()
    } else if result.knockedOut {
        noticeMessage := "Knocked out"
        CloseRebirthWindow()
        Sleep TIMINGS.UI_RESPONSE
        ClickAt(CLICK_COORDS.KNOCKED_OUT_NO_THANKS)
    
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
    if !OpenRebirthWindow()
        return

    startTime := A_TickCount
    Loop { ; wait for button to be ready
        buttonReady := CheckRebirthButton()
        if buttonReady
           break
        Sleep 50
    } Until (A_TickCount - startTime > 5000)

    if !buttonReady
        return

    success := TryRebirth()
    if !success
        return

    StepOne()
}

SendToTower() {
    ClickAt(CLICK_COORDS.TOWER_ICON)
    Sleep TIMINGS.UI_RESPONSE

    CheckForPurchaseAd()

    s := PIXEL_SEARCH.SKIP_TO_FRONTIER
    if PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, s.HEX, s.VAR) {
        ClickAt(CLICK_COORDS.TOWER_SKIP_TO_FRONTIER)
        return
    }

    s := PIXEL_SEARCH.SKIP_TO_WARMUP
    if PixelSearchRobloxClient(s.X1, s.Y1, s.X2, s.Y2, s.HEX, s.VAR) {
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

OpenRebirthWindow() {
    startTime := A_TickCount
    Loop {
        if CheckForRebirthWindow()
            return true
        ClickAt(CLICK_COORDS.REBIRTH_ICON)
        Sleep TIMINGS.UI_RESPONSE
    } Until (A_TickCount - startTime > 5000)

    MsgBox "Timed out looking for the Rebirth window"
    return false
}

CloseRebirthWindow() {
    startTime := A_TickCount
    Loop {
        ClickAt(CLICK_COORDS.REBIRTH_WINDOW_CLOSE)

        if !CheckForRebirthWindow()
            return true
        Sleep TIMINGS.UI_RESPONSE
    } Until (A_TickCount - startTime > 5000)

    MsgBox "Timed out closing the Rebirth window"
    return false
}

TryRebirth() { ; click rebirth until it works
    startTime := A_TickCount
    Loop {
        CheckForPurchaseAd() ; is this still needed?
        ClickAt(CLICK_COORDS.REBIRTH_BUTTON)

        if !CheckRebirthButton()
           return true

        Sleep 1000
    } Until (A_TickCount - startTime > TIMINGS.TIMEOUTS.TRY_REBIRTH)

    MsgBox "Timed out trying to use the Rebirth button"
    return false
}

GetInitialTowerRunResult() {
    startTime := A_TickCount
    Loop {
        CheckForPurchaseAd()

        if (initialRetreatTime && initialRetreatTime * 1000 - TIMINGS.TOWER_ENTRY_WAIT < A_TickCount - startTime){
            Retreat()
            return true
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
            ClickAt(CLICK_COORDS.KNOCKED_OUT_NO_THANKS)
            return true
        }        
    } Until (A_TickCount - startTime > TIMINGS.TIMEOUTS.TOWER_RUN_INITIAL)

    return false
}

GetTowerRunResult() { ; watch for tower floor progress bar completion or hidden knockedout window
    if (mainGui.Title != GUI_SETTINGS.WAITING.WIN_TITLE)
        SwitchGui(GUI_SETTINGS.WAITING)   

    startTime := A_TickCount
    rebirthReady := false
    knockedOut := false

    while (A_TickCount - startTime < TIMINGS.TIMEOUTS.TOWER_RUN_LOOPED) {
        if !OpenRebirthWindow()
            return

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
; EVENT COUNTDOWN & NOTIFICATIONS
; =====================================================================

global CYCLE_SECONDS := 50 * 60          ; 3000 s full cycle
global LIVE_SECONDS := 180               ; 3 minutes live
global NOTIFY_SECONDS := 60              ; notify 1 min before

EVENT_BASE := 1789229400          ; ANCIENT_EGG start

SetTimer(UpdateCountdown.Bind(countdownLabel), 1000)

UpdateCountdown(countdownLabel) {
    static CYCLE      := 3000   ; 5 events * 600s
    static SLOT       := 600    ; 10 min between event starts
    static DURATION   := 180    ; 3 min active window
    static lastWarned := -1     ; index of the event we've already warned about

    nowUnix := DateDiff(A_NowUTC, "19700101000000", "Seconds")

    elapsed := Mod(nowUnix - EVENT_BASE, CYCLE)
    if (elapsed < 0)
        elapsed += CYCLE

    currentIndex := elapsed // SLOT
    intoSlot     := Mod(elapsed, SLOT)

    currentEvent := EVENTS[currentIndex + 1]
    nextEvent    := EVENTS[Mod(currentIndex + 1, EVENTS.Length) + 1]

    if (intoSlot < DURATION) {
        ; Event is live — show remaining time on it
        remaining := DURATION - intoSlot
        mm := Format("{:02}", remaining // 60)
        ss := Format("{:02}", Mod(remaining, 60))
        countdownLabel.Text := currentEvent.name " (" mm ":" ss ")"
    } else {
        ; Waiting for next event
        remaining := SLOT - intoSlot   ; seconds until next event starts
        mm := Format("{:02}", remaining // 60)
        ss := Format("{:02}", Mod(remaining, 60))
        countdownLabel.Text := nextEvent.name " in " mm ":" ss

        ; Warn once, at the top of the final minute before the next event
        nextIndex := Mod(currentIndex + 1, EVENTS.Length)
        if (remaining <= 60 && lastWarned != nextIndex && nextEvent.notify) {
            TrayTip(nextEvent.name, "Starts in the next minute!")
            lastWarned := nextIndex
        }
    }
}