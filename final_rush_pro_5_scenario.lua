version = 3
ScenarioInfo = {
    name="Final Rush Pro 5",
    map_version=20,
    description=[[This map supports multiple game modes.

1. Survival Versus
-----------------------

Survive longer than the other team to win the game. Survive till the end of the final stage for full victory.

Waves of increasingly strong survival units assault your base from the center of the map. This makes it difficult to attack the enemy team and hasten their demise, though this is certainly possible.

2. Survival Classic
-----------------------

Survive till the end of the final stage to win the game. Playable with 1 to 8 people. Best played with 2 groups of 4.

Waves of increasingly strong survival units assault your base from the center of the map.

3. Paragon Wars
----------------------

In Paragon Wars, the two teams fight for control over the centre of the map, where an enemy civilian base guards the Paragon Activator. Whoever captures the Paragon Activator gets a paragon for one minute. Once the minute expires, the centre of the map gets cleared and a new civilian base with Paragon Activator spawns.

4. Normal
------------

The Normal mode allows you to play on the map without survival units being spawned.

For more information, see the README.md (text file) located in "Maps/final_rush_pro_5.v0020", or visit the site at https://github.com/JeroenDeDauw/FinalRushPro5]],
    norushoffsetX_ARMY_BOTTOM_LEFT=0,
    norushoffsetX_ARMY_BOTTOM_LMID=0,
    norushoffsetX_ARMY_BOTTOM_RMID=0,
    norushoffsetX_ARMY_BOTTOM_RIGHT=0,
    norushoffsetX_ARMY_TOP_RIGHT=0,
    norushoffsetX_ARMY_TOP_RMID=0,
    norushoffsetX_ARMY_TOP_LMID=0,
    norushoffsetX_ARMY_TOP_LEFT=0,
    norushoffsetY_ARMY_BOTTOM_LEFT=0,
    norushoffsetY_ARMY_BOTTOM_LMID=0,
    norushoffsetY_ARMY_BOTTOM_RMID=0,
    norushoffsetY_ARMY_BOTTOM_RIGHT=0,
    norushoffsetY_ARMY_TOP_RIGHT=0,
    norushoffsetY_ARMY_TOP_RMID=0,
    norushoffsetY_ARMY_TOP_LMID=0,
    norushoffsetY_ARMY_TOP_LEFT=0,
    norushradius=110,
    map="/maps/final_rush_pro_5.v0020/final_rush_pro_5.scmap",
    preview="/maps/final_rush_pro_5.v0020/preview.jpg",
    save="/maps/final_rush_pro_5.v0020/final_rush_pro_5_save.lua",
    script="/maps/final_rush_pro_5.v0020/final_rush_pro_5_script.lua",
    size={ 512, 512 },
    starts=true,
    type="skirmish",
    Configurations={
        standard={
            customprops={ ExtraArmies="BOTTOM_BOT TOP_BOT HOSTILE_BOT FRIENDLY_BOT" },
            teams={
                {
                    armies={
                        "ARMY_BOTTOM_LEFT",
                        "ARMY_BOTTOM_LMID",
                        "ARMY_BOTTOM_RMID",
                        "ARMY_BOTTOM_RIGHT",
                        "ARMY_TOP_RIGHT",
                        "ARMY_TOP_RMID",
                        "ARMY_TOP_LMID",
                        "ARMY_TOP_LEFT"
                    },
                    name="FFA"
                }
            }
        }
    }
}
