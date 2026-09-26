#Requires AutoHotkey v2.0


StartRebirthAutomation(*) {
    instructions := {
        single: "Stand in the back left corner of the coop, behind the feeder",
        strafe: "Stand in the back left corner of the coop, behind the feeder, facing the tower",
        turn: "Stand towards the back middle of the coop, facing the left feeder"
    }

    result := MsgBox("Upgrade Method: " SETTINGS.feederUpgradeMethod "`n`n" instructions.%SETTINGS.feederUpgradeMethod% "`n`n`nAre you in position?" , "Rebirth Automation", "YesNo 0x40000")
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
    global NOTICE_MESSAGE

    NOTICE_MESSAGE := "Starting initial Tower run"
    guiStateCheck(GUI_SETTINGS.RUNNING)

    UpgradeFeeder(1)

    Sleep SETTINGS.initialFeedTime * 1000
    StepTwo()
}

StepTwo() {
    global NOTICE_MESSAGE

    NOTICE_MESSAGE := "Upgrading feeders"
    guiStateCheck(GUI_SETTINGS.RUNNING)

    SendToTower()
    Sleep TIMINGS.TOWER_ENTRY_WAIT
    
    result := GetInitialTowerRunResult()
    if result {
        if (SETTINGS.feederUpgradeMethod == "single")
            Sleep TIMINGS.FEED_TIME_SINGLE
        else
            Sleep TIMINGS.FEED_TIME_DOUBLE
        StepThree()
    } else {
        result := MsgBox("No initial tower run results after " TIMINGS.TIMEOUTS.TOWER_RUN_INITIAL " seconds.`n`nWould you retry?" , "AutoRebirth Error", "YesNo T30 Icon! 0x40000")
        if result == "No" {
            ReloadScript()
        } else
            ClearMousePos()
            StepTwo()
    }
}

StepThree(*) {
    global NOTICE_MESSAGE

    NOTICE_MESSAGE := "Starting Tower Run Loop"

    guiStateCheck(GUI_SETTINGS.RUNNING)

    CheckForPurchaseAd()
    SendToTower()

    guiStateCheck(GUI_SETTINGS.WAITING)

    result := GetTowerRunResult()
    if !result
        return

    if result.rebirthReady {
        NOTICE_MESSAGE := "Rebirth is ready"
        CloseRebirthWindow()

        if CheckForKnockout()
            ClickAt(CLICK_COORDS.KNOCKED_OUT_NO_THANKS)
        else
            Retreat()

        StepFour()
    } else if result.knockedOut {
        NOTICE_MESSAGE := "Knocked out"
        CloseRebirthWindow()
        Sleep TIMINGS.UI_RESPONSE
        ClickAt(CLICK_COORDS.KNOCKED_OUT_NO_THANKS)
    
        if (SETTINGS.feederUpgradeMethod == "single")
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
    global NOTICE_MESSAGE

    NOTICE_MESSAGE := "Upgrading feeders"

    returnState := guiStateCheck(GUI_SETTINGS.RUNNING)

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
    global NOTICE_MESSAGE

    startTime := A_TickCount
    Loop {
        CheckForPurchaseAd()

        if (SETTINGS.initialRetreatTime && SETTINGS.initialRetreatTime * 1000 - TIMINGS.TOWER_ENTRY_WAIT < A_TickCount - startTime){
            Retreat()
            return true
        }

        if (SETTINGS.feederUpgradeMethod == "strafe")
            UpgradeFeedersStrafe()
        else if (SETTINGS.feederUpgradeMethod == "turn")
            UpgradeFeedersTurn()
        else {
            CheckActiveWindow()
            Send "e"
            Sleep 500 ; sleep hard code
        }

        if CheckForKnockout() {
            NOTICE_MESSAGE := "Knocked Out"
            ClickAt(CLICK_COORDS.KNOCKED_OUT_NO_THANKS)
            return true
        }        
    } Until (A_TickCount - startTime > TIMINGS.TIMEOUTS.TOWER_RUN_INITIAL)

    return false
}

GetTowerRunResult() { ; watch for tower floor progress bar completion or hidden knockedout window
    guiStateCheck(GUI_SETTINGS.WAITING)   

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
    if FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0.1, 0.1, Text) {
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
    if FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0.1, 0.1, Text) {
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
    if FindText(&x, &y, searchX1, searchY1, searchX2, searchY2, 0.1, 0.1, Text) {
        ClickAt(CLICK_COORDS.PURCHASE_AD)
    }
}