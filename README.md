# Survival versus
<img align="right" src="preview.jpg" height="150px">

A survival map for [Supreme Commander: Forged Alliance Forever][FAF]. Supports 1 up to 8 players.

Enemy units come from the center of the map after flying in from the left or right corner. In Survival Versus
mode (the default), you win by outlasting the enemy team, after which you can optionally continue the game
till the final wave. In Survival Classic mode you win by surviving all waves.

If your team has no living ACUs you lose.

You can [read the documentation][docs] and watch [a cast by Yuri](https://www.youtube.com/watch?v=OaOBy9-WNcI).

[![image](https://user-images.githubusercontent.com/146040/61600959-a00c9700-ac33-11e9-9751-82bfa836b426.png)](https://www.youtube.com/watch?v=Jb15tCC7_gc)

## Installation

*FAF Map Vault*

The easiest way to install the map is to get it via the [Forged Alliance Forever][FAF] map vault.
The name of the map there is **Survival Versus**. Older versions are available as Final Rush Pro 5.

Note: you do not need to have the FinalRushPro3 mod like you did with version 4 of this map.
Furthermore since the Auto Reclaim option has been fixed, you probably want to use that instead
of the Vampire mod.

*From a Friend*

If the map vault does not work for you and a friend has the map, ask them to send you a copy
of their `survival_versus.v0024` in `Documents\My Games\Gas Powered Games\Supreme Commander Forged Alliance\Maps`.
Then place that copy into the `Maps` directory.

*Manual Installation*

You can download the latest development version of the map from GitHub.

Beware that these versions are not the same as the ones typically hosted on the Forged Alliance Forever lobby.
If not everyone is using the same version of the map, you will get a desync. When using development versions the
advertised version of the map, ie Survival Versus v24, is in itself not sufficient to check, as there will be
many development versions of Survival Versus v24.

* Download the [latest development version of the map][download]
* Extract the zip. The result should be a directory named `survival_versus.v0024`
* Place the directory into `Documents\My Games\Gas Powered Games\Supreme Commander Forged Alliance\Maps`
* Clone `lib` into `vendor`


## Release notes

### New in version 24

Under development

* Changed map name to "Survival Versus" since people do not understand that `Final Rush Pro 5.11` is older than `Final Rush Pro 5 v23`

### New in version 5.23

Released on 2020-12-23

* Fixed issue with Hunter event

### New in version 5.21

Released on 2020-05-01

* Drowning ACUs now cause the "commander under attack" warning (thanks speed2!)
* Allow first defeated team to watch the remaining team play in Survival Versus
* Increased satellite count by 50%
* Increased experimental transport base HP from 8500 to 9500 and from 13337 to 15000

### New in version 5.20

Released on 2018-10-16

* Fixed regression from 5.19 that broke detection of full victory
* All Factions mod has been integrated and is on by default. This can be disabled via the new "All Factions" lobby option
* The "Enemy T2 MMLs" and "Enemy Mobile T3 Artillery" lobby options are now affected by the difficulty preset
* Mobile Arty no longer spawns by default on Very Easy
* MMLs no longer spawns by default on Very Easy and Easier
* Fatboy and Ythota random events now stop at the beginning of stage 6
* Improved stage descriptions in the timed objectives
* Removed unused Sniper Bots option from the lobby

### New in version 5.19

Released on 2018-10-14

* Rebalancing to make Normal and Easy difficulties less hard
* Default Auto-reclaim has been nerfed. It now linearly decreases to 0 at minute 60. This can be changed in the lobby
* Default Auto-reclaim is now affected by the difficulty preset
* You can now no longer lose during the 8 seconds the game runs after winning

### New in version 5.18

Released on 2018-10-13

* When beating the other team in Survival Versus you can now keep on playing to beat the final stage
* Survival Classic games now end in victory when the final stage has been completed
* Added timed objectives for each survival stage
* Added Escalation Speed lobby option which allows modifying how fast the game escalates to higher tier stages
* Added Unit Amount lobby option which allows modifying how many survival units spawn
* Players on one side of the map are now always allied in Survival Versus (no need to set teams in the lobby)
* Reduced survival air experimental base health to 25000
* Added health increase to survival air experimentals
* Survival units inside transports now have their shields on
* Removed spawn delay lobby options for T1, T2, T3 and T4 stages (replaced by new Escalation Speed option)
* Removed spawn frequency lobby options for T1, T2, T3 and T4 stages (replaced by new Unit Amount option)
* Removed Aggression Tracking option from the lobby (already non functional since 5.17)

### New in version 5.17

Released on 2018-09-16

* Resources now only spawn for players present in the game
* Stage 6 and 7 transports now have double speed
* Improved stage notification messages
* Removed aggression tracking (was disabled by default except on very hard and insane)

### New in version 5.16

Released on 2018-09-15

* Fatboys can now be build when artillery and nukes are disabled
* Added Stage 5: tier 3 units stop spawning and instead bugs and arty spawn
* Added Stage 6: monkeys and GCs stop spawning and instead megas and chickens spawn, plus the occasional satellite
* Added Stage 7: stage 5 stops spawning and instead CZARs, T4 bombers, fatboys and monkeys spawn

### New in version 5.15

Released on 2018-08-28

* Fixed paragon event to not be re-triggered when gifting a paragon
* The nukes/T3/T4 arty option now also affects T4 *mobile* arty
* Fixed Paragon Wars game mode: the central base with the activator now actually spawns

### New in version 5.14

Released on 2018-08-19

* Fixed paragon event to only be triggered by completed paragons
* Added visible area around the flying paragon so all players can see what is going on (thanks speed2!)

### New in version 5.13

Released on 2018-08-18

* Player nukes and T3/T4 arty are now disabled by default
* Added option to enable or disable player nukes and T3/T4 arty
* Building a paragon will now result in your enemy bot building one as well. Better have AA ready! (thanks speed2!)

### New in version 5.12

Released on 2018-08-15

* Removed central mexes
* Experimentals are now brought in with a special transport instead of with a Continental
* Nered islands bases even further by removing the T2 shields
* Reduced income of island base mex from 50 mass/s to 36 mass/s
* The island base mex now retains its modified max health after capture
* Improved map preview in the FAF client

### New in version 5.11

Released on 2018-05-04

* Buffed beetle random event: 2x base HP, survival HP increase now applied, 1.5x speed

### New in version 5.10

Released on 2018-05-01

* Added beetle random event
* Nerfed island bases further by replacing T2 PD with T1 PD

### New in version 5.9

Released on 2018-04-15

* Changed bot colors so they cannot be the same as those of players (thanks JJ!)
* Tech 2 waves now include MMLs again, unless disabled in the options
* Tech 2 waves now contain a rhino, riptide, mongoose and rocket bot, instead of 2 rhino and 2 mongoose
* Tech 3 waves no longer include shield disruptors when T3 arty is disabled in the options
* Tech 3 waves now include 1 slipper and 1 T3 shield instead of 2 slippers
* Added new T2 random event that spawns 5x5 rangebots
* Units from T1 and T2 random events now have their HP increase like all other survival units
* Hunter ACUs no longer drown in the water
* Nerfed island base defences by removing the torpedo launcher ring
* Island base mex now yields 50 mass instead of 36
* Island base mex now retains its altered stats after capture

### New in version 5.8

Released on 2018-03-09

* Wrecks of player units now consistently stay on the map (most notably GC and Monkey wrecks no longer vanish) (thanks speed2!)
* Added small bases on the central islands to make TAC cheese easier to detect and harder to setup
* Added T3 mex with double yield on central islands to incentivize paying attention to them
* Massively increased base health of each hunter to 75k
* Hunters now take 15 seconds to spawn on the map after their announcement (instead of instantly)

### New in version 5.7

Released on 2018-03-04

* Fixed the location of the prebuild hives for player 8 (top team, left edge slot)
* Added message to notify players of drowning ACUs
* Fixed bug causing Vision Centers to become killable after being captured twice
* Fixed bug causing Team HP Bonus to be applied twice (once on the total HP and once on the % of HP)
* The 3 groups of bombers in the strategic bombers random event now spawn with 5 second delay in between them
* Slightly decreased pathing randomness of spawned air and navy units

### New in version 5.6

Released on 2018-02-19

* The Hill Guards (GCs) are now hostile to both teams
* The bot now stops spawning T2 units once the T4 stage has been reached
* The bot now has vision and omni on the entire map
* Intel shared with the players has been reduced to a t1 radar in the hills that share their intel with all players
* Removed (recently broken) lobby option to disable teleporting (in favour of the lobby unit restriction tool)
* The shields of the bots units (most notably the T3 transports) no longer flicker due to power shortage

### New in version 5.5

Released on 2018-02-15

* Rebalanced strategic bomber random event from 8 bombers going for 1 random player to
  3 groups (1 group of 4 and 2 groups of 3) each going for a random player
* Added team bonus options to welcome message (only shown in case there is a bonus)

### New in version 5.4

Released on 2018-02-10

* Added Team Bonus option that allows giving one team a recourse bonus
* Added Team Bonus option that allows decreasing the HP of the enemy units for one team
* Reworked difficulty presets
    * Normal difficulty was renamed to Hard
    * Hard difficulty was renamed to Very hard
    * Easy difficulty was renamed to Easier
    * Added new "Normal" difficulty (the default), slightly easier than Hard (the old Normal)
    * Added new "Easy" difficulty, slightly easier than (the new) Normal
    * Added new "Hard" difficulty, slightly harder than (the new) Normal
* Monkeys and GCs no longer spawn together in a single transport and now separately choose target players
* Added extra values for the HP Increase lobby option
* Added extra values for the wave frequency and wave delay lobby options
* Added extra values for the Auto Reclaim lobby option
* Aggression Tracking is now disabled by default for all difficulties except Very hard and Insane
* Fixed HP increase when playing with Total Veterancy (HP will now increase rather than stay the same)

### New in version 5.3

Released on 2017-12-25

* Changed default difficulty from EASY to NORMAL (NORMAL is a lot more difficult as the game progresses)
* ACU hiding is now prevented by default in Survival Versus (but can be enabled with via the options)
* Modified lobby options are now (mostly) highlighted in the welcome message
* Added 125% and 150% values to the Auto Reclaim option
* Fixed "Can kill transports" showing the opposite of the actual option in the welcome message

### New in version 5.2

Released on 2017-12-10

* Added option to set if the survival transports can be killed
* Added option to set if ACU hiding should be prevented
* Fixed Novax not being buildable

### New in version 5.1

Released on 2017-10-29

* Fixed random event units spawning only for bottom team players
* Added messages showing detailed game settings at the start of the game
* Decreased default HP increase on easy from 11.11% to 10%

### New in version 5

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

If you have Docker and Docker Compose installed, you can run the tests with

    docker-compose run --rm app busted

## Authors

The authors of the original map are Commander-Chronicles, TV-Nobby and Diegobah. Fixes where later
made by ozonex.

This version of the map includes files from the FinalRushPro3 mod, which was created by CommanderChronicles.

Changes in version 5.x are by [EntropyWins][Entropy]. The version 5 preview image was created by JuiceBoy.

[FAF]: http://www.faforever.com/
[docs]: https://wiki.faforever.com/index.php?title=Final_Rush_Pro_5
[download]: https://github.com/JeroenDeDauw/FinalRushPro5/archive/master.zip
[GitHub]: https://github.com/JeroenDeDauw/FinalRushPro5/
[Busted]: http://olivinelabs.com/busted/
[Entropy]: https://entropywins.wtf/
