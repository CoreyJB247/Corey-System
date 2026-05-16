-- shared/config.lua

Config = {}

-- Key to open the appearance menu (default: F5)
Config.MenuKey = ''

-- Enable/disable menu sections
Config.Categories = {
    SpawnPed      = true,
    CreateMPPed   = true,
    CustomizePed  = true,
    SavedPeds     = true,
    PlayerUtils   = true,   -- Heal, Armour, Clean, Revive, Wanted level
}
 
-- Player utilities config
Config.PlayerUtils = {
    -- Full armour value (0–100)
    ArmourAmount   = 100,
    -- Which armour tier to equip as a clothing component (0 = none visible, 1–3 = light/med/heavy)
    -- Uses ped component 9 (body armour drawable index)
    ArmourDrawable = 0,     -- set to desired drawable; 0 = no visible armour item
}

-- Saved ped categories shown in the Saved Peds menu.
-- Order here controls display order. 'id' must be unique and lowercase.
-- 'icon' is an emoji shown next to the category name.
Config.PedCategories = {
    { id = 'favorites',       label = 'Favorites',               icon = '⭐' },
    { id = 'law_enforcement', label = 'Law Enforcement',         icon = '🛡️' },
    { id = 'fire',            label = 'San Andreas Fire Rescue', icon = '🚒' },
    { id = 'civilians',       label = 'Civilians',               icon = '👥' },
    { id = 'other',           label = 'Other',                   icon = '📁' },
}

-- ─── Ped Spawner Categories ───────────────────────────────────────────────────
-- Organised by role/theme. Each entry needs a unique 'label' and valid 'model'.
-- Categories are displayed as sub-menus inside the Spawn Ped menu.
Config.SpawnPeds = {

    -- ── Law Enforcement
    {
        category = '🛡️  Law Enforcement',
        peds = {
            -- LSPD
            { label = 'LSPD Officer (M)',        model = 's_m_y_cop_01'          },
            { label = 'LSPD Officer (F)',         model = 's_f_y_cop_01'          },
            { label = 'LSPD Highway Patrol (M)', model = 's_m_y_hwaycop_01'      },
            { label = 'LSPD Swat',               model = 's_m_y_swat_01'         },
            -- Sheriff
            { label = 'Sheriff (M)',             model = 's_m_y_sheriff_01'       },
            { label = 'Sheriff (F)',             model = 's_f_y_sheriff_01'       },
            -- FIB / FED
            { label = 'FIB Agent (M)',           model = 's_m_m_fiboffice_01'     },
            { label = 'FIB Agent 2 (M)',         model = 's_m_m_fiboffice_02'     },
            { label = 'FIB Suit',                model = 'cs_fbisuit_01'          },
            -- Prison
            { label = 'Prison Guard (M)',        model = 's_m_m_prisguard_01'     },
            -- Riot / Military Police
            { label = 'Riot Officer',            model = 's_m_m_riotcop_01'      },
        },
    },

    -- ── Fire & Rescue───
    {
        category = '🚒  Fire & Rescue',
        peds = {
            { label = 'Firefighter (M)',          model = 's_m_y_fireman_01'      },
            { label = 'Lifeguard (M)',            model = 's_m_y_lifeguard_01'    },
            { label = 'Lifeguard (F)',            model = 's_f_y_lifeguard_01'    },
        },
    },

    -- ── Emergency Medical ─────────────────────────────────────────────────────
    {
        category = '🚑  Emergency Medical',
        peds = {
            { label = 'Paramedic (M)',            model = 's_m_y_ems_01'          },
            { label = 'Paramedic (F)',            model = 's_f_y_ems_01'          },
            { label = 'Doctor (M)',               model = 's_m_m_doctor_01'       },
            { label = 'Nurse (F)',                model = 's_f_y_nurse_01'        },
        },
    },

    -- ── Military───────
    {
        category = '🎖️  Military',
        peds = {
            { label = 'Army Soldier (M)',         model = 's_m_y_ranger_01'       },
            { label = 'Army Mechanic (M)',        model = 's_m_y_armymech_01'     },
            { label = 'Blackops Soldier (M)',     model = 's_m_y_blackops_01'     },
            { label = 'Blackops Soldier 2 (M)',   model = 's_m_y_blackops_02'     },
            { label = 'Blackops Soldier 3 (M)',   model = 's_m_y_blackops_03'     },
            { label = 'Marine (M)',               model = 's_m_m_marine_01'       },
            { label = 'Marine 2 (M)',             model = 's_m_m_marine_02'       },
            { label = 'Marine (Y)',               model = 's_m_y_marine_01'       },
            { label = 'Marine 2 (Y)',             model = 's_m_y_marine_02'       },
            { label = 'Marine 3 (Y)',             model = 's_m_y_marine_03'       },
            { label = 'Noose (M)',                model = 's_m_y_noose_01'        },
        },
    },

    -- ── Story Characters ─────────────────────────────────────────────────────
    {
        category = '🎭  Story Characters',
        peds = {
            { label = 'Trevor',                  model = 'player_two'             },
            { label = 'Franklin',                model = 'player_one'             },
            { label = 'Michael',                 model = 'player_zero'            },
            { label = 'Lamar Davis',             model = 'cs_lamardavis'          },
            { label = 'Lester Crest',            model = 'cs_lestercrest'         },
            { label = 'Ron',                     model = 'cs_nervousron'          },
            { label = 'Wade',                    model = 'cs_wade'                },
            { label = 'Johnny Klebitz',          model = 'cs_johnnyklebitz'       },
            { label = 'Martin Madrazo',          model = 'cs_martinmadrazo'       },
            { label = 'Dave Norton',             model = 'cs_davenorton'          },
            { label = 'Steve Hains',             model = 'cs_stevehains'          },
            { label = 'Stretch',                 model = 'cs_stretch'             },
            { label = 'Solomon',                 model = 'cs_solomon'             },
            { label = 'Devin Weston',            model = 'cs_devin'               },
        },
    },

    -- ── Service Workers
    {
        category = '🔧  Service Workers',
        peds = {
            { label = 'Mechanic (M)',             model = 's_m_y_xmech_01'        },
            { label = 'Mechanic 2 (M)',           model = 's_m_y_xmech_02'        },
            { label = 'Gas Station (M)',          model = 's_m_y_xmech_cut_01'    },
            { label = 'Taxi Driver (M)',          model = 's_m_y_taxi_01'         },
            { label = 'Bus Driver (M)',           model = 's_m_y_busdriver'       },
            { label = 'Trucker (M)',              model = 's_m_y_trucker_01'      },
            { label = 'Garbage Worker (M)',       model = 's_m_y_garbage'         },
            { label = 'Postal Worker (M)',        model = 's_m_m_postal_01'       },
            { label = 'Postal Worker 2 (M)',      model = 's_m_m_postal_02'       },
            { label = 'Pilot (M)',                model = 's_m_y_pilot_01'        },
            { label = 'Pilot 2 (M)',              model = 's_m_y_pilot_02'        },
            { label = 'Cop Pilot (M)',            model = 's_m_y_coppilot_01'     },
            { label = 'Construction (M)',         model = 's_m_y_construct_01'    },
            { label = 'Construction 2 (M)',       model = 's_m_y_construct_02'    },
            { label = 'Dock Worker (M)',          model = 's_m_y_dockwork_01'     },
            { label = 'Factory Worker (M)',       model = 's_m_y_factory_01'      },
            { label = 'Farmer (M)',               model = 'a_m_m_farmer_01'       },
            { label = 'Janitor (M)',              model = 's_m_m_janitor'         },
            { label = 'Street Cleaner (M)',       model = 's_m_y_streetvend_01'   },
            { label = 'Car Dealer (M)',           model = 's_m_m_autoshop_01'     },
            { label = 'Car Dealer 2 (M)',         model = 's_m_m_autoshop_02'     },
            { label = 'Valet (M)',                model = 's_m_y_valet_01'        },
            { label = 'Waiter (M)',               model = 's_m_y_waiter_01'       },
            { label = 'Chef (M)',                 model = 's_m_m_chef_01'         },
            { label = 'Chef 2 (M)',               model = 's_m_m_chef_02'         },
            { label = 'Bartender (F)',            model = 's_f_y_bartender_01'    },
            { label = 'Housekeeper (F)',          model = 's_f_m_femaleshopassist' },
            { label = 'Shop Keeper (F)',          model = 's_f_y_shop_mid'        },
            { label = 'Shop Keeper 2 (F)',        model = 's_f_y_shop_high'       },
            { label = 'Shop Keeper 3 (F)',        model = 's_f_y_shop_low'        },
            { label = 'Paramedic Scientist (M)',  model = 's_m_m_paramedic_01'    },
        },
    },

    -- ── Security───────
    {
        category = '🔒  Security',
        peds = {
            { label = 'Security Guard (M)',       model = 's_m_m_security_01'     },
            { label = 'Armoured Truck (M)',       model = 's_m_m_armoured_01'     },
            { label = 'Armoured Truck 2 (M)',     model = 's_m_m_armoured_02'     },
            { label = 'Bouncer (M)',              model = 's_m_m_bouncer_01'      },
        },
    },

    -- ── Criminals & Gangs ─────────────────────────────────────────────────────
    {
        category = '💀  Criminals & Gangs',
        peds = {
            -- Ballas
            { label = 'Ballas (M)',               model = 'g_m_y_ballast_01'      },
            { label = 'Ballas OG (M)',            model = 'g_m_y_ballaog_01'      },
            -- Families
            { label = 'Families (M)',             model = 'g_m_y_famfor_01'       },
            { label = 'Families 2 (M)',           model = 'g_m_y_famca_01'        },
            -- Vagos
            { label = 'Vagos (M)',                model = 'g_m_y_lost_01'         },
            -- Marabunta
            { label = 'Marabunta (M)',            model = 'g_m_y_mexgang_01'      },
            -- Lost MC
            { label = 'Lost MC (M)',              model = 'g_m_y_lostmc_01'       },
            { label = 'Lost MC 2 (M)',            model = 'g_m_y_lostmc_02'       },
            -- Merryweather
            { label = 'Merryweather (M)',         model = 's_m_y_mervwear_01'     },
            -- Triads
            { label = 'Korean Mob (M)',           model = 'g_m_m_korboss_01'      },
            -- Professionals
            { label = 'Gunman (M)',               model = 'g_m_y_mexgang_01'      },
            { label = 'Street Thug (M)',          model = 'g_m_y_strpunk_01'      },
            { label = 'Street Thug 2 (M)',        model = 'g_m_y_strpunk_02'      },
        },
    },

    -- ── Professionals & Business ─────────────────────────────────────────────
    {
        category = '💼  Professionals & Business',
        peds = {
            { label = 'Business (M Young)',       model = 'a_m_y_business_01'     },
            { label = 'Business (M Mid)',         model = 'a_m_m_business_01'     },
            { label = 'Business (F Young)',       model = 'a_f_y_business_01'     },
            { label = 'Business (F Mid)',         model = 'a_f_m_business_02'     },
            { label = 'Lawyer (M)',               model = 's_m_m_lawyer_01'       },
            { label = 'Real Estate (M)',          model = 's_m_m_realestate_01'   },
            { label = 'Paparazzi (M)',            model = 'a_m_m_paparazzi_01'    },
            { label = 'Reporter (F)',             model = 's_f_y_reporter'        },
            { label = 'Life Invader (M)',         model = 'cs_lifeinvad_01'       },
        },
    },

    -- ── Outdoors & Sports ─────────────────────────────────────────────────────
    {
        category = '⛰️  Outdoors & Sports',
        peds = {
            { label = 'Hiker (M)',                model = 'a_m_y_hiker_01'        },
            { label = 'Hiker (F)',                model = 'a_f_y_hiker_01'        },
            { label = 'Cyclist (M)',              model = 'a_m_y_cyclist_01'      },
            { label = 'Road Cyclist (M)',         model = 'a_m_y_roadcyc_01'      },
            { label = 'Runner (M)',               model = 'a_m_y_runner_01'       },
            { label = 'Runner (F)',               model = 'a_f_y_runner_01'       },
            { label = 'Skater (M)',               model = 'a_m_y_skater_01'       },
            { label = 'Skater (F)',               model = 'a_f_y_skater_01'       },
            { label = 'Golfer (M Young)',         model = 'a_m_y_golfer_01'       },
            { label = 'Golfer (M Mid)',           model = 'a_m_m_golfer_01'       },
            { label = 'Golfer (F)',               model = 'a_f_y_golfer_01'       },
            { label = 'Tennis (M)',               model = 'a_m_m_tennis_01'       },
            { label = 'Tennis (F)',               model = 'a_f_y_tennis_01'       },
            { label = 'Surfer (M)',               model = 'a_m_y_surfer_01'       },
            { label = 'Motocross (M)',            model = 'a_m_y_motox_01'        },
            { label = 'Motocross 2 (M)',          model = 'a_m_y_motox_02'        },
            { label = 'Yoga (M)',                 model = 'a_m_y_yoga_01'         },
            { label = 'Yoga (F)',                 model = 'a_f_y_yoga_01'         },
            { label = 'Beach (M Young)',          model = 'a_m_y_beach_01'        },
            { label = 'Beach (F Young)',          model = 'a_f_y_beach_01'        },
            { label = 'Bodybuilder (F)',          model = 'a_f_m_bodybuild_01'    },
            { label = 'Muscle Beach (M)',         model = 'a_m_y_musclbeac_01'    },
            { label = 'Jetski (M)',               model = 'a_m_y_jetski_01'       },
        },
    },

    -- ── Civilians (General) ───────────────────────────────────────────────────
    {
        category = '👥  Civilians',
        peds = {
            { label = 'Downtown (M)',             model = 'a_m_y_downtown_01'     },
            { label = 'Downtown (F)',             model = 'a_f_m_downtown_01'     },
            { label = 'Beverly Hills (M)',        model = 'a_m_m_bevhills_01'     },
            { label = 'Beverly Hills (F)',        model = 'a_f_m_bevhills_01'     },
            { label = 'Hipster (M)',              model = 'a_m_y_hipster_01'      },
            { label = 'Hipster (F)',              model = 'a_f_y_hipster_01'      },
            { label = 'Tourist (M)',              model = 'a_m_m_tourist_01'      },
            { label = 'Tourist (F)',              model = 'a_f_m_tourist_01'      },
            { label = 'Salton (M)',               model = 'a_m_m_salton_01'       },
            { label = 'Salton (F)',               model = 'a_f_m_salton_01'       },
            { label = 'South Central (M)',        model = 'a_m_m_soucent_01'      },
            { label = 'South Central (F)',        model = 'a_f_m_soucent_01'      },
            { label = 'East LS (M)',              model = 'a_m_m_eastsa_01'       },
            { label = 'East LS (F)',              model = 'a_f_m_eastsa_01'       },
            { label = 'Vinewood (M)',             model = 'a_m_y_vinewood_01'     },
            { label = 'Vinewood (F)',             model = 'a_f_y_vinewood_01'     },
            { label = 'Indian (M)',               model = 'a_m_y_indian_01'       },
            { label = 'Indian (F)',               model = 'a_f_y_indian_01'       },
            { label = 'Hillbilly (M)',            model = 'a_m_m_hillbilly_01'    },
            { label = 'Hillbilly 2 (M)',          model = 'a_m_m_hillbilly_02'    },
            { label = 'Old Man Street (M)',       model = 'a_m_o_genstreet_01'    },
            { label = 'Old Lady (F)',             model = 'a_f_o_genstreet_01'    },
            { label = 'Hippie (M)',               model = 'a_m_y_hippy_01'        },
            { label = 'Hippie (F)',               model = 'a_f_y_hippie_01'       },
            { label = 'Club Customer (M)',        model = 'a_m_y_clubcust_01'     },
            { label = 'Club Customer (F)',        model = 'a_f_y_clubcust_01'     },
            { label = 'Epsilon Cult (M)',         model = 'a_m_y_epsilon_01'      },
            { label = 'Epsilon Cult (F)',         model = 'a_f_y_epsilon_01'      },
            { label = 'Smart Casual (M)',         model = 'a_m_y_smartcaspat_01'  },
            { label = 'Smart Casual (F)',         model = 'a_f_y_smartcaspat_01'  },
            { label = 'Breakdancer (M)',          model = 'a_m_y_breakdance_01'   },
        },
    },

    -- ── Homeless & Rough Sleepers ─────────────────────────────────────────────
    {
        category = '🏕️  Homeless',
        peds = {
            { label = 'Tramp (M Mid)',            model = 'a_m_m_tramp_01'        },
            { label = 'Tramp (M Old)',            model = 'a_m_o_tramp_01'        },
            { label = 'Tramp (F)',                model = 'a_f_m_tramp_01'        },
            { label = 'Beach Tramp (M)',          model = 'a_m_m_trampbeac_01'    },
            { label = 'Beach Tramp (F)',          model = 'a_f_m_trampbeac_01'    },
            { label = 'Skid Row (M)',             model = 'a_m_m_skidrow_01'      },
            { label = 'Skid Row (F)',             model = 'a_f_m_skidrow_01'      },
            { label = 'Meth Head (M)',            model = 'a_m_y_methhead_01'     },
            { label = 'Rural Meth (M)',           model = 'a_m_m_rurmeth_01'      },
            { label = 'Rural Meth (F)',           model = 'a_f_y_rurmeth_01'      },
        },
    },

}