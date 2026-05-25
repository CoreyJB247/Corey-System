-- Weapon Menu - Client
-- ox_lib context menus styled to match the reference menu.lua:
--   • preventClosing = true on every menu
--   • menu = 'parent_id' for native ox_lib back arrows (no manual ← Back items)
--   • ShowContext() wrapper so the last open menu is always tracked

-- ============================================================
-- LAST-CONTEXT TRACKER  (mirrors ReopenLastMenu pattern)
-- ============================================================

local _lastContextId = nil

local function ShowContext(id)
    _lastContextId = id
    lib.showContext(id)
end

function ReopenLastMenu()
    if _lastContextId then
        lib.showContext(_lastContextId)
    end
end

-- ============================================================
-- STATE
-- ============================================================

local savedLoadouts = {}

-- ============================================================
-- WEAPON DATA
-- ============================================================

local weaponCategories = {
    {
        label     = 'Handguns',
        icon      = 'gun',
        iconColor = '#3498db',
        weapons   = {
            { label = 'Pistol',            name = 'WEAPON_PISTOL',          ammo = 250 },
            { label = 'Pistol .50',        name = 'WEAPON_PISTOL50',        ammo = 250 },
            { label = 'Heavy Pistol',      name = 'WEAPON_HEAVYPISTOL',     ammo = 250 },
            { label = 'Vintage Pistol',    name = 'WEAPON_VINTAGEPISTOL',   ammo = 250 },
            { label = 'AP Pistol',         name = 'WEAPON_APPISTOL',        ammo = 250 },
            { label = 'SNS Pistol',        name = 'WEAPON_SNSPISTOL',       ammo = 250 },
            { label = 'Marksman Pistol',   name = 'WEAPON_MARKSMANPISTOL',  ammo = 50  },
            { label = 'Revolver',          name = 'WEAPON_REVOLVER',        ammo = 100 },
            { label = 'Flare Gun',         name = 'WEAPON_FLAREGUN',        ammo = 20  },
            { label = 'Stun Gun',          name = 'WEAPON_STUNGUN',         ammo = 0   },
        }
    },
    {
        label     = 'Submachine Guns',
        icon      = 'gun',
        iconColor = '#9b59b6',
        weapons   = {
            { label = 'Micro SMG',         name = 'WEAPON_MICROSMG',        ammo = 500 },
            { label = 'SMG',               name = 'WEAPON_SMG',             ammo = 500 },
            { label = 'Assault SMG',       name = 'WEAPON_ASSAULTSMG',      ammo = 500 },
            { label = 'Combat PDW',        name = 'WEAPON_COMBATPDW',       ammo = 500 },
            { label = 'Machine Pistol',    name = 'WEAPON_MACHINEPISTOL',   ammo = 500 },
            { label = 'Mini SMG',          name = 'WEAPON_MINISMG',         ammo = 500 },
        }
    },
    {
        label     = 'Shotguns',
        icon      = 'gun',
        iconColor = '#e67e22',
        weapons   = {
            { label = 'Pump Shotgun',      name = 'WEAPON_PUMPSHOTGUN',     ammo = 100 },
            { label = 'Sawed-Off Shotgun', name = 'WEAPON_SAWNOFFSHOTGUN',  ammo = 100 },
            { label = 'Assault Shotgun',   name = 'WEAPON_ASSAULTSHOTGUN',  ammo = 100 },
            { label = 'Bullpup Shotgun',   name = 'WEAPON_BULLPUPSHOTGUN',  ammo = 100 },
            { label = 'Heavy Shotgun',     name = 'WEAPON_HEAVYSHOTGUN',    ammo = 100 },
            { label = 'Double Barrel',     name = 'WEAPON_DBSHOTGUN',       ammo = 100 },
        }
    },
    {
        label     = 'Assault Rifles',
        icon      = 'gun',
        iconColor = '#27ae60',
        weapons   = {
            { label = 'Assault Rifle',     name = 'WEAPON_ASSAULTRIFLE',    ammo = 500 },
            { label = 'Carbine Rifle',     name = 'WEAPON_CARBINERIFLE',    ammo = 500 },
            { label = 'Advanced Rifle',    name = 'WEAPON_ADVANCEDRIFLE',   ammo = 500 },
            { label = 'Special Carbine',   name = 'WEAPON_SPECIALCARBINE',  ammo = 500 },
            { label = 'Bullpup Rifle',     name = 'WEAPON_BULLPUPRIFLE',    ammo = 500 },
            { label = 'Compact Rifle',     name = 'WEAPON_COMPACTRIFLE',    ammo = 500 },
        }
    },
    {
        label     = 'Light Machine Guns',
        icon      = 'gun',
        iconColor = '#e74c3c',
        weapons   = {
            { label = 'MG',                name = 'WEAPON_MG',              ammo = 500 },
            { label = 'Combat MG',         name = 'WEAPON_COMBATMG',        ammo = 500 },
            { label = 'Gusenberg Sweeper', name = 'WEAPON_GUSENBERG',       ammo = 500 },
        }
    },
    {
        label     = 'Sniper Rifles',
        icon      = 'gun',
        iconColor = '#1abc9c',
        weapons   = {
            { label = 'Sniper Rifle',      name = 'WEAPON_SNIPERRIFLE',     ammo = 50  },
            { label = 'Heavy Sniper',      name = 'WEAPON_HEAVYSNIPER',     ammo = 30  },
            { label = 'Marksman Rifle',    name = 'WEAPON_MARKSMANRIFLE',   ammo = 50  },
        }
    },
    {
        label     = 'Heavy Weapons',
        icon      = 'bomb',
        iconColor = '#e74c3c',
        weapons   = {
            { label = 'RPG',               name = 'WEAPON_RPG',             ammo = 20  },
            { label = 'Grenade Launcher',  name = 'WEAPON_GRENADELAUNCHER', ammo = 20  },
            { label = 'Minigun',           name = 'WEAPON_MINIGUN',         ammo = 500 },
            { label = 'Railgun',           name = 'WEAPON_RAILGUN',         ammo = 20  },
            { label = 'Homing Launcher',   name = 'WEAPON_HOMINGLAUNCHER',  ammo = 10  },
        }
    },
    {
        label     = 'Throwables',
        icon      = 'circle-dot',
        iconColor = '#f39c12',
        weapons   = {
            { label = 'Grenade',           name = 'WEAPON_GRENADE',         ammo = 10 },
            { label = 'Smoke Grenade',     name = 'WEAPON_SMOKEGRENADE',    ammo = 10 },
            { label = 'BZ Gas',            name = 'WEAPON_BZGAS',           ammo = 10 },
            { label = 'Molotov',           name = 'WEAPON_MOLOTOV',         ammo = 10 },
            { label = 'Sticky Bomb',       name = 'WEAPON_STICKYBOMB',      ammo = 10 },
            { label = 'Proximity Mine',    name = 'WEAPON_PROXMINE',        ammo = 10 },
            { label = 'Pipe Bomb',         name = 'WEAPON_PIPEBOMB',        ammo = 10 },
            { label = 'Flare',             name = 'WEAPON_FLARE',           ammo = 10 },
            { label = 'Snowball',          name = 'WEAPON_SNOWBALL',        ammo = 20 },
        }
    },
    {
        label     = 'Melee',
        icon      = 'hand-fist',
        iconColor = '#e74c3c',
        weapons   = {
            { label = 'Knife',             name = 'WEAPON_KNIFE',           ammo = 0 },
            { label = 'Nightstick',        name = 'WEAPON_NIGHTSTICK',      ammo = 0 },
            { label = 'Baseball Bat',      name = 'WEAPON_BAT',             ammo = 0 },
            { label = 'Crowbar',           name = 'WEAPON_CROWBAR',         ammo = 0 },
            { label = 'Hammer',            name = 'WEAPON_HAMMER',          ammo = 0 },
            { label = 'Golf Club',         name = 'WEAPON_GOLFCLUB',        ammo = 0 },
            { label = 'Wrench',            name = 'WEAPON_WRENCH',          ammo = 0 },
            { label = 'Machete',           name = 'WEAPON_MACHETE',         ammo = 0 },
            { label = 'Hatchet',           name = 'WEAPON_HATCHET',         ammo = 0 },
            { label = 'Brass Knuckles',    name = 'WEAPON_KNUCKLE',         ammo = 0 },
            { label = 'Switchblade',       name = 'WEAPON_SWITCHBLADE',     ammo = 0 },
            { label = 'Flashlight',        name = 'WEAPON_FLASHLIGHT',      ammo = 0 },
        }
    },
    {
        label     = 'Misc / Tools',
        icon      = 'wrench',
        iconColor = '#7f8c8d',
        weapons   = {
            { label = 'Jerry Can',         name = 'WEAPON_PETROLCAN',        ammo = 0 },
            { label = 'Fire Extinguisher', name = 'WEAPON_FIREEXTINGUISHER', ammo = 0 },
            { label = 'Parachute',         name = 'WEAPON_PARACHUTE',        ammo = 0 },
        }
    },
}

-- Emergency preset loadouts
local emergencyLoadouts = {
    {
        label       = 'Law Enforcement Officer',
        description = 'Standard LEO patrol weapons',
        icon        = 'shield-halved',
        iconColor   = '#0a64da',
        weapons     = {
            { name = 'WEAPON_COMBATPISTOL',          ammo = 200, components = { 'COMPONENT_AT_PI_FLSH' } },
            { name = 'WEAPON_FM1_BENELLIM4',    ammo = 130, components = { 'COMPONENT_FM1_BENELLIM4_FLSH_01' } },
            { name = 'WEAPON_COLBATON',         ammo = 0 },
            { name = 'WEAPON_FLASHLIGHT',       ammo = 0 },
            { name = 'WEAPON_FLARE',            ammo = 10 },
            { name = 'WEAPON_DD14_B',           ammo = 240, components = { 'COMPONENT_EXPS34_B', 'COMPONENT_BCM_B', 'COMPONENT_SFS14_B' } },
            { name = 'WEAPON_STUNGUN',          ammo = 0 },
        }
    },
    {
        label       = 'Law Enforcement Detective',
        description = 'CID LEO patrol weapons',
        icon        = 'shield-halved',
        iconColor   = '#0a64da',
        weapons     = {
            { name = 'WEAPON_COMBATPISTOL',       ammo = 200, components = { 'COMPONENT_AT_PI_FLSH' } },
            { name = 'WEAPON_FM1_BENELLIM4', ammo = 130, components = { 'COMPONENT_FM1_BENELLIM4_FLSH_01' } },
            { name = 'WEAPON_COLBATON',      ammo = 0 },
            { name = 'WEAPON_FLASHLIGHT',    ammo = 0 },
            { name = 'WEAPON_DD14_B',        ammo = 240, components = { 'COMPONENT_EXPS34_B', 'COMPONENT_BCM_B', 'COMPONENT_SFS14_B' } },
        }
    },
    {
        label       = 'SWAT Officer',
        description = 'SWAT weapons',
        icon        = 'shield-halved',
        iconColor   = '#0a64da',
        weapons     = {
            { name = 'WEAPON_COMBATPISTOL',          ammo = 235, components = { 'COMPONENT_GLOCK20_FLSH_01' } },
            { name = 'WEAPON_FM1_BENELLIM4',    ammo = 130, components = { 'COMPONENT_FM1_BENELLIM4_FLSH_01' } },
            { name = 'WEAPON_FLASHLIGHT',       ammo = 0 },
            { name = 'WEAPON_FLARE',            ammo = 6 },
            { name = 'WEAPON_DD14_B',           ammo = 500, components = { 'COMPONENT_EXPS34_B', 'COMPONENT_BCM_B', 'COMPONENT_SFS14_B' } },
            { name = 'WEAPON_STUNGUN',          ammo = 0 },
            { name = 'WEAPON_SNIPERRIFLE', ammo = 60, components = { 'COMPONENT_VICTUSXMR_CLIP_01', 'COMPONENT_VICTUSXMR_SCOPE_01' }},
        }
    },
    {
        label       = 'Fire & EMS Loadout',
        description = 'General Tools for Fire and EMS',
        icon        = 'fire-extinguisher',
        iconColor   = '#e67e22',
        weapons     = {
            { name = 'WEAPON_FIREEXTINGUISHER', ammo = 0 },
            { name = 'WEAPON_FLASHLIGHT',       ammo = 0 },
            { name = 'WEAPON_BATTLEAXE',        ammo = 0 },
            { name = 'WEAPON_CROWBAR',          ammo = 0 },
        }
    },
}

-- ============================================================
-- WEAPON COMPONENTS DATA
-- ============================================================

local weaponComponents = {
    -- ── PISTOLS ──────────────────────────────────────────────
    WEAPON_PISTOL = {
        { label = 'Default Clip',    hash = 'COMPONENT_PISTOL_CLIP_01',             icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_PISTOL_CLIP_02',             icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_PI_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_PI_SUPP_02',              icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Compensator',     hash = 'COMPONENT_AT_PI_COMP',                 icon = 'bolt',               iconColor = '#bdc3c7' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_PISTOL_VARMOD_LUXE',         icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_PISTOL50 = {
        { label = 'Default Clip',    hash = 'COMPONENT_PISTOL50_CLIP_01',           icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_PISTOL50_CLIP_02',           icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_PI_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_PI_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Compensator',     hash = 'COMPONENT_AT_PI_COMP',                 icon = 'bolt',               iconColor = '#bdc3c7' },
        { label = 'Skull Varmod',    hash = 'COMPONENT_PISTOL50_VARMOD_02',         icon = 'skull',              iconColor = '#e74c3c' },
    },
    WEAPON_HEAVYPISTOL = {
        { label = 'Default Clip',    hash = 'COMPONENT_HEAVYPISTOL_CLIP_01',        icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_HEAVYPISTOL_CLIP_02',        icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_PI_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_PI_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Tape Varmod',     hash = 'COMPONENT_HEAVYPISTOL_VARMOD_LUXE',    icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_APPISTOL = {
        { label = 'Default Clip',    hash = 'COMPONENT_APPISTOL_CLIP_01',           icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_APPISTOL_CLIP_02',           icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_PI_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_PI_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Varsity Varmod',  hash = 'COMPONENT_APPISTOL_VARMOD_LUXE',       icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_SNSPISTOL = {
        { label = 'Default Clip',    hash = 'COMPONENT_SNSPISTOL_CLIP_01',          icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_SNSPISTOL_CLIP_02',          icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_SNSPISTOL_VARMOD_LOWRIDER',  icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_VINTAGEPISTOL = {
        { label = 'Default Clip',    hash = 'COMPONENT_VINTAGEPISTOL_CLIP_01',      icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_VINTAGEPISTOL_CLIP_02',      icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_PI_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
    },
    WEAPON_REVOLVER = {
        { label = 'Varmod Owl',      hash = 'COMPONENT_REVOLVER_VARMOD_BOSS',       icon = 'star',               iconColor = '#f39c12' },
        { label = 'Varmod Gambler',  hash = 'COMPONENT_REVOLVER_VARMOD_GOON',       icon = 'star',               iconColor = '#e67e22' },
    },
    -- ── SMGs ─────────────────────────────────────────────────
    WEAPON_MICROSMG = {
        { label = 'Default Clip',    hash = 'COMPONENT_MICROSMG_CLIP_01',           icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_MICROSMG_CLIP_02',           icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_PI_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_PI_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Scope',           hash = 'COMPONENT_AT_SCOPE_MACRO',             icon = 'circle-half-stroke', iconColor = '#3498db' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_MICROSMG_VARMOD_LUXE',       icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_SMG = {
        { label = 'Default Clip',    hash = 'COMPONENT_SMG_CLIP_01',                icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_SMG_CLIP_02',                icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Drum Mag',        hash = 'COMPONENT_SMG_CLIP_03',                icon = 'circle-dot',         iconColor = '#e74c3c' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_PI_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Scope',           hash = 'COMPONENT_AT_SCOPE_MACRO',             icon = 'circle-half-stroke', iconColor = '#3498db' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_SMG_VARMOD_LUXE',            icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_ASSAULTSMG = {
        { label = 'Default Clip',    hash = 'COMPONENT_ASSAULTSMG_CLIP_01',         icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_ASSAULTSMG_CLIP_02',         icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_PI_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Scope',           hash = 'COMPONENT_AT_SCOPE_MACRO',             icon = 'circle-half-stroke', iconColor = '#3498db' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_ASSAULTSMG_VARMOD_LUXE',     icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_COMBATPDW = {
        { label = 'Default Clip',    hash = 'COMPONENT_COMBATPDW_CLIP_01',          icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_COMBATPDW_CLIP_02',          icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Drum Mag',        hash = 'COMPONENT_COMBATPDW_CLIP_03',          icon = 'circle-dot',         iconColor = '#e74c3c' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Grip',            hash = 'COMPONENT_AT_AR_AFGRIP',               icon = 'hand',               iconColor = '#8e44ad' },
        { label = 'Scope',           hash = 'COMPONENT_AT_SCOPE_SMALL',             icon = 'circle-half-stroke', iconColor = '#3498db' },
    },
    -- ── SHOTGUNS ─────────────────────────────────────────────
    WEAPON_PUMPSHOTGUN = {
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_SR_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Yusuf Varmod',    hash = 'COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER', icon = 'star',              iconColor = '#f39c12' },
    },
    WEAPON_ASSAULTSHOTGUN = {
        { label = 'Default Clip',    hash = 'COMPONENT_ASSAULTSHOTGUN_CLIP_01',     icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_ASSAULTSHOTGUN_CLIP_02',     icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_AR_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Grip',            hash = 'COMPONENT_AT_AR_AFGRIP',               icon = 'hand',               iconColor = '#8e44ad' },
    },
    WEAPON_BULLPUPSHOTGUN = {
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_AR_SUPP_02',              icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Grip',            hash = 'COMPONENT_AT_AR_AFGRIP',               icon = 'hand',               iconColor = '#8e44ad' },
    },
    -- ── ASSAULT RIFLES ───────────────────────────────────────
    WEAPON_ASSAULTRIFLE = {
        { label = 'Default Clip',    hash = 'COMPONENT_ASSAULTRIFLE_CLIP_01',       icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_ASSAULTRIFLE_CLIP_02',       icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Drum Mag',        hash = 'COMPONENT_ASSAULTRIFLE_CLIP_03',       icon = 'circle-dot',         iconColor = '#e74c3c' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_AR_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Grip',            hash = 'COMPONENT_AT_AR_AFGRIP',               icon = 'hand',               iconColor = '#8e44ad' },
        { label = 'Holo Sight',      hash = 'COMPONENT_AT_SCOPE_MACRO',             icon = 'circle-half-stroke', iconColor = '#3498db' },
        { label = 'Small Scope',     hash = 'COMPONENT_AT_SCOPE_SMALL',             icon = 'circle-half-stroke', iconColor = '#2980b9' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_ASSAULTRIFLE_VARMOD_LUXE',   icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_CARBINERIFLE = {
        { label = 'Default Clip',    hash = 'COMPONENT_CARBINERIFLE_CLIP_01',       icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_CARBINERIFLE_CLIP_02',       icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Drum Mag',        hash = 'COMPONENT_CARBINERIFLE_CLIP_03',       icon = 'circle-dot',         iconColor = '#e74c3c' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_AR_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Grip',            hash = 'COMPONENT_AT_AR_AFGRIP',               icon = 'hand',               iconColor = '#8e44ad' },
        { label = 'Holo Sight',      hash = 'COMPONENT_AT_SCOPE_MACRO',             icon = 'circle-half-stroke', iconColor = '#3498db' },
        { label = 'Small Scope',     hash = 'COMPONENT_AT_SCOPE_SMALL',             icon = 'circle-half-stroke', iconColor = '#2980b9' },
        { label = 'Medium Scope',    hash = 'COMPONENT_AT_SCOPE_MEDIUM',            icon = 'circle-half-stroke', iconColor = '#1abc9c' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_CARBINERIFLE_VARMOD_LUXE',   icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_ADVANCEDRIFLE = {
        { label = 'Default Clip',    hash = 'COMPONENT_ADVANCEDRIFLE_CLIP_01',      icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_ADVANCEDRIFLE_CLIP_02',      icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_AR_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Small Scope',     hash = 'COMPONENT_AT_SCOPE_SMALL',             icon = 'circle-half-stroke', iconColor = '#2980b9' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE',  icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_SPECIALCARBINE = {
        { label = 'Default Clip',    hash = 'COMPONENT_SPECIALCARBINE_CLIP_01',     icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_SPECIALCARBINE_CLIP_02',     icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Drum Mag',        hash = 'COMPONENT_SPECIALCARBINE_CLIP_03',     icon = 'circle-dot',         iconColor = '#e74c3c' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_AR_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Grip',            hash = 'COMPONENT_AT_AR_AFGRIP',               icon = 'hand',               iconColor = '#8e44ad' },
        { label = 'Holo Sight',      hash = 'COMPONENT_AT_SCOPE_MACRO',             icon = 'circle-half-stroke', iconColor = '#3498db' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_SPECIALCARBINE_VARMOD_LUXE', icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_BULLPUPRIFLE = {
        { label = 'Default Clip',    hash = 'COMPONENT_BULLPUPRIFLE_CLIP_01',       icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_BULLPUPRIFLE_CLIP_02',       icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_AR_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Grip',            hash = 'COMPONENT_AT_AR_AFGRIP',               icon = 'hand',               iconColor = '#8e44ad' },
        { label = 'Small Scope',     hash = 'COMPONENT_AT_SCOPE_SMALL',             icon = 'circle-half-stroke', iconColor = '#2980b9' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_BULLPUPRIFLE_VARMOD_LOW',    icon = 'star',               iconColor = '#f39c12' },
    },
    -- ── LMGs ─────────────────────────────────────────────────
    WEAPON_MG = {
        { label = 'Default Clip',    hash = 'COMPONENT_MG_CLIP_01',                 icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_MG_CLIP_02',                 icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Scope',           hash = 'COMPONENT_AT_SCOPE_SMALL_02',          icon = 'circle-half-stroke', iconColor = '#3498db' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_MG_VARMOD_LUXE',             icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_COMBATMG = {
        { label = 'Default Clip',    hash = 'COMPONENT_COMBATMG_CLIP_01',           icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_COMBATMG_CLIP_02',           icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Grip',            hash = 'COMPONENT_AT_AR_AFGRIP',               icon = 'hand',               iconColor = '#8e44ad' },
        { label = 'Scope',           hash = 'COMPONENT_AT_SCOPE_MEDIUM',            icon = 'circle-half-stroke', iconColor = '#1abc9c' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_COMBATMG_VARMOD_LUXE',       icon = 'star',               iconColor = '#f39c12' },
    },
    -- ── SNIPERS ──────────────────────────────────────────────
    WEAPON_SNIPERRIFLE = {
        { label = 'Default Clip',    hash = 'COMPONENT_SNIPERRIFLE_CLIP_01',        icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_AR_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Large Scope',     hash = 'COMPONENT_AT_SCOPE_MAX',               icon = 'circle-half-stroke', iconColor = '#9b59b6' },
        { label = 'Advanced Scope',  hash = 'COMPONENT_AT_SCOPE_LARGE',             icon = 'circle-half-stroke', iconColor = '#8e44ad' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_SNIPERRIFLE_VARMOD_LUXE',    icon = 'star',               iconColor = '#f39c12' },
    },
    WEAPON_HEAVYSNIPER = {
        { label = 'Default Clip',    hash = 'COMPONENT_HEAVYSNIPER_CLIP_01',        icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Large Scope',     hash = 'COMPONENT_AT_SCOPE_MAX',               icon = 'circle-half-stroke', iconColor = '#9b59b6' },
        { label = 'Advanced Scope',  hash = 'COMPONENT_AT_SCOPE_LARGE',             icon = 'circle-half-stroke', iconColor = '#8e44ad' },
    },
    WEAPON_MARKSMANRIFLE = {
        { label = 'Default Clip',    hash = 'COMPONENT_MARKSMANRIFLE_CLIP_01',      icon = 'circle-dot',         iconColor = '#95a5a6' },
        { label = 'Extended Clip',   hash = 'COMPONENT_MARKSMANRIFLE_CLIP_02',      icon = 'circle-dot',         iconColor = '#2ecc71' },
        { label = 'Flashlight',      hash = 'COMPONENT_AT_AR_FLSH',                 icon = 'flashlight',         iconColor = '#f1c40f' },
        { label = 'Suppressor',      hash = 'COMPONENT_AT_AR_SUPP',                 icon = 'wind',               iconColor = '#7f8c8d' },
        { label = 'Grip',            hash = 'COMPONENT_AT_AR_AFGRIP',               icon = 'hand',               iconColor = '#8e44ad' },
        { label = 'Large Scope',     hash = 'COMPONENT_AT_SCOPE_LARGE',             icon = 'circle-half-stroke', iconColor = '#9b59b6' },
        { label = 'Luxury Finish',   hash = 'COMPONENT_MARKSMANRIFLE_VARMOD_LUXE',  icon = 'star',               iconColor = '#f39c12' },
    },
}

-- All ammo-bearing weapons for refill
local refillWeapons = {
    'WEAPON_PISTOL','WEAPON_PISTOL50','WEAPON_HEAVYPISTOL','WEAPON_VINTAGEPISTOL',
    'WEAPON_APPISTOL','WEAPON_SNSPISTOL','WEAPON_MARKSMANPISTOL','WEAPON_REVOLVER',
    'WEAPON_FLAREGUN','WEAPON_MICROSMG','WEAPON_SMG','WEAPON_ASSAULTSMG',
    'WEAPON_COMBATPDW','WEAPON_MACHINEPISTOL','WEAPON_MINISMG','WEAPON_PUMPSHOTGUN',
    'WEAPON_SAWNOFFSHOTGUN','WEAPON_ASSAULTSHOTGUN','WEAPON_BULLPUPSHOTGUN',
    'WEAPON_HEAVYSHOTGUN','WEAPON_DBSHOTGUN','WEAPON_ASSAULTRIFLE','WEAPON_CARBINERIFLE',
    'WEAPON_ADVANCEDRIFLE','WEAPON_SPECIALCARBINE','WEAPON_BULLPUPRIFLE',
    'WEAPON_COMPACTRIFLE','WEAPON_MG','WEAPON_COMBATMG','WEAPON_GUSENBERG',
    'WEAPON_SNIPERRIFLE','WEAPON_HEAVYSNIPER','WEAPON_MARKSMANRIFLE','WEAPON_RPG',
    'WEAPON_GRENADELAUNCHER','WEAPON_MINIGUN','WEAPON_RAILGUN','WEAPON_HOMINGLAUNCHER',
    'WEAPON_GRENADE','WEAPON_SMOKEGRENADE','WEAPON_BZGAS','WEAPON_MOLOTOV',
    'WEAPON_STICKYBOMB','WEAPON_PROXMINE','WEAPON_PIPEBOMB','WEAPON_FLARE','WEAPON_SNOWBALL',
}

local weaponTints = { 'Normal', 'Green', 'Gold', 'Pink', 'Army', 'LSPD', 'Orange', 'Platinum' }

-- ============================================================
-- DB  –  load on start, save on change
-- ============================================================

CreateThread(function()
    local result = lib.callback.await('corey_weaponmenu:getSavedLoadouts', false)
    if result then
        savedLoadouts = result
        print('[Weapon Menu] Loaded ' .. #savedLoadouts .. ' saved loadout(s) from database')
    end
end)

local function SaveLoadoutsToDB()
    TriggerServerEvent('corey_weaponmenu:saveLoadouts', json.encode(savedLoadouts))
end

-- ============================================================
-- HELPERS
-- ============================================================

local function applyLoadoutWeapons(weapons)
    local ped = PlayerPedId()
    for _, w in ipairs(weapons) do
        local weaponHash = GetHashKey(w.name)
        GiveWeaponToPed(ped, weaponHash, w.ammo, false, false)
        if w.tint and w.tint > 0 then
            SetPedWeaponTintIndex(ped, weaponHash, w.tint)
        end
        if w.components then
            for _, compHashName in ipairs(w.components) do
                GiveWeaponComponentToPed(ped, weaponHash, GetHashKey(compHashName))
            end
        end
    end
end

local function captureCurrentWeapons()
    local ped      = PlayerPedId()
    local captured = {}
    for _, category in ipairs(weaponCategories) do
        for _, weapon in ipairs(category.weapons) do
            local hash = GetHashKey(weapon.name)
            if HasPedGotWeapon(ped, hash, false) then
                local activeComps = {}
                local comps = weaponComponents[weapon.name]
                if comps then
                    for _, comp in ipairs(comps) do
                        local compHash = GetHashKey(comp.hash)
                        if HasPedGotWeaponComponent(ped, hash, compHash) then
                            activeComps[#activeComps + 1] = comp.hash
                        end
                    end
                end
                captured[#captured + 1] = {
                    name       = weapon.name,
                    ammo       = GetAmmoInPedWeapon(ped, hash),
                    components = activeComps,
                    tint       = GetPedWeaponTintIndex(ped, hash),
                }
            end
        end
    end
    return captured
end

-- ============================================================
-- MAIN WEAPON MENU
-- ============================================================

function OpenWeaponMenu()
    lib.registerContext({
        id             = 'weapon_main_menu',
        title          = 'Corey Weapon Menu',
        menu = 'unified_main_menu',
        preventClosing = true,
        options        = {
            {
                title       = '➕ Spawn Weapon',
                description = 'Browse available weapons',
                arrow       = true,
                onSelect    = OpenSpawnWeaponMenu,
            },
            {
                title       = '🛡️ Emergency Loadouts',
                description = 'Pre-made loadouts for emergency services',
                arrow       = true,
                onSelect    = OpenEmergencyLoadoutsMenu,
            },
            { title = '', disabled = true },
            {
                title       = '🔧 Modify Weapons',
                description = 'Change tints and attachments on your weapons',
                arrow       = true,
                onSelect    = OpenModifyWeaponsMenu,
            },
            {
                title       = '📦 Refill Ammunition',
                description = 'Top up ammo on all held weapons',
                onSelect    = function()
                    RefillAllAmmo()
                    lib.showContext('weapon_main_menu')
                end,
            },
            {
                title       = '🗑️ Remove All Weapons',
                description = 'Clear your entire weapon inventory',
                onSelect    = function()
                    RemoveAllWeapons()
                    lib.showContext('weapon_main_menu')
                end,
            },
            { title = '', disabled = true },
            {
                title       = '💾 Save Current Loadout',
                description = 'Snapshot your current weapons to My Loadouts',
                onSelect    = SaveCurrentLoadout,
            },
            {
                title       = '📁 My Loadouts',
                description = 'Equip or manage your saved loadouts',
                arrow       = true,
                onSelect    = OpenMyLoadoutsMenu,
            },
        }
    })
    ShowContext('weapon_main_menu')
end

-- ============================================================
-- 1. SPAWN WEAPON  →  Category list  →  Weapon list
-- ============================================================

function OpenSpawnWeaponMenu()
    local items = {}
    for i, category in ipairs(weaponCategories) do
        local catRef = category
        local idx    = i
        items[#items + 1] = {
            title       = catRef.label,
            description = 'Browse ' .. #catRef.weapons .. ' weapons',
            icon        = catRef.icon,
            iconColor   = catRef.iconColor,
            arrow       = true,
            onSelect    = function() OpenWeaponCategoryMenu(idx, catRef) end,
        }
    end

    lib.registerContext({
        id             = 'wm_spawn_menu',
        title          = '➕ Spawn Weapon',
        menu           = 'weapon_main_menu',
        preventClosing = true,
        options        = items,
    })
    ShowContext('wm_spawn_menu')
end

function OpenWeaponCategoryMenu(categoryIndex, category)
    local items = {}
    for _, weapon in ipairs(category.weapons) do
        local wRef = weapon
        items[#items + 1] = {
            title       = wRef.label,
            description = wRef.ammo > 0 and ('Give with ' .. wRef.ammo .. ' ammo') or 'Give weapon',
            icon        = 'gun',
            iconColor   = '#ecf0f1',
            onSelect    = function()
                GiveWeaponToPed(PlayerPedId(), GetHashKey(wRef.name), wRef.ammo, false, false)
                lib.notify({ title = 'Weapon Given', description = wRef.label, type = 'success' })
                lib.showContext('wm_cat_menu_' .. categoryIndex)
            end,
        }
    end

    lib.registerContext({
        id             = 'wm_cat_menu_' .. categoryIndex,
        title          = category.label,
        menu           = 'wm_spawn_menu',
        preventClosing = true,
        options        = items,
    })
    ShowContext('wm_cat_menu_' .. categoryIndex)
end

-- ============================================================
-- 2. EMERGENCY LOADOUTS
-- ============================================================

function OpenEmergencyLoadoutsMenu()
    local items = {}
    for _, loadout in ipairs(emergencyLoadouts) do
        local ref = loadout
        items[#items + 1] = {
            title       = ref.label,
            description = ref.description,
            icon        = ref.icon,
            iconColor   = ref.iconColor,
            onSelect    = function()
                applyLoadoutWeapons(ref.weapons)
                lib.notify({ title = 'Loadout Applied', description = ref.label .. ' equipped', type = 'success' })
                lib.showContext('wm_emergency_menu')
            end,
        }
    end

    lib.registerContext({
        id             = 'wm_emergency_menu',
        title          = '🛡️ Emergency Loadouts',
        menu           = 'weapon_main_menu',
        preventClosing = true,
        options        = items,
    })
    ShowContext('wm_emergency_menu')
end

-- ============================================================
-- 3. MODIFY WEAPONS  →  Per-weapon  →  Tint / Components
-- ============================================================

function OpenModifyWeaponsMenu()
    local ped   = PlayerPedId()
    local items = {}
    local found = {}

    for _, category in ipairs(weaponCategories) do
        for _, weapon in ipairs(category.weapons) do
            local hash = GetHashKey(weapon.name)
            if HasPedGotWeapon(ped, hash, false) then
                local hasComps = weaponComponents[weapon.name] and #weaponComponents[weapon.name] > 0
                local wRef     = weapon
                local wHash    = hash
                items[#items + 1] = {
                    title       = wRef.label,
                    description = hasComps and 'Tint + Components available' or 'Tint only',
                    icon        = 'gun',
                    iconColor   = '#ecf0f1',
                    arrow       = true,
                    onSelect    = function()
                        OpenModifyWeaponOptionsMenu(wHash, wRef.label, wRef.name)
                    end,
                }
                found[#found + 1] = true
            end
        end
    end

    if #found == 0 then
        lib.notify({ title = 'No Weapons', description = 'You have no weapons to modify', type = 'error' })
        lib.showContext('weapon_main_menu')
        return
    end

    lib.registerContext({
        id             = 'wm_modify_menu',
        title          = '🔧 Modify Weapons',
        menu           = 'weapon_main_menu',
        preventClosing = true,
        options        = items,
    })
    ShowContext('wm_modify_menu')
end

function OpenModifyWeaponOptionsMenu(weaponHash, weaponLabel, weaponName)
    local hasComponents = weaponComponents[weaponName] and #weaponComponents[weaponName] > 0
    local safeId        = 'wm_weapon_opts_' .. weaponName

    lib.registerContext({
        id             = safeId,
        title          = weaponLabel,
        menu           = 'wm_modify_menu',
        preventClosing = true,
        options        = {
            {
                title       = '🎨 Tint',
                description = 'Change weapon colour tint',
                arrow       = true,
                onSelect    = function()
                    OpenModifyWeaponTintMenu(weaponHash, weaponLabel, weaponName)
                end,
            },
            {
                title       = '🔩 Components',
                description = hasComponents and 'Scopes, suppressors, grips & more' or 'No components available',
                arrow       = hasComponents,
                disabled    = not hasComponents,
                onSelect    = function()
                    OpenModifyWeaponComponentsMenu(weaponHash, weaponLabel, weaponName)
                end,
            },
        },
    })
    ShowContext(safeId)
end

function OpenModifyWeaponTintMenu(weaponHash, weaponLabel, weaponName)
    local optsSafeId = 'wm_weapon_opts_' .. weaponName
    local items      = {}

    for i, tintName in ipairs(weaponTints) do
        local idx  = i
        local name = tintName
        items[#items + 1] = {
            title    = 'Tint: ' .. name,
            icon     = 'palette',
            iconColor = '#c0392b',
            onSelect = function()
                SetPedWeaponTintIndex(PlayerPedId(), weaponHash, idx - 1)
                lib.notify({ title = 'Tint Applied', description = weaponLabel .. ' → ' .. name, type = 'success' })
                lib.showContext('wm_tint_' .. weaponName)
            end,
        }
    end

    lib.registerContext({
        id             = 'wm_tint_' .. weaponName,
        title          = '🎨 Tints: ' .. weaponLabel,
        menu           = optsSafeId,
        preventClosing = true,
        options        = items,
    })
    ShowContext('wm_tint_' .. weaponName)
end

function OpenModifyWeaponComponentsMenu(weaponHash, weaponLabel, weaponName)
    local components = weaponComponents[weaponName]
    if not components or #components == 0 then
        lib.notify({ title = 'No Components', description = weaponLabel .. ' has no attachments available', type = 'error' })
        lib.showContext('wm_weapon_opts_' .. weaponName)
        return
    end

    local ped   = PlayerPedId()
    local items = {}

    for _, comp in ipairs(components) do
        local compRef  = comp
        local compHash = GetHashKey(comp.hash)
        local hasComp  = HasPedGotWeaponComponent(ped, weaponHash, compHash)
        items[#items + 1] = {
            title       = compRef.label,
            description = hasComp and '✔ Equipped — click to remove' or 'Click to attach',
            icon        = compRef.icon,
            iconColor   = hasComp and '#2ecc71' or compRef.iconColor,
            onSelect    = function()
                local ped2  = PlayerPedId()
                local cHash = GetHashKey(compRef.hash)
                if HasPedGotWeaponComponent(ped2, weaponHash, cHash) then
                    RemoveWeaponComponentFromPed(ped2, weaponHash, cHash)
                    lib.notify({ title = 'Component Removed', description = compRef.label .. ' removed from ' .. weaponLabel, type = 'inform' })
                else
                    GiveWeaponComponentToPed(ped2, weaponHash, cHash)
                    lib.notify({ title = 'Component Added', description = compRef.label .. ' attached to ' .. weaponLabel, type = 'success' })
                end
                -- Reopen to refresh equipped states
                OpenModifyWeaponComponentsMenu(weaponHash, weaponLabel, weaponName)
            end,
        }
    end

    lib.registerContext({
        id             = 'wm_comps_' .. weaponName,
        title          = '🔩 Components: ' .. weaponLabel,
        menu           = 'wm_weapon_opts_' .. weaponName,
        preventClosing = true,
        options        = items,
    })
    ShowContext('wm_comps_' .. weaponName)
end

-- ============================================================
-- 4. REFILL AMMUNITION
-- ============================================================

function RefillAllAmmo()
    local ped   = PlayerPedId()
    local count = 0
    for _, weaponName in ipairs(refillWeapons) do
        local hash = GetHashKey(weaponName)
        if HasPedGotWeapon(ped, hash, false) then
            AddAmmoToPed(ped, hash, 9999)
            count = count + 1
        end
    end
    if count > 0 then
        lib.notify({ title = 'Ammo Refilled', description = 'Refilled ' .. count .. ' weapon(s)', type = 'success' })
    else
        lib.notify({ title = 'No Weapons', description = 'No weapons found to refill', type = 'error' })
    end
end

-- ============================================================
-- 5. REMOVE ALL WEAPONS
-- ============================================================

function RemoveAllWeapons()
    RemoveAllPedWeapons(PlayerPedId(), true)
    lib.notify({ title = 'Weapons Cleared', description = 'All weapons removed', type = 'inform' })
end

-- ============================================================
-- 6. SAVE CURRENT LOADOUT
-- ============================================================

function SaveCurrentLoadout()
    local weapons = captureCurrentWeapons()
    if #weapons == 0 then
        lib.notify({ title = 'No Weapons', description = 'You have no weapons to save', type = 'error' })
        return
    end

    local result = lib.inputDialog('Save Loadout', {
        { type = 'input', label = 'Loadout Name', placeholder = 'e.g. My Patrol Kit', required = true }
    })

    if not result or not result[1] or result[1] == '' then
        lib.showContext('weapon_main_menu')
        return
    end

    local name = result[1]
    for _, loadout in ipairs(savedLoadouts) do
        if loadout.name:lower() == name:lower() then
            lib.notify({ title = 'Name Taken', description = 'A loadout with that name already exists', type = 'error' })
            lib.showContext('weapon_main_menu')
            return
        end
    end

    savedLoadouts[#savedLoadouts + 1] = { name = name, weapons = weapons }
    SaveLoadoutsToDB()
    lib.notify({
        title       = 'Loadout Saved',
        description = '"' .. name .. '" saved with ' .. #weapons .. ' weapon(s)',
        type        = 'success'
    })
    lib.showContext('weapon_main_menu')
end

-- ============================================================
-- 7. MY LOADOUTS  (DB-backed, equip or delete)
-- ============================================================

function OpenMyLoadoutsMenu()
    if #savedLoadouts == 0 then
        lib.notify({ title = 'No Loadouts', description = 'You have no saved loadouts yet', type = 'error' })
        lib.showContext('weapon_main_menu')
        return
    end

    local items = {}
    for i, loadout in ipairs(savedLoadouts) do
        local ref = loadout
        local idx = i
        items[#items + 1] = {
            title       = '📦 ' .. ref.name,
            description = #ref.weapons .. ' weapon(s) saved',
            arrow       = true,
            onSelect    = function()
                OpenLoadoutOptionsMenu(ref, idx)
            end,
        }
    end

    lib.registerContext({
        id             = 'wm_my_loadouts_menu',
        title          = '📁 My Loadouts',
        menu           = 'weapon_main_menu',
        preventClosing = true,
        options        = items,
    })
    ShowContext('wm_my_loadouts_menu')
end

function OpenLoadoutOptionsMenu(loadout, idx)
    lib.registerContext({
        id             = 'wm_loadout_opts_' .. idx,
        title          = '📦 ' .. loadout.name,
        menu           = 'wm_my_loadouts_menu',
        preventClosing = true,
        options        = {
            {
                title       = '▶️ Equip Loadout',
                description = 'Apply all weapons from this loadout',
                onSelect    = function()
                    applyLoadoutWeapons(loadout.weapons)
                    lib.notify({
                        title       = 'Loadout Equipped',
                        description = loadout.name .. ' applied (' .. #loadout.weapons .. ' weapons)',
                        type        = 'success'
                    })
                    lib.showContext('wm_loadout_opts_' .. idx)
                end,
            },
            {
                title       = '🗑️ Delete Loadout',
                description = 'Permanently remove this loadout',
                onSelect    = function()
                    local confirm = lib.alertDialog({
                        header   = 'Delete Loadout',
                        content  = ('Are you sure you want to delete **%s**? This cannot be undone.'):format(loadout.name),
                        centered = true,
                        cancel   = true,
                    })
                    if confirm == 'confirm' then
                        local name = loadout.name
                        table.remove(savedLoadouts, idx)
                        SaveLoadoutsToDB()
                        lib.notify({ title = 'Loadout Deleted', description = name .. ' removed', type = 'inform' })
                        OpenMyLoadoutsMenu()
                    else
                        lib.showContext('wm_loadout_opts_' .. idx)
                    end
                end,
            },
        },
    })
    ShowContext('wm_loadout_opts_' .. idx)
end

-- ============================================================
-- COMMAND
-- ============================================================

RegisterCommand('weaponmenu', function()
    OpenWeaponMenu()
end, false)