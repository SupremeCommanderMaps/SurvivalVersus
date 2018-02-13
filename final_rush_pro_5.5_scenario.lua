version = 5
ScenarioInfo = {
    name="Final Rush Pro 5.4",
    map_version=1,
    description=[[More comprehensive documentation can be found at bit.ly/final-rush-pro

This map supports multiple game modes: Survival, Survival Versus, Paragon Wars and Normal.

In the Survival modes, waves of increasingly strong enemy units get spawned and your mission is to survive as long as possible. Beware that you cannot put your ACU into the water or hide in the hills behind your base; both will result in it being destroyed.

In Survival Versus, two teams, each on their side of the map, get waves of enemy units. The team that holds out the longest wins. If the pressure is not high enough, you can attack the enemy team, to put them out of their misery faster :)

In Paragon Wars, the two teams fight for control over the centre of the map, where an enemy civilian base guards the Paragon Activator. Whoever captures the Paragon Activator gets a paragon for one minute. Once the minute expires, the centre of the map gets cleared and a new civilian base with Paragon Activator spawns.

At the left and right corners of the map, civilian lighthouses get spawned. These can be captured for extra map vision.

Version of the 5 adds several new features and fixes many bugs. For more information, see the README.md (text file) located in "Maps/final_rush_pro_5.5.v0001", or visit the site at https://github.com/JeroenDeDauw/FinalRushPro5]],
    norushoffsetX_ARMY_1=0,
    norushoffsetX_ARMY_2=0,
    norushoffsetX_ARMY_3=0,
    norushoffsetX_ARMY_4=0,
    norushoffsetX_ARMY_5=0,
    norushoffsetX_ARMY_6=0,
    norushoffsetX_ARMY_7=0,
    norushoffsetX_ARMY_8=0,
    norushoffsetY_ARMY_1=0,
    norushoffsetY_ARMY_2=0,
    norushoffsetY_ARMY_3=0,
    norushoffsetY_ARMY_4=0,
    norushoffsetY_ARMY_5=0,
    norushoffsetY_ARMY_6=0,
    norushoffsetY_ARMY_7=0,
    norushoffsetY_ARMY_8=0,
    norushradius=110,
    map="/maps/final_rush_pro_5.5.v0001/final_rush_pro_5.5.scmap",
    preview="/maps/final_rush_pro_5.5.v0001/preview.jpg",
    save="/maps/final_rush_pro_5.5.v0001/final_rush_pro_5.5_save.lua",
    script="/maps/final_rush_pro_5.5.v0001/final_rush_pro_5.5_script.lua",
    size={ 512, 512 },
    starts=true,
    type="skirmish",
    Configurations={
        standard={
            customprops={ ExtraArmies="ARMY_9 NEUTRAL_CIVILIAN" },
            teams={
                {
                    armies={
                        "ARMY_1",
                        "ARMY_2",
                        "ARMY_3",
                        "ARMY_4",
                        "ARMY_5",
                        "ARMY_6",
                        "ARMY_7",
                        "ARMY_8"
                    },
                    name="FFA"
                }
            }
        }
    }
}
