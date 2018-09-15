newInstance = function(resourceCreator, playerArmies)
    return {
        spawnResources = function()
            resourceCreator.createHydro(VECTOR3(295.5, 25.9844, 443.5))
            resourceCreator.createHydro(VECTOR3(313.5, 25.9844, 443.5))
            resourceCreator.createHydro(VECTOR3(313.5, 25.9844, 461.5))

            resourceCreator.createHydro(VECTOR3(367.5, 25.9844, 427.5))
            resourceCreator.createHydro(VECTOR3(385.5, 25.9844, 427.5))
            resourceCreator.createHydro(VECTOR3(367.5, 25.9844, 445.5))

            resourceCreator.createHydro(VECTOR3(427.5, 25.9844, 367.5))
            resourceCreator.createHydro(VECTOR3(445.5, 25.9844, 367.5))
            resourceCreator.createHydro(VECTOR3(427.5, 25.9844, 385.5))

            resourceCreator.createHydro(VECTOR3(443.5, 25.9844, 295.5))
            resourceCreator.createHydro(VECTOR3(461.5, 25.9844, 313.5))
            resourceCreator.createHydro(VECTOR3(443.5, 25.9844, 313.5))



--            resourceCreator.createHydro(VECTOR3())
--            resourceCreator.createHydro(VECTOR3())
--            resourceCreator.createHydro(VECTOR3())
        end
    }
end