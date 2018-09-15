version = 3
ScenarioInfo = {
    name="Final Rush Pro 5",
    map_version=17,
    description=[[Version 5.17

This map supports multiple game modes: Survival, Survival Versus, Paragon Wars and Normal.

In the Survival modes, waves of increasingly strong enemy units get spawned and your mission is to survive as long as possible. Beware that you cannot put your ACU into the water or hide in the hills behind your base; both will result in it being destroyed.

In Survival Versus, two teams, each on their side of the map, get waves of enemy units. The team that holds out the longest wins. If the pressure is not high enough, you can attack the enemy team, to put them out of their misery faster :)

In Paragon Wars, the two teams fight for control over the centre of the map, where an enemy civilian base guards the Paragon Activator. Whoever captures the Paragon Activator gets a paragon for one minute. Once the minute expires, the centre of the map gets cleared and a new civilian base with Paragon Activator spawns.

At the left and right corners of the map, civilian lighthouses get spawned. These can be captured for extra map vision.

More comprehensive documentation can be found at bit.ly/final-rush-pro

Version of the 5 adds several new features and fixes many bugs. For more information, see the README.md (text file) located in "Maps/final_rush_pro_5.v0017", or visit the site at https://github.com/JeroenDeDauw/FinalRushPro5]],
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
    map="/maps/final_rush_pro_5.v0017/final_rush_pro_5.scmap",
    preview="/maps/final_rush_pro_5.v0017/preview.jpg",
    save="/maps/final_rush_pro_5.v0017/final_rush_pro_5_save.lua",
    script="/maps/final_rush_pro_5.v0017/final_rush_pro_5_script.lua",
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
