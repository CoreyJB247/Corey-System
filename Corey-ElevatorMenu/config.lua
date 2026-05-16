-- elevator/config.lua
-- All elevator definitions live here. Add, remove, or edit elevators freely.
-- The client and server will automatically pick up changes on resource restart.

Config = {}

-- Zone interaction radius (in metres) for all elevator zones
Config.ZoneRadius = 1.5

-- Show debug zone spheres (set true while placing coords, false in production)
Config.Debug = false

-- Screen fade duration in milliseconds when teleporting
Config.FadeOutMs = 500
Config.FadeInMs  = 500

-- Notification settings
Config.Notify = {
    title    = "Elevator",
    message  = "Arrived at destination.",
    type     = "inform",   -- "inform" | "success" | "error" | "warning"
    duration = 3000,
    icon     = "elevator",
}

--[[
    ELEVATOR DEFINITIONS
    --------------------
    Each entry follows this structure:

    ["unique_id"] = {
        label  = "Display name shown in the context menu header",
        floors = {
            -- Each floor needs a label and a vector4 (x, y, z, heading)
            { label = "Floor Name", coords = vector4(x, y, z, heading) },
        },
        -- One vector3 zone per floor, usually matching the floor coords x/y/z
        zones = {
            vector3(x, y, z),
        }
    },

    NOTE: floors and zones must be in the same order (index 1 = floor 1 = zone 1).
]]

Config.Elevators = {

    -- -------------------------------------------------------------------------
    -- Example: Office building (4 floors)
    -- -------------------------------------------------------------------------
    ["201Hospital"] = {
        label  = "Pillbox Hospital Elavator",
        floors = {
            { label = "Ground Floor", coords = vec4(344.2, -586.6, 28.8, 177.24) },
            { label = "Floor 1",     coords = vec4(332.36, -595.64, 43.28, 189.48) },
        },
        zones = {
            vec3(344.2, -586.6, 28.8),
            vec3(332.36, -595.64, 43.28),
        }
    },

    -- -------------------------------------------------------------------------
    -- Example: Parking garage (3 levels)
    -- -------------------------------------------------------------------------
    ["parking"] = {
        label  = "Parking Garage Elevator",
        floors = {
            { label = "Level P2 (Underground)", coords = vector4(200.0, -800.0, 16.0, 90.0) },
            { label = "Level P1",               coords = vector4(200.0, -800.0, 25.0, 90.0) },
            { label = "Street Level",           coords = vector4(200.0, -800.0, 33.0, 90.0) },
        },
        zones = {
            vector3(200.0, -800.0, 16.0),
            vector3(200.0, -800.0, 25.0),
            vector3(200.0, -800.0, 33.0),
        }
    },

    -- -------------------------------------------------------------------------
    -- Example: Hospital (5 floors)
    -- -------------------------------------------------------------------------
    ["hospital"] = {
        label  = "Pillbox Hill Medical Elevator",
        floors = {
            { label = "Basement — Morgue",  coords = vector4(300.0, -580.0, 38.0, 180.0) },
            { label = "Ground — Reception", coords = vector4(300.0, -580.0, 44.0, 180.0) },
            { label = "Floor 1 — Wards",    coords = vector4(300.0, -580.0, 57.0, 180.0) },
            { label = "Floor 2 — ICU",      coords = vector4(300.0, -580.0, 68.0, 180.0) },
            { label = "Rooftop — Helipad",  coords = vector4(300.0, -580.0, 78.0, 180.0) },
        },
        zones = {
            vector3(300.0, -580.0, 38.0),
            vector3(300.0, -580.0, 44.0),
            vector3(300.0, -580.0, 57.0),
            vector3(300.0, -580.0, 68.0),
            vector3(300.0, -580.0, 78.0),
        }
    },

    -- -------------------------------------------------------------------------
    -- Add more elevators below following the same pattern...
    -- -------------------------------------------------------------------------

}