Copyright (C) 2019 mirage335
See the end of the file for license conditions.
See license.txt for PanelBoard license conditions.

Simulator/Vehicle Panel/Kneeboard computer window placement/switching standard/script for VR/AR panels.

Scripted window placement/switching functions intended for dedicated/virtual machines used as limited document/map/data readers for VR/AR panels.


Inspired by the benefits of physical printed paper. Specifically intended to replicate, with arbitrary applications, the flexibility of paper, pen, folding, tabbing, printing, and scanning, for paperless VR/AR environments. Under VR/AR equipment, a user's own hands may not be visible, and any available input/pointing keyboard/mouse device may need to remain connected to more essential systems as often as possible.


Manages other application windows, rather than providing a custom application attempting to recreate all required functonality.


# Standards

* extendedInterface - Keybindings and voice commands.


# Usage

## Workflows

### Automatic Loop

Run _panel_place_loop .

Conditions for window placement/switching.
* Managed desktops enumerated in function '_panel_place_procedure' . Default only '01-plates', '02-plates'. Alternative, any current desktop.


### Dedicated File Manager

Configure an "_fsClient" installation (part of webClient) with file associations using "_panel_place_app" .

Placement of file manager may be done through "_panel_place_app" .

Conditions for window placement/switching.
* Current desktop must be enumerated in function '_panel_place_sidebar_id_rules_determine_fileDriven'. Default any desktop.
* App matches lists under '_wmctrl_place_filter', '_wmctrl_change_hash' functions.
* Workarounds, if needed, are defined by lists under '_panel_place_app_simple', '_panel_place_app_reasonable'.

## Script

* _panel_place
	Place windows.

* _panel_place_loop
	Continiously places windows. Not recommended. Especially on small screens, interferes with user temporarily maximizing applicatons when needed.

* _panel_place_app
	Launches or switches to, and places application window, with specified files.

* _panel_files
	Switches to file manager on current desktop.

File parameters must include "./" or "/" - any relying on PATH or similar will not be processed correctly.

## Workarounds

* LibreOffice - Focus Stealing Prevention OFF.

## Virtual Desktops

Physical desktop computer (or virtual machine) contains an interface divided into multiple virtual desktops. At least one virtual desktop, 'quick', uses scripting to ensure file manager remains visible as a left sidebar, with the selected file visible in the remaining space. Taskbar is placed at top of display.

Quick desktop should be visually equivalent to a typical tabbed IDE interface.

```
01-quick*	Specifically named files and folders. File manager driven.
02-plates*	Predetermined approach plates. File manager driven.

03-cruise**	Cruising waypoints. Spreadsheets. Calculators.

04-fusion	Combined synthetic rendering (typically single window rendered framebuffer). Redundant AR HUD/HMD on/off toggle switch.
05-synthetic	Map, SyntheticVision, Traffic Collision Avoidance, Infrared, Radar, Weather.
06-nav		Horizontal Situation Indicator, Orbital Parameters.


07-material	Video. Kodi, XBMC. External weather reports.
08-media	Media, Lighting, Climate.
09-transceiver	Radio/Transponder Channel/Mode, File/Image Digital Modem.

10-research	Research and Detailed Analysis (no scripted window placement).
11-recorder	Recorder (Voice Notes) On/Off/Timeout.
12-report	Reports (Fuel, Positioning Sources, Structural Integrity, Instrument Status, Maintenance).


13-startup**	Startup Procedures.
14-emergency**	Emergency Procedures.
15-scripted**	Scripted Communications.

16-instruments	Instruments (in case of other display, fusion, or synthetic, failure).
17-integration	Embedded Links (USB Drive Mounting, Keyboard/Mouse Sharing).
18-admin	Admin (daemon, computer resource consumption).
```

*Marked desktops default to continious window placement by '_panel_place_loop'.
**Marked desktops are recommended to be used with window placement by '_panel_place_app' and similar.
Not all desktops will typically be populated.


Intended to roughly resemble a simple layout usable for complex development work, with the added 'activities' dimenision.

```
01-Task1	File manager driven, typically.
02-Task1	File manager driven, typically.
03-Task1
04-Task1
05-Task2	File manager driven, typically.
06-Task2

07-Material
08-Media
09-Messaging
10-Mail
11-Daemon
12-Daemon

13-Task3	File manager driven, typically.
14-Task3	File manager driven, typically.
15-Task3
16-Task3
17-Maintenance
18-Maintenance

```

Keeping as much commonality as possible between use cases is hoped to reduce user mental fatigue and mistakes.

## Voice Commands

Quick desktop active window is managed by voice commands. Vehicles will directly call shell script functions. Simulators will process these into keybindings to be sent to VM graphical console or graphical remote access window.

```
panel tab <Two, Three - default One> Forward		Next active window (LAlt+Tab).
panel tab <Two, Three - default One> Back		Previous active window (LAlt+LShift+Tab).


switch panel <quick, plates, cruise, fusion, synthetic, nav, video, media, transceiver, research, recorder, report, startup, emergency, scripted, instruments, integration, admin - default quick> <custom, specifically named files/app - default none>
	LAlt+[1-9,0]
	RAlt+[1-8]

switch panel files					Shows file manager.
	RAlt+0

```

Quick tab commands in fact send LAlt+Tab and LAlt+LShift+Tab, cycling through active windows.

Not all voice commands will typically be enabled.

## Indicators

* Clock must be visible at all times and include seconds indicator to demonstrate display is continuing to update.
* Autopilot (of any kind) ON/OFF indicator should be included on taskbar at all times if relevant data is available.



# Recommended

* webClient - Provides methods to launch multiple instances of filesystem and web browsers, each with file parameters recognizable in window lists.


# Design

Several window scripting methods have been attempted with varying degrees of completion. FVWM, KWin, xrandr monitor split, and wmctrl, were the most promising candidates.

Operating System should be chosen to ease initial installation of custom software. Gentoo/Funtoo/Sabayon strongly recommended.


# Figures of Merit

Possible changes to this standard, reference implementations, and related systems will be evaluated by a few specific critera, in order, subject to further development.

* Commonality with familiar physical methids (ie. similarity to physical paper).

* Commonality with familiar software tools (ie. similarity to typical Integrated Development Environment - IDE - such as Atom text editor).
* Commonality with other typical and efficient vehicle/tool operating or development practice (eg. effective Virtual Desktop work habits).
* Commonality with existing vehicle/tool control demonstrating best principles (eg. glass cockpit standards).

* User latency required using keyboard/mouse (ie. user time - Hands OFF Throttle and Stick - HOTAS).

* Capability with input formats.
	* Document editing (ie. Desktop LibreOffice).
	* HTML browsing/searching/inspection/bookmarking (ie. Atom text editor browser-plus-find plugin, FireFox extensions).
	* PDF bookmarking.
	* PDF marking (ie. Xournal).
	* Graphical clipboard copy/paste.

* Integration convenience.
	* File/Folder copy as text address.

* Multi-Instance (ie. do no attempt to switch desktops with open application to open file).

* Single-Click Interface
	* Selected file immediately opened and brought to focus in well placed application window.
	* All application windows resized with screen.
	* Tabbed document interface.
	
* Rapid file tree browsing.
	* Directory expansion with files (ie. Dolphin file manager 'Expandable' folders, Atom text editor tree-view plugin).
	* Landscape desktop views will be preferable. Portrait modes may require file manager visibility toggling.


# Safety

May be sufficiently reliable, when carefully configured, to improve combined mean-time-between-failures for other instrumentation. Nonetheless, desktop operating system infrastructure is not adequately reliable by itself.

Fallbacks to other display inputs may be triggered automatically, for example, following autopilot disengagement or other detected failure.

Disks should be nonpersistent, with less critical large datasets stored on separate nonpersistent disk, to allow rapid recovery from faults.

Filesystems should be local only, due to possibility of file manager problems.

Reboots should be carefully structured for minimum startup time. Less than 12 seconds preferred.

Internal voice commands must not conflict with other voice recognition systems that may be running. Repeatability and efficiency are also important.


# Other

Additionally serves as reference implemenation for similar window placement projects until upstream integration of relevant procedures with Ubiquitous Bash is undertaken.


# Future Work

* Upstream, Ubiquitous Bash, voice commands using Pocket Sphinx and limited vocabulary. Specifically NOT a 'digital assistant'.

* Pure Wayland support.
* KWin Scripting alternative to use of Bash/wmctrl.

* PDF reader keybindings to mark and goto tabbed bookmarks.


# Reference

https://askubuntu.com/questions/150066/split-monitor-in-two
https://lists.freedesktop.org/archives/xorg/2017-March/058634.html

https://github.com/kwin-scripts/kwin-tiling
https://store.kde.org/p/1212092/


https://unix.stackexchange.com/questions/107818/how-can-you-run-a-script-triggered-by-a-joystick-input

https://medium.com/@ranjanprj/for-some-time-now-i-have-been-thinking-really-hard-to-build-a-diy-study-aid-for-children-which-uses-17ce90e72f43
http://www.speech.cs.cmu.edu/tools/lmtool-new.html



https://play.google.com/store/apps/details?id=com.teamviewer.host.market&hl=en

https://en.wikipedia.org/wiki/Comparison_of_note-taking_software
https://www.tagspaces.org/
https://en.wikipedia.org/wiki/WikidPad#/media/File:WikidPad_Screenshot.gif
https://en.wikipedia.org/wiki/BasKet_Note_Pads#/media/File:Basket_note_pads.png
https://en.wikipedia.org/wiki/MyNotex#/media/File:Mynotex-screenshot.png
https://en.wikipedia.org/wiki/Zim_(software)
https://en.wikipedia.org/wiki/QOwnNotes

https://en.wikipedia.org/wiki/ARINC_661

https://en.wikipedia.org/wiki/Apollo_Guidance_Computer

http://www.stefanv.com/aviation/flight_computers.html
https://www.sportys.com/pilotshop/runway-selector.html

https://www.globalmarinenet.com/wp-content/uploads/2015/04/T-PC-Aviation-White-Paper.pdf

https://www.aes-eu.com/datasheets/sdk/SD-EDM-datasheet.pdf



https://www.domoticz.com/wiki/Setting_up_overlayFS_on_Raspberry_Pi



__Copyright__
This file is part of PanelBoard.

PanelBoard is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanelBoard is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanelBoard.  If not, see <http://www.gnu.org/licenses/>.
