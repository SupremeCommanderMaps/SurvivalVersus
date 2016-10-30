# Final Rush Pro 5
<img align="right" src="preview.jpg">
A survival map for [Supreme Commander: Forged Alliance Forever][FAF].

[![Build Status](https://travis-ci.org/JeroenDeDauw/FinalRushPro5.svg?branch=master)](https://travis-ci.org/JeroenDeDauw/FinalRushPro5)

## New in version 5

This is an alpha version, no stable release is available yet.

(Changes since version 4.0007)

* Added Auto Reclaim option (or rather made it work with recent versions of FAF)
* Added additional possible values to the Auto Reclaim option
* Changed default values of the lobby options to what most people expect
* Added option that allows turning all player air units on
* The Player Air restriction option now applies to all game modes
* Added additional possible values to the Player Tech Delay option
* Improved the wording of all option titles and descriptions
* Added description of the game modes to the map description visible in the lobby
* Dropped Final Rush UI and dependence on the FinalRushPro3 mod

**Survival mode**

* Added Spawn Delay option
* Added option that allows turning Aggression Tracking off
* Fixed the MML restriction option (it did not show up in the lobby)
* Fixed the T3 Mobile Arty restriction option (it did not show up in the lobby)
* Fixed the Sniper Bot restriction option (it did not show up in the lobby)
* Indestructible transports can no longer be captured or reclaimed

**Paragon Wars mode**

* Paragon Wars now works properly when playing with less than 8 players
* The Paragon Activator and civilian base now spawn in the exact center of the map (rather than deviating randomly)
* The civilian base is now symmetrical (rather than constructed randomly)
* Units will no longer automatically fire on the (indestructible) Paragon Activator

**Internal changes**

* Refactored the codebase from procedural to object orientated
    * Cohesive sets of code now have their own modules
    * Global/static scope is now avoided where possible and dependency injection is used
* Moved the codebase into Git
* Added a limited number of automated tests
* Added README with installation instructions and release notes
* Set up continuous integration via TravisCI 

## Installation

* Download the [latest version of the map][download]
* Extract the zip and rename the directory from `FinalRushPro5-master` to `Final Rush Pro 5`
* Place the directory into `Documents\My Games\Gas Powered Games\Supreme Commander Forged Alliance\Maps`

Note: you do not need to have the FinalRushPro3 mod like you did with version 4 of this map.
Furthermore since the Auto Reclaim option has been fixed, you probably want to use that instead
of the Vampire mod.

## Updates and contributing

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
[download]: https://github.com/JeroenDeDauw/FinalRushPro5/archive/master.zip
[GitHub]: https://github.com/JeroenDeDauw/FinalRushPro5/
[Busted]: http://olivinelabs.com/busted/
[Entropy]: https://entropywins.wtf/
