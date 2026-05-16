-- Advanced Object Spawner - Config
-- By CoreyJB247 | Built with OX Lib

Config = {}

Config.UsageMode = "Everyone"       -- Who can use the menu? Options: 'Everyone', 'Steam', 'IP', 'Ped'
Config.ActivationMode = "Command"       -- How the menu opens. Options: 'Key', 'Command'
Config.ActivationKey = ""         -- Key binding when ActivationMode is 'Key'
Config.ActivationCommand = "objspawner" -- Command when ActivationMode is 'Command' (auto-adds /)

--[[

USED WITH 'Ped' MODE!

List of ped models allowed to open the menu.
Ignore if not using Ped mode.

]]--
Config.WhitelistedPeds = {
    's_m_y_cop_01',
}

--[[

USED WITH 'IP' MODE!

List of IPs allowed to open the menu.
Ignore if not using IP mode.

]]--
Config.WhitelistedIPs = {
    'ip:127.0.0.1',
}

--[[

USED WITH 'Steam' MODE!

List of SteamID64s allowed to open the menu.
Must be SteamID64 format — find yours at https://steamid.io/
Ignore if not using Steam mode.

]]--
Config.WhitelistedSteam = {
    '76561198191725723',
}

--[[

OBJECT CATEGORIES

Each category has a label (shown as a submenu title) and a list of objects.
Add new categories or objects following the templates below.

To add an object:
  { Displayname = "Object Label", Object = "prop_spawn_code" },

]]--
Config.Categories = {
    
    {
        Label = "Scene Equipment",
        Objects = {
            { Displayname = "Scene Lights",     Object = "prop_worklight_03b"   },
            { Displayname = "Flood Light",      Object = "prop_worklight_04a"   },
            { Displayname = "Generator",        Object = "prop_generator_03b"   },
            { Displayname = "Gazebo",           Object = "prop_gazebo_02"       },
            { Displayname = "First Aid Kit",    Object = "prop_ld_health_pack"  },
            { Displayname = "Fire Extinguisher",Object = "prop_fire_exting_1"   },
            { Displayname = "Police Barrier",   Object = "prop_barrier_work05"  },
            { Displayname = "Large Barrier",    Object = "prop_barrier_wat_03b" },
            { Displayname = "Medium Barrier",   Object = "prop_barrier_work06a" },
            { Displayname = "Small Barrier",    Object = "prop_barrier_work01a" },
            { Displayname = "Fence Barrier",    Object = "prop_mp_barrier_02b"  },
            { Displayname = "Big Cone",         Object = "prop_roadcone01a"     },
            { Displayname = "Small Cone",       Object = "prop_roadcone02b"     },
            { Displayname = "Warning Triangle", Object = "prop_mp_cone_02"      },
        }
    },
    {
        Label = "Camping & Leisure",
        Objects = {
            { Displayname = "Tent",             Object = "prop_skid_tent_01"      },
            { Displayname = "Camp Chair",       Object = "prop_skid_chair_02"     },
            { Displayname = "Cooler Box",       Object = "prop_coolbox_01"        },
            { Displayname = "BBQ Grill",        Object = "prop_bbq_4"             },
            { Displayname = "Camp Fire",        Object = "prop_beach_fire"        },
        }
    },
    {
        Label = "Furniture & Props",
        Objects = {
            { Displayname = "Wooden Table",     Object = "prop_table_04"        },
            { Displayname = "Office Chair",     Object = "prop_chair_01a"       },
            { Displayname = "Park Bench",       Object = "prop_bench_01a"       },
            { Displayname = "Trash Can",        Object = "prop_rub_binbag_01"   },
            { Displayname = "Oil Drum",         Object = "prop_oildrum_01a"     },
            { Displayname = "Pallet",           Object = "prop_pallet_04a"      },
        }
    },
    
    {
        Label = "Construction",
        Objects = {
            { Displayname = "Portaloo",             Object = "prop_portaloo_01a"        },
            { Displayname = "Scaffolding Frame",    Object = "prop_scafold_frame1f"     },
            { Displayname = "Scaffolding Section",  Object = "prop_scafold_03f"         },
            { Displayname = "Scaffolding Large",    Object = "prop_scafold_06a"         },
            { Displayname = "Concrete Barrier",     Object = "prop_barier_conc_01b"     },
            { Displayname = "Concrete Barrier 2",   Object = "prop_barier_conc_03a"     },
            { Displayname = "Concrete Pipes",       Object = "prop_pipes_conc_01"       },
            { Displayname = "Concrete Pipes 2",     Object = "prop_pipes_conc_02"       },
            { Displayname = "Metal Pipes",          Object = "prop_pipes_03a"           },
            { Displayname = "Concrete Sacks",       Object = "prop_conc_sacks_02a"      },
            { Displayname = "Dirt Pile",            Object = "prop_pile_dirt_07"        },
            { Displayname = "Log Pile",             Object = "prop_logpile_05"          },
            { Displayname = "Toolbox",              Object = "prop_tool_box_06"         },
            { Displayname = "Pickaxe",              Object = "prop_tool_pickaxe"        },
            { Displayname = "Blowtorch",            Object = "prop_tool_blowtorch"      },
            { Displayname = "Cable Reel",           Object = "prop_tool_cable01"        },
            { Displayname = "Blueprints",           Object = "prop_tool_bluepnt"        },
            { Displayname = "Paint Can",            Object = "prop_paints_can07"        },
            { Displayname = "Work Wall",            Object = "prop_workwall_01"         },
            { Displayname = "Work Light",           Object = "prop_worklight_01a"       },
            { Displayname = "Road Pole",            Object = "prop_roadpole_01b"        },
            { Displayname = "Tower Crane",          Object = "prop_towercrane_02c"      },
        }
    },
    {
        Label = "Crime Scene",
        Objects = {
            { Displayname = "Evidence Marker 1",    Object = "prop_e_marker_01"         },
            { Displayname = "Evidence Marker 2",    Object = "prop_e_marker_02"         },
            { Displayname = "Evidence Marker 3",    Object = "prop_e_marker_03"         },
            { Displayname = "Evidence Marker 4",    Object = "prop_e_marker_04"         },
            { Displayname = "Evidence Bag",         Object = "prop_cs_bag_drop_01"      },
            { Displayname = "Body Bag",             Object = "prop_body_bag_01a"        },
            { Displayname = "Police Tape Post",     Object = "prop_barrier_work01b"     },
            { Displayname = "Spotlight",            Object = "prop_worklight_03a"       },
            { Displayname = "Work Light",           Object = "prop_worklight_04b"       },
            { Displayname = "Forensic Tent",        Object = "prop_gazebo_02"           },
            { Displayname = "Orange Cone",          Object = "prop_roadcone01a"         },
            { Displayname = "Med Station",          Object = "prop_medstation_03"       },
            { Displayname = "Med Station Large",    Object = "prop_medstation_04"       },
            { Displayname = "First Aid Kit",        Object = "prop_ld_health_pack"      },
        }
    },
    {
        Label = "Beach & Outdoor",
        Objects = {
            { Displayname = "Beach Parasol",        Object = "prop_beach_parasol_05"    },
            { Displayname = "Beach Towel",          Object = "prop_beach_towel_02"      },
            { Displayname = "Beach Towel 2",        Object = "prop_beach_towel_04"      },
            { Displayname = "Beach Fire",           Object = "prop_beach_fire"          },
            { Displayname = "Beach Rings",          Object = "prop_beach_rings_01"      },
            { Displayname = "Boogie Board",         Object = "prop_boogieboard_03"      },
            { Displayname = "Boogie Board 2",       Object = "prop_boogieboard_10"      },
            { Displayname = "Boogie Board Stack",   Object = "prop_boogbd_stack_01"     },
            { Displayname = "Skate Rail",           Object = "prop_skate_rail"          },
            { Displayname = "Bleachers",            Object = "prop_bleachers_04"        },
            { Displayname = "Sunglasses Stand",     Object = "prop_sglasses_stand_01"   },
            { Displayname = "Venice Board",         Object = "prop_venice_board_03"     },
            { Displayname = "Snack Vending Machine",Object = "prop_vend_snak_01"        },
            { Displayname = "Cooler Box",           Object = "prop_coolbox_01"          },
            { Displayname = "BBQ Grill",            Object = "prop_bbq_4"               },
        }
    },

    -----------------------------------------------------------------
    ------------------- Add more categories below! ------------------
    -----------------------------------------------------------------
}

-- How far away (in metres) Remove Nearest Object searches
Config.DeleteRadius = 5.0

-- How far away (in metres) Remove All Nearby Objects searches
Config.DeleteAllRadius = 15.0

-- Freeze spawned objects in place (cannot be pushed by players/vehicles)
Config.FreezeObjects = true

-- Notify chat/other players when an object is placed. Set to false to disable.
Config.AnnounceSpawn = false