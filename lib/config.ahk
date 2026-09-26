#Requires AutoHotkey v2.0

global ROBLOX_WINDOW := "ahk_exe RobloxPlayerBeta.exe"
global INI_FILE := "ezmode_gacf.ini"
global GUI_X := 0
global GUI_Y := 0


gui_title := "EZ Mode"

global GUI_SETTINGS := {
    IDLE: {
        WIN_TITLE: gui_title,
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
        WIN_TITLE: gui_title " - Running",
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
        WIN_TITLE: gui_title " - Waiting",
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
        WIN_TITLE: gui_title " - Paused",
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
        WIN_TITLE: gui_title " - Arena",
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

global CLICK_COORDS := {
    TOWER_ICON:              {X: 375 + 44 // 2, Y: 530 + 60 // 2, W: 44, H: 60},
    TOWER_SKIP_TO_FRONTIER:  {X: 459 + 88 // 2, Y: 288 + 32 // 2, W: 88, H: 32},
    TOWER_SKIP_TO_WARMUP:    {X: 459 + 88 // 2, Y: 227 + 32 // 2, W: 88, H: 32},
    TOWER_START_FROM_BOTTOM: {X: 356 + 88 // 2, Y: 396 + 32 // 2, W: 88, H: 32},
    KNOCKED_OUT_NO_THANKS:   {X: 356 + 88 // 2, Y: 428 + 24 // 2, W: 88, H: 24},
    REBIRTH_ICON:            {X: 746 + 30 // 2, Y: 287 + 30 // 2, W: 30, H: 30},
    REBIRTH_WINDOW_CLOSE:    {X: 588 + 30 // 2, Y: 50 + 30 // 2,  W: 30, H: 30},
    REBIRTH_BUTTON:          {X: 356 + 88 // 2, Y: 415 + 40 // 2, W: 88, H: 40},
    PURCHASE_AD:             {X: 562 + 40 // 2, Y: 309 + 44 // 2, W: 24, H: 24},
    ARENA_ICON:              {X: 65 + 20 // 2,  Y: 342 + 20 // 2, W: 20, H: 20},
    GO_TO_BATTLE:            {X: 410 + 30 // 2, Y: 392 + 30 // 2, W: 30, H: 30},
    EXIT_ARENA:              {X: 66, Y: 55},
    ARENA_BACK:              {X: 620 + 44 // 2, Y: 152 + 24 // 2, W: 44, H: 24},
    EDIT_TEAM:               {X: 592 + 44 // 2, Y: 234 + 16 // 2, W: 44, H: 16},
    SAVE_TEAM:               {X: 430 + 88 // 2, Y: 398 + 24 // 2, W: 88, H: 24},
    CLAIM_EGGS:              {X: 428 + 88 // 2, Y: 396 + 24 // 2, W: 88, H: 24},
}

global PIXEL_SEARCH := {
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

global TIMINGS := {
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

global DEFAULT_SETTINGS := {
    feederUpgradeMethod: "single",
    initialFeedTime: 2,
    initialRetreatTime: 0,
    EVENT_COUNTDOWN_ENABLED: 1,
    EVENT_COUNTDOWN: {
        goldenGoose: 0,
        hotEgg: 0,
        ufoInvasion: 1,
        chickenBoss: 0
    },
    notify: {
        goldenGoose: 0,
        hotEgg: 0,
        ufoInvasion: 1,
        chickenBoss: 0
    }
}

global NOTICE_MESSAGE := ""
global ROBLOX_AUTOMATION_WIDTH := 800
global ROBLOX_AUTOMATION_HEIGHT := 600

global SETTINGS := {}

global hotkeyGotoBattle := "F7"
global hotkeyReroll := "F8"
global hotkeyGotoBattle := "F7"