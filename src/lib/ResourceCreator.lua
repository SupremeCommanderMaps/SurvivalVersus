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
        end
    }
end

