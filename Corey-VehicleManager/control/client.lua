-- Vehicle Control Menu
-- Page Up = open menu | Page Down = toggle lock

local menuOpen = false
local isPersonalVehicle = false
local trackingEnabled = false
local keylessEnabled = false
local engineAlwaysOn = false
local isLocked = false
local personalVehicle = nil
local blipHandle = nil

-- ox_lib notification wrapper
local function notify(msg, notifyType, duration)
    lib.notify({
        title = 'Vehicle Control',
        description = msg,
        type = notifyType or 'inform',
        duration = duration or 3000,
        position = 'bottom-center'
    })
end

-- Toggle the NUI menu
local function toggleMenu(state)
    menuOpen = state
    SetNuiFocus(state, state)
    SendNUIMessage({ type = "toggleMenu", show = state })
end

-- Get current or personal vehicle
local function getVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then return veh end
    if personalVehicle and DoesEntityExist(personalVehicle) then return personalVehicle end
    notify('No vehicle found!', 'error')
    return nil
end

-- Build vehicle data for UI (doors, seats, liveries, extras)
local function buildVehicleData(vehicle)
    local data = {
        numSeats   = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)),
        doors      = {},
        extras     = {},
        liveries   = {},
        liveryCount = 0,
    }

    -- Doors: try to open each door briefly to check if it exists.
    -- GetVehicleDoorAngleRatio returns -1.0 for non-existent doors.
    -- Standard doors 0-3 always exist; 4 (hood) and 5 (trunk) usually do.
    -- 6 and 7 are rare extras. We detect by checking if the angle is >= 0.
    for d = 0, 7 do
        -- A door exists if its angle ratio is not exactly -1.0 (the sentinel for no door)
        local angle = GetVehicleDoorAngleRatio(vehicle, d)
        if angle >= 0.0 then
            table.insert(data.doors, {
                index = d,
                open  = angle > 0.1
            })
        end
    end

    -- Extras 1-12
    for i = 1, 12 do
        if DoesExtraExist(vehicle, i) then
            table.insert(data.extras, {
                index = i,
                on    = IsVehicleExtraTurnedOn(vehicle, i)
            })
        end
    end

    -- Liveries
    local count = GetVehicleLiveryCount(vehicle)
    data.liveryCount = count
    if count > 0 then
        data.currentLivery = GetVehicleLivery(vehicle)
        for i = 0, count - 1 do
            local label = GetLabelText('CMOD_LVR' .. i)
            if label == 'NULL' or label == '' then label = 'Livery ' .. (i + 1) end
            table.insert(data.liveries, { index = i, label = label })
        end
    end

    return data
end

-- Update UI with current vehicle state
local function updateUI()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local inVehicle = vehicle ~= 0
    local veh = vehicle ~= 0 and vehicle or personalVehicle

    local vehicleData = nil
    if veh and DoesEntityExist(veh) then
        vehicleData = buildVehicleData(veh)
    end

    SendNUIMessage({
        type             = "updateState",
        inVehicle        = inVehicle,
        isPersonalVehicle = isPersonalVehicle,
        trackingEnabled  = trackingEnabled,
        keylessEnabled   = keylessEnabled,
        engineAlwaysOn   = engineAlwaysOn,
        vehicleName      = veh and DoesEntityExist(veh) and GetDisplayNameFromVehicleModel(GetEntityModel(veh)) or "None",
        vehicleData      = vehicleData
    })
end

-- Keyfob animation
local function pressKeyFob()
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local animDict = "anim@mp_keyfob"
        local animName = "fob_click"

        -- Load anim dict
        RequestAnimDict(animDict)
        local timeout = GetGameTimer() + 3000
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
            if GetGameTimer() > timeout then return end
        end

        -- Load prop model
        local fobModel = GetHashKey("prop_car_keys_01")
        RequestModel(fobModel)
        timeout = GetGameTimer() + 3000
        while not HasModelLoaded(fobModel) do
            Citizen.Wait(0)
            if GetGameTimer() > timeout then
                RemoveAnimDict(animDict)
                return
            end
        end

        -- Spawn prop and attach to right hand (bone 57005 = SKEL_R_Hand)
        local fob = CreateObject(fobModel, 0.0, 0.0, 0.0, true, true, false)
        AttachEntityToEntity(fob, ped, GetPedBoneIndex(ped, 57005),
            0.09, 0.03, -0.02, -76.0, 13.0, 28.0,
            false, true, true, true, 0, true)
        SetModelAsNoLongerNeeded(fobModel)

        -- Play the animation (flag 48 = upperbody only so walking still works)
        TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, 1500, 48, 0.0, false, false, false)
        Citizen.Wait(1500)

        -- Cleanup
        ClearPedTasks(ped)
        if DoesEntityExist(fob) then DeleteObject(fob) end
        RemoveAnimDict(animDict)
    end)
end

-- Horn + light flash (vMenu SoundVehicleHornThisFrame approach)
local function honkFor(vehicle, ms)
    Citizen.CreateThread(function()
        local endTime = GetGameTimer() + ms
        while GetGameTimer() < endTime do
            if DoesEntityExist(vehicle) then SoundVehicleHornThisFrame(vehicle) end
            Wait(0)
        end
    end)
end

local function lockFeedback(vehicle, locked)
    if not DoesEntityExist(vehicle) then return end
    pressKeyFob()
    Citizen.CreateThread(function()
        if locked then
            honkFor(vehicle, 200)
            SetVehicleLights(vehicle, 2)
            Wait(350)
            SetVehicleLights(vehicle, 0)
        else
            honkFor(vehicle, 150)
            SetVehicleLights(vehicle, 2)
            Wait(250)
            SetVehicleLights(vehicle, 0)
            Wait(100)
            honkFor(vehicle, 150)
            SetVehicleLights(vehicle, 2)
            Wait(250)
            SetVehicleLights(vehicle, 0)
        end
    end)
end

-- Set/unset personal vehicle
local function setPersonalVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        notify('You must be in a vehicle!', 'error')
        return
    end

    if isPersonalVehicle and personalVehicle == vehicle then
        isPersonalVehicle = false
        personalVehicle   = nil
        isLocked          = false
        if blipHandle and DoesBlipExist(blipHandle) then
            RemoveBlip(blipHandle)
            blipHandle = nil
        end
        trackingEnabled = false
        keylessEnabled  = false
        notify('Personal vehicle removed.', 'inform')
    else
        isPersonalVehicle = true
        personalVehicle   = vehicle
        isLocked          = true
        SetVehicleDoorsLocked(vehicle, 2)
        notify('Vehicle set as personal & locked!', 'success')
    end
    updateUI()
end

-- Toggle lock
local function toggleLock()
    local targetVehicle = personalVehicle
    if not targetVehicle or not DoesEntityExist(targetVehicle) then
        local ped = PlayerPedId()
        targetVehicle = GetVehiclePedIsIn(ped, false)
        if targetVehicle == 0 then return end
    end
    isLocked = not isLocked
    SetVehicleDoorsLocked(targetVehicle, isLocked and 2 or 1)
    lockFeedback(targetVehicle, isLocked)
    notify(isLocked and '🔒 Vehicle Locked' or '🔓 Vehicle Unlocked', 'inform')
end

-- Toggle tracking
local function toggleTracking()
    if not isPersonalVehicle or not personalVehicle then
        notify('Set a personal vehicle first!', 'error')
        return
    end
    trackingEnabled = not trackingEnabled
    if trackingEnabled then
        -- Use a coordinate-based blip so it stays visible across the full map
        -- even when the vehicle entity is streamed out (far away).
        local coords = GetEntityCoords(personalVehicle)
        if not (blipHandle and DoesBlipExist(blipHandle)) then
            blipHandle = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blipHandle, 225)
            SetBlipColour(blipHandle, 4)
            SetBlipScale(blipHandle, 0.9)
            SetBlipAsShortRange(blipHandle, false)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Personal Vehicle")
            EndTextCommandSetBlipName(blipHandle)
        end
        notify('Tracking enabled.', 'success')
    else
        if blipHandle and DoesBlipExist(blipHandle) then
            RemoveBlip(blipHandle)
            blipHandle = nil
        end
        notify('Tracking disabled.', 'inform')
    end
    updateUI()
end

-- Toggle keyless entry
local function toggleKeyless()
    if not isPersonalVehicle or not personalVehicle then
        notify('Set a personal vehicle first!', 'error')
        return
    end
    keylessEnabled = not keylessEnabled
    notify(keylessEnabled and 'Keyless entry enabled.' or 'Keyless entry disabled.', keylessEnabled and 'success' or 'inform')
    updateUI()
end

-- Toggle engine always on
local function toggleEngine()
    engineAlwaysOn = not engineAlwaysOn
    notify(engineAlwaysOn and 'Engine always on enabled.' or 'Engine always on disabled.', engineAlwaysOn and 'success' or 'inform')
    updateUI()
end

-- Engine always on thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if engineAlwaysOn then
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle ~= 0 then SetVehicleEngineOn(vehicle, true, true, false) end
        end
    end
end)

-- Tracking blip update thread
-- Polls the personal vehicle coords every second and moves the blip to match.
-- Because we use AddBlipForCoord (not AddBlipForEntity), the blip stays on the
-- map even when the vehicle entity is streamed out at long range.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if trackingEnabled and personalVehicle and blipHandle and DoesBlipExist(blipHandle) then
            if DoesEntityExist(personalVehicle) then
                -- Entity is loaded — get its live coords
                local coords = GetEntityCoords(personalVehicle)
                SetBlipCoords(blipHandle, coords.x, coords.y, coords.z)
            end
            -- If entity isn't loaded (streamed out), coords stay at last known position,
            -- which is fine — the blip keeps showing where the car last was.
        end
    end
end)

-- Keyless entry thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if keylessEnabled and personalVehicle and DoesEntityExist(personalVehicle) then
            local ped = PlayerPedId()
            local dist = #(GetEntityCoords(ped) - GetEntityCoords(personalVehicle))
            local wasLocked = isLocked
            if dist < 6.0 then
                SetVehicleDoorsLocked(personalVehicle, 1)
                isLocked = false
            else
                SetVehicleDoorsLocked(personalVehicle, 2)
                isLocked = true
            end
            if wasLocked ~= isLocked then lockFeedback(personalVehicle, isLocked) end
        end
    end
end)

-- Keybinds
RegisterKeyMapping('vehiclemenu', 'Open Vehicle Control Menu', 'keyboard', 'PRIOR')
RegisterKeyMapping('vehiclelock', 'Toggle Vehicle Lock',        'keyboard', 'NEXT')

RegisterCommand('vehiclemenu', function()
    if menuOpen then
        toggleMenu(false)
    else
        updateUI()
        toggleMenu(true)
    end
end, false)

RegisterCommand('vehiclelock', function() toggleLock() end, false)

-- Escape to close
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuOpen and IsControlJustPressed(0, 177) then toggleMenu(false) end
    end
end)

-- ── NUI Callbacks ──────────────────────────────────────────────

RegisterNUICallback('closeMenu', function(_, cb) toggleMenu(false) cb('ok') end)
RegisterNUICallback('setPersonalVehicle', function(_, cb) setPersonalVehicle() cb('ok') end)
RegisterNUICallback('toggleTracking',     function(_, cb) toggleTracking()     cb('ok') end)
RegisterNUICallback('toggleKeyless',      function(_, cb) toggleKeyless()      cb('ok') end)
RegisterNUICallback('toggleEngine',       function(_, cb) toggleEngine()       cb('ok') end)

RegisterNUICallback('repairVehicle', function(_, cb)
    ExecuteCommand('repair')
    notify('Repair command sent!', 'success')
    cb('ok')
end)

RegisterNUICallback('washVehicle', function(_, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        SetVehicleDirtLevel(vehicle, 0.0)
        notify('Vehicle washed!', 'success')
    else
        notify('You must be in a vehicle!', 'error')
    end
    cb('ok')
end)

-- Doors
local doorNames = {
    [0]='Front Left',[1]='Front Right',[2]='Rear Left',[3]='Rear Right',
    [4]='Hood',[5]='Trunk',[6]='Extra Door 1',[7]='Extra Door 2'
}

RegisterNUICallback('toggleAllDoors', function(_, cb)
    local vehicle = getVehicle()
    if vehicle then
        -- Check if any door is open
        local anyOpen = false
        for i = 0, 7 do
            if GetVehicleDoorAngleRatio(vehicle, i) > 0.1 then
                anyOpen = true
                break
            end
        end
        -- Toggle: if any open then close all, else open all
        for i = 0, 7 do
            if anyOpen then
                SetVehicleDoorShut(vehicle, i, false)
            else
                SetVehicleDoorOpen(vehicle, i, false, false)
            end
        end
        notify(anyOpen and 'All doors closed.' or 'All doors opened.', 'inform')
        -- Refresh UI
        Wait(100)
        updateUI()
    end
    cb('ok')
end)

for doorIndex = 0, 7 do
    RegisterNUICallback('toggleDoor' .. doorIndex, function(_, cb)
        local vehicle = getVehicle()
        if vehicle then
            local isOpen = GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0.1
            if isOpen then
                SetVehicleDoorShut(vehicle, doorIndex, false)
                notify((doorNames[doorIndex] or 'Door') .. ' closed.', 'inform')
            else
                SetVehicleDoorOpen(vehicle, doorIndex, false, false)
                notify((doorNames[doorIndex] or 'Door') .. ' opened.', 'inform')
            end
            Wait(50)
            SendNUIMessage({
                type = 'doorState',
                door = doorIndex,
                open = not isOpen
            })
        end
        cb('ok')
    end)
end

-- Windows
local windowNames = {[0]='Front Left',[1]='Front Right',[2]='Rear Left',[3]='Rear Right'}
local windowOpen  = {false, false, false, false}

for winIndex = 0, 3 do
    RegisterNUICallback('toggleWindow' .. winIndex, function(_, cb)
        local vehicle = getVehicle()
        if vehicle then
            windowOpen[winIndex + 1] = not windowOpen[winIndex + 1]
            if windowOpen[winIndex + 1] then
                RollDownWindow(vehicle, winIndex)
                notify(windowNames[winIndex] .. ' window down.', 'inform')
            else
                RollUpWindow(vehicle, winIndex)
                notify(windowNames[winIndex] .. ' window up.', 'inform')
            end
            SendNUIMessage({ type = 'windowState', win = winIndex, open = windowOpen[winIndex + 1] })
        end
        cb('ok')
    end)
end

RegisterNUICallback('allWindows', function(_, cb)
    local vehicle = getVehicle()
    if vehicle then
        local anyOpen = false
        for i = 1, 4 do if windowOpen[i] then anyOpen = true break end end
        for i = 0, 3 do
            windowOpen[i + 1] = not anyOpen
            if anyOpen then RollUpWindow(vehicle, i) else RollDownWindow(vehicle, i) end
            SendNUIMessage({ type = 'windowState', win = i, open = windowOpen[i + 1] })
        end
        notify(anyOpen and 'All windows up.' or 'All windows down.', 'inform')
    end
    cb('ok')
end)

-- Seats
local seatLabels = {
    [-1]='Driver seat',[0]='Front passenger',[1]='Rear left',[2]='Rear right',
    [3]='Row 3 left',[4]='Row 3 mid',[5]='Row 3 right',[6]='Seat 8',[7]='Seat 9'
}

RegisterNUICallback('getSeat', function(data, cb)
    local vehicle = getVehicle()
    if vehicle then
        local seatIndex = tonumber(data.seat)
        if IsVehicleSeatFree(vehicle, seatIndex) or seatIndex == -1 then
            SetPedIntoVehicle(PlayerPedId(), vehicle, seatIndex)
            notify('Moved to ' .. (seatLabels[seatIndex] or 'seat') .. '.', 'success')
        else
            notify('That seat is occupied!', 'error')
        end
    end
    cb('ok')
end)

-- Extras
RegisterNUICallback('toggleExtra', function(data, cb)
    local vehicle = getVehicle()
    if vehicle then
        local extraIndex = tonumber(data.extra)
        if DoesExtraExist(vehicle, extraIndex) then
            local isOn = IsVehicleExtraTurnedOn(vehicle, extraIndex)
            SetVehicleExtra(vehicle, extraIndex, isOn and 1 or 0)
            SendNUIMessage({ type = 'extraState', extra = extraIndex, on = not isOn })
            notify('Extra ' .. extraIndex .. (isOn and ' off.' or ' on.'), 'inform')
        else
            notify('Extra ' .. extraIndex .. ' not on this vehicle.', 'error')
        end
    end
    cb('ok')
end)

-- Livery
RegisterNUICallback('setLivery', function(data, cb)
    local vehicle = getVehicle()
    if vehicle then
        local liveryIndex = tonumber(data.livery)
        SetVehicleLivery(vehicle, liveryIndex)
        notify('Livery applied.', 'success')
    end
    cb('ok')
end)

print("^2[VehicleControl]^7 Loaded. ^3Page Up^7 = Menu | ^3Page Down^7 = Lock/Unlock")