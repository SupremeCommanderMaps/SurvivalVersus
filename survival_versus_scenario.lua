version = 3
ScenarioInfo = {
    name="Survival Versus",
    map_version=27,
    description="Survive longer than the other team to win the game. Survive till the end of the final stage for full victory. https://github.com/SupremeCommanderMaps/SurvivalVersus",
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
    map="/maps/survival_versus.v0027/survival_versus.scmap",
    preview="/maps/survival_versus.v0027/preview.jpg",
    save="/maps/survival_versus.v0027/survival_versus_save.lua",
    script="/maps/survival_versus.v0027/survival_versus_script.lua",
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
