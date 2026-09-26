#Requires AutoHotkey v2.0

; ==================== SCHEDULE ====================
EVENT_BASE     := 1789229400   ; first event
EVENT_COOLDOWN := 600          ; 10 min between event starts
EVENT_DURATION := 180          ; 3 min active window

; Edit this list when events change.
EVENTS := [
    {key: "hotEgg",      name: "Hot Egg"},
    {key: "ufoInvasion", name: "UFO Invasion"},
    {key: "chickenBoss", name: "Chicken Boss"},
    {key: "goldenGoose", name: "Golden Goose"},
]

; ==================== STATE ====================
LastNotifiedStart := 0

; ==================== GUI ====================
; CountdownGui := Gui("+AlwaysOnTop -Resize", "Event Countdown")
; CountdownGui.SetFont("s16 bold", "Segoe UI")
; CountdownLabel := CountdownGui.Add("Text", "w320 Center", "...")
; CountdownGui.Show("AutoSize")

; ==================== TIMER ====================
SetTimer(Update, 1000)
Update()   ; run once immediately so GUI isn't blank for 1s

; ==================== MAIN ====================
Update() {
    global EVENTS, EVENT_BASE, EVENT_COOLDOWN, EVENT_DURATION
    global LastNotifiedStart, countdownLabel

    now := UnixNow()

    n            := Floor((now - EVENT_BASE) / EVENT_COOLDOWN)
    currentStart := EVENT_BASE + n * EVENT_COOLDOWN
    currentEnd   := currentStart + EVENT_DURATION
    currentIdx   := PositiveMod(n, EVENTS.Length) + 1
    currentEvent := EVENTS[currentIdx]

    ; ---- Countdown label ----
    if (now < currentEnd && SETTINGS.EVENT_COUNTDOWN.%currentEvent.key%) {
        ; Currently running and enabled -> show time remaining
        countdownLabel.Text := currentEvent.name . " (" . FormatSeconds(currentEnd - now) . ")"
    } else {
        ; Otherwise show next enabled event
        labelText := ""
        Loop EVENTS.Length {
            i     := A_Index
            start := EVENT_BASE + (n + i) * EVENT_COOLDOWN
            idx   := PositiveMod(n + i, EVENTS.Length) + 1
            event := EVENTS[idx]
            if (SETTINGS.EVENT_COUNTDOWN.%event.key%) {
                labelText := event.name . " in " . FormatSeconds(start - now)
                break
            }
        }
        countdownLabel.Text := labelText
    }

    ; ---- Notification: one minute before next event ----
    nextStart := EVENT_BASE + (n + 1) * EVENT_COOLDOWN
    nextIdx   := PositiveMod(n + 1, EVENTS.Length) + 1
    nextEvent := EVENTS[nextIdx]

    if (now >= nextStart - 60
        && now < nextStart
        && SETTINGS.notify.%nextEvent.key%
        && LastNotifiedStart != nextStart) {

        TrayTip(nextEvent.name, "Starts in the next minute!")
        LastNotifiedStart := nextStart
    }
}

; ==================== HELPERS ====================
UnixNow() {
    return DateDiff(A_NowUTC, "19700101000000", "Seconds")
}

PositiveMod(a, b) {
    return Mod(Mod(a, b) + b, b)
}

FormatSeconds(sec) {
    sec := Max(0, Floor(sec))
    return Format("{:02}:{:02}", Floor(sec / 60), Mod(sec, 60))
}
