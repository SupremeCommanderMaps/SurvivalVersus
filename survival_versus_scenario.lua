version = 3 -- Lua Version. Dont touch this
ScenarioInfo = {
    name = "Survival Versus",
    description = "Survive longer than the other team to win the game. Survive till the end of the final stage for full victory. https://github.com/SupremeCommanderMaps/SurvivalVersus",
    preview = '/maps/survival_versus.V0030/preview.jpg',
    map_version = 30,
    AdaptiveMap = true,
    type = 'skirmish',
    starts = true,
    size = {512, 512},
    reclaim = {0, 0},
    map = '/maps/survival_versus.V0030/survival_versus.scmap',
    save = '/maps/survival_versus.V0030/survival_versus_save.lua',
    script = '/maps/survival_versus.V0030/survival_versus_script.lua',
    norushradius = 110,
    Configurations = {
        ['standard'] = {
            teams = {
                {
                    name = 'FFA',
                    armies = {'ARMY_BOTTOM_LEFT', 'ARMY_BOTTOM_LMID', 'ARMY_BOTTOM_RMID', 'ARMY_BOTTOM_RIGHT', 'ARMY_TOP_RIGHT', 'ARMY_TOP_RMID', 'ARMY_TOP_LMID', 'ARMY_TOP_LEFT'}
                },
            },
            customprops = {
                ['ExtraArmies'] = STRING( 'BOTTOM_BOT TOP_BOT HOSTILE_BOT FRIENDLY_BOT' ),
            },
        },
    },
}
