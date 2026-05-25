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
            {model = "GC18Raptor", name = "2018 Ford Raptor"},
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
    title = "Declasse",
    vehicles = {
        {model = "onx_merit1", name = "Declasse Merit Classic"},
        {model = "onx_merit2", name = "Declasse Merit Cruiser"},
        {model = "onx_tulip2c", name = "Declasse Tulip M-100"},
        {model = "onx_tfalamo", name = "Declasse Alamo 2700LX"},
        {model = "onx_tfgranger", name = "Declasse Granger 3700LX"},
        -- Add more sedans here if needed
    }
},
{
    title = "Albany",
    vehicles = {
        {model = "ncavalcade ", name = "Albany Cavalcade III"},
        -- Add more sedans here if needed
    }
},
{
    title = "Benefactor",
    vehicles = {
        {model = "ONX_TFJOGGERCL1", name = "Benefactor Jogger Cargo LWB"},
        {model = "ONX_TFJOGGERCS1", name = "Benefactor Jogger Cargo SWB"},
        {model = "ONX_TFJOGGERPL1", name = "Benefactor Jogger Passenger LWB"},
        {model = "ONX_TFJOGGERPS1", name = "Benefactor Jogger Passenger SWB"},
        {model = "imperial", name = "Benefactor Imperial"},
        {model = "imperialpas", name = "Benefactor Imperial Passenger"},
        {model = "imperialev", name = "Benefactor Imperial EV"},
    }
},
{
    title = "Bravado",
    vehicles = {
        
        {model = "onx_tfbison", name = "Bravado Bison"},
        {model = "onx_tfbison2", name = "Bravado Bison (Single Cab)"},
        {model = "onx_tfbison3", name = "Bravado Bison LWB Dually"},
        {model = "onx_tfbison4", name = "Bravado Bison Offroad Edition"},
    }
},
{
    title = "Brute",
    vehicles = {
        
        {model = "onx_tfregent", name = "Brute Regent"},
        {model = "onx_tfregentxl", name = "Brute Regent XL LWB"},
    }
},
{
    title = "Vapid",
    vehicles = {
        {model = "onx_domgtcoupe", name = "Vapid Dominator GT"},
        {model = "onx_scoutc", name = "Vapid Scout C"},
        {model = "nspeedo", name = "Vapid Speedo Express"},
        {model = "nriata", name = "Vapid Riata TX"},
        {model = "nriata2", name = "Vapid Riata S"},
        {model = "nsandstorm", name = "Vapid Sandstorm D205"},
        {model = "nsandstorm2", name = "Vapid Sandstorm D205 XL"},
        {model = "hellenstorm", name = "Vapid D205 Hellenbach"},
        {model = "nsandstorm3", name = "Vapid D205 SWB"},
    }
},
{
    title = "Audi",
    vehicles = {
        {model = "r820", name = "2020 Audi R8"},
        {model = "rs62", name = "2020 Audi RS6 Avant"},
        {model = "rs6", name = "2016 Audi RS6 C7 Performance"},
        {model = "sq72016", name = "2016 Audi SQ7"},
        {model = "q820", name = "2020 Audi Q8"},
        {model = "23rs7", name = "2023 Audi RS7"},
        {model = "11rs5", name = "2011 Audi RS5"},
    }
},
{
    title = "Bentley",
    vehicles = {
        {model = "mulca21", name = "2021 Bentley Mulliner Bacalar"},
    }
},
{
    title = "BMW",
    vehicles = {
        {model = "f82", name = "2015 BMW F82 M4"},
        {model = "bmci", name = "2018 BMW M5 F90"},
        {model = "i8", name = "2015 BMW i8"},
        {model = "bmwm8", name = "2019 BMW M8"},
        {model = "750li", name = "2016 BMW 750Li"},
        {model = "x5e53", name = "2005 BMW X5 E53"},
        {model = "bmwm4csl", name = "2022 BMW M4CSL"},
        {model = "18m5", name = "2018 BMW M5"},
        {model = "m3e36", name = "1997 BMW M3 E36"},
        {model = "m3g80", name = "2022 BMW M3 G80"},
    }
},
{
    title = "Cadillac",
    vehicles = {
        {model = "ctsv16", name = "2016 Cadillac CTS-V"},
        {model = "ct5v", name = "2020 Cadillac CT-V Sport"},
        {model = "ct5vbw22", name = "2022 Cadillac CT-V Blackwing"},
    }
},
{
    title = "Chevrolet",
    vehicles = {
        {model = "211le", name = "2022 Chevrolet Camaro ZL1-1LE"},
        {model = "checol17", name = "2017 Chevrolet Colorado"},
        {model = "camaro90", name = "1990 Chevrolet Camaro IROC-Z"},
        {model = "camrs17", name = "2017 Chevrolet Camaro RS"},
        {model = "13malibu", name = "2013 Chevrolet Malibu"},
        {model = "czr1", name = "2009 Chevrolet Corvette ZR1"},
        {model = "tahoe", name = "2013 Chevrolet Tahoe"},
        {model = "c8", name = "2020 Chevrolet Corvette C8"},
        {model = "C7", name = "2014 Chevrolet Corvette C7 Stingray"},
        {model = "subn", name = "2016 Chevrolet Suburban"},
        {model = "silverado", name = "2017 Chevrolet Silverado 1500 LTZ"},
        {model = "caprice13", name = "2013 Chevrolet Caprice"},
        {model = "caprice89w", name = "1989 Chevrolet Caprice Wagon"},
        {model = "chevropremtn", name = "2019 Chevrolet Blazer Premier"},
        {model = "15z28", name = "2015 Chevorlet Camaro Z/28"},
    }
},
{
    title = "Chrysler",
    vehicles = {
        {model = "pacifica", name = "2020 Chrysler Pacifica"},
        {model = "chry300", name = "2008 Chrysler 300C SRT8"},
    }
},
{
    title = "Dodge",
    vehicles = {
        {model = "viper", name = "2016 Dodge Viper SRT"},
        {model = "dl2016", name = "2016 Dodge RAM 1500 Limited"},
        {model = "chr20", name = "2020 Dodge Charger Hellcat Widebody"},
        {model = "16charger", name = "2016 Dodge Charger SRT Hellcat"},
        {model = "demon", name = "2018 Dodge Challenger SRT Demon"},
        {model = "ram16", name = "2016 Dodge Ram Rebel"},
        {model = "ram2500", name = "2015 Dodge RAM 2500"},
        {model = "12charger", name = "2012 Dodge Charger SRT"},
        {model = "08magnumsrt", name = "2008 Dodge Magnum SRT"},
        {model = "69charger", name = "1969 Dodge Charger"},
    }
},
{
    title = "Ford",
    vehicles = {
        {model = "bronco2021", name = "2021 Ford Bronco"},
        {model = "raptor2017", name = "2017 Ford Raptor"},
        {model = "focusrs", name = "2017 Ford Focus RS"},
        {model = "mustang19", name = "2019 Ford Mustang GT"},
        {model = "19Raptor", name = "2019 Ford Raptor"},
        {model = "19GT500", name = "2019 Ford Mustang Shelby GT500"},
        {model = "wildtrak", name = "2021 Ford Bronco Wildtrak"},
        {model = "everest", name = "2018 Ford Everest"},
        {model = "mache", name = "2021 Ford Mustang Mach-E"},
        {model = "mach1", name = "2021 Ford Mustang Mach-1"},
        {model = "f450plat", name = "2021 Ford F-450 Platinum"},
        {model = "st", name = "2013 Ford Focus ST"},
        {model = "00f350d", name = "2000 Ford F-350 Super Duty Dually"},
        {model = "fescape", name = "2012 Ford Escape"},
        {model = "crownvic2011", name = "2011 Ford Crown Victoria"},
        {model = "expmax20", name = "2020 Ford Expedition MAX"},
        {model = "taurus23", name = "2023 Ford Taurus"},
    }
},
{
    title = "GMC",
    vehicles = {
        {model = "gmcyd", name = "2015 GMC Yukon Denali"},
        {model = "21sierra", name = "2021 GMC Sierra 1500"},
        {model = "denalihd", name = "2018 GMC Sierra Denali 3500D"},
        {model = "terrain22", name = "2022 GMC Terrain AT4"},
    }
},
{
    title = "Honda",
    vehicles = {
        {model = "fk8", name = "2018 Honda Civic Type-R"},
        {model = "nc1", name = "2016 Honda NSX"},
        {model = "fd2", name = "2008 Honda Civic Type-R"},
        {model = "ody18", name = "2019 Honda Odyssey Elite"},
        {model = "cu2", name = "2010 Honda Accord"},
        {model = "citytrg", name = "2016 Honda City"},
        {model = "accord2017", name = "2017 Honda Accord"},
    }
},
{
    title = "Hyundai",
    vehicles = {
        {model = "veln", name = "2018 Hyundai Veloster N"},
        {model = "sonata20", name = "2020 Hyundai Sonata Limited"},
        {model = "16santafe", name = "2016 Hyundai Santa Fe"},
        {model = "elantrang", name = "2021 Hyundai Elantra"},
        {model = "14grandeur", name = "2014 Hyundai Grandeur"},
    }
},
{
    title = "Jeep",
    vehicles = {
        {model = "srt8", name = "2015 Jeep SRT-8"},
        {model = "jeepg", name = "2020 Jeep Gladiator Rubicon"},
        {model = "trhawk", name = "2018 Jeep Grand Cherokee Trackhawk"},
        {model = "jeep2012", name = "2012 Jeep Wrangler"},
        {model = "wrangler22", name = "2022 Jeep Wrangler Rubicon"},
    }
},
{
    title = "Kia",
    vehicles = {
        {model = "kiagt", name = "2017 KIA Stinger GT"},
        {model = "optima", name = "2014 KIA Optima K5"},
        {model = "19sorento", name = "2019 KIA Sorento"},
        {model = "kiasoul2", name = "2020 KIA Soul"},
        {model = "sportage", name = "2022 KIA Sportage"},
        {model = "24telluridesxp", name = "2024 KIA Telluride SXP"},
    }
},
{
    title = "Lexus",
    vehicles = {
        {model = "lex570", name = "2016 Lexus LX570"},
        {model = "lc500", name = "2018 Lexus LC500"},
        {model = "rx450h", name = "2016 Lexus RX450h"},
        {model = "RC350S", name = "2022 Lexus RC350"},
    }
},
{
    title = "Mercedes",
    vehicles = {
        {model = "xxxxx", name = "2023 Mercedes X-Class"},
        {model = "s500w222", name = "2014 Mercedes S500 AMG W222"},
        {model = "c63w205", name = "2017 Mercedes C63S AMG"},
        {model = "XPERIA38", name = "2019 Mercedes G63 AMG"},
        {model = "e400", name = "2019 Mercedes E400 4-Matic"},
        {model = "v250", name = "2019 Mercedes V-Class"},
        {model = "gls63", name = "2016 Mercedes AMG GLS 63"},
        {model = "amggt", name = "2016 Mercedes AMG GT"},
        {model = "2013e63", name = "2013 Mercedes E63 AMG"},
    }
},
{
    title = "Mitsubishi",
    vehicles = {
        {model = "evo10", name = "2016 Mitsubishi Lancer Evolution X"},
    }
},
{
    title = "Nissan",
    vehicles = {
        {model = "rogue20", name = "2020 Nissan Rogue Sport"},
        {model = "gtr", name = "2017 Nissan GTR"},
        {model = "370z", name = "2016 Nissan 370Z Nismo Z34"},
        {model = "nissantitan17", name = "2017 Nissan Titan Warrior"},
        {model = "gtr50", name = "2021 Nissan GT-R50"},
        {model = "qashqai16", name = "2016 Nissan Qashqai"},
        {model = "patrol25", name = "2025 Nissan Armada"},
    }
},
{
    title = "Tesla",
    vehicles = {
        {model = "tr22", name = "2020 Tesla Roadster"},
        {model = "tmodel", name = "2018 Tesla Model 3"},
    }
},
{
    title = "Toyota",
    vehicles = {
        {model = "lc200", name = "2016 Toyota Land Cruiser 200"},
        {model = "camry55", name = "2016 Toyota Camry"},
        {model = "camry18", name = "2018 Toyota Camry XSE"},
        {model = "sclkuz", name = "2020 Toyota Land Cruiser 200"},
        {model = "supra19", name = "2019 Toyota Supra GR"},
        {model = "4runner", name = "2020 Toyota 4Runner"},
        {model = "hilux2019", name = "2019 Toyota Hilux"},
        {model = "taco23", name = "2023 Toyota Tacoma"},
        {model = "cruisersj", name = "2020 Toyota LC200"},
        {model = "20supra", name = "2020 Toyota Supra"},
        {model = "70series2022", name = "2022 Toyota Land Cruiser 70 Series"},
        {model = "gg_ds_camry18", name = "2018 Toyota Camry (Driving School)"},
        {model = "26grgt", name = "2026 Toyota GR GT"},
        {model = "hilux21", name = "2021 Toyota Hilux"},
    }
},
{
    title = "Volkswagen",
    vehicles = {
        {model = "R50", name = "2008 Volkswagen Touareg R50"},
        {model = "vwstance", name = "2016 Volkswagen Passat"},
        {model = "cox2013", name = "2013 Volkswagen Beetle"},
        {model = "jettagli25", name = "2025 Volkswagen Jetta GLI"},
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