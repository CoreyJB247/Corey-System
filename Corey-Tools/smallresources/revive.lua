--- Config ---

local reviveWait = -1 -- Change the amount of time to wait before allowing revive (in seconds).

--- Code ---
local timerCount = reviveWait
local isDead = false
local textUIShown = false

-- Turn off automatic respawn here instead of updating FiveM file.
AddEventHandler('onClientMapStart', function()
    Citizen.Trace("RPRevive: Disabling the autospawn.")
    exports.spawnmanager:spawnPlayer() -- Ensure player spawns into server.
    Citizen.Wait(2500)
    exports.spawnmanager:setAutoSpawn(false)
    Citizen.Trace("RPRevive: Autospawn is disabled.")
end)

function respawnPed(ped, coords)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
    SetPlayerInvincible(ped, false)
    TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
    ClearPedBloodDamage(ped)
end

function revivePed(ped)
    local playerPos = GetEntityCoords(ped, true)
    isDead = false
    timerCount = reviveWait
    NetworkResurrectLocalPlayer(playerPos, true, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
end

Citizen.CreateThread(function()
    local respawnCount = 0
    local spawnPoints = {}
    local playerIndex = NetworkGetPlayerIndex(-1) or 0
    math.randomseed(playerIndex)

    function createSpawnPoint(x1, x2, y1, y2, z, heading)
        local xValue = math.random(x1, x2) + 0.0001
        local yValue = math.random(y1, y2) + 0.0001

        local newObject = {
            x = xValue,
            y = yValue,
            z = z + 0.0001,
            heading = heading + 0.0001
        }
        table.insert(spawnPoints, newObject)
    end

    createSpawnPoint(-448, -448, -340, -329, 35.5, 0) -- Mount Zonah
    createSpawnPoint(372, 375, -596, -594, 30.0, 0)   -- Pillbox Hill
    createSpawnPoint(335, 340, -1400, -1390, 34.0, 0) -- Central Los Santos
    createSpawnPoint(1850, 1854, 3700, 3704, 35.0, 0) -- Sandy Shores
    createSpawnPoint(-247, -245, 6328, 6332, 33.5, 0) -- Paleto

    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)

        if IsEntityDead(ped) then
            isDead = true
            SetPlayerInvincible(ped, true)
            SetEntityHealth(ped, 1)

            -- Build label depending on whether the timer has expired
            local label
            if timerCount > 0 then
                label = ('You are dead. Wait **%ds** before reviving.\n[**E**] Revive   [**R**] Respawn'):format(timerCount)
            else
                label = 'You are dead.\n[**E**] Revive   [**R**] Respawn'
            end

            -- Show or update the ox_lib text UI
            if not textUIShown then
                lib.showTextUI(label, { position = 'bottom-center' })
                textUIShown = true
            else
                lib.showTextUI(label, { position = 'bottom-center' })
            end

            -- Revive
            if IsControlJustReleased(0, 38) and GetLastInputMethod(0) then
                if timerCount <= 0 then
                    lib.hideTextUI()
                    textUIShown = false
                    revivePed(ped)
                else
                    -- Timer message is already shown in the text UI; no extra notification needed
                end
            -- Respawn
            elseif IsControlJustReleased(0, 45) and GetLastInputMethod(0) then
                local coords = spawnPoints[math.random(1, #spawnPoints)]
                lib.hideTextUI()
                textUIShown = false
                respawnPed(ped, coords)
                isDead = false
                timerCount = reviveWait
                respawnCount = respawnCount + 1
                math.randomseed(playerIndex * respawnCount)
            end
        else
            -- Player is alive — hide the UI if it was showing
            if textUIShown then
                lib.hideTextUI()
                textUIShown = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isDead then
            timerCount = timerCount - 1
        end
        Citizen.Wait(1000)
    end
end)