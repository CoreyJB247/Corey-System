Config = {}

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168,
    ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160,
    ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83,
    ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246,
    ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34,
    ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249,
    ["M"] = 244, [","] = 82, ["."] = 81, ["LCONTROL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174,
    ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107,
    ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

--------------------------------------------------------
-- Player Actions Configuration
--------------------------------------------------------

Config.PVP = true                            -- Set to true to enable player vs. player combat
Config.IdleCam = true                        -- Set to true to stop the native camera from panning around when the player stands idle
Config.HandsUp = false                        -- Enable "Hands Up" action
Config.HealthRegen = true                    -- Enables health regeneration
Config.StaminaBuff = true                    -- Set to true to give a stamina buff allowing longer running
Config.Crouch = false                         -- Enable crouch action
Config.AimAssist = true                      -- Disable aim assist on controllers
Config.BlindFire = false                      -- Prevent blind firing around corners
Config.PistolWhip = true                     -- Disable pistol whipping
Config.PointKeybind = Keys[""]              -- Sets key for pointing action
Config.JumpSpam = true                       -- Prevent jump spamming with rag dolling chance
Config.DisconnectReason = false               -- Shows a disconnect reason in console
Config.DisconnectTest = false                 -- Enables disconnect test
Config.DisconnectCmdName = ""  -- Command name for disconnect test
Config.PID = false                            -- Set to true to toggle player ID above their head with left alt
Config.PIDToggleKey = Keys[""]        -- The keybind to toggle player ID.
Config.WeaponDrops = true                    -- Set to true to prevent NPC weapon drop rewards

--------------------------------------------------------
-- Vehicle Settings
--------------------------------------------------------

Config.CustomPlates = false        -- Enable custom license plates
Config.DriveBy = false             -- Prevent shooting from moving vehicles above speed limit
Config.DriveBySpeed = 30          -- Speed limit for drive-by shooting (in MPH)
Config.HeadLightsStrength = 12.0  -- Headlight strength
Config.lockVehicles = false       -- Lock AI traffic and/or parked vehicles
Config.lockChance = 5             -- Lock percentage for vehicles
Config.lockDistance = 5           -- Maximum check distance for locked vehicles
Config.parkedOnly = false         -- Lock only parked vehicles if true
Config.HornFlash = false           -- Flash headlights when horn is active
Config.HornFlashEmerg = false     -- Limit flashing to emergency vehicles
Config.VehRewards = true          -- Set to true to disable vehicle rewards (guns from police cars). Set to false to enable vehicle rewards
Config.HeliHUD = {                
    hud = false,                   -- Enable helicopter HUD
    realisitc = true,             -- Enable realistic takeoff/landing
    UIPosition = { x = -0.36, y = 0.22 }
}               

--------------------------------------------------------
-- HUD and Interface Settings
--------------------------------------------------------

Config.weaponReticle = true       -- Remove reticle for all weapons except snipers
Config.HideHud = true             -- Hide specific HUD elements (set below)
Config.HudElements = {            -- List of HUD elements to hide
    HUD_WANTED_STARS = 1, HUD_WEAPON_ICON = 2, HUD_CASH = 3, HUD_MP_CASH = 4,
    HUD_VEHICLE_NAME = 6, HUD_AREA_NAME = 7, HUD_VEHICLE_CLASS = 8,
    HUD_STREET_NAME = 9, HUD_CASH_CHANGE = 13, HUD_SAVING_GAME = 17
}

--------------------------------------------------------
-- Density and Spawner Configuration
--------------------------------------------------------

Config.DisableAmbientSounds = true -- Set to true to reduce the noise of the ammunations gun range. Set to false to leave native ambiance
Config.ManagedDensity = true       -- Adjust density dynamically based on time/weather
Config.DynamicPedSpawner = true    -- Adjusts pedestrian spawn rate with ManagedDensity
Config.GeneratorsDensity = {       -- Density multipliers for different entities
    ['vehicle'] = 0.8, ['parked'] = 0.8, ['multiplier'] = 0.8, ['peds'] = 0.8, ['actions'] = 0.8
}

--------------------------------------------------------
-- Blips Configuration
--------------------------------------------------------

Config.Blips = true
Config.TheBlips = {
    { title = "LSPD Station 1", colour = 38, id = 60, vector3 = vec3(437.88, -981.12, 30.64) },
    { title = "LSPD Station 2", colour = 38, id = 60, vector3 = vec3(-1633.6, -1016.32, 13.16) },

    { title = "BCSO Station 1", colour = 28, id = 60, vector3 = vec3(1828.64, 3680.52, 34.32) },

    { title = "SASP Station 1", colour = 55, id = 60, vector3 = vec3(-3156.12, 1132.48, 21.12) },

    { title = "Fire Station 1", colour = 1, id = 61, vector3 = vec3(-383.0, 6117.48, 31.84) },
    { title = "Fire Station 2", colour = 1, id = 61, vector3 = vec3(1689.72, 3592.84, 52.72) },
    { title = "Fire Station 3", colour = 1, id = 61, vector3 = vec3(-635.88, -124.6, 40.92) },

    { title = "Hospital", colour = 1, id = 80, vector3 = vec3(-253.64, 6331.8, 33.48) },
    { title = "Hospital", colour = 1, id = 80, vector3 = vec3(1767.12, 3640.16, 34.64) },
    { title = "Hospital", colour = 1, id = 80, vector3 = vec3(301.16, -586.36, 43.88) },

    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(162.8, 6639.2, 31.68) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(1733.0, 6412.92, 35.8) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(1961.64, 3742.36, 32.36) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(544.28, 2672.08, 42.08) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(-3241.4, 1003.96, 13.0) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(-3039.4, 588.4, 8.76) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(378.04, 326.16, 104.92) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(28.84, -1347.68, 30.8) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(2557.88, 385.4, 108.4) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(2677.6, 3283.56, 55.16) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(153.84, 239.48, 106.96) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(-695.16, -859.12, 24.88) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(-578.12, -1014.6, 22.32) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(198.72, -29.6, 69.92) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(529.24, -157.48, 57.04) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(-2544.12, 2314.08, 33.24) },
    { title = "24/7 Store", colour = 2, id = 59, vector3 = vec3(266.8, -982.52, 29.36) },

    { title = "Liquor Store", colour = 33, id = 59, vector3 = vec3(-159.84, 6326.76, 31.76) },
    { title = "Liquor Store", colour = 33, id = 59, vector3 = vec3(-2971.96, 390.88, 15.6) },
    { title = "Liquor Store", colour = 33, id = 59, vector3 = vec3(-1489.76, -382.28, 40.6) },
    { title = "Liquor Store", colour = 33, id = 59, vector3 = vec3(-1225.88, -903.52, 12.36) },
    { title = "Liquor Store", colour = 33, id = 59, vector3 = vec3(210.6, -1775.52, 28.92) },
    { title = "Liquor Store", colour = 33, id = 59, vector3 = vec3(1139.16, -980.76, 46.4) },

    { title = "YouTool Store", colour = 3, id = 59, vector3 = vec3(2750.32, 3471.56, 55.04) },

    { title = "Megamall Store", colour = 3, id = 59, vector3 = vec3(30.2, -1769.52, 29.8) },

    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(-662.180, -934.961, 21.829) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(810.25, -2157.60, 29.62) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(1693.44, 3760.16, 34.71) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(-330.24, 6083.88, 31.45) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(252.63, -50.00, 69.94) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(22.56, -1109.89, 29.80) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(2567.69, 294.38, 108.73) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(-1117.58, 2698.61, 18.55) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(842.44, -1033.42, 28.19) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(-3170.12, 1085.4, 20.84) },
    { title = "Ammunation", colour = 1, id = 110, vector3 = vec3(-1309.8, -391.68, 36.68) },

    { title = "Bar", colour = 61, id = 93, vector3 = vec3(-565.04, 276.2, 83.32) },
    { title = "Bar", colour = 61, id = 93, vector3 = vec3(1995.68, 3065.04, 47.56) },
    { title = "Bar", colour = 61, id = 93, vector3 = vec3(-1388.28, -589.04, 30.32) },

    { title = "Jewelry Store", colour = 25, id = 617, vector3 = vec3(-624.28, -232.48, 39.04) },

    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(1350.28, -582.08, 76.52) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(921.2, -575.36, 57.8) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(-3083.48, 220.64, 13.92) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(1534.36, 2232.16, 78.76) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(-1097.4, -1669.92, 7.8) },

    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(-1652.76, -1040.28, 13.16) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(-583.16, -870.64, 25.2) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(-1180.12, -886.36, 13.88) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(135.24, -1463.36, 29.32) },

    { title = "Hotel", colour = 3, id = 492, vector3 = vec3(-131.68, -999.48, 53.08) },
    { title = "Hotel", colour = 3, id = 492, vector3 = vec3(-693.2, 5767.12, 17.84) },
    { title = "Hotel", colour = 3, id = 492, vector3 = vec3(1132.48, 2656.52, 38.0) },
}
