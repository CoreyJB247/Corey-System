-- elevator/client.lua

-- Returns the index of the floor the player is currently closest to (within 3m vertically)
local function getCurrentFloorIndex(elevator)
    local playerCoords = GetEntityCoords(PlayerPedId())
    for i, zone in ipairs(elevator.zones) do
        if math.abs(playerCoords.z - zone.z) < 3.0
        and #(vector2(playerCoords.x, playerCoords.y) - vector2(zone.x, zone.y)) < 5.0 then
            return i
        end
    end
    return nil
end

-- Opens the floor-selection context menu for a given elevator
local function openElevatorMenu(elevatorId)
    local elevator = Config.Elevators[elevatorId]
    if not elevator then return end

    local currentFloor = getCurrentFloorIndex(elevator)

    local options = {}
    for i, floor in ipairs(elevator.floors) do
        local label = floor.label
        if i == currentFloor then
            label = ("%s [Current]"):format(label)
        end
        options[#options + 1] = {
            title    = label,
            icon     = "elevator",
            disabled = (i == currentFloor), -- can't travel to the floor you're already on
            onSelect = function()
                TriggerServerEvent("elevator:teleport", elevatorId, i)
            end
        }
    end

    lib.registerContext({
        id      = "elevator_menu",
        title   = ("🛗 %s"):format(elevator.label),
        options = options,
    })
    lib.showContext("elevator_menu")
end

-- Register ox_target sphere zones for every floor of every elevator
CreateThread(function()
    for elevatorId, elevator in pairs(Config.Elevators) do
        for i, zoneCoord in ipairs(elevator.zones) do
            local floor = elevator.floors[i]
            exports.ox_target:addSphereZone({
                coords = zoneCoord,
                radius = Config.ZoneRadius,
                debug  = Config.Debug,
                options = {
                    {
                        name     = ("elevator_%s_floor_%d"):format(elevatorId, i),
                        icon     = "fa-solid fa-elevator",
                        label    = ("Use elevator — %s"):format(floor.label),
                        onSelect = function()
                            openElevatorMenu(elevatorId)
                        end
                    }
                }
            })
        end
    end
end)

-- Server fires this back once it validates the request
RegisterNetEvent("elevator:doTeleport", function(coords)
    local ped = PlayerPedId()

    DoScreenFadeOut(Config.FadeOutMs)
    Wait(Config.FadeOutMs + 100)

    SetEntityCoords(ped, coords.x, coords.y, coords.z - 0.9, false, false, false, true)
    SetEntityHeading(ped, coords.w)

    Wait(300)
    DoScreenFadeIn(Config.FadeInMs)

    lib.notify({
        title       = Config.Notify.title,
        description = Config.Notify.message,
        type        = Config.Notify.type,
        duration    = Config.Notify.duration,
        icon        = Config.Notify.icon,
    })
end)