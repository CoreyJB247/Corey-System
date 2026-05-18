-- client.lua - Corey Vehicle Manager (FULL COMPLETE VERSION)
local lastSpawned = nil
local replaceLastVehicle = true
local savedVehicles = {}

local function ShowContext(id)
    lib.showContext(id)
end

-- GTA V Colors with IDs
local gtaColors = {
    {id = 0, name = "Black"},
    {id = 1, name = "Graphite"},
    {id = 2, name = "Black Steel"},
    {id = 3, name = "Dark Silver"},
    {id = 4, name = "Silver"},
    {id = 5, name = "Bluish Silver"},
    {id = 6, name = "Rolled Steel"},
    {id = 7, name = "Shadow Silver"},
    {id = 8, name = "Stone Silver"},
    {id = 9, name = "Midnight Silver"},
    {id = 10, name = "Cast Iron Silver"},
    {id = 11, name = "Anthracite Black"},
    {id = 27, name = "Red"},
    {id = 28, name = "Torino Red"},
    {id = 29, name = "Formula Red"},
    {id = 30, name = "Blaze Red"},
    {id = 31, name = "Grace Red"},
    {id = 32, name = "Garnet Red"},
    {id = 33, name = "Sunset Red"},
    {id = 34, name = "Cabernet Red"},
    {id = 35, name = "Candy Red"},
    {id = 36, name = "Sunrise Orange"},
    {id = 37, name = "Gold"},
    {id = 38, name = "Orange"},
    {id = 88, name = "Yellow"},
    {id = 89, name = "Race Yellow"},
    {id = 90, name = "Bronze"},
    {id = 91, name = "Dew Yellow"},
    {id = 92, name = "Lime Green"},
    {id = 49, name = "Dark Green"},
    {id = 50, name = "Racing Green"},
    {id = 51, name = "Sea Green"},
    {id = 52, name = "Olive Green"},
    {id = 53, name = "Bright Green"},
    {id = 54, name = "Gasoline Green"},
    {id = 61, name = "Galaxy Blue"},
    {id = 62, name = "Dark Blue"},
    {id = 63, name = "Saxon Blue"},
    {id = 64, name = "Blue"},
    {id = 65, name = "Mariner Blue"},
    {id = 66, name = "Harbor Blue"},
    {id = 67, name = "Diamond Blue"},
    {id = 68, name = "Surf Blue"},
    {id = 69, name = "Nautical Blue"},
    {id = 70, name = "Ultra Blue"},
    {id = 71, name = "Schafter Purple"},
    {id = 72, name = "Spinnaker Purple"},
    {id = 73, name = "Racing Blue"},
    {id = 74, name = "Light Blue"},
    -- Whites
    {id = 107, name = "Cream"},
    {id = 111, name = "Ice White"},
    {id = 112, name = "Frost White"},
    {id = 120, name = "Chrome"},
}

-- ==================== BUILD FULL VEHICLE DATA ====================
-- ==================== BUILD FULL VEHICLE DATA ====================
local function BuildVehicleData(vehicle, modelName)
    SetVehicleModKit(vehicle, 0)

    -- Prefer the explicitly passed name, then the statebag set at spawn time,
    -- then fall back to the display name (vanilla vehicles only).
    local resolvedModel = modelName
        or Entity(vehicle).state.spawnModel
        or string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))

    local data = {
        model = resolvedModel,
        category = "civilian",
        colors = {},
        mods = {},
        extras = {},
        plate = GetVehicleNumberPlateText(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        windowTint = GetVehicleWindowTint(vehicle),
        livery = GetVehicleLivery(vehicle)  -- ← Added
    }

    local color1, color2 = GetVehicleColours(vehicle)
    local pearlescent, wheelColor = GetVehicleExtraColours(vehicle)
    data.colors = { primary = color1, secondary = color2, pearlescent = pearlescent, wheel = wheelColor }

    for i = 0, 49 do
        local mod = GetVehicleMod(vehicle, i)
        if mod ~= -1 then data.mods[tostring(i)] = mod end
    end

    for i = 0, 14 do
        if DoesExtraExist(vehicle, i) then
            data.extras[tostring(i)] = IsVehicleExtraTurnedOn(vehicle, i)
        end
    end

    return data
end

-- ==================== SPAWN FUNCTION ====================
function SpawnVehicle(model, savedData, onAfter)
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)
    local currentVehicle = GetVehiclePedIsIn(ped, false)

    local vehicleToReplace = currentVehicle ~= 0 and currentVehicle
        or (lastSpawned and DoesEntityExist(lastSpawned) and lastSpawned or 0)

    local originCoords = vehicleToReplace ~= 0 and GetEntityCoords(vehicleToReplace) or GetEntityCoords(ped)

    if replaceLastVehicle and vehicleToReplace ~= 0 then
        SetEntityAsMissionEntity(vehicleToReplace, true, true)
        DeleteEntity(vehicleToReplace)
        lastSpawned = nil
    end

    local hash = GetHashKey(model)
    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 300 do
        Wait(50)
        timeout = timeout + 1
    end

    if not HasModelLoaded(hash) then
        lib.notify({ title = 'Error', description = 'Failed to load model', type = 'error' })
        return
    end

    local groundFound, groundZ = GetGroundZFor_3dCoord(originCoords.x, originCoords.y, originCoords.z + 5.0, false)
    local spawnZ = groundFound and (groundZ + 0.5) or (originCoords.z + 0.5)

    local vehicle = CreateVehicle(hash, originCoords.x, originCoords.y, spawnZ, heading, true, false)

    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    SetModelAsNoLongerNeeded(hash)
    SetVehicleOnGroundProperly(vehicle)

    if savedData then
        SetVehicleModKit(vehicle, 0)

        if savedData.colors then
            local c = savedData.colors
            SetVehicleColours(vehicle, c.primary or 0, c.secondary or 0)
            if c.pearlescent then SetVehicleExtraColours(vehicle, c.pearlescent, c.wheel or 0) end
        end

        if savedData.mods then
            for modType, modValue in pairs(savedData.mods) do
                SetVehicleMod(vehicle, tonumber(modType), modValue, false)
            end
        end

        if savedData.extras then
            for extraId, state in pairs(savedData.extras) do
                SetVehicleExtra(vehicle, tonumber(extraId), state and 0 or 1)
            end
        end

        -- Apply Livery
        if savedData.livery then
            SetVehicleLivery(vehicle, savedData.livery)
        end

        if savedData.plate then SetVehicleNumberPlateText(vehicle, savedData.plate) end
        if savedData.windowTint then SetVehicleWindowTint(vehicle, savedData.windowTint) end
    end

    TaskWarpPedIntoVehicle(ped, vehicle, -1)
    lastSpawned = vehicle
    Entity(vehicle).state:set('spawnModel', model, false)

    lib.notify({ title = 'Vehicle Spawned', description = model, type = 'success' })

    if onAfter then onAfter() end
end


-- ==================== ENGINE ALWAYS ON + KEEP CLEAN (vMenu Style) ====================
local engineAlwaysOn = false
local keepVehicleClean = false

CreateThread(function()
    while true do
        Wait(250)

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= 0 and DoesEntityExist(veh) then
            -- Engine Always On
            if engineAlwaysOn then
                SetVehicleEngineOn(veh, true, true, false)
            end

            -- Keep Vehicle Clean
            if keepVehicleClean then
                SetVehicleDirtLevel(veh, 0.0)
            end
        end
    end
end)




-- ==================== MAIN MENU (New Options at Bottom) ====================
local function OpenHeavyVehicleManager()
    local options = {}

    -- Vehicle Categories
    for _, category in ipairs(Config.VehicleCategories) do
        local iconColor = category.id == "law" and "#3b82f6" 
                       or category.id == "fire" and "#ef4444" 
                       or "#22c55e"

        table.insert(options, {
            title = category.title,
            icon = category.icon,
            iconColor = iconColor,
            description = category.description,
            arrow = true,
            onSelect = function() OpenSubCategoryMenu(category) end
        })
    end

    -- Spawn by Name
    table.insert(options, {
        title = 'Spawn by Name',
        icon = 'keyboard',
        iconColor = '#f97316',
        description = 'Type any vehicle model name to spawn it',
        onSelect = function()
            local input = lib.inputDialog('Spawn by Name', {
                { type = 'input', label = 'Vehicle Model Name', description = 'e.g. adder, zentorno, police', placeholder = 'Enter model name...', required = true }
            })
            if not input or not input[1] or input[1] == '' then
                OpenHeavyVehicleManager()
                return
            end
            local model = input[1]:lower():gsub('%s+', '')
            local hash = GetHashKey(model)
            RequestModel(hash)
            local timeout = 0
            while not HasModelLoaded(hash) and timeout < 100 do
                Wait(50)
                timeout = timeout + 1
            end
            if not HasModelLoaded(hash) then
                lib.notify({ title = 'Spawn by Name', description = 'Model "' .. model .. '" not found or failed to load', type = 'error' })
                OpenHeavyVehicleManager()
                return
            end
            SetModelAsNoLongerNeeded(hash)
            SpawnVehicle(model)
        end
    })

    table.insert(options, { title = '', disabled = true })

    -- Save Section
    table.insert(options, { title = 'Save Current Vehicle', icon = 'floppy-disk', iconColor = '#a855f7', onSelect = SaveCurrentVehicle })
    table.insert(options, { title = 'My Saved Vehicles', icon = 'folder-open', iconColor = '#eab308', onSelect = openSavedVehiclesMenu })

    -- Replace Toggle
    table.insert(options, {
        title = 'Replace Last Spawned Vehicle',
        icon = replaceLastVehicle and 'toggle-on' or 'toggle-off',
        iconColor = replaceLastVehicle and '#22c55e' or '#ef4444',
        description = replaceLastVehicle and 'Currently: Enabled' or 'Currently: Disabled',
        onSelect = function()
            replaceLastVehicle = not replaceLastVehicle
            lib.notify({ title = 'Replace Mode', description = replaceLastVehicle and '✅ Enabled' or '❌ Disabled', type = replaceLastVehicle and 'success' or 'warning' })
            OpenHeavyVehicleManager()
        end
    })

    table.insert(options, { title = '', disabled = true })

    -- Main Options
    table.insert(options, { title = 'Vehicle Modifications', icon = 'wrench', iconColor = '#3b82f6', arrow = true, onSelect = openVehicleModsMenu })
    table.insert(options, { title = 'Paint & Colors', icon = 'palette', iconColor = '#ec4899', arrow = true, onSelect = openPaintMenu })
    table.insert(options, { title = 'Extras & Liveries', icon = 'layer-group', iconColor = '#f1f5f9', arrow = true, onSelect = openExtrasLiveryMenu })
    table.insert(options, { title = 'Window & Door Control', icon = 'door-open', iconColor = '#8b5cf6', onSelect = OpenDoorWindowMenu })
    table.insert(options, { title = 'Switch Vehicle Seats', icon = 'users', iconColor = '#22c55e', onSelect = function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            for i = -1, GetVehicleMaxNumberOfPassengers(veh) do
                if IsVehicleSeatFree(veh, i) then SetPedIntoVehicle(PlayerPedId(), veh, i) break end
            end
        end
        OpenHeavyVehicleManager()
    end })

    table.insert(options, { title = '', disabled = true })

    -- Bottom Options
    table.insert(options, { title = 'Repair Vehicle', icon = 'screwdriver-wrench', iconColor = '#eab308', description = 'Requires proximity to a mechanic for full repair', onSelect = function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            ExecuteCommand('repair')
        end
        OpenHeavyVehicleManager()
    end })

    table.insert(options, { title = 'Wash Vehicle', icon = 'shower', iconColor = '#0ea5e9', onSelect = function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            SetVehicleDirtLevel(veh, 0.0)
            lib.notify({ title = 'Vehicle Washed', type = 'success' })
        end
        OpenHeavyVehicleManager()
    end })

    table.insert(options, {
        title = 'Engine Always On',
        icon = engineAlwaysOn and 'toggle-on' or 'toggle-off',
        iconColor = engineAlwaysOn and '#22c55e' or '#ef4444',
        description = engineAlwaysOn and 'Currently: Enabled' or 'Currently: Disabled',
        onSelect = function()
            engineAlwaysOn = not engineAlwaysOn
            lib.notify({ title = 'Engine Always On', description = engineAlwaysOn and '✅ Enabled' or '❌ Disabled', type = engineAlwaysOn and 'success' or 'warning' })
            OpenHeavyVehicleManager()
        end
    })

    table.insert(options, {
        title = 'Keep Vehicle Clean',
        icon = keepVehicleClean and 'toggle-on' or 'toggle-off',
        iconColor = keepVehicleClean and '#22c55e' or '#ef4444',
        description = keepVehicleClean and 'Currently: Enabled' or 'Currently: Disabled',
        onSelect = function()
            keepVehicleClean = not keepVehicleClean
            lib.notify({ title = 'Keep Vehicle Clean', description = keepVehicleClean and '✅ Enabled' or '❌ Disabled', type = keepVehicleClean and 'success' or 'warning' })
            OpenHeavyVehicleManager()
        end
    })

    lib.registerContext({
        id = 'corey_vehicle_manager',
        title = 'Corey Vehicle Manager',
        menu = 'unified_main_menu',
        preventClosing = true,
        options = options
    })

    ShowContext('corey_vehicle_manager')
end
-- ==================== SUB MENUS ====================
function OpenSubCategoryMenu(category)
    local options = {}

    for _, sub in ipairs(category.subcategories) do
        if sub.subcategories then
            -- Special handling for nested "Addon Vehicles"
            table.insert(options, {
                title = sub.title,
                description = sub.description or "Custom Addon Vehicles",
                icon = sub.icon or 'plus',
                arrow = true,
                onSelect = function() OpenAddonSubMenu(sub) end
            })
        else
            -- Normal subcategory
            table.insert(options, {
                title = sub.title,
                icon = 'layer-group',
                arrow = true,
                onSelect = function() OpenVehicleList('subcat_' .. category.id, sub.title, sub.vehicles) end
            })
        end
    end

    lib.registerContext({ 
        id = 'subcat_' .. category.id, 
        title = category.title, 
        menu = 'corey_vehicle_manager', 
        preventClosing = true, 
        options = options 
    })
    ShowContext('subcat_' .. category.id)
end

-- New function for nested addon menu
function OpenAddonSubMenu(addonCategory)
    local options = {}
    local menuId = 'addon_subcat_' .. addonCategory.title:lower():gsub('%s+', '_')

    for _, sub in ipairs(addonCategory.subcategories) do
        local capturedSub = sub
        table.insert(options, {
            title = sub.title,
            icon = 'layer-group',
            arrow = true,
            onSelect = function() OpenVehicleList(menuId, capturedSub.title, capturedSub.vehicles) end
        })
    end

    lib.registerContext({ 
        id = menuId, 
        title = addonCategory.title, 
        menu = 'subcat_civilian', 
        preventClosing = true, 
        options = options 
    })
    ShowContext(menuId)
end

function OpenVehicleList(parentMenuId, title, vehicles)
    -- Create a copy and sort alphabetically by name
    local sortedVehicles = {}
    for _, veh in ipairs(vehicles) do
        table.insert(sortedVehicles, veh)
    end

    table.sort(sortedVehicles, function(a, b)
        return a.name:lower() < b.name:lower()
    end)

    local options = {}
    for _, veh in ipairs(sortedVehicles) do
        table.insert(options, {
            title = veh.name,
            description = 'Model: ' .. veh.model,
            icon = 'car',
            onSelect = function() SpawnVehicle(veh.model, nil, function() OpenVehicleList(parentMenuId, title, vehicles) end) end
        })
    end

    local listId = 'vehlist_' .. parentMenuId
    lib.registerContext({ 
        id = listId, 
        title = title, 
        menu = parentMenuId,
        preventClosing = true, 
        options = options 
    })
    ShowContext(listId)
end

-- ==================== VEHICLE MODIFICATIONS (FULL FUNCTIONAL) ====================
function openVehicleModsMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then
        lib.notify({title = 'Error', description = 'You must be in a vehicle', type = 'error'})
        return
    end

    local options = {
        {title = 'Performance Mods', description = 'Engine, brakes, transmission, and turbo', icon = 'bolt', onSelect = openPerformanceModsMenu},
        {title = 'Visual Mods', description = 'Spoilers, bumpers, skirts, hoods and more', icon = 'car-side', onSelect = openVisualModsMenu},
        {title = 'Wheels & Tires', description = 'Wheel types, custom wheels, and tire smoke', icon = 'circle', onSelect = openWheelsTiresMenu},
        {title = 'Lights & Neon', description = 'Headlights, neon underglow, and xenon lights', icon = 'lightbulb', onSelect = openLightsNeonMenu},
        {title = 'Windows, Plate & Horn', description = 'Window tint, license plates and horn sounds', icon = 'window-restore', onSelect = openPlateWindowHornMenu}
    }

    lib.registerContext({
        id = 'vehicle_mods_menu',
        title = 'Vehicle Modifications',
        menu = 'corey_vehicle_manager',
        preventClosing = true,
        options = options
    })
    ShowContext('vehicle_mods_menu')
end

-- ==================== VISUAL MODS ====================
-- Mod type IDs sourced from the official CitizenFX/GTA V eVehicleModType enum.
-- Performance & toggle mods (11-18, 22-24) are handled in their own menus.
-- Horn (14) is handled in Windows/Plate/Horn menu.
local visualModDefs = {
    -- ── Exterior body ──────────────────────────────────────────────
    { modType = 0,  title = 'Spoiler',            icon = 'car' },
    { modType = 1,  title = 'Front Bumper',        icon = 'car' },
    { modType = 2,  title = 'Rear Bumper',         icon = 'car' },
    { modType = 3,  title = 'Side Skirts',         icon = 'car' },
    { modType = 4,  title = 'Exhaust',             icon = 'wind' },
    { modType = 5,  title = 'Roll Cage / Frame',   icon = 'car' },
    { modType = 6,  title = 'Grille',              icon = 'car' },
    { modType = 7,  title = 'Hood',                icon = 'car' },
    { modType = 8,  title = 'Left Fender',         icon = 'car' },
    { modType = 9,  title = 'Right Fender',        icon = 'car' },
    { modType = 10, title = 'Roof',                icon = 'car' },
    -- 11 = Engine (perf), 12 = Brakes (perf), 13 = Gearbox (perf)
    -- 14 = Horn → Windows/Plate/Horn menu
    -- 15 = Suspension (perf), 16 = Armour (perf), 17 = Nitrous (perf)
    -- 18 = Turbo (perf toggle), 19 = Subwoofer, 20 = Tyre Smoke → Wheels menu
    -- 21 = Hydraulics → Wheels menu, 22 = Xenon Lights (toggle) → Lights menu
    -- 23/24 = Wheels → Wheels menu

    -- ── Interior & cosmetic ─────────────────────────────────────────
    { modType = 25, title = 'Plate Holder',        icon = 'id-badge' },
    { modType = 26, title = 'Vanity Plates',       icon = 'id-badge' },
    { modType = 27, title = 'Trim (Interior 1)',   icon = 'car' },
    { modType = 28, title = 'Trim (Interior 2)',   icon = 'car' },
    { modType = 29, title = 'Dashboard',           icon = 'gauge' },
    { modType = 30, title = 'Dial Design',         icon = 'gauge' },
    { modType = 31, title = 'Trim (Interior 3)',   icon = 'car' },
    { modType = 32, title = 'Trim (Interior 4)',   icon = 'car' },
    { modType = 33, title = 'Seats',               icon = 'couch' },
    { modType = 34, title = 'Steering Wheel',      icon = 'circle' },
    { modType = 35, title = 'Shift Lever',         icon = 'car' },
    { modType = 36, title = 'Plaques',             icon = 'id-badge' },
    { modType = 37, title = 'Ice / Bling',         icon = 'gem' },
    { modType = 38, title = 'Trunk',               icon = 'box' },
    { modType = 39, title = 'Engine Bay (Hydro)',  icon = 'arrows-up-down' },
    { modType = 40, title = 'Engine Bay 1',        icon = 'gear' },
    { modType = 41, title = 'Engine Bay 2',        icon = 'gear' },
    { modType = 42, title = 'Engine Bay 3',        icon = 'gear' },
    { modType = 43, title = 'Chassis 2',           icon = 'car' },
    { modType = 44, title = 'Chassis 3',           icon = 'car' },
    { modType = 45, title = 'Chassis 4',           icon = 'car' },
    { modType = 46, title = 'Chassis 5',           icon = 'car' },
    { modType = 47, title = 'Door (Left)',          icon = 'door-open' },
    { modType = 48, title = 'Door (Right)',         icon = 'door-open' },
}



-- Returns a short human-friendly label for a given mod index (-1 = Stock).
local function getModOptionLabel(veh, modType, index, count)
    if index == -1 then return 'Stock (None)' end
    local raw = GetModTextLabel(veh, modType, index) or ''
    if raw ~= '' and raw ~= 'NULL' then
        local friendly = raw:gsub('_', ' '):lower()
        friendly = friendly:gsub('(%a)([%w_]*)', function(f, r) return f:upper()..r end)
        return friendly .. ' (' .. (index + 1) .. '/' .. count .. ')'
    end
    return 'Option ' .. (index + 1) .. ' / ' .. count
end

-- ==================== VISUAL MODS (Cycle on click, description = current) ====================
function openVisualModsMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then
        lib.notify({title = 'Error', description = 'You must be in a vehicle', type = 'error'})
        return
    end
    SetVehicleModKit(veh, 0)

    local options = {}
    for _, def in ipairs(visualModDefs) do
        local count = GetNumVehicleMods(veh, def.modType)
        if count and count > 0 then
            local current = GetVehicleMod(veh, def.modType)
            -- Description always shows what is currently fitted
            local currentLabel = getModOptionLabel(veh, def.modType, current, count)

            -- Capture loop variables for the closure
            local modType  = def.modType
            local modTitle = def.title

            table.insert(options, {
                title       = modTitle,
                -- Description shows the currently equipped option; refreshes on every click
                description = '🔧 ' .. currentLabel,
                icon        = def.icon,
                -- No arrow — clicking cycles directly, no sub-menu
                onSelect    = function()
                    SetVehicleModKit(veh, 0)
                    local c       = GetNumVehicleMods(veh, modType)
                    local cur     = GetVehicleMod(veh, modType)
                    -- Cycle: Stock(-1) → 0 → 1 → … → c-1 → Stock(-1) → …
                    local next
                    if cur == -1 then
                        next = 0
                    elseif cur >= c - 1 then
                        next = -1   -- wrap back to Stock
                    else
                        next = cur + 1
                    end
                    SetVehicleMod(veh, modType, next, false)
                    -- Wait for ox_lib to finish closing before re-opening
                    CreateThread(function()
                        Wait(100)
                        openVisualModsMenu()
                    end)
                end
            })
        end
    end

    if #options == 0 then
        table.insert(options, {title = 'No visual mods available for this vehicle', disabled = true})
    end

    lib.registerContext({
        id             = 'visual_mods_menu',
        title          = 'Visual Mods',
        menu           = 'vehicle_mods_menu',
        preventClosing = true,
        options        = options
    })
    ShowContext('visual_mods_menu')
end

-- ==================== LIGHTS & NEON MENU ====================
-- Neon RGB values keyed by name
local neonColors = {
    { name = 'White',            r = 255, g = 255, b = 255 },
    { name = 'Blue',             r = 0,   g = 0,   b = 255 },
    { name = 'Electric Blue',    r = 0,   g = 150, b = 255 },
    { name = 'Mint Green',       r = 0,   g = 255, b = 200 },
    { name = 'Lime Green',       r = 0,   g = 255, b = 0   },
    { name = 'Yellow',           r = 255, g = 255, b = 0   },
    { name = 'Gold',             r = 255, g = 200, b = 0   },
    { name = 'Orange',           r = 255, g = 128, b = 0   },
    { name = 'Red',              r = 255, g = 0,   b = 0   },
    { name = 'Pony Pink',        r = 255, g = 100, b = 180 },
    { name = 'Hot Pink',         r = 255, g = 0,   b = 150 },
    { name = 'Purple',           r = 128, g = 0,   b = 255 },
    { name = 'Blacklight Purple',r = 75,  g = 0,   b = 130 },
}

-- Helper: are any neon lights currently enabled?
local function isNeonOn(veh)
    for i = 0, 3 do
        if IsVehicleNeonLightEnabled(veh, i) then return true end
    end
    return false
end

-- Helper: get current neon color name by matching RGB
local function getCurrentNeonName(veh)
    local r, g, b = GetVehicleNeonLightsColour(veh)
    for _, c in ipairs(neonColors) do
        if c.r == r and c.g == g and c.b == b then return c.name end
    end
    if r == 0 and g == 0 and b == 0 then return 'Off' end
    return ('Custom (%d, %d, %d)'):format(r, g, b)
end

function openLightsNeonMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    SetVehicleModKit(veh, 0)
    local xenonOn = IsToggleModOn(veh, 22)
    local neonOn  = isNeonOn(veh)
    local neonColorName = neonOn and getCurrentNeonName(veh) or 'Off'

    local options = {
        {
            title       = 'Xenon Headlights: ' .. (xenonOn and '✅ ON' or '❌ OFF'),
            description = 'Click to toggle xenon headlights',
            icon        = 'lightbulb',
            iconColor   = xenonOn and '#22c55e' or '#ef4444',
            onSelect    = function()
                ToggleVehicleMod(veh, 22, not xenonOn)
                CreateThread(function() Wait(100) openLightsNeonMenu() end)
            end
        },
        {
            title       = 'Neon Underglow: ' .. (neonOn and '✅ ON' or '❌ OFF'),
            description = 'Click to toggle neon on/off',
            icon        = 'circle-dot',
            iconColor   = neonOn and '#22c55e' or '#ef4444',
            onSelect    = function()
                for i = 0, 3 do
                    SetVehicleNeonLightEnabled(veh, i, not neonOn)
                end
                CreateThread(function() Wait(100) openLightsNeonMenu() end)
            end
        },
        {
            title       = 'Neon Color',
            description = 'Current: ' .. neonColorName,
            icon        = 'palette',
            arrow       = true,
            onSelect    = openNeonColorMenu
        }
    }

    lib.registerContext({
        id             = 'lights_neon_menu',
        title          = 'Lights & Neon',
        menu           = 'vehicle_mods_menu',
        preventClosing = true,
        options        = options
    })
    ShowContext('lights_neon_menu')
end

function openNeonColorMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    local curName = getCurrentNeonName(veh)
    local options = {}

    for _, color in ipairs(neonColors) do
        local isCurrent = (color.name == curName)
        table.insert(options, {
            title     = color.name,
            description = isCurrent and '✅ Currently selected' or nil,
            icon      = isCurrent and 'check' or 'circle',
            iconColor = isCurrent and '#22c55e' or nil,
            onSelect  = function()
                -- Enable all four neon positions and apply RGB color
                for i = 0, 3 do
                    SetVehicleNeonLightEnabled(veh, i, true)
                end
                SetVehicleNeonLightsColour(veh, color.r, color.g, color.b)
                lib.notify({ title = 'Neon Color', description = color.name, type = 'success' })
                CreateThread(function() Wait(100) openNeonColorMenu() end)
            end
        })
    end

    lib.registerContext({
        id             = 'neon_color_menu',
        title          = 'Neon Color',
        menu           = 'lights_neon_menu',
        preventClosing = true,
        options        = options
    })
    ShowContext('neon_color_menu')
end

-- ==================== PERFORMANCE MODS ====================
-- ==================== PERFORMANCE MODS (Shows Current Level + Updates) ====================
-- ==================== PERFORMANCE MODS (All Mods Update Correctly) ====================
function openPerformanceModsMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    SetVehicleModKit(veh, 0)  -- Force refresh

    local engineLevel = GetVehicleMod(veh, 11)
    local brakesLevel = GetVehicleMod(veh, 12)
    local transLevel  = GetVehicleMod(veh, 13)
    local suspLevel   = GetVehicleMod(veh, 15)
    local turboOn     = IsToggleModOn(veh, 18)

    local options = {
        {
            title = 'Engine (Level ' .. (engineLevel == -1 and 'Stock' or engineLevel + 1) .. ')',
            description = 'Select engine upgrade level',
            onSelect = function() openModLevelMenu(veh, 11, 'Engine') end
        },
        {
            title = 'Brakes (Level ' .. (brakesLevel == -1 and 'Stock' or brakesLevel + 1) .. ')',
            description = 'Select brake upgrade level',
            onSelect = function() openModLevelMenu(veh, 12, 'Brakes') end
        },
        {
            title = 'Transmission (Level ' .. (transLevel == -1 and 'Stock' or transLevel + 1) .. ')',
            description = 'Select transmission upgrade level',
            onSelect = function() openModLevelMenu(veh, 13, 'Transmission') end
        },
        {
            title = 'Suspension (Level ' .. (suspLevel == -1 and 'Stock' or suspLevel + 1) .. ')',
            description = 'Select suspension upgrade level',
            onSelect = function() openModLevelMenu(veh, 15, 'Suspension') end
        },
        {
            title = 'Turbo: ' .. (turboOn and 'ON' or 'OFF'),
            description = 'Toggle turbo for extra power',
            onSelect = function()
                ToggleVehicleMod(veh, 18, not turboOn)
                Wait(50)  -- Small delay for transmission to register
                openPerformanceModsMenu()
            end
        }
    }

    lib.registerContext({
        id = 'performance_mods_menu',
        title = 'Performance Mods',
        menu = 'vehicle_mods_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('performance_mods_menu')
end

function openModLevelMenu(veh, modType, name)
    local options = {}

    -- Stock option
    table.insert(options, {
        title = 'Stock',
        description = 'Remove upgrade',
        onSelect = function()
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, modType, -1, false)
            lib.notify({title = name, description = 'Stock', type = 'success'})
            Wait(100)
            openPerformanceModsMenu()
        end
    })

    -- Dynamically get the actual number of upgrade levels this vehicle supports
    local count = GetNumVehicleMods(veh, modType)
    for level = 0, count - 1 do
        -- GTA internally stores 0-based but players expect "Level 1", "Level 2", etc.
        local label = 'Level ' .. (level + 1)
        local capturedLevel = level
        table.insert(options, {
            title = label,
            onSelect = function()
                SetVehicleModKit(veh, 0)
                SetVehicleMod(veh, modType, capturedLevel, false)
                lib.notify({title = name, description = label, type = 'success'})
                Wait(100)
                openPerformanceModsMenu()
            end
        })
    end

    lib.registerContext({
        id = 'mod_level_menu',
        title = name .. ' Upgrade',
        menu = 'performance_mods_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('mod_level_menu')
end
-- ==================== WHEELS & TIRES (Fixed - No Random Menus) ====================
function openWheelsTiresMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then 
        lib.notify({title = 'Error', description = 'You must be in a vehicle', type = 'error'})
        return 
    end

    SetVehicleModKit(veh, 0)

    local currentType = GetVehicleWheelType(veh)
    local typeNames = {"Sport", "Muscle", "Lowrider", "SUV", "Offroad", "Tuner", "Bike", "High End", "Benny's"}

    local options = {
        {title = 'Wheel Type', description = 'Current: ' .. (typeNames[currentType + 1] or "Unknown"), icon = 'list', onSelect = openWheelTypeMenu},
        {title = 'Wheels', description = 'Browse wheel designs', icon = 'circle', onSelect = openWheelSelectionMenu},
        {title = 'Wheel Color', description = 'Change wheel color', icon = 'palette', onSelect = openWheelColorPicker},
        {title = 'Custom Wheels', description = GetVehicleModVariation(veh, 23) and '✅ Enabled' or '❌ Disabled', icon = 'star', onSelect = ToggleCustomWheels},
        {title = 'Bulletproof Tires', description = not GetVehicleTyresCanBurst(veh) and '✅ Enabled' or '❌ Disabled', icon = 'shield', onSelect = ToggleBulletproofTires},
        {title = 'Tire Smoke', description = IsToggleModOn(veh, 20) and '✅ Enabled' or '❌ Disabled', icon = 'smoke', onSelect = ToggleTireSmoke}
    }

    lib.registerContext({
        id = 'wheels_tires_menu',
        title = 'Wheels & Tires',
        menu = 'vehicle_mods_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('wheels_tires_menu')
end

function openWheelTypeMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local options = {}

    local types = {
        {id=0, name="Sport"}, {id=1, name="Muscle"}, {id=2, name="Lowrider"},
        {id=3, name="SUV"}, {id=4, name="Offroad"}, {id=5, name="Tuner"},
        {id=6, name="Bike Wheels"}, {id=7, name="High End"}, {id=8, name="Benny's"}
    }

    for _, t in ipairs(types) do
        table.insert(options, {
            title = t.name,
            onSelect = function()
                SetVehicleModKit(veh, 0)
                SetVehicleWheelType(veh, t.id)
                lib.notify({title = 'Wheel Type', description = t.name, type = 'success'})
                openWheelTypeMenu()
            end
        })
    end

    lib.registerContext({
        id = 'wheel_type_menu',
        title = 'Wheel Type',
        menu = 'wheels_tires_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('wheel_type_menu')
end

function openWheelSelectionMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local options = {}

    local wheels = {
        {name = "Stock", id = -1},
        {name = "Inferno", id = 0}, {name = "Deep Five", id = 1}, {name = "Lozspeed Ten", id = 2},
        {name = "Diamond Cut", id = 3}, {name = "Mercie", id = 4}, {name = "Synthetic Z", id = 5},
        {name = "Organic Type 0", id = 6}, {name = "Endo v1", id = 7}, {name = "GT One", id = 8},
        {name = "Classic Five", id = 11}, {name = "Super Diamond", id = 12}
    }

    for _, w in ipairs(wheels) do
        table.insert(options, {
            title = w.name,
            onSelect = function()
                SetVehicleModKit(veh, 0)
                SetVehicleMod(veh, 23, w.id, false)
                SetVehicleMod(veh, 24, w.id, false)
                lib.notify({title = 'Wheels Applied', description = w.name, type = 'success'})
                openWheelSelectionMenu() -- Stay here
            end
        })
    end

    lib.registerContext({
        id = 'wheel_selection_menu',
        title = 'Select Wheels',
        menu = 'wheels_tires_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('wheel_selection_menu')
end

function openWheelColorPicker()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local options = {}

    for _, color in ipairs(gtaColors) do
        table.insert(options, {
            title = color.name,
            description = 'Color ID ' .. color.id,
            icon = 'circle',
            onSelect = function()
                local pearl = select(1, GetVehicleExtraColours(veh))
                SetVehicleExtraColours(veh, pearl, color.id)
                lib.notify({title = 'Wheel Color', description = color.name})
                openWheelColorPicker() -- Stay here
            end
        })
    end

    lib.registerContext({
        id = 'wheel_color_menu',
        title = 'Wheel Color',
        menu = 'wheels_tires_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('wheel_color_menu')
end

function ToggleCustomWheels()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local mod = GetVehicleMod(veh, 23)
    SetVehicleMod(veh, 23, mod, not GetVehicleModVariation(veh, 23))
    SetVehicleMod(veh, 24, mod, not GetVehicleModVariation(veh, 24))
    openWheelsTiresMenu()
end

function ToggleBulletproofTires()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleTyresCanBurst(veh, not GetVehicleTyresCanBurst(veh))
    openWheelsTiresMenu()
end

function ToggleTireSmoke()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    ToggleVehicleMod(veh, 20, not IsToggleModOn(veh, 20))
    openWheelsTiresMenu()
end
-- ==================== WINDOWS, PLATE & HORN ====================
-- ==================== WINDOWS, PLATE & HORN (Full Horns with Categories) ====================
function openPlateWindowHornMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    local plate = GetVehicleNumberPlateText(veh)

    local options = {
        {
            title = 'Set Plate Text: "' .. plate .. '"',
            description = 'Click to change license plate text (max 8 characters)',
            icon = 'id-card',
            onSelect = function()
                local input = lib.inputDialog('License Plate', {{type = 'input', label = 'Plate Text', default = plate, max = 8}})
                if input and input[1] then
                    SetVehicleNumberPlateText(veh, input[1])
                end
                openPlateWindowHornMenu()
            end
        },
        {
            title = 'Plate Type',
            description = 'Change license plate style',
            icon = 'credit-card',
            arrow = true,
            onSelect = openPlateTypeMenu
        },
        {
            title = 'Window Tint',
            description = 'Select window tint level',
            icon = 'window-restore',
            onSelect = openWindowTintMenu
        },
        {
            title = 'Horn',
            description = 'Select horn sound',
            icon = 'volume-high',
            onSelect = openHornMenu
        }
    }

    lib.registerContext({
        id = 'plate_window_horn_menu',
        title = 'Windows, Plate & Horn',
        menu = 'vehicle_mods_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('plate_window_horn_menu')
end

-- Window Tint
function openWindowTintMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local tints = {
        {id = 0, name = "None"},
        {id = 1, name = "Pure Black"},
        {id = 2, name = "Dark Smoke"},
        {id = 3, name = "Light Smoke"},
        {id = 4, name = "Stock"},
        {id = 5, name = "Limo"}
    }

    local options = {}
    for _, tint in ipairs(tints) do
        table.insert(options, {
            title = tint.name,
            onSelect = function()
                SetVehicleWindowTint(veh, tint.id)
                lib.notify({title = 'Window Tint', description = tint.name, type = 'success'})
                openWindowTintMenu() -- Stay open
            end
        })
    end

    lib.registerContext({
        id = 'window_tint_menu',
        title = 'Window Tint',
        menu = 'plate_window_horn_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('window_tint_menu')
end

-- Plate Type
function openPlateTypeMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    local plateTypes = {
        { id = 0,  name = 'Blue/White',          description = '' },
        { id = 1,  name = 'Yellow/Black',         description = '' },
        { id = 2,  name = 'Yellow/Blue',          description = '' },
        { id = 3,  name = 'Blue/White 2',         description = '' },
        { id = 4,  name = 'Blue/White 3',         description = 'Only use if LEO/Fire/EMS' },
        { id = 5,  name = 'Yankton',              description = '' },
        { id = 6,  name = 'Ecola',              description = '' },
        { id = 7,  name = 'Las Venturas',           description = '' },
        { id = 8,  name = 'Liberty City',            description = '' },
        { id = 9,  name = 'LS Car Meet',         description = '' },
        { id = 10, name = 'LS Panic',              description = '' },
        { id = 11, name = 'LS Pounders',              description = '' },
        { id = 12, name = 'Sprunk',        description = '' },
    }

    local current = GetVehicleNumberPlateTextIndex(veh)
    local options = {}

    for _, pt in ipairs(plateTypes) do
        local isCurrent = (pt.id == current)
        local capturedId = pt.id
        table.insert(options, {
            title       = pt.name,
            description = (isCurrent and '✅ Currently selected — ' or '') .. pt.description,
            icon        = isCurrent and 'check' or 'credit-card',
            iconColor   = isCurrent and '#22c55e' or nil,
            onSelect    = function()
                SetVehicleNumberPlateTextIndex(veh, capturedId)
                lib.notify({ title = 'Plate Type', description = pt.name, type = 'success' })
                openPlateTypeMenu()
            end
        })
    end

    lib.registerContext({
        id             = 'plate_type_menu',
        title          = 'Plate Type',
        menu           = 'plate_window_horn_menu',
        preventClosing = true,
        options        = options
    })
    ShowContext('plate_type_menu')
end

-- Horn Menu with Categories
function openHornMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local options = {}

    local hornCategories = {
        {title = "Stock & Classic", horns = {
            {name = "Stock Horn", id = -1},
            {name = "Truck Horn", id = 0},
            {name = "Police Horn", id = 1},
        }},
        {title = "Musical Horns", horns = {
            {name = "Jazz Horn", id = 10},
            {name = "Saxophone", id = 11},
            {name = "Trumpet", id = 12},
        }},
        {title = "Fun Horns", horns = {
            {name = "Sad Trombone", id = 14},
            {name = "Clown", id = 15},
            {name = "Air Horn", id = 16},
        }}
    }

    for _, cat in ipairs(hornCategories) do
        table.insert(options, {
            title = cat.title,
            arrow = true,
            onSelect = function()
                local subOptions = {}
                for _, h in ipairs(cat.horns) do
                    table.insert(subOptions, {
                        title = h.name,
                        onSelect = function()
                            SetVehicleMod(veh, 14, h.id, false) -- Horn mod ID = 14
                            lib.notify({title = 'Horn Changed', description = h.name, type = 'success'})
                            openHornMenu() -- Stay open
                        end
                    })
                end

                lib.registerContext({
                    id = 'horn_sub_menu',
                    title = cat.title,
                    menu = 'plate_window_horn_menu',
                    preventClosing = true,
                    options = subOptions
                })
                ShowContext('horn_sub_menu')
            end
        })
    end

    lib.registerContext({
        id = 'horn_menu',
        title = 'Select Horn',
        menu = 'plate_window_horn_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('horn_menu')
end
-- ==================== SAVED VEHICLES ====================
CreateThread(function()
    Wait(1000)
    local success, result = pcall(function() return lib.callback.await('corey_vehiclemenu:getSavedVehicles', false) end)
    if success and result then
        savedVehicles = result
        print('^2[Vehicle Menu] Loaded ' .. #savedVehicles .. ' saved vehicles^7')
    else
        savedVehicles = {}
    end
end)

local function SaveSingleVehicle(name, vehicleData)
    TriggerServerEvent('corey_vehiclemenu:saveVehicle', name, vehicleData)
end

local function DeleteVehicleFromDB(name)
    TriggerServerEvent('corey_vehiclemenu:deleteVehicle', name)
end

function SaveCurrentVehicle()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return lib.notify({title = 'Error', description = 'You must be in a vehicle', type = 'error'}) end

    local input = lib.inputDialog('Save Vehicle', {
        {type = 'input', label = 'Vehicle Name', required = true, max = 50},
        {type = 'select', label = 'Category', options = {
            {value = 'civilian', label = 'Civilian'}, {value = 'favorites', label = 'Favorites'},
            {value = 'law', label = 'Law Enforcement'}, {value = 'fire', label = 'San Andreas Fire Rescue'},
            {value = 'other', label = 'Other'}
        }, required = true, default = 'civilian'}
    })
    if not input then return end

    local vehicleData = BuildVehicleData(vehicle)
    vehicleData.category = input[2]

    table.insert(savedVehicles, {name = input[1], data = vehicleData})
    SaveSingleVehicle(input[1], vehicleData)

    lib.notify({title = 'Vehicle Saved', description = input[1], type = 'success'})
    openSavedVehiclesMenu()
end

function openSavedVehiclesMenu()
    local cats = {civilian=0, favorites=0, law=0, fire=0, other=0}
    for _, v in ipairs(savedVehicles) do
        local c = v.data and v.data.category or 'other'
        if cats[c] then cats[c] = cats[c] + 1 end
    end

    local options = {
        { title = 'Search Saved Vehicles', icon = 'magnifying-glass', onSelect = openSavedVehicleSearchMenu }
    }

    local catDefs = {
        {id='civilian', label='Civilian', icon='users', color='#22c55e'},
        {id='favorites', label='Favorites', icon='star', color='#eab308'},
        {id='law', label='Law Enforcement', icon='shield-halved', color='#3b82f6'},
        {id='fire', label='San Andreas Fire Rescue', icon='fire-extinguisher', color='#ef4444'},
        {id='other', label='Other', icon='folder', color='#a1a1aa'}
    }

    for _, def in ipairs(catDefs) do
        if cats[def.id] > 0 then
            table.insert(options, {
                title = def.label .. ' (' .. cats[def.id] .. ')',
                icon = def.icon,
                iconColor = def.color,
                onSelect = function() openCategorySavedMenu(def.id, def.label) end
            })
        end
    end

    if #savedVehicles == 0 then
        table.insert(options, {title = 'No saved vehicles yet', disabled = true})
    end

    lib.registerContext({ id = 'saved_vehicles_menu', title = 'Saved Vehicles', menu = 'corey_vehicle_manager', preventClosing = true, options = options })
    ShowContext('saved_vehicles_menu')
end

function openSavedVehicleSearchMenu()
    local input = lib.inputDialog('Search Saved Vehicles', {{type = 'input', label = 'Name or Model', required = true}})
    if not input or not input[1] then return openSavedVehiclesMenu() end

    local query = input[1]:lower()
    local results = {}

    for i, saved in ipairs(savedVehicles) do
        if saved.name:lower():find(query) or (saved.data.model or ''):lower():find(query) then
            table.insert(results, {
                title = saved.name,
                description = saved.data.plate and ("Plate: " .. saved.data.plate) or saved.data.model,
                icon = 'car',
                onSelect = function() showSavedVehicleActions(i, saved) end
            })
        end
    end

    if #results == 0 then
        lib.notify({title = 'No Results', type = 'error'})
        return openSavedVehiclesMenu()
    end

    lib.registerContext({ id = 'saved_search_results', title = 'Search Results', menu = 'saved_vehicles_menu', preventClosing = true, options = results })
    ShowContext('saved_search_results')
end

function showSavedVehicleActions(index, saved)
    lib.registerContext({
        id = 'saved_vehicle_actions',
        title = saved.name,
        menu = 'saved_category_menu',
        preventClosing = true,
        options = {
            {title = 'Spawn Vehicle', icon = 'car', onSelect = function() SpawnVehicle(saved.data.model, saved.data, function() showSavedVehicleActions(index, saved) end) end},
            {title = 'Replace with Current Vehicle', icon = 'rotate', onSelect = function() ReplaceSavedVehicle(index) end},
            {title = 'Rename Vehicle', icon = 'pen', onSelect = function() RenameSavedVehicle(index) end},
            {title = 'Change Category', icon = 'tags', onSelect = function() ChangeSavedCategory(index) end},
            {title = 'Delete', icon = 'trash', iconColor = '#ef4444', onSelect = function() DeleteSavedVehicle(index) end}
        }
    })
    ShowContext('saved_vehicle_actions')
end

function ReplaceSavedVehicle(index)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return lib.notify({title = 'Error', description = 'You must be in a vehicle', type = 'error'}) end

    local saved = savedVehicles[index]
    local vehicleData = BuildVehicleData(vehicle)
    vehicleData.category = saved.data.category

    saved.data = vehicleData
    SaveSingleVehicle(saved.name, vehicleData)
    lib.notify({title = 'Replaced', description = saved.name .. ' updated', type = 'success'})
end

function ChangeSavedCategory(index)
    local saved = savedVehicles[index]
    local input = lib.inputDialog('Change Category', {
        {type = 'select', label = 'New Category', options = {
            {value = 'civilian', label = 'Civilian'}, {value = 'favorites', label = 'Favorites'},
            {value = 'law', label = 'Law Enforcement'}, {value = 'fire', label = 'San Andreas Fire Rescue'},
            {value = 'other', label = 'Other'}
        }, default = saved.data.category}
    })
    if input then
        saved.data.category = input[1]
        SaveSingleVehicle(saved.name, saved.data)
        lib.notify({title = 'Category Updated', type = 'success'})
        openSavedVehiclesMenu()
    end
end

function RenameSavedVehicle(index)
    local saved = savedVehicles[index]
    if not saved then return end

    local input = lib.inputDialog('Rename Vehicle', {
        {type = 'input', label = 'New Name', default = saved.name, required = true, max = 50}
    })

    if not input or not input[1] or input[1] == saved.name then 
        return 
    end

    local oldName = saved.name
    local newName = input[1]

    -- Update client table
    saved.name = newName

    -- Update database
    TriggerServerEvent('corey_vehiclemenu:renameVehicle', oldName, newName)

    lib.notify({title = 'Vehicle Renamed', description = oldName .. ' → ' .. newName, type = 'success'})
    openSavedVehiclesMenu() -- Refresh menu
end

function DeleteSavedVehicle(index)
    local saved = savedVehicles[index]
    local confirm = lib.alertDialog({ header = 'Delete Vehicle?', content = 'Delete "' .. saved.name .. '"?', centered = true, cancel = true })
    if confirm == 'confirm' then
        table.remove(savedVehicles, index)
        DeleteVehicleFromDB(saved.name)
        lib.notify({title = 'Deleted', type = 'warning'})
        openSavedVehiclesMenu()
    end
end

function openCategorySavedMenu(categoryId, categoryName)
    local options = {}
    for i, saved in ipairs(savedVehicles) do
        if saved.data and (saved.data.category or 'other') == categoryId then
            table.insert(options, {
                title = saved.name,
                description = saved.data.plate and ("License Plate: " .. saved.data.plate) or (saved.data.model or 'Unknown'),
                icon = 'car',
                onSelect = function() showSavedVehicleActions(i, saved) end
            })
        end
    end

    if #options == 0 then table.insert(options, {title = 'No vehicles in this category', disabled = true}) end

    lib.registerContext({ id = 'saved_category_menu', title = categoryName, menu = 'saved_vehicles_menu', preventClosing = true, options = options })
    ShowContext('saved_category_menu')
end

-- ==================== COLOR CATEGORIES (Correct GTA V Types) ====================
local colorCategories = {
    { id = 'classic', title = 'Classic Colors',     icon = 'palette',  iconColor = '#ef4444', type = 0, description = 'Standard metallic colors' },
    { id = 'matte',   title = 'Matte Colors',       icon = 'square',   iconColor = '#94a3b8', type = 3, description = 'Matte finish colors' },
    { id = 'metal',   title = 'Metal Colors',       icon = 'wrench',   iconColor = '#64748b', type = 4, description = 'Brushed metal finishes' },
    { id = 'util',    title = 'Util Colors',        icon = 'screwdriver-wrench', iconColor = '#f97316', type = 5, description = 'Utility / flat colors' },
    { id = 'worn',    title = 'Worn Colors',        icon = 'layer-group', iconColor = '#a16207', type = 6, description = 'Weathered / worn finishes' },
}

-- Full color lists per category
colorCategories[1].colors = { -- Classic
    {id=0,name="Black"},{id=1,name="Graphite"},{id=2,name="Black Steel"},{id=3,name="Dark Silver"},
    {id=4,name="Silver"},{id=5,name="Bluish Silver"},{id=6,name="Rolled Steel"},{id=7,name="Shadow Silver"},
    {id=8,name="Stone Silver"},{id=9,name="Midnight Silver"},{id=10,name="Cast Iron Silver"},{id=11,name="Anthracite Black"},
    {id=27,name="Red"},{id=28,name="Torino Red"},{id=29,name="Formula Red"},{id=30,name="Blaze Red"},
    {id=31,name="Grace Red"},{id=32,name="Garnet Red"},{id=33,name="Sunset Red"},{id=34,name="Cabernet Red"},
    {id=35,name="Candy Red"},{id=36,name="Sunrise Orange"},{id=37,name="Gold"},{id=38,name="Orange"},
    {id=88,name="Yellow"},{id=89,name="Race Yellow"},{id=90,name="Bronze"},{id=91,name="Dew Yellow"},
    {id=92,name="Lime Green"},{id=49,name="Dark Green"},{id=50,name="Racing Green"},{id=51,name="Sea Green"},
    {id=52,name="Olive Green"},{id=53,name="Bright Green"},{id=54,name="Gasoline Green"},{id=61,name="Galaxy Blue"},
    {id=62,name="Dark Blue"},{id=63,name="Saxon Blue"},{id=64,name="Blue"},{id=65,name="Mariner Blue"},
    {id=66,name="Harbor Blue"},{id=67,name="Diamond Blue"},{id=68,name="Surf Blue"},{id=69,name="Nautical Blue"},
    {id=70,name="Ultra Blue"},{id=71,name="Schafter Purple"},{id=72,name="Spinnaker Purple"},{id=73,name="Racing Blue"},
    {id=74,name="Light Blue"},{id=107,name="Cream"},{id=111,name="Ice White"},{id=112,name="Frost White"},
    {id=120,name="Chrome"}
}

colorCategories[2].colors = { -- Matte (indices 0-18, passed to SetVehicleModColor_1/2)
    {id=0,name="Matte Black"},{id=1,name="Matte Gray"},{id=2,name="Matte Light Gray"},{id=3,name="Matte Ice White"},
    {id=4,name="Matte Blue"},{id=5,name="Matte Dark Blue"},{id=6,name="Matte Midnight Blue"},{id=7,name="Matte Midnight Purple"},
    {id=8,name="Matte Schafter Purple"},{id=9,name="Matte Red"},{id=10,name="Matte Dark Red"},{id=11,name="Matte Orange"},
    {id=12,name="Matte Yellow"},{id=13,name="Matte Lime Green"},{id=14,name="Matte Green"},{id=15,name="Matte Forest Green"},
    {id=16,name="Matte Foliage Green"},{id=17,name="Matte Olive Drab"},{id=18,name="Matte Dark Earth"}
}

colorCategories[3].colors = { -- Metal (indices 0-4, passed to SetVehicleModColor_1/2)
    {id=0,name="Brushed Steel"},{id=1,name="Brushed Black Steel"},{id=2,name="Brushed Aluminum"},
    {id=3,name="Pure Gold"},{id=4,name="Brushed Gold"}
}

colorCategories[4].colors = { -- Util
    {id=96,name="Util Black"},{id=97,name="Util Black Poly"},{id=98,name="Util Dark Silver"},{id=99,name="Util Silver"},
    {id=100,name="Util Gun Metal"},{id=101,name="Util Shadow Silver"},{id=102,name="Util Red"},{id=103,name="Util Bright Red"},
    {id=104,name="Util Garnet Red"},{id=105,name="Util Dark Green"},{id=106,name="Util Green"},{id=107,name="Util Bright Green"},
    {id=108,name="Util Dark Blue"},{id=109,name="Util Midnight Blue"},{id=110,name="Util Blue"},{id=111,name="Util Sea Foam"},
    {id=112,name="Util Periwinkle"},{id=113,name="Util Bright Blue"},{id=114,name="Util Golden Yellow"},{id=115,name="Util Yellow"},
    {id=116,name="Util Bright Orange"},{id=117,name="Util Orange"},{id=118,name="Util Sandy"},{id=119,name="Util Bright Sandy"},
    {id=120,name="Util Brown"},{id=121,name="Util Medium Brown"},{id=122,name="Util Tan"},{id=123,name="Util Beige"},
    {id=124,name="Util Off White"},{id=125,name="Util White"},{id=126,name="Util Frost White"}
}

colorCategories[5].colors = { -- Worn
    {id=160,name="Worn Black"},{id=161,name="Worn Graphite"},{id=162,name="Worn Silver Gray"},{id=163,name="Worn Silver"},
    {id=164,name="Worn Blue Silver"},{id=165,name="Worn Shadow Silver"},{id=166,name="Worn Red"},{id=167,name="Worn Golden Red"},
    {id=168,name="Worn Dark Red"},{id=169,name="Worn Dark Green"},{id=170,name="Worn Green"},{id=171,name="Worn Sea Wash"},
    {id=172,name="Worn Hard Blue"},{id=173,name="Worn Blue"},{id=174,name="Worn Midnight Blue"},{id=175,name="Worn Sandy"},
    {id=176,name="Worn Grayish Brown"},{id=177,name="Worn Brown"},{id=178,name="Worn Dark Brown"},{id=179,name="Worn Straw Beige"},
    {id=180,name="Worn Off White"},{id=181,name="Worn Cream"},{id=182,name="Worn Chestnut"},{id=183,name="Worn Medium Brown"},
    {id=184,name="Worn Light Brown"},{id=185,name="Worn Yellow"}
}

-- ==================== APPLY COLOR (Fixed for all types) ====================
-- paintType: 0=Normal/Classic, 1=Metallic, 2=Pearl, 3=Matte, 4=Metal, 5=Chrome
-- colorId:   for Classic (paintType 0) → raw GTA colour ID passed to SetVehicleColours
--            for all others → 0-based index within that paint type's list,
--            passed to SetVehicleModColor_1/2 (NOT the raw colour number)
local function applyColor(isPrimary, colorId, paintType)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    local pearl, wheel = GetVehicleExtraColours(veh)

    if paintType == 0 then
        -- Classic: SetVehicleColours takes the raw colour ID directly
        local pri, sec = GetVehicleColours(veh)
        if isPrimary then
            SetVehicleColours(veh, colorId, sec)
        else
            SetVehicleColours(veh, pri, colorId)
        end
    else
        -- Matte/Metal/Util/Worn: colorId is a 0-based index within the paint type list.
        -- SetVehicleModColor_1/2 signature: (vehicle, paintType, colorIndex, pearlescentColor)
        if isPrimary then
            SetVehicleModColor_1(veh, paintType, colorId, 0)
        else
            SetVehicleModColor_2(veh, paintType, colorId)
        end
        -- Restore pearl/wheel — SetVehicleModColor_1 can reset them
        SetVehicleExtraColours(veh, pearl, wheel)
    end
end

-- ==================== PAINT & COLORS MENU (Clean + Correct IDs) ====================
function openPaintMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then 
        lib.notify({title = 'Error', description = 'You must be in a vehicle', type = 'error'})
        return 
    end

    local primary, secondary = GetVehicleColours(veh)
    local pearlescent, wheel = GetVehicleExtraColours(veh)
    local dashboard = GetVehicleDashboardColour(veh) or 0
    local interior = GetVehicleInteriorColour(veh) or 0

    local options = {
        {title = 'Primary Color',   icon = 'palette',   iconColor = '#ef4444', description = 'Current: Color ID '..primary,   onSelect = function() openColorTypeMenu(true) end},
        {title = 'Secondary Color', icon = 'paintbrush',iconColor = '#3b82f6', description = 'Current: Color ID '..secondary, onSelect = function() openColorTypeMenu(false) end},
        {title = 'Pearlescent Color', icon = 'gem',     iconColor = '#eab308', description = 'Current: Color ID '..pearlescent, onSelect = openPearlescentPicker},
        {title = 'Wheel Color',     icon = 'circle',    iconColor = '#22c55e', description = 'Current: Color ID '..wheel,      onSelect = openWheelColorPicker},
        {title = 'Dashboard Color', icon = 'gauge',     iconColor = '#a855f7', description = 'Current: Color ID '..dashboard,  onSelect = openDashboardColorPicker},
        {title = 'Interior Color',  icon = 'couch',     iconColor = '#f97316', description = 'Current: Color ID '..interior,   onSelect = openInteriorColorPicker},
    }

    lib.registerContext({
        id = 'paint_menu',
        title = 'Paint & Colors',
        menu = 'corey_vehicle_manager',
        preventClosing = true,
        options = options
    })
    ShowContext('paint_menu')
end

-- ==================== COLOR TYPE MENU (Classic / Matte / etc.) ====================
function openColorTypeMenu(isPrimary)
    local slotName = isPrimary and "Primary Color" or "Secondary Color"
    local options = {}

    for _, cat in ipairs(colorCategories) do
        table.insert(options, {
            title = cat.title,
            icon = cat.icon,
            iconColor = cat.iconColor,
            description = cat.description,
            arrow = true,
            onSelect = function() openColorList(isPrimary, cat) end
        })
    end

    -- Custom RGB
    table.insert(options, {
        title = 'Custom RGB',
        icon = 'rainbow',
        iconColor = '#a855f7',
        description = 'Set custom RGB values',
        onSelect = function() openCustomRGBMenu(isPrimary) end
    })

    lib.registerContext({
        id = isPrimary and 'primary_color_type' or 'secondary_color_type',
        title = slotName,
        menu = 'paint_menu',
        preventClosing = true,
        options = options
    })
    ShowContext(isPrimary and 'primary_color_type' or 'secondary_color_type')
end

-- ==================== COLOR LIST (Stays Open) ====================
function openColorList(isPrimary, category)
    local options = {}

    for _, color in ipairs(category.colors) do
        table.insert(options, {
            title = color.name,
            description = 'Color ID ' .. color.id,
            icon = 'circle',
            onSelect = function()
                applyColor(isPrimary, color.id, category.type)
                lib.notify({
                    title = (isPrimary and 'Primary' or 'Secondary') .. ' Color',
                    description = color.name .. ' (ID ' .. color.id .. ')',
                    type = 'success'
                })
                openColorList(isPrimary, category) -- Stay open
            end
        })
    end

    lib.registerContext({
        id = (isPrimary and 'primary_' or 'secondary_') .. category.id .. '_list',
        title = category.title,
        menu = isPrimary and 'primary_color_type' or 'secondary_color_type',
        preventClosing = true,
        options = options
    })
    ShowContext((isPrimary and 'primary_' or 'secondary_') .. category.id .. '_list')
end

-- ==================== CUSTOM RGB ====================
function openCustomRGBMenu(isPrimary)
    local input = lib.inputDialog(
        (isPrimary and 'Primary' or 'Secondary') .. ' Custom RGB',
        {
            {type = 'number', label = 'Red (0-255)',   min = 0, max = 255, default = 255},
            {type = 'number', label = 'Green (0-255)', min = 0, max = 255, default = 255},
            {type = 'number', label = 'Blue (0-255)',  min = 0, max = 255, default = 255},
        }
    )
    if not input then
        openColorTypeMenu(isPrimary)
        return
    end

    local r, g, b = tonumber(input[1]) or 255, tonumber(input[2]) or 255, tonumber(input[3]) or 255
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    if isPrimary then
        SetVehicleCustomPrimaryColour(veh, r, g, b)
    else
        SetVehicleCustomSecondaryColour(veh, r, g, b)
    end

    lib.notify({
        title = (isPrimary and 'Primary' or 'Secondary') .. ' RGB Color',
        description = ('R:%d G:%d B:%d'):format(r, g, b),
        type = 'success'
    })
    openColorTypeMenu(isPrimary)
end

-- ==================== PEARLESCENT ====================
function openPearlescentPicker()
    local options = {}
    -- Pearlescent only uses classic range 0-74
    local pearlescentColors = colorCategories[1].colors -- Classic
    for _, color in ipairs(pearlescentColors) do
        if color.id <= 74 then
            table.insert(options, {
                title = color.name,
                description = 'Color ID ' .. color.id,
                icon = 'circle',
                onSelect = function()
                    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                    local _, wc = GetVehicleExtraColours(veh)
                    SetVehicleExtraColours(veh, color.id, wc)
                    lib.notify({title = 'Pearlescent Color', description = color.name .. ' (ID ' .. color.id .. ')', type = 'success'})
                    openPearlescentPicker()
                end
            })
        end
    end
    lib.registerContext({id = 'pearlescent_menu', title = 'Pearlescent Color', menu = 'paint_menu', preventClosing = true, options = options})
    ShowContext('pearlescent_menu')
end

-- ==================== WHEEL COLOR ====================
function openWheelColorPicker()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    local options = {}
    for _, color in ipairs(colorCategories[1].colors) do -- Classic range works for wheels
        table.insert(options, {
            title = color.name,
            description = 'Color ID ' .. color.id,
            icon = 'circle',
            onSelect = function()
                local pearl = select(1, GetVehicleExtraColours(veh))
                SetVehicleExtraColours(veh, pearl, color.id)
                lib.notify({title = 'Wheel Color', description = color.name, type = 'success'})
                openWheelColorPicker()
            end
        })
    end

    lib.registerContext({
        id = 'wheel_color_menu',
        title = 'Wheel Color',
        menu = 'paint_menu',
        preventClosing = true,
        options = options
    })
    ShowContext('wheel_color_menu')
end

-- ==================== INTERIOR COLOR ====================
function openInteriorColorPicker()
    local options = {}
    for _, color in ipairs(colorCategories[1].colors) do
        table.insert(options, {
            title = color.name,
            description = 'Color ID ' .. color.id,
            icon = 'circle',
            onSelect = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                SetVehicleInteriorColour(veh, color.id)
                lib.notify({title = 'Interior Color', description = color.name .. ' (ID ' .. color.id .. ')', type = 'success'})
                openInteriorColorPicker()
            end
        })
    end
    lib.registerContext({id = 'interior_color_menu', title = 'Interior Color', menu = 'paint_menu', preventClosing = true, options = options})
    ShowContext('interior_color_menu')
end

-- ==================== DASHBOARD COLOR ====================
function openDashboardColorPicker()
    local options = {}
    for _, color in ipairs(colorCategories[1].colors) do
        table.insert(options, {
            title = color.name,
            description = 'Color ID ' .. color.id,
            icon = 'circle',
            onSelect = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                SetVehicleDashboardColour(veh, color.id)
                lib.notify({title = 'Dashboard Color', description = color.name .. ' (ID ' .. color.id .. ')', type = 'success'})
                openDashboardColorPicker()
            end
        })
    end
    lib.registerContext({id = 'dashboard_color_menu', title = 'Dashboard Color', menu = 'paint_menu', preventClosing = true, options = options})
    ShowContext('dashboard_color_menu')
end

-- ==================== EXTRAS & LIVERIES ====================
function openExtrasLiveryMenu()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end

    local options = {}

    local currentLivery = GetVehicleLivery(veh)
    local liveryCount = GetVehicleLiveryCount(veh) or 0
    table.insert(options, {
        title = 'Current Livery: ' .. (currentLivery + 1) .. '/' .. (liveryCount > 0 and liveryCount or 1),
        description = 'Click to cycle through available liveries',
        icon = 'palette',
        onSelect = function()
            local next = (currentLivery + 1) % math.max(liveryCount, 1)
            SetVehicleLivery(veh, next)
            openExtrasLiveryMenu()
        end
    })

    table.insert(options, { title = 'Individual Extras', disabled = true })

    -- GTA extras are 1-indexed; slot 0 is unused on nearly all vehicles
    local hasExtra = false
    for i = 1, 14 do
        if DoesExtraExist(veh, i) then
            hasExtra = true
            local on = IsVehicleExtraTurnedOn(veh, i)
            local capturedI  = i
            local capturedOn = on
            table.insert(options, {
                title       = 'Extra ' .. i,
                description = 'Currently: ' .. (on and 'Enabled' or 'Disabled'),
                icon        = on and 'toggle-on' or 'toggle-off',
                iconColor   = on and '#22c55e' or '#ef4444',
                onSelect    = function()
                    -- SetVehicleExtra: second param 0 = enable, 1 = disable
                    SetVehicleExtra(veh, capturedI, capturedOn and 1 or 0)
                    openExtrasLiveryMenu()
                end
            })
        end
    end

    if not hasExtra then
        table.insert(options, { title = 'No extras available', disabled = true })
    end

    lib.registerContext({
        id = 'extras_livery_menu',
        title = 'Extras & Liveries',
        menu = 'corey_vehicle_manager',
        preventClosing = true,
        options = options
    })
    ShowContext('extras_livery_menu')
end

-- ==================== COMMAND ====================
RegisterCommand('vehmanager', OpenHeavyVehicleManager, false)

print('^2Corey Vehicle Manager - Full Version Loaded^7')