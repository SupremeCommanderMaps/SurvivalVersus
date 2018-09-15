newInstance = function()
    return {
        createHydro = function(positionVector)
            local hydroInfo = {
                x = positionVector[1],
                z = positionVector[2],
                y = positionVector[3]
            }

            -- create the resource
            CreateResourceDeposit("Hydrocarbon", hydroInfo.x, hydroInfo.z, hydroInfo.y, 3.00)

            -- create the resource graphic on the map
            CreatePropHPR(
                "/env/common/props/hydrocarbonDeposit01_prop.bp",
                hydroInfo.x,
                hydroInfo.z,
                hydroInfo.y,
                0, -- heading
                0, -- pitch
                0 -- roll
            )

            -- create the resource icon on the map
            CreateSplat(
                { hydroInfo.x, hydroInfo.z, hydroInfo.y },
                0, -- Heading (rotation)
                "/env/common/splats/hydrocarbon_marker.dds", -- Texture name for albedo
                6, 6, -- SizeX/Z
                200, -- LOD
                0, -- Duration (0 == does not expire)
                -1, -- army (-1 == not owned by any single army)
                0
            )
        end,

        createMex = function(positionVector)
            local mexInfo = {
                x = positionVector[1],
                z = positionVector[2],
                y = positionVector[3]
            }

            CreateResourceDeposit("Mass", mexInfo.x, mexInfo.z, mexInfo.y, 1.00)

            CreatePropHPR(
                '/env/common/props/massDeposit01_prop.bp',
                mexInfo.x,
                mexInfo.z,
                mexInfo.y,
                0, -- heading
                0, -- pitch
                0 -- roll
            )

            CreateSplat(
                { mexInfo.x, mexInfo.z, mexInfo.y },
                0, -- Heading (rotation)
                "/env/common/splats/mass_marker.dds", -- Texture name for albedo
                2, 2, -- SizeX/Z
                100, -- LOD
                0, -- Duration (0 == does not expire)
                -1, -- army (-1 == not owned by any single army)
                0
            )
        end
    }
end

