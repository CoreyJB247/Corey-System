Config = {}

Config.VehicleCategories = {
    {
        id = "law",
        title = "Law Enforcement",
        icon = "shield-halved",
        description = "Spawn Law Enforcement",
        subcategories = {
            {
                title = "Los Santos Police Department",
                vehicles = {
            {model = "nf18taur", name = "2018 Ford Taurus"},
            {model = "nf18charg", name = "2018 Dodge Charger"},
            {model = "nf14charg", name = "2014 Dodge Charger"},
            {model = "nf14tah", name = "2014 Chevy Tahoe"},
            {model = "nf12cap", name = "2012 Chevy Caprice"},
            {model = "nf13exp", name = "2013 Ford FPIU"},
            {model = "nf16exp", name = "2016 Ford FPIU"},
            {model = "nf20dur", name = "2020 Dodge Durango"},
            {model = "nf20exp", name = "2020 Ford FPIU"},
            {model = "nf18f150", name = "2018 Ford F-150"},
            {model = "nf21tah", name = "2021 Chevy Tahoe"},
            {model = "nf19tah", name = "2019 Chevy Tahoe"},
                }
            },

            {
                title = "Blaine County Sheriffs Office",
                vehicles = {
                    {model = "m14charger", name = "2014 Dodge Charger"},
            {model = "m15expedition", name = "2015 Ford Expedition"},
            {model = "m16explorer", name = "2016 Ford FPIU"},
            {model = "m18charger", name = "2020 Dodge Charger"},
            {model = "m18taurus", name = "2018 Ford Taurus"},
            {model = "m19f150", name = "2019 Ford F-150"},
            {model = "m19tahoe", name = "2019 Chevy Tahoe"},
            {model = "m20explorer", name = "2021 Ford FPIU"},
            {model = "m21tahoe", name = "2021 Chevy Tahoe"},
                }
            },
            {
                title = "SASP Detectives (CID)",
                vehicles = {
                    {model = "detec1", name = "2020 Ford FPIU"},
                    {model = "detec2", name = "2016 Ford Fusion"},
                    {model = "detec3", name = "2020 Dodge Durango"},
                    {model = "um3", name = "2011 Ford CVPI"},
                    {model = "fbimalibu", name = "2013 Chevy Malibu"},
                    {model = "fbi22tahoe", name = "2022 Chevy Tahoe"},
                    {model = "fbi6", name = "2016 Ford FPIU"},
                    {model = "fbi4", name = "2020 Dodge Charger"},
                    {model = "ramfl", name = "2017 Dodge Ram"},
                }
            },
            {
                title = "San Andreas State Police",
                vehicles = {
                    {model = "v11vic", name = "2009 Ford CVPI (Retro)"},
                    {model = "v13explorer", name = "2013 Ford FPIU"},
                    {model = "v14charger", name = "2014 Dodge Charger"},
                    {model = "v14tahoe", name = "2014 Chevy Tahoe"},
                    {model = "v14ram", name = "2014 Dodge Ram"},
                    {model = "v16explorer", name = "2016 Ford FPIU"},
                    {model = "v18charger", name = "2018 Dodge Charger"},
                    {model = "v18taurus", name = "2018 Ford Taurus"},
                    {model = "v19tahoe", name = "2019 Chevy Tahoe"},
                    {model = "v21durango", name = "2021 Dodge Durango"},
                    {model = "vf150", name = "2021 Ford F-150"},
                }
            },
            {
                title = "San Andreas State Police SWAT",
                vehicles = {
                    {model = "swat22tahoe", name = "2022 Chevy Tahoe Armoured"},
                    {model = "swatexpedition", name = "2022 Ford Expedition Armoured"},
                    {model = "swatraptor", name = "2022 Ford F-150 Raptor Armoured"},
                    {model = "SWATVAN", name = "2023 Mercedes Sprinter Armoured"},
                    {model = "tahoeswat", name = "2019 Chevy Tahoe Armoured"},
                }
            },
            {
                title = "San Andreas Fish & Wildlife",
                vehicles = {
                    {model = "fwtruck", name = "2022 Chevy Silverado"},
                    {model = "fwbike", name = "2015 Honda Bros150"},
                }
            },
        }
    },

    {
        id = "fire",
        title = "San Andreas Fire Rescue",
        icon = "fire-extinguisher",
        description = "Spawn San Andreas Fire Rescue",
        subcategories = {
            {
                title = "Fire Rescue",
                vehicles = {
                    { name = "2019 Ford F550 Wildland Brush", model = "brush" },
                    { name = "2014 Ram 2500 Wildland Brush", model = "brushram" },
                    { name = "2019 Pierce Velocity Engine", model = "pierce1" },
                    { name = "2019 Pierce Velocity Rescue", model = "vrescuewi" },
                }
            },
            {
                title = "EMS",
                vehicles = {
                    { name = "2019 Ford 550 Ambulance", model = "fordambo" },
                    { name = "2017 Dodge Ram Ambulance", model = "rambulance" },
                    { name = "2019 Chevy Tahoe Sprint", model = "bat3" },
                    { name = "2015 Ford F-150 Sprint", model = "bat2" },
                }
            },
        }
    },

    {
        id = "civilian",
        title = "Civilian Vehicles",
        icon = "car",
        description = "Spawn civilian vehicles",
        subcategories = {
{
                title = "Addon Vehicles",
                description = "Custom / Addon Vehicles",
                icon = "plus",
                subcategories = {  -- This makes it open another menu
                    {
                        title = "Sedans",
                        vehicles = {
            {model = "onx_merit1", name = "Declasse Merit Classic"},
            {model = "onx_merit2", name = "Declasse Merit Cruiser"},
            {model = "onx_tulip2c", name = "Declasse Tulip M-100"},
                        }
                    },
                    {
                        title = "Vans",
                        vehicles = {
            {model = "nspeedo", name = "Vapid Speedo Express"},
            {model = "ONX_TFJOGGERCL1", name = "Benefactor Jogger Cargo LWB"},
            {model = "ONX_TFJOGGERCS1", name = "Benefactor Jogger Cargo SWB"},
            {model = "ONX_TFJOGGERPL1", name = "Benefactor Jogger Passenger LWB"},
            {model = "ONX_TFJOGGERPS1", name = "Benefactor Jogger Passenger SWB"},
                        }
                    },
                    {
                        title = "Offroad",
                        vehicles = {
            {model = "onx_scoutc", name = "Vapid Scout C"},
            {model = "onx_tfbison", name = "Bravado Bison"},
            {model = "onx_tfbison2", name = "Bravado Bison (Single Cab)"},
            {model = "onx_tfbison3", name = "Bravado Bison LWB Dually"},
            {model = "onx_tfbison4", name = "Bravado Bison Offroad Edition"},
                        }
                    },
                    {
                        title = "Suvs",
                        vehicles = {
            {model = "onx_tfalamo", name = "Declasse Alamo 2700LX"},
            {model = "onx_tfgranger", name = "Declasse Granger 3700LX"},
            {model = "onx_tfregent", name = "Brute Regent"},
            {model = "onx_tfregentxl", name = "Brute Regent XL LWB"},
                        }
                    },
                    {
                        title = "Sports",
                        vehicles = {
            {model = "onx_domgtcoupe", name = "Vapid Dominator GT"},
                        }
                    },
                }
    },

            {
    title = "Compacts",
    vehicles = {
        {name = "Dinka Blista", model = "blista"},
        {name = "Karin Dilettante", model = "dilettante"},
        {name = "Weeny Issi", model = "issi2"},
        {name = "Benefactor Panto", model = "panto"},
        {name = "Bollokan Prairie", model = "prairie"},
        {name = "Declasse Rhapsody", model = "rhapsody"},
        {name = "BF Club", model = "club"},
        {name = "Maxwell Asbo", model = "asbo"},
        {name = "Dinka Blista Kanjo", model = "kanjo"},
        {name = "Weeny Issi Classic", model = "issi3"},
        {name = "Grotti Brioso R/A", model = "brioso"},
        {name = "Benefactor Brioso 300", model = "brioso2"},
    }
},
{
    title = "Sedans",
    vehicles = {
        {name = "Declasse Asea", model = "asea"},
        {name = "Declasse Asterope", model = "asterope"},
        {name = "Declasse Emperor", model = "emperor"},
        {name = "Declasse Fugitive", model = "fugitive"},
        {name = "Vapid Glendale", model = "glendale"},
        {name = "Karin Intruder", model = "intruder"},
        {name = "Declasse Premier", model = "premier"},
        {name = "Dundreary Regina", model = "regina"},
        {name = "Obey Tailgater", model = "tailgater"},
        {name = "Vulcar Warrener", model = "warrener"},
        {name = "Albany Primo", model = "primo"},
        {name = "Cheval Surge", model = "surge"},
        {name = "Benefactor Schafter", model = "schafter2"},
        {name = "Enus Super Diamond", model = "superd"},
        {name = "Karin Sultan Classic", model = "sultan2"},
        {name = "Benefactor Glendale Custom", model = "glendale2"},
    }
},
{
    title = "Coupes",
    vehicles = {
        {name = "Enus Cognoscenti", model = "cognoscenti"},
        {name = "Dewbauchee Exemplar", model = "exemplar"},
        {name = "Benefactor Feltzer 2", model = "feltzer2"},
        {name = "Ocelot Jackal", model = "jackal"},
        {name = "Ubermacht Oracle", model = "oracle"},
        {name = "Ubermacht Sentinel", model = "sentinel"},
        {name = "Enus Windsor", model = "windsor"},
        {name = "Lampadati Felon", model = "felon"},
        {name = "Lampadati Felon GT", model = "felon2"},
        {name = "Ubermacht Zion", model = "zion"},
        {name = "Ubermacht Zion Cabrio", model = "zion2"},
        {name = "Enus Windsor Drop", model = "windsor2"},
    }
},
{
    title = "Muscle",
    vehicles = {
        {name = "Vapid Blade", model = "blade"},
        {name = "Albany Buccaneer", model = "buccaneer"},
        {name = "Vapid Chino", model = "chino"},
        {name = "Vapid Dominator", model = "dominator"},
        {name = "Bravado Gauntlet", model = "gauntlet"},
        {name = "Imponte Phoenix", model = "phoenix"},
        {name = "Declasse Sabre Turbo", model = "sabregt"},
        {name = "Vapid Slamvan", model = "slamvan"},
        {name = "Declasse Vigero", model = "vigero"},
        {name = "Declasse Yosemite", model = "yosemite"},
        {name = "Bravado Rat-Loader", model = "ratloader"},
        {name = "Vapid Ellie", model = "ellie"},
        {name = "Imponte Dukes", model = "dukes"},
        {name = "Bravado Gauntlet Classic", model = "gauntlet3"},
        {name = "Declasse Tampa", model = "tampa"},
        {name = "Vapid Clique", model = "clique"},
    }
},
{
    title = "Sports",
    vehicles = {
        {name = "Truffade Adder", model = "adder"},
        {name = "Bravado Banshee", model = "banshee"},
        {name = "Grotti Carbonizzare", model = "carbonizzare"},
        {name = "Progen Comet", model = "comet2"},
        {name = "Annis Elegy RH8", model = "elegy2"},
        {name = "Karin Futo", model = "futo"},
        {name = "Pegassi Infernus", model = "infernus"},
        {name = "Progen Itali GTB", model = "italigtb"},
        {name = "Dinka Jester", model = "jester"},
        {name = "Karin Kuruma", model = "kuruma"},
        {name = "Dinka Massacro", model = "massacro"},
        {name = "BF Neon", model = "neon"},
        {name = "Karin Sultan", model = "sultan"},
        {name = "Pegassi Zentorno", model = "zentorno"},
        {name = "Obey 9F", model = "ninef"},
        {name = "Obey 9F Cabrio", model = "ninef2"},
        {name = "Dewbauchee Rapid GT", model = "rapidgt"},
        {name = "Dewbauchee Rapid GT Convertible", model = "rapidgt2"},
        {name = "Grotti Bestia GTS", model = "bestiagts"},
        {name = "Lampadati Tropos Rallye", model = "tropos"},
        {name = "Annis Remus", model = "remus"},
        {name = "Annis Euros", model = "euros"},
        {name = "Pfister Comet Retro Custom", model = "comet3"},
        {name = "Pfister Neon", model = "neon"},
    }
},
{
    title = "Super",
    vehicles = {
        {name = "Overflod Entity XF", model = "entityxf"},
        {name = "Pegassi Osiris", model = "osiris"},
        {name = "Progen T20", model = "t20"},
        {name = "Truffade Turismo R", model = "turismor"},
        {name = "Pegassi Vacca", model = "vacca"},
        {name = "Coil Voltic", model = "voltic"},
        {name = "Grotti X80 Proto", model = "prototipo"},
        {name = "Principe Deveste Eight", model = "deveste"},
        {name = "Overflod Tyrant", model = "tyrant"},
        {name = "Benefactor Krieger", model = "krieger"},
        {name = "Pegassi Tezeract", model = "tezeract"},
        {name = "Truffade Nero", model = "nero"},
        {name = "Progen Emerus", model = "emerus"},
        {name = "Ocelot XA-21", model = "xa21"},
    }
},
{
    title = "SUVs",
    vehicles = {
        {name = "Gallivanter Baller", model = "baller"},
        {name = "Albany Cavalcade", model = "cavalcade"},
        {name = "Benefactor Dubsta", model = "dubsta"},
        {name = "Declasse Granger", model = "granger"},
        {name = "Vapid Huntley", model = "huntley"},
        {name = "Dundreary Landstalker", model = "landstalker"},
        {name = "Canis Mesa", model = "mesa"},
        {name = "Vapid Radius", model = "radius"},
        {name = "Obey Rocoto", model = "rocoto"},
        {name = "Canis Seminole", model = "seminole"},
        {name = "Enus XLS", model = "xls"},
        {name = "Benefactor Streiter", model = "streiter"},
        {name = "Gallivanter Baller LE", model = "baller3"},
        {name = "Albany Cavalcade XL", model = "cavalcade2"},
        {name = "Mammoth Patriot", model = "patriot"},
        {name = "Fathom FQ 2", model = "fq2"},
    }
},
{
    title = "Motorcycles",
    vehicles = {
        {name = "Dinka Akuma", model = "akuma"},
        {name = "Western Bagger", model = "bagger"},
        {name = "Pegassi Bati 801", model = "bati"},
        {name = "Nagasaki Carbon RS", model = "carbonrs"},
        {name = "Western Daemon", model = "daemon"},
        {name = "Dinka Double-T", model = "double"},
        {name = "Pegassi Faggio", model = "faggio2"},
        {name = "Shitzu Hakuchou", model = "hakuchou"},
        {name = "Principe Lectro", model = "lectro"},
        {name = "Shitzu PCJ 600", model = "pcj"},
        {name = "Maibatsu Sanchez", model = "sanchez"},
        {name = "Western Nightblade", model = "nightblade"},
        {name = "LCC Hexer", model = "hexer"},
        {name = "Western Wolfsbane", model = "wolfsbane"},
        {name = "Pegassi Ruffian", model = "ruffian"},
        {name = "Dinka Vindicator", model = "vindicator"},
        {name = "Pegassi Oppressor", model = "oppressor"},
    }
},
{
    title = "Off-Road",
    vehicles = {
        {name = "BF Bifta", model = "bifta"},
        {name = "Nagasaki Blazer", model = "blazer"},
        {name = "Canis Brawler", model = "brawler"},
        {name = "Bravado Duneloader", model = "dloader"},
        {name = "Canis Mesa", model = "mesa3"},
        {name = "Declasse Rancher XL", model = "rancherxl"},
        {name = "Vapid Rebel", model = "rebel2"},
        {name = "Vapid Sandking", model = "sandking"},
        {name = "Annis Hellion", model = "hellion"},
        {name = "Canis Kamacho", model = "kamacho"},
        {name = "BF Injection", model = "bfinjection"},
        {name = "Maxwell Vagrant", model = "vagrant"},
        {name = "Nagasaki Outlaw", model = "outlaw"},
        {name = "Declasse Draugur", model = "draugur"},
    }
},
{
    title = "Helicopters",
    vehicles = {
        {name = "Nagasaki Buzzard", model = "buzzard"},
        {name = "Western Frogger", model = "frogger"},
        {name = "Western Maverick", model = "maverick"},
        {name = "Western Annihilator", model = "annihilator"},
        {name = "HVY Savage", model = "savage"},
        {name = "Buckingham Volatus", model = "volatus"},
        {name = "Nagasaki Havok", model = "havok"},
        {name = "Buckingham SuperVolito", model = "supervolito"},
        {name = "Buckingham Swift", model = "swift"},
        {name = "Buckingham Akula", model = "akula"},
        {name = "FH-1 Hunter", model = "hunter"},
    }
},
{
    title = "Planes",
    vehicles = {
        {name = "Buckingham Luxor", model = "luxor"},
        {name = "Buckingham Shamal", model = "shamal"},
        {name = "Buckingham Miljet", model = "miljet"},
        {name = "Western Lazer", model = "lazer"},
        {name = "Western Mammatus", model = "mammatus"},
        {name = "Western Velum", model = "velum"},
        {name = "Western Duster", model = "duster"},
        {name = "Western Cropduster", model = "cropduster"},
        {name = "JoBuilt P-996 LAZER", model = "lazer"},
        {name = "Buckingham Pyro", model = "pyro"},
        {name = "RM-10 Bombushka", model = "bombushka"},
        {name = "Western Rogue", model = "rogue"},
        {name = "Buckingham Alpha-Z1", model = "alphaz1"},
    }
},
{
    title = "Boats",
    vehicles = {
        {name = "Nagasaki Dinghy", model = "dinghy"},
        {name = "Shitzu Jetmax", model = "jetmax"},
        {name = "Dinka Marquis", model = "marquis"},
        {name = "Speedophile Seashark", model = "seashark"},
        {name = "Pegassi Speeder", model = "speeder"},
        {name = "Shitzu Squalo", model = "squalo"},
        {name = "Lampadati Toro", model = "toro"},
        {name = "Shitzu Longfin", model = "longfin"},
        {name = "Kraken Submersible", model = "submersible"},
        {name = "Pegassi Toreador", model = "toreador"},
        {name = "Nagasaki Tropic", model = "tropic"},
        {name = "Shitzu Suntrap", model = "suntrap"},
    }
},
}
}
}