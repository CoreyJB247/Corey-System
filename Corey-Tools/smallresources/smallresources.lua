if Config.StaminaBuff then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            RestorePlayerStamina(GetPlayerPed(-1), 2.0)
        end
    end)
end

if Config.VehRewards then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            DisablePlayerVehicleRewards(PlayerId())
        end
    end)
end

if Config.WeaponDrops then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local handle, ped = FindFirstPed()
            local finished = false

            repeat
                if not IsEntityDead(ped) then
                    SetPedDropsWeaponsWhenDead(ped, false)
                end
                finished, ped = FindNextPed(handle)
            until not finished

            EndFindPed(handle)
        end
    end)
end

if Config.PVP then
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)
end

if not Config.PistolWhip then
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while true do
            Citizen.Wait(0)
            if IsPedArmed(ped, 6) then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end
        end
    end)
end

if Config.JumpSpam then
    local ragdoll_chance = 0.5
    local ragdoll_time = 5000
    local ragdoll_flags = 1 + 2

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            local ped = PlayerPedId()
            if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and
                not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
                if math.random() < ragdoll_chance then
                    Citizen.Wait(600)
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
                    SetPedToRagdoll(ped, ragdoll_time, ragdoll_flags, 0, false, true, false)
                else
                    Citizen.Wait(2000)
                end
            end
        end
    end)
end

if Config.IdleCam then
    DisableIdleCamera(true)
end

if Config.HideHud then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            for _, v in pairs(Config.HudElements) do
                HideHudComponentThisFrame(v)
            end
        end
    end)
end

if Config.weaponReticle then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            local ped = GetPlayerPed(-1)
            local currentWeaponHash = GetSelectedPedWeapon(ped)
            local isSniper = (currentWeaponHash == 100416529 or
                              currentWeaponHash == 205991906 or
                              currentWeaponHash == -952879014 or
                              currentWeaponHash == GetHashKey('WEAPON_HEAVYSNIPER_MK2'))

            if not isSniper then
                HideHudComponentThisFrame(14)
            end
        end
    end)
end

if not Config.HealthRegen then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(00)
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
            SetPlayerHealthRechargeLimit(PlayerId(), 0.0)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.ManagedDensity and 100 or 1000)

        if Config.ManagedDensity then
            local timeModifier = 1.0
            local weatherModifier = 1.0

            if Config.DynamicPedSpawner then
                local hour = GetClockHours()
                local weather = GetPrevWeatherTypeHashName()

                if hour >= 20 or hour < 6 then
                    timeModifier = 0.5
                end

                if weather == "RAIN" or weather == "THUNDER" then
                    weatherModifier = 0.75
                end
            end

            SetVehicleDensityMultiplierThisFrame(Config.GeneratorsDensity.vehicle * timeModifier * weatherModifier)
            SetParkedVehicleDensityMultiplierThisFrame(Config.GeneratorsDensity.parked * timeModifier * weatherModifier)
            SetRandomVehicleDensityMultiplierThisFrame(Config.GeneratorsDensity.multiplier * timeModifier * weatherModifier)
            SetPedDensityMultiplierThisFrame(Config.GeneratorsDensity.peds * timeModifier * weatherModifier)
            SetScenarioPedDensityMultiplierThisFrame(Config.GeneratorsDensity.actions * timeModifier * weatherModifier, 
                                                     Config.GeneratorsDensity.actions * timeModifier * weatherModifier)

        elseif Config.TrafficZones then
            for _, area in ipairs(Config.TrafficArea) do
                ClearAreaOfPeds(area.pos.x, area.pos.y, area.pos.z, area.radius, false, false, false, false, false)
                ClearAreaOfVehicles(area.pos.x, area.pos.y, area.pos.z, area.radius, false, false, false, false, false)
            end
        end
    end
end)

if Config.DisableAmbientSounds then
    Citizen.CreateThread(function()
        SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, true)
        SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", true, true)
        
        SetAudioFlag("DisableFlightMusic", true)
        SetAudioFlag("PoliceScannerDisabled", true)
        
        SetDeepOceanScaler(0.0)

        SetRandomEventFlag(false)

        local scenarios = {
            "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE", "WORLD_VEHICLE_BUSINESSMEN", "WORLD_VEHICLE_EMPTY",
            "WORLD_VEHICLE_MECHANIC", "WORLD_VEHICLE_MILITARY_PLANES_BIG", "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
            "WORLD_VEHICLE_POLICE_BIKE", "WORLD_VEHICLE_POLICE_CAR", "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
            "WORLD_VEHICLE_SALTON_DIRT_BIKE", "WORLD_VEHICLE_SALTON", "WORLD_VEHICLE_STREETRACE"
        }
        
        for _, scenario in ipairs(scenarios) do
            SetScenarioTypeEnabled(scenario, false)
        end

        local emitters = {
            "LOS_SANTOS_VANILLA_UNICORN_01_STAGE", "LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",
            "LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM", "se_dlc_aw_arena_construction_01",
            "se_dlc_aw_arena_crowd_background_main", "se_dlc_aw_arena_crowd_exterior_lobby",
            "se_dlc_aw_arena_crowd_interior_lobby"
        }

        for _, emitter in ipairs(emitters) do
            SetStaticEmitterEnabled(emitter, false)
        end

        StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
        StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
        StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
    end)
end

Citizen.CreateThread(function()
    local angle = 0.0
    local speed = 0.0
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        if DoesEntityExist(veh) then
            local tangle = GetVehicleSteeringAngle(veh)
            if tangle > 10.0 or tangle < -10.0 then
                angle = tangle
            end
            speed = GetEntitySpeed(veh)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
            if speed < 0.1 and DoesEntityExist(vehicle) and not GetIsTaskActive(PlayerPedId(), 151) and not GetIsVehicleEngineRunning(vehicle) then
                SetVehicleSteeringAngle(GetVehiclePedIsIn(PlayerPedId(), true), angle)
            end
        end
    end
end)

-- DV
RegisterCommand( "dv", function()
    TriggerEvent( "wk:deleteVehicle" )
end, false )
TriggerEvent( "chat:addSuggestion", "/dv", "Deletes the vehicle you're sat in, or standing next to." )

-- The distance to check in front of the player for a vehicle   
local distanceToCheck = 5.0

-- The number of times to retry deleting a vehicle if it fails the first time 
local numRetries = 5

-- Add an event handler for the deleteVehicle event. Gets called when a user types in /dv in chat
RegisterNetEvent( "wk:deleteVehicle" )
AddEventHandler( "wk:deleteVehicle", function()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            else 
                lib.notify({
                    title = 'Corey Vehicle Actions',
                    description = 'You must be in the driver\'s seat!',
                    type = 'error'
                })
            end 
        else
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( ped, pos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            else 
                lib.notify({
                    title = 'Corey Vehicle Actions',
                    description = 'You must be in or near a vehicle to delete it',
                    type = 'warning'
                })
            end 
        end 
    end 
end )

function DeleteGivenVehicle( veh, timeoutMax )
    local timeout = 0 

    SetEntityAsMissionEntity( veh, true, true )
    DeleteVehicle( veh )

    if ( DoesEntityExist( veh ) ) then
        lib.notify({
            title = 'Corey Vehicle Actions',
            description = 'Failed to delete vehicle, trying again...',
            type = 'error'
        })

        -- Fallback if the vehicle doesn't get deleted
        while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
            DeleteVehicle( veh )

            -- The vehicle has been banished from the face of the Earth!
            if ( not DoesEntityExist( veh ) ) then 
                lib.notify({
                    title = 'Corey Vehicle Actions',
                    description = 'Vehicle deleted',
                    type = 'success'
                })
            end 

            -- Increase the timeout counter and make the system wait
            timeout = timeout + 1 
            Citizen.Wait( 500 )

            -- We've timed out and the vehicle still hasn't been deleted. 
            if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
                lib.notify({
                    title = 'Corey Vehicle Actions',
                    description = 'Failed to delete vehicle after ' .. timeoutMax .. ' retries',
                    type = 'error'
                })
            end 
        end 
    else 
        lib.notify({
            title = 'Corey Vehicle Actions',
            description = 'Vehicle deleted',
            type = 'success'
        })
    end 
end 

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    
    if ( IsEntityAVehicle( vehicle ) ) then 
        return vehicle
    end 
end

local notify = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)

        if not notify then
            if IsPedInAnyVehicle(ped, true) then
                lib.notify({
                    description = 'Hold F when exiting to leave engine running',
                    type = 'info',
                    duration = 6250
                })
                notify = true
            end
        end
        
        if RestrictEmer then
            if GetVehicleClass(veh) == 18 then
                if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                    Citizen.Wait(150)
                    if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                        SetVehicleEngineOn(veh, true, true, false)
                        if highBeams then
                            SetVehicleLights(veh, 2) -- Force turn light on
                            SetVehicleFullbeam(veh, true) 
                            SetVehicleLightMultiplier(veh, 1.0)
                        end
                        if keepDoorOpen then
                            TaskLeaveVehicle(ped, veh, 256)
                        else
                            TaskLeaveVehicle(ped, veh, 0)
                        end
                    end
                end
            end
        else
            if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                Citizen.Wait(150)
                if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                    SetVehicleEngineOn(veh, true, true, false)
                    if highBeams then
                        SetVehicleLights(veh, 2) -- Force turn light on
                        SetVehicleFullbeam(veh, true) 
                        SetVehicleLightMultiplier(veh, 1.0)
                    end
                    if keepDoorOpen then
                        TaskLeaveVehicle(ped, veh, 256)
                    else
                        TaskLeaveVehicle(ped, veh, 0)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local angle = 0.0
    local speed = 0.0
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        if DoesEntityExist(veh) then
            local tangle = GetVehicleSteeringAngle(veh)
            if tangle > 10.0 or tangle < -10.0 then
                angle = tangle
            end
            speed = GetEntitySpeed(veh)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
            if speed < 0.1 and DoesEntityExist(vehicle) and not GetIsTaskActive(PlayerPedId(), 151) and not GetIsVehicleEngineRunning(vehicle) then
                SetVehicleSteeringAngle(GetVehiclePedIsIn(PlayerPedId(), true), angle)
            end
        end
    end
end)

-- Seat Shuffle

-- optimizations
local tonumber = tonumber
local CreateThread = Citizen.CreateThread
local Wait = Citizen.Wait
local TriggerEvent = TriggerEvent
local RegisterCommand = RegisterCommand
local PlayerPedId = PlayerPedId
local IsPedInAnyVehicle = IsPedInAnyVehicle
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetVehiclePedIsIn = GetVehiclePedIsIn
local SetPedIntoVehicle = SetPedIntoVehicle
-- end optimizations

local disabled = false

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local restrictSwitching = false
        
        if IsPedInAnyVehicle(ped, false) and not disabled then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
                restrictSwitching = true
            end
        end
        
        SetPedConfigFlag(ped, 184, restrictSwitching)
        Wait(150)
    end
end)

local function switchSeat(_, args)
    local seatIndex = tonumber(args[1]) - 1
    
    if seatIndex < -1 or seatIndex >= 4 then
        SetNotificationTextEntry('STRING')
        AddTextComponentString("~r~Seat ~b~" .. (seatIndex + 1) .. "~r~ is not recognized")
        DrawNotification(true, true)
    else
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        
        if veh ~= nil and veh > 0 then
            CreateThread(function()
                disabled = true
                SetPedIntoVehicle(PlayerPedId(), veh, seatIndex)
                Wait(50)
                disabled = false
            end)
        end
    end
end

local function shuffleSeat()
    CreateThread(function()
        disabled = true
        Wait(3000)
        disabled = false
    end)
end

RegisterCommand("seat", switchSeat)
RegisterCommand("shuff", shuffleSeat)

TriggerEvent('chat:addSuggestion', '/shuff', "Switch to the driver's seat")
TriggerEvent('chat:addSuggestion', '/seat', 'Switch seats in the current vehicle',
  { { name = 'seat', help = "Switch seats in the current vehicle. 0 = driver, 1 = passenger, 2-3 = back seats" } })

AddEventHandler('onClientResourceStop', function(name)
    if name == 'seat-switcher' then
        SetPedConfigFlag(PlayerPedId(), 184, false)
    end
end)


--[[ SEAT SHUFFLE ]]--
--[[ BY JAF ]]--

local actionkey=9999 --Lshift (or whatever your sprint key is bound to)
local allowshuffle = false
local playerped=nil
local currentvehicle=nil

--getting vars
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		--constantly getting the current 
		playerped=PlayerPedId()
		--constantly get player vehicle
		currentvehicle=GetVehiclePedIsIn(playerped, false)
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if IsPedInAnyVehicle(playerped, false) and allowshuffle == false then
			--if they're trying to shuffle for whatever reason
			SetPedConfigFlag(playerped, 184, true)
			if GetIsTaskActive(playerped, 165) then
				--getting seat player is in 
				seat=0
				if GetPedInVehicleSeat(currentvehicle, -1) == playerped then
					seat=-1
				end
				--if the passenger doesn't shut the door, shut it manually
				--if GetVehicleDoorAngleRatio(currentvehicle,1) > 0.0 and seat == 0 then
					--SetVehicleDoorShut(currentvehicle,1,false)
				--end
				--move ped back into the seat right as the animation starts
				SetPedIntoVehicle(playerped, currentvehicle, seat)
			end
		elseif IsPedInAnyVehicle(playerped, false) and allowshuffle == true then
			SetPedConfigFlag(playerped, 184, false)
		end
	end
end)


RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
	if IsPedInAnyVehicle(playerped, false) then
		--getting seat
		seat=0
		if GetPedInVehicleSeat(currentvehicle, -1) == playerped then
			seat=-1
		end
		--if they're a driver
		if GetPedInVehicleSeat(currentvehicle,-1) == playerped then
			TaskShuffleToNextVehicleSeat(playerped,currentvehicle)
		end
		--if they're a passenger
		--adding a block until they are actually in their new seat
		allowshuffle=true
		while GetPedInVehicleSeat(currentvehicle,seat) == playerped do
			Citizen.Wait(0)
		end
		allowshuffle=false
	else
		allowshuffle=false
		CancelEvent('SeatShuffle')
	end
end)


local elapsed=0
--thread to get duration of key press
Citizen.CreateThread(function()
  while true do
	Citizen.Wait(0)
	elapsed=0
	while IsControlPressed(0,actionkey) and GetIsTaskActive(playerped, 165) do
		Citizen.Wait(100)
		elapsed=elapsed+0.1
	end
  end
end)



Citizen.CreateThread(function()
  while true do
  --if the press the control then start the animation
	if IsControlJustPressed(1, actionkey) then -- Lshift
	   TriggerEvent("SeatShuffle")
    end
	--if they release the control mid anim then set back
	if IsControlJustReleased(1, actionkey) and allowshuffle == true then 
		--setting threshold for how long the ksy should be pressed for
		threshhold=0.8
		--if they're in passenger seat then remove add 1 second to the threshold because of slight delay when moving from passenger side
		--if GetPedInVehicleSeat(currentvehicle, 0) == playerped then
			--threshhold=threshhold+0.55
		--end
		--if the animation is playing and the key is pressed down for long enough, cancel the animation
	   if GetIsTaskActive(playerped, 165) and elapsed < threshhold then
			allowshuffle=false
	   end
    end
    Citizen.Wait(0)
  end
end)

RegisterCommand("shuff", function(source, args, raw) --change command here
    TriggerEvent("SeatShuffle")
end, false) --False, allow everyone to run it

if Config.Blips then
    Citizen.CreateThread(function()
        for _, info in pairs(Config.TheBlips) do
            if info.vector3 and info.title and info.id and info.colour then
                local blip = AddBlipForCoord(info.vector3.x, info.vector3.y, info.vector3.z)
                
                SetBlipSprite(blip, info.id)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.9)
                SetBlipColour(blip, info.colour)
                SetBlipAsShortRange(blip, true)
                
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(info.title)
                EndTextCommandSetBlipName(blip)
            else
                print("Warning: Invalid blip data (Config.TheBlips)")
            end
        end
    end)
end

if Config.AimAssist then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500) 
            local weaponHash = GetSelectedPedWeapon(PlayerPedId())
            if weaponHash and weaponHash ~= GetHashKey("WEAPON_PISTOL") then
                SetPlayerLockonRangeOverride(PlayerId(), 0.0)
            end
        end
    end)
end

--------------------------------------------------------
-- Custom Blip Placement (/addblip)
-- Saves permanently to config.lua on the server
--------------------------------------------------------

local playerBlips = {}

RegisterCommand("addblip", function()
    local input = lib.inputDialog("Add Map Blip", {
        {
            type = "input",
            label = "Blip Name",
            description = "Label shown on the map",
            required = true,
            placeholder = "e.g. My House"
        },
        {
            type = "number",
            label = "Sprite ID",
            description = "Blip icon (e.g. 1 = circle, 60 = police, 61 = bar, 280 = house). See FiveM blip sprites wiki.",
            required = true,
            default = 1,
            min = 1,
            max = 826
        },
        {
            type = "number",
            label = "Colour ID",
            description = "Blip colour (e.g. 0 = white, 1 = red, 2 = green, 3 = blue, 38 = police blue). See FiveM blip colours wiki.",
            required = true,
            default = 0,
            min = 0,
            max = 85
        },
    })

    if not input then return end

    local name   = tostring(input[1])
    local sprite = tonumber(input[2])
    local colour = tonumber(input[3])

    if not name or name == "" then
        lib.notify({ title = "Add Blip", description = "Invalid blip name.", type = "error" })
        return
    end

    if not sprite or not colour then
        lib.notify({ title = "Add Blip", description = "Invalid sprite or colour ID.", type = "error" })
        return
    end

    local coords = GetEntityCoords(PlayerPedId())

    -- Send to server first — blip is only drawn if server confirms permission
    TriggerServerEvent("smallresources:saveBlip", name, sprite, colour, coords.x, coords.y, coords.z)
end, false)

RegisterCommand("removeblips", function()
    if #playerBlips == 0 then
        lib.notify({ title = "Remove Blips", description = "You have no custom blips to remove.", type = "warning" })
        return
    end

    for _, blip in ipairs(playerBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end

    playerBlips = {}

    lib.notify({ title = "Remove Blips", description = "All your custom blips removed from map (not from config).", type = "success" })
end, false)

TriggerEvent("chat:addSuggestion", "/addblip", "Place a custom blip at your location and save it permanently to config.")
TriggerEvent("chat:addSuggestion", "/removeblips", "Remove your added blips from the map this session.")

RegisterNetEvent("smallresources:blipDenied")
AddEventHandler("smallresources:blipDenied", function()
    lib.notify({ title = "Add Blip", description = "You do not have permission to add blips.", type = "error" })
end)

RegisterNetEvent("smallresources:blipSaved")
AddEventHandler("smallresources:blipSaved", function(name, sprite, colour, x, y, z)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, 0.9)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)

    playerBlips[#playerBlips + 1] = blip

    lib.notify({
        title = "Add Blip",
        description = "Blip '" .. name .. "' added and saved to config.",
        type = "success"
    })
end)