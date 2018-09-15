local TransportDestinations = {
    SouthernAttackerEnd = VECTOR3(500,80,10),
    NorthernAttackerEnd = VECTOR3(10,80,500)
}

local AttackLocations = {
    Team1 = {
        Player1 = VECTOR3( 305.5, 25.9844, 451.5 ),
        Player2 = VECTOR3( 375.5, 25.9844, 435.5 ),
        Player3 = VECTOR3( 435.5, 25.9844, 375.5 ),
        Player4 = VECTOR3( 451.5, 25.9844, 305.5 )
    },
    Team2 = {
        Player1 = VECTOR3( 206.5, 25.9844, 60.5 ),
        Player2 = VECTOR3( 132.5, 25.9922, 71.5 ),
        Player3 = VECTOR3( 71.5, 25.9922, 132.5 ),
        Player4 = VECTOR3( 68.5, 25.9844, 214.5 )
    }
}

local transports = {
    BOTTOM_BOT = {
        spawnPosition = {
            x = 500,
            y = 10
        },
        finalDestination = TransportDestinations.SouthernAttackerEnd
    },
    TOP_BOT = {
        spawnPosition = {
            x = 10,
            y = 500
        },
        finalDestination = TransportDestinations.NorthernAttackerEnd
    }
}

function newInstance()
    return {
        TransportDestinations = TransportDestinations,
        AttackLocations = AttackLocations,
        transports = transports,
        mapCenter = VECTOR3( 255, 25.9844, 255 )
    }
end


