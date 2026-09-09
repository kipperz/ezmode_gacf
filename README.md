# EZ Mode - Grow a Chicken Fighter
### EZ Mode for Roblox: Grow a Chicken Fighter is a helper tool that uses AutoHotKey to automate repetitive gameplay such as rebirthing and provides useful features like UFO Event notifications.
<br/>

**Usage Guide**
- [Support](#support)
- [Prerequsites](#prerequisites)
- [Installation](#installation)

**Key Features**
- [Rebirth Automation](#rebirth-automation)
- [Arena Automations](#arena-automations)
- [UFO Event Notification](#ufo-event-notifications)

**Other**
- [License](#license)
<br/>

***
<br/>

EZ Mode Automations use pixel/image searches to detect game events and perform actions by sending keystrokes and mouse events to the Roblox client — think of it as ***smart macros***. The tool does not inject code into the client (commonly known as scripting) or modify game files, however, automations of any kind can violate Roblox TOS, please read the below warning.

> [!WARNING]  
> Automating games in Roblox violates their Terms of Service and can lead to account bans. Use the automations at your own risk.
<br/>

***
<br/>

## Usage Guide
### Support
Join my community Discord server at [discord.gg/kipperz](https://discord.gg/kipperz) for support, suggestions, or game discussion.

### Prerequisites
- **Windows 10/11**
- **Minimum Display Resolution: 1280x720**
- **Windows Display Scaling: 100%**
- **Roblox Text Size: Default**

### Installation
1. **Download and Install [AutoHotKey v2.0](https://www.autohotkey.com/)**

1. **Download the [latest release](https://github.com/kipperz/ezmode_gacf/releases)**

2. **Extract **ezmode_gacf-beta.zip** to a folder**

3. **Run "ezmode_gacf.ahk"** - ezmode_gacf.ini will be created to store settings

4. **Press the ⚙️ button** for settings (optional)
<br/>


## Key Features
### Rebirth Automation
This automation will buy and upgrade feeders, run the Tower continuously until eligible for rebirth, recall the chicken, rebirth, and then repeat until the automation is canceled.

#### How to use
1. Move your player in to position according to the **Upgrade Method** (set from the ⚙️ button)
	- **single** - Back left corner of the coop, behind the feeder
	- **strafe** - Back left corner of the coop, behind the feeder, facing the tower
	- **turn** - Towards the back middle of the coop, facing the left feeder

2. Press **Rebirth** then **Start**, or

3. Press **Continue** if your run was interrupted and feeders are already upgraded.

#### How it works
The full rebirth process is automated and looped until canceled. For most of the automation, you will need to avoid mouse and keyboard input and the tool will display "Automation in control."  If another window gains focus while the automation is in control, the automation will halt and send an alert. During most of Phase 2, the tool will show "Safe to multitask". While the tool is in this state, you may work in other windows but the Tower Floor progress bar must remain visible. The automation cannot detect the progress bar if Roblox is minimized or covered by another window.

- **Phase 1:** The feeder is purchased, the chicken is allowed time to feed, then the initial tower run is started. During this run, the feeders are upgraded until the chicken is knocked out or recalled. You can set an upgrade method (one or two feeders) and a recall time in the settings.

- **Phase 2:** Time is allowed for the chicken to feed, then the tower run is continued until rebirth is ready. If your chicken gets knocked out, refeeding time is given before continuing the tower run. This will loop until the rebirth requirement is met.

- **Phase 3:** Rebirth is ready so the chicken is recalled by pressing **Retreat.** The rebirth button will be pressed until successfully rebirthing and the process starts back at Phase 1.
<br/>

### Arena Automations

**How to use**
1. **Assist:** With current matchmaking, this is the best method for ranking up. Use **F7** to press the **Go To Battle** button and **F8** to reroll the match-up when you're out of skips.

2. **Auto:** Automatically go to battle until canceled. Auto battling will likely result in more losses than wins but you will earn crowns for the shop and feathers for upgrades at the expense of losing rank.

3. **Derank:**  Automatically go to battle and forfeit to lower your rank.
<br/>

### UFO Event Notifications

Get notified when the next UFO Event is about to start. Enable/disable a visual countdown to the event from the settings menu

<br/>

## License
This project is dual-licensed under:

1. **GNU Affero General Public License v3.0** (*AGPL-3.0-only*) — free for open-source use. Any modification or derived work distributed or offered over a network must be released under the AGPL-3.0.
2. **A commercial license** — available for organizations that wish to use this software in closed-source products or hosted services without AGPL obligations. Contact business@kipperz.gg for terms and pricing.

Unless you obtain a commercial license, your use is governed by the AGPL-3.0. The code is the same under both.
