#Requires AutoHotkey v2.0

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

        result := MsgBox(NOTICE_MESSAGE "`n`nWould you like to continue?" , "AutoRebirth Paused", "YesNo T120 Iconi 0x40000")
        if result == "No" {
            ReloadScript()
        } else {
            SwitchGui(GUI_SETTINGS.RUNNING)
            ActivateRoblox()
        }
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
    if (windowY + newH > workAreaBottom) {
        newY := workAreaBottom - newH
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
; GAME CONTROL
; =====================================================================

MovePlayer(key, seconds) {
    CheckActiveWindow()
    Send "{" key " down}"
    Sleep seconds * 1000

    CheckActiveWindow()
    Send "{" key " up}" 
}

ClickAt(objectOrTargetX, y := 0, variationX := 2, variationY := 2, speed := 5, clickDelayMs := 100) {
    if IsObject(objectOrTargetX) && objectOrTargetX.HasProp("X") {
        targetX := objectOrTargetX.X + Random(-objectOrTargetX.W // 2, objectOrTargetX.W // 2)
        targetY := objectOrTargetX.Y + Random(-objectOrTargetX.H // 2, objectOrTargetX.H // 2)
        
    } else {
        targetX := objectOrTargetX + Random(-variationX, variationX)
        targetY := y + Random(-variationY, variationY)
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