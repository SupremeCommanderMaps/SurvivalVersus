# Final Rush Pro 5
<img align="right" src="preview.jpg">
A survival map for [Supreme Commander: Forged Alliance Forever][FAF].

You can [read the documentation][docs].

## Installation

The easiest way to install the map is to get it via the [Forged Alliance Forever][FAF] map vault.
Alternatively you can download it from GitHub, using these steps:

* Download the [latest version of the map][download]
* Extract the zip. The result should be a directory named `final_rush_pro_5.3.v0001`
* Place the directory into `Documents\My Games\Gas Powered Games\Supreme Commander Forged Alliance\Maps`

Note: you do not need to have the FinalRushPro3 mod like you did with version 4 of this map.
Furthermore since the Auto Reclaim option has been fixed, you probably want to use that instead
of the Vampire mod.

## New in version 5.3

Not released yet

* Changed default difficulty from EASY to NORMAL (NORMAL is a lot more difficult as the game progresses)
* ACU hiding is now prevented by default in Survival Versus (but can be enabled with via the options)
* Modified lobby options are now (mostly) highlighted in the welcome message
* Added 125% and 150% values to the Auto Reclaim option

## New in version 5.2

Released on 2017-12-10

* Added option to set if the survival transports can be killed
* Added option to set if ACU hiding should be prevented
* Fixed Novax not being buildable

## New in version 5.1

Released on 2017-10-29

* Fixed random event units spawning only for bottom team players
* Added messages showing detailed game settings at the start of the game
* Decreased default HP increase on easy from 11.11% to 10%

## New in version 5

Released on 2016-11-20 (changes since v4.0007)

TL;DR: many new options, various balance enhancements, no more need for mods

**New lobby options**

* Added Survival Difficulty option (which can be used in both Survival Classic and Survival Versus)
* Added Auto Reclaim option (or rather made it work with recent versions of FAF)
* Added Spawn Delay option (survival modes only)
* Added options to specify T1, T2, T3 and T4 Spawn Frequency (survival modes only)
* Added options to specify T2, T3 and T4 Spawn Delay (survival modes only)
* Added option to specify the Health Increase of the spawned units (survival modes only)
* Added option to specify Random Event Frequency (survival modes only)
* Added option to specify Bounty Hunter Frequency (survival modes only)
* Added option to specify Bounty Hunter Delay (survival modes only)
* Added option that allows turning Aggression Tracking (punishing of fast tech, ACU in mid, etc) off (survival modes only)
* Fixed the MML restriction option (it did not show up in the lobby) (survival modes only)
* Fixed the T3 Mobile Arty restriction option (it did not show up in the lobby) (survival modes only)
* Fixed the Sniper Bot restriction option (it did not show up in the lobby) (survival modes only)
* Added option that allows turning all player air units on
* Added option that allows disabling event notifications

Extra option values:

* Added additional possible values to the Auto Reclaim option
* Added additional possible values to the Player Tech Delay option

Other lobby improvements:

* Changed default values of the lobby options to what most people expect
* Improved the wording of all option titles and descriptions
* The Player Air restriction option now applies to all game modes
* Added description of the game modes to the map description visible in the lobby

**Survival modes**

* Random events now spawn units for both teams rather than one random victim
* Bounty Hunters now spawn for both teams rather than one random victim
* Random events now match the land unit tech level and stop spawning lower tech units as they get obsolete
* Added T2 Gunships and Fatboy random events
* Random event units now only spawn for players that are still in game (rather than glitch and sit idly in the center)
* Bounty Hunters will now attack targets in the bottom team (rather than glitch and sit idly in the center)
* All Bounty  Hunters now teleport out once their target has been killed (rather than a few glitching and remaining)
* Improved target areas selection of random event units

**Paragon Wars mode**

* Paragon Wars now works properly when playing with less than 8 players
* The Paragon Activator and civilian base now spawn in the exact center of the map (rather than deviating randomly)
* The civilian base is now symmetrical (rather than constructed randomly)
* Units will no longer automatically fire on the (indestructible) Paragon Activator
* The Paragon Activator now takes more build power to capture (multiple seconds with SACU, instead of near instant with T1)

**Internal changes**

* Dropped Final Rush UI and dependence on the FinalRushPro3 mod
* Refactored the codebase from procedural to object orientated
    * Cohesive sets of code now have their own modules
    * Global/static scope is now avoided where possible and dependency injection is used
* Moved the codebase into Git
* Added a limited number of automated tests
* Added README with installation instructions and release notes
* Set up continuous integration via TravisCI

## Updates and contributing

[![Build Status](https://travis-ci.org/JeroenDeDauw/FinalRushPro5.svg?branch=master)](https://travis-ci.org/JeroenDeDauw/FinalRushPro5)

You can find the latest version of the map on the [Final Rush Pro 5 GitHub project][GitHub], which is
also the place where you can file issues, post feature request, and submit patches.

### Running the tests

Some of the code that does not bind to FA(F) directly is tested using the
[Busted unit testing framework][Busted]. To run the tests on Linux, execute `busted` in the project
root directory. To run them on Windows, well, I don't know how to work with Windows.

## Authors

The authors of the original map are Commander-Chronicles, TV-Nobby and Diegobah. Fixes where later
made by ozonex.

This version of the map includes files from the FinalRushPro3 mod, which was created by CommanderChronicles.

Changes in version 5.x are by [EntropyWins][Entropy]. The version 5 preview image was created by JuiceBoy.

[FAF]: http://www.faforever.com/
[docs]: https://wiki.faforever.com/index.php?title=Final_Rush_Pro_5
[download]: https://github.com/JeroenDeDauw/FinalRushPro5/releases/download/v5.2.0/Final.Rush.Pro.5.2.zip
[GitHub]: https://github.com/JeroenDeDauw/FinalRushPro5/
[Busted]: http://olivinelabs.com/busted/
[Entropy]: https://entropywins.wtf/
