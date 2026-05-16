-- elevator/server.lua

RegisterNetEvent("elevator:teleport", function(elevatorId, floorIndex)
    local src      = source
    local elevator = Config.Elevators[elevatorId]

    -- Validate elevator ID
    if not elevator then
        print(("[Elevator] Player %d sent invalid elevatorId: %s"):format(src, tostring(elevatorId)))
        return
    end

    -- Validate floor index
    if type(floorIndex) ~= "number" or floorIndex < 1 or floorIndex > #elevator.floors then
        print(("[Elevator] Player %d sent invalid floorIndex: %s"):format(src, tostring(floorIndex)))
        return
    end

    local targetCoords = elevator.floors[floorIndex].coords
    TriggerClientEvent("elevator:doTeleport", src, targetCoords)
end)