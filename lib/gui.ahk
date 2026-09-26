#Requires AutoHotkey v2.0


InitializeGui() {
    global GUI_X, GUI_Y, hotkeyReroll

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

    if SETTINGS.EVENT_COUNTDOWN_ENABLED {
        mainGui.SetFont("Q5 cWhite s9 W400", "Segoe UI")
        global countdownLabel := mainGui.AddText("x" marginX " y+12 w" contentWidth " right", CreateStatusLabel())
    }

    mainGui.OnEvent("Close", CloseGui)

    if (GUI_X == "" || GUI_Y == "") {
        mainGui.Show("Center") 
    } else {
        mainGui.Show("x" . GUI_X . " y" . GUI_Y)
    }
}

SwitchGui(guiSetting) {
    global mainGui, headerLabel, statusLabel, buttonRebirth, buttonArena, buttonSettings, buttonCancel, buttonBattle, buttonReroll, buttonBack, countdownLabel

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

    if IsSet(countdownLabel) {
        if (guiSetting.HasOwnProp("COUNTDOWN_FONT_STYLE"))
            countdownLabel.SetFont(guiSetting.COUNTDOWN_FONT_STYLE, guiSetting.COUNTDOWN_FONT_FACE)
        else
            countdownLabel.SetFont(GUI_SETTINGS.RUNNING.COUNTDOWN_FONT_STYLE, GUI_SETTINGS.RUNNING.COUNTDOWN_FONT_FACE)
    }

}

ShowSettingsGui(*) {
    global mainGui

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
        if (val == SETTINGS.feederUpgradeMethod) {
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
    initialFeedTimeInput := settingsGui.AddEdit("x+10 yp-5 w" inputW, SETTINGS.initialFeedTime)

    settingsGui.SetFont("Q5 c000000 s8 W400", "Segoe UI")
    settingsGui.AddText("x10 y+0", "Allows time for feeding before first run")
    settingsGui.AddText("x10 y+5", "Set 2 for one feeding, 16 for two feedings")


    ; Initial Recall
    settingsGui.SetFont("Q5 c000000 s10 W800", "Segoe UI")
    settingsGui.AddText("x10 y+20 w" titleW, "Initial Recall Time (s):")

    settingsGui.SetFont("Q5 c000000 s10 W400", "Segoe UI")
    initialRetreatTimeInput := settingsGui.AddEdit("x+10 yp-5 w" inputW, SETTINGS.initialRetreatTime)

    settingsGui.SetFont("Q5 c000000 s8 W400", "Segoe UI")
    settingsGui.AddText("x10 y+0", "Retreat after X seconds on initial run")
    

    ; Event Countdown
    settingsGui.SetFont("Q5 c000000 s10 W800", "Segoe UI")
    settingsGui.AddText("x10 y+20 w" titleW, "Event Countdown:")

    twoButtonWidth := (settingsW - (10 * 3)) // 2

    settingsGui.SetFont("Q5 c000000 s8 W400", "Segoe UI")
    
    goldenGooseCountdownInput := settingsGui.Add("CheckBox", "x10 y+5 w" twoButtonWidth " " (SETTINGS.EVENT_COUNTDOWN.goldenGoose ? "Checked" : ""), "Golden Goose")
    hotEggCountdownInput := settingsGui.Add("CheckBox",      "x+10    w" twoButtonWidth " " (SETTINGS.EVENT_COUNTDOWN.hotEgg ? "Checked" : ""), "Hot Egg")
    ufoInvasionCountdownInput := settingsGui.Add("CheckBox", "x10 y+5 w" twoButtonWidth " " (SETTINGS.EVENT_COUNTDOWN.ufoInvasion ? "Checked" : ""), "UFO Invasion")
    chickenBossCountdownInput := settingsGui.Add("CheckBox", "x+10    w" twoButtonWidth " " (SETTINGS.EVENT_COUNTDOWN.chickenBoss ? "Checked" : ""), "Chicken Boss")


    ; Event Notifications
    settingsGui.SetFont("Q5 c000000 s10 W800", "Segoe UI")
    settingsGui.AddText("x10 y+20 w" titleW, "Event Notifications")
    
    twoButtonWidth := (settingsW - (10 * 3)) // 2

    settingsGui.SetFont("Q5 c000000 s10 W400", "Segoe UI")

    goldenGooseNotificationsInput := settingsGui.Add("CheckBox", "x10 y+5 w" twoButtonWidth " " (SETTINGS.notify.goldenGoose ? "Checked" : ""), "Golden Goose")
    hotEggNotificationsInput := settingsGui.Add("CheckBox",      "x+10    w" twoButtonWidth " " (SETTINGS.notify.hotEgg ? "Checked" : ""), "Hot Egg")
    ufoInvasionNotificationsInput := settingsGui.Add("CheckBox", "x10 y+5 w" twoButtonWidth " " (SETTINGS.notify.ufoInvasion ? "Checked" : ""), "UFO Invasion")
    chickenBossNotificationsInput := settingsGui.Add("CheckBox", "x+10     w" twoButtonWidth " " (SETTINGS.notify.chickenBoss ? "Checked" : ""), "Chicken Boss")

    ; Save Button
    btnSave := settingsGui.AddButton("w150 h30 x" (settingsW // 2) - (150 // 2) " y+20 Default", "Save")

    settingsCtrls := {
        feederUpgradeMethod: feederUpgradeMethodInput,
        initialFeedTime:     initialFeedTimeInput,
        initialRetreatTime:  initialRetreatTimeInput,
        EVENT_COUNTDOWN: {
            goldenGoose: goldenGooseCountdownInput,
            hotEgg:      hotEggCountdownInput,
            ufoInvasion: ufoInvasionCountdownInput,
            chickenBoss: chickenBossCountdownInput
        },
        notify: {
            goldenGoose: goldenGooseNotificationsInput,
            hotEgg:      hotEggNotificationsInput,
            ufoInvasion: ufoInvasionNotificationsInput,
            chickenBoss: chickenBossNotificationsInput
        }
    }

    btnSave.OnEvent("Click", SaveSettingsGui.Bind(settingsCtrls))

    ; Set coords and show GUI
    mainGui.GetPos(&mainX, &mainY)
    mainGui.GetClientPos(, , &mainW, &mainH)

    settingsGui.Show("x" CalcXForCenter(mainX, mainW, settingsW) " y" mainY + 35 " w" settingsW)
}

SaveSettingsGui(ctrls, *) {
    global mainGui, settingsGui

    oldCountdownSettings := SETTINGS.EVENT_COUNTDOWN

    ; controls → Settings
    SETTINGS.feederUpgradeMethod := ctrls.feederUpgradeMethod.Text
    SETTINGS.initialFeedTime     := Integer(ctrls.initialFeedTime.Value)
    SETTINGS.initialRetreatTime  := Integer(ctrls.initialRetreatTime.Value)

    for key in DEFAULT_SETTINGS.EVENT_COUNTDOWN.OwnProps()
        SETTINGS.EVENT_COUNTDOWN.%key% := Integer(ctrls.EVENT_COUNTDOWN.%key%.Value)

    for key in DEFAULT_SETTINGS.notify.OwnProps()
        SETTINGS.notify.%key% := Integer(ctrls.notify.%key%.Value)

    ; Settings → INI
    SaveSettings()

    ; Rebuild main GUI only if countdown visibility changed
    if (SETTINGS.EVENT_COUNTDOWN != oldCountdownSettings) {
        SaveWindowPosition()
        mainGui.Destroy()
        InitializeGui()
    }

    settingsGui.Destroy()
}

ShowRebirthGui(*) {
    global mainGui

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
    global mainGui

    global selectionGui := Gui("+AlwaysOnTop", " ")

    buttonAssist := selectionGui.Add("Button", "x15 y+5 w150 h30", "Assist")
    buttonAssist.OnEvent("Click", SelectOption.Bind(StartArenaAssist))

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
    global mainGui

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
    global selectionGui

    selectionGui.Destroy()
    ActivateRoblox()
    clickedFunction()
}

UpgradeOption(count, *) {
    global feederUpgradeGui

    feederUpgradeGui.Destroy()
    ActivateRoblox()
    UpgradeFeeder(count)
}

ReloadScript(*) {
    SaveWindowPosition()
    Reload()
}

CloseGui(*) {
    SaveWindowPosition()
    ExitApp()
}

CalcXForCenter(mainX, mainW, newW) {
    return (mainW - newW) // 2 + mainX
}

CreateStatusLabel(countdown := "Calculating...") {
    global statusLabelText := ""

    if (SETTINGS.EVENT_COUNTDOWN_ENABLED == 1)
        statusLabelText := statusLabelText countdown

    return statusLabelText
}

guiStateCheck(guiName) {
    if mainGui.Title == GUI_SETTINGS.IDLE.WIN_TITLE
        returnState := GUI_SETTINGS.IDLE
    else if mainGui.Title == GUI_SETTINGS.RUNNING.WIN_TITLE
        returnState := GUI_SETTINGS.RUNNING
    else if mainGui.Title == GUI_SETTINGS.WAITING.WIN_TITLE
        returnState := GUI_SETTINGS.WAITING
    else if mainGui.Title == GUI_SETTINGS.INTERRUPTED.WIN_TITLE
        returnState := GUI_SETTINGS.INTERRUPTED
    else if mainGui.Title == GUI_SETTINGS.ARENA.WIN_TITLE
        returnState := GUI_SETTINGS.ARENA
    else
        MsgBox "Current gui state unknown"

    if (mainGui.Title != guiName.WIN_TITLE)
        SwitchGui(guiName)
    
    if (guiName.WIN_TITLE == GUI_SETTINGS.RUNNING.WIN_TITLE)
        CheckActiveWindow()

    return returnState
}

SaveWindowPosition() {
    global GUI_X, GUI_Y, mainGui

    WinGetPos(&x, &y, , , mainGui.Hwnd)
    GUI_X := x
    GUI_Y := y
    IniWrite(x, INI_FILE, "Window", "X")
    IniWrite(y, INI_FILE, "Window", "Y")
}
