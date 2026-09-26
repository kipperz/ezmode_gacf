#Requires AutoHotkey v2.0


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

    ArenaAuto()
}

StartArenaAssist(*) {
    global hotkeyGotoBattle, hotkeyReroll

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
    global NOTICE_MESSAGE

    result := MsgBox("Deranking will auto forfeit arena matches to lower your rank`n`nWould you like to continue?" , "WARNING", "YesNo Icon! 0x40000")
    if result == "Yes" {
        
        NOTICE_MESSAGE := "Auto Deranking"

        guiStateCheck(GUI_SETTINGS.RUNNING)

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
    global NOTICE_MESSAGE
    
    NOTICE_MESSAGE := "Auto Arena Battle"

    guiStateCheck(GUI_SETTINGS.RUNNING)

    Loop {
        GoToBattle()
        Sleep TIMINGS.UI_RESPONSE

        GoToBattle()
        Sleep TIMINGS.UI_RESPONSE

        if !CheckForResultScreen()
            break

        ; startTime := A_TickCount
        ; while (A_TickCount - startTime < 60000) {
        ;     if CheckForDefeatScreen()
        ;         break

        ;     if CheckForVictoryScreen()
        ;         break
        ; }

        ClickAt(CLICK_COORDS.GO_TO_BATTLE)
    }
}

RerollMatch(*) {
    ActivateRoblox()

    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 528
    searchY1 := robloxY + 394
    searchX2 := robloxX + 590
    searchY2 := robloxY + 434

    Text := "|<>**1$33.7zzy3VsDtkSS0zA3nX7nbzwwSQzTbXXUTwoQzlzbXbzDQQszlvk7BUCT1lg3lzzRvwU|<>**1$33.7zzy3VsDtkSS0zA3nX7nbzwwSQzTbXXUTwoQzlzbXbzDQQszlvk7BUCT1lg3lzzRvwU"
    if !FindText(&x := "wait1", &y := "10", searchX1, searchY1, searchX2, searchY2, 0.2, 0.2, Text) {
        ClickAt(542, 414) ; update to variable
        return
    }

    ClickAt(CLICK_COORDS.ARENA_BACK)
    Sleep TIMINGS.UI_RESPONSE

    ClickAt(CLICK_COORDS.ARENA_ICON)
    Sleep TIMINGS.UI_RESPONSE

    ClickAt(CLICK_COORDS.EDIT_TEAM)
    Sleep TIMINGS.UI_RESPONSE

    ClickAt(CLICK_COORDS.SAVE_TEAM)
    Sleep TIMINGS.UI_RESPONSE

    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 513
    searchY1 := robloxY + 392
    searchX2 := robloxX + 589
    searchY2 := robloxY + 435

    Text := "|<>**1$40.U0zk70201y0Q0803s1k0U0DU3021Uy0A08C3k0y1UsT01s603w47UM07UkS1UsC31s63UM03UMC100C1U0400w600EC1kM031s71U0M7UQ6|<>**1$37.U1zUQ0E0TUC0807k70403s1U231s0k11Uw0T1Uky0DUk0y23kM0D11sA63UUw630U0C31UE071U0803Uk0A70kM0A3UMA"
    if FindText(&x := "wait1", &y := "10", searchX1, searchY1, searchX2, searchY2, 0.2, 0.2, Text) {
        GoToBattle()
    } else {
        MsgBox "Could not find Go to Battle Button"
    }
}

GoToBattleMatchup(*) {
    GoToBattle()

    Sleep 20

    if !CheckForResultScreen()
        return

    Sleep TIMINGS.UI_RESPONSE
    ClickAt(CLICK_COORDS.GO_TO_BATTLE)
}


; =====================================================================

GoToBattle() {
    ClickAt(CLICK_COORDS.GO_TO_BATTLE)
}

ArenaBackToIdle(*) {
    global hotkeyGotoBattle, hotkeyReroll

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
; GAME STATE
; =====================================================================

CheckForArenaWindow() {
    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 149
    searchY1 := robloxY + 152
    searchX2 := robloxX + 241
    searchY2 := robloxY + 189

    Text:="|<>*1$77.00003008300000008600k60000000E601UA0000A00UA030M00k8"
    if FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0.1, 0.1, Text) {
        return true
    } else {
        return false
    }
}

CheckForResultScreen() {
    WinGetClientPos(&robloxX, &robloxY, &robloxW, &robloxH, ROBLOX_WINDOW)
    searchX1 := robloxX + 427
    searchY1 := robloxY + 470
    searchX2 := robloxX + 475
    searchY2 := robloxY + 526

    Text:="|<>**1$20.zzzwNgm6HAjVn8Mwnm7Awdn8PAnTzwzzzs|<>**1$21.zzzyAqMVYn5wCNVXnDYCMwdnABaNrzzDzzzU|<>**1$21.zzzyAqMVYn5wCNVXnDYCMwdnABaNrzzDzzzU"
    if FindText(&x := "wait1", &y := "50", searchX1, searchY1, searchX2, searchY2, 0.2, 0.2, Text) {
        return true
    } else {
        MsgBox "Could not find battle result screen"
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
