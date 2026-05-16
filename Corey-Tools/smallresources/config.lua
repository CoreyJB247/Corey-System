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
    { title = "LSPD Station 1", colour = 38, id = 60, vector3 = vec3(-562.32, -138.04, 37.76) },
    { title = "LSPD Station 2", colour = 38, id = 60, vector3 = vec3(437.88, -981.12, 30.64) },
    { title = "LSPD Station 3", colour = 38, id = 60, vector3 = vec3(-1633.6, -1016.32, 13.16) },

    { title = "BCSO Station 1", colour = 28, id = 60, vector3 = vec3(1828.68, 3667.4, 35.88) },

    { title = "PBPD Station 1", colour = 38, id = 60, vector3 = vec3(-444.56, 6009.52, 32.16) },

    { title = "SASP Station 1", colour = 55, id = 60, vector3 = vec3(822.76, -1291.24, 32.28) },
    { title = "SASP Station 2", colour = 55, id = 60, vector3 = vec3(1526.64, 788.96, 84.28) },
    { title = "SASP SWAT Station", colour = 55, id = 60, vector3 = vec3(2471.96, -384.08, 95.48) },

    { title = "Fire Station 1", colour = 1, id = 60, vector3 = vec3(-383.0, 6117.48, 31.84) },
    { title = "Fire Station 2", colour = 1, id = 60, vector3 = vec3(1689.72, 3592.84, 52.72) },
    { title = "Fire Station 3", colour = 1, id = 60, vector3 = vec3(-635.88, -124.6, 40.92) },
    { title = "Fire Station 4", colour = 1, id = 60, vector3 = vec3(387.96, 275.8, 104.92) },
    { title = "Fire Station 5", colour = 1, id = 60, vector3 = vec3(315.2, -1029.12, 29.32) },
    { title = "Fire Station 6", colour = 1, id = 60, vector3 = vec3(-1049.64, -1399.36, 5.56) },

    { title = "Hospital", colour = 2, id = 61, vector3 = vec3(-253.64, 6331.8, 33.48) },
    { title = "Hospital", colour = 2, id = 61, vector3 = vec3(1761.88, 3636.96, 36.32) },
    { title = "Hospital", colour = 2, id = 61, vector3 = vec3(301.16, -586.36, 43.88) },
    { title = "Hospital", colour = 2, id = 61, vector3 = vec3(359.72, -1409.8, 34.64) },

    { title = "Touchdown Car Rentals", colour = 5, id = 225, vector3 = vec3(-832.11, -2348.33, 13.57) },
    { title = "Touchdown Car Rentals", colour = 5, id = 225, vector3 = vec3(1733.0, 3324.6, 42.6) },

    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(1436.44, -1497.44, 66.36) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(112.2, -1956.24, 23.16) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(1800.4, 3735.24, 34.08) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(1729.0, 3859.2, 40.08) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(1372.44, 3652.48, 65.84) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(1616.84, 3585.28, 93.28) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(1421.0, 3537.0, 83.52) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(189.16, -1078.08, 29.28) },
    { title = "House Interiors", colour = 31, id = 40, vector3 = vec3(-210.48, -1586.24, 35.12) },

    { title = "Hotel", colour = 3, id = 492, vector3 = vec3(1620.84, 3779.8, 45.32) },
    { title = "Hotel", colour = 3, id = 492, vector3 = vec3(321.16, -213.52, 70.56) },
    { title = "Hotel", colour = 3, id = 492, vector3 = vec3(59.68, -1001.52, 29.36) },

    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(461.44, -1457.8, 30.08) },
    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(-1059.08, -238.92, 41.48) },
    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(-827.24, -728.24, 28.84) },
    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(461.44, -1457.8, 30.08) },
    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(461.44, -1457.8, 30.08) },
    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(461.44, -1457.8, 30.08) },
    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(461.44, -1457.8, 30.08) },
    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(461.44, -1457.8, 30.08) },
    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(-514.48, -1739.88, 20.72) },
    { title = "Civilian Interiors", colour = 2, id = 357, vector3 = vec3(1511.08, 3698.16, 45.84) },

    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(-583.16, -870.64, 25.2) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(130.8, -1461.32, 33.2) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(1241.6, -364.24, 69.52) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(-180.32, -1445.32, 31.84) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(1843.88, 3778.4, 34.6) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(-381.12, 6052.52, 32.0) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(-160.76, 281.52, 93.8) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(1532.92, 3776.88, 35.4) },
    { title = "Restaurant", colour = 50, id = 628, vector3 = vec3(-1652.12, -1040.28, 13.16) },
    
    { title = "Bar", colour = 61, id = 93, vector3 = vec3(-565.04, 276.2, 83.32) },
    { title = "Bar", colour = 61, id = 93, vector3 = vec3(1995.68, 3065.04, 47.56) },

    { title = "City Hall", colour = 4, id = 487, vector3 = vec3(1742.6, 3796.04, 38.16) },
    { title = "City Hall", colour = 4, id = 487, vector3 = vec3(340.92, 6622.68, 33.64) },
    { title = "City Hall", colour = 4, id = 487, vector3 = vec3(-1288.08, -569.28, 32.24) },

    { title = "Diamond Casino", colour = 4, id = 679, vector3 = vec3(924.56, 47.52, 80.96) },
    { title = "Four Dragons Casino", colour = 4, id = 679, vector3 = vec3(304.04, 212.2, 104.36) },

    { title = "Sandy Train Station", colour = 43, id = 607, vector3 = vec3(1884.04, 3577.12, 67.24) },

    { title = "Jewelry Store", colour = 43, id = 617, vector3 = vec3(-645.96, -275.16, 36.28) },
    { title = "Jewelry Store", colour = 43, id = 617, vector3 = vec3(-624.28, -232.48, 39.04) },
}
