#Requires AutoHotkey v2.0


LoadSettings() {
    global SETTINGS, GUI_X, GUI_Y

    SETTINGS := DEFAULT_SETTINGS.Clone()

    SETTINGS.notify := DEFAULT_SETTINGS.notify.Clone()
    SETTINGS.EVENT_COUNTDOWN := DEFAULT_SETTINGS.EVENT_COUNTDOWN.Clone()

    if (val := IniRead(INI_FILE, "Settings", "feederUpgradeMethod", "")) != ""
        SETTINGS.feederUpgradeMethod := val

    if (val := IniRead(INI_FILE, "Settings", "initialFeedTime", "")) != ""
        SETTINGS.initialFeedTime := Integer(val)

    if (val := IniRead(INI_FILE, "Settings", "initialRetreatTime", "")) != ""
        SETTINGS.initialRetreatTime := Integer(val)

    if (val := IniRead(INI_FILE, "Settings", "EVENT_COUNTDOWN_ENABLED", "")) != ""
        SETTINGS.EVENT_COUNTDOWN_ENABLED := Integer(val)

    for key in ["goldenGoose", "hotEgg", "ufoInvasion", "chickenBoss"] {
        if (saved := IniRead(INI_FILE, "Countdown", key, "")) != ""
            SETTINGS.EVENT_COUNTDOWN.%key% := Integer(saved)
    }

    for key in ["goldenGoose", "hotEgg", "ufoInvasion", "chickenBoss"] {
        if (saved := IniRead(INI_FILE, "Notifications", key, "")) != ""
            SETTINGS.notify.%key% := Integer(saved)
    }

    GUI_X := IniRead(INI_FILE, "Window", "X", "")
    GUI_Y := IniRead(INI_FILE, "Window", "Y", "")
}

SaveSettings() {
    for key in ["feederUpgradeMethod", "initialFeedTime", "initialRetreatTime"] {
        if (IniRead(INI_FILE, "Settings", key, "") != "" || SETTINGS.%key% != DEFAULT_SETTINGS.%key%)
            IniWrite(SETTINGS.%key%, INI_FILE, "Settings", key)
    }

    for key in ["goldenGoose", "hotEgg", "ufoInvasion", "chickenBoss"] {
        if (IniRead(INI_FILE, "Countdown", key, "") != "" || SETTINGS.EVENT_COUNTDOWN.%key% != DEFAULT_SETTINGS.EVENT_COUNTDOWN.%key%)
            IniWrite(SETTINGS.EVENT_COUNTDOWN.%key%, INI_FILE, "Countdown", key)
    }

    for key in ["goldenGoose", "hotEgg", "ufoInvasion", "chickenBoss"] {
        if (IniRead(INI_FILE, "Notifications", key, "") != "" || SETTINGS.notify.%key% != DEFAULT_SETTINGS.notify.%key%)
            IniWrite(SETTINGS.notify.%key%, INI_FILE, "Notifications", key)
    }
}
