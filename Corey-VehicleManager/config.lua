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
        -- Add more sedans here if needed
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
{
    title = "Boats",
    vehicles = {
        {model = "650e", name = "Sea Ray 650 Express"},
        {model = "sr650fly", name = "Sea Ray 650 L"},
        {model = "amels200", name = "Amels 200 Yacht"},
    }
},

-- ==================== REAL LIFE MANUFACTURER CATEGORIES ====================

{
    title = "Acura",
    vehicles = {
        {model = "tltypes", name = "Acura TL Type-S"},
    }
},
{
    title = "Aston Martin",
    vehicles = {
        {model = "amdbx", name = "Aston Martin DBX Carbon Edition"},
        {model = "ast", name = "2013 Aston Martin Vanquish"},
    }
},
{
    title = "Audi",
    vehicles = {
        {model = "80B4", name = "1995 Audi Cabriolet (RS2) (B4)"},
        {model = "audquattros", name = "1983 Audi Quattro Sport"},
        {model = "aaq4", name = "2017 Audi A4 Quattro ABT"},
        {model = "q820", name = "2020 Audi Q8 50TDI"},
        {model = "r8ppi", name = "2013 Audi R8 V10"},
        {model = "r820", name = "2020 Audi R8"},
        {model = "rs6", name = "2016 Audi RS6 C7"},
        {model = "rs72020", name = "2020 Audi RS7"},
        {model = "s8d2", name = "1998 Audi S8 (D2/PFL)"},
        {model = "sq72016", name = "2016 Audi SQ7"},
        {model = "ttrs", name = "2010 Audi TT RS"},
    }
},
{
    title = "Bentley",
    vehicles = {
        {model = "bbentayga", name = "Bentley Bentayga"},
        {model = "cgts", name = "2020 Bentley Continental GT Convertible"},
    }
},
{
    title = "BMW",
    vehicles = {
        {model = "760li04", name = "2004 BMW 760Li Individual (E66/PFL)"},
        {model = "e34", name = "1995 BMW M5 E34"},
        {model = "m2", name = "2016 BMW M2"},
        {model = "m3e36", name = "1997 BMW M3 E36"},
        {model = "m3e92", name = "2008 BMW M3 e92"},
        {model = "m3f80", name = "2015 BMW M3 (F80)"},
        {model = "m4f82", name = "2015 BMW M4 F82"},
        {model = "m6f13", name = "BMW M6 F13 Shadow Line"},
        {model = "z419", name = "2019 BMW Z4 M40i"},
    }
},
{
    title = "Bugatti",
    vehicles = {
        {model = "bolide", name = "2020 Bugatti Bolide"},
    }
},
{
    title = "Cadillac",
    vehicles = {
        {model = "cats", name = "2016 Cadillac ATS-V Coupe"},
        {model = "cesc21", name = "2021 Cadillac Escalade"},
    }
},
{
    title = "Chevrolet",
    vehicles = {
        {model = "09tahoe", name = "2009 Chevrolet Tahoe"},
        {model = "15tahoe", name = "2015 Chevrolet Tahoe"},
        {model = "2020ss", name = "2020 Chevrolet Camaro SS"},
        {model = "camrs17", name = "2017 Chevrolet Camaro RS"},
        {model = "tahoe21", name = "2021 Chevrolet Tahoe RST"},
    }
},
{
    title = "Corvette",
    vehicles = {
        {model = "corvettec5z06", name = "Chevrolet Corvette C5 Z06"},
        {model = "czr1", name = "2009 Chevrolet Corvette ZR1"},
        {model = "c7", name = "2014 Chevrolet Corvette C7 Stingray"},
        {model = "stingray", name = "2020 Chevrolet Corvette C8 Stingray"},
    }
},
{
    title = "Dodge",
    vehicles = {
        {model = "16charger", name = "2016 Dodge Charger"},
        {model = "99viper", name = "1999 Dodge Viper GTS ACR"},
        {model = "chr20", name = "Dodge Charger Hellcat Widebody 2021"},
        {model = "demon", name = "2018 Dodge Challenger SRT Demon"},
        {model = "raid", name = "Dodge Challenger Raid"},
        {model = "ram2500", name = "2015 Dodge RAM 2500"},
        {model = "srt4", name = "Dodge Neon SRT-4"},
        {model = "trx", name = "2017 Dodge RAM 1500 Rebel TRX"},
        {model = "16challenger", name = "2016 Dodge Challenger"},
    }
},
{
    title = "Ferrari",
    vehicles = {
        {model = "488", name = "Ferrari 488 Spider"},
        {model = "f430s", name = "Ferrari F430 Scuderia"},
        {model = "f812", name = "2018 Ferrari 812 Superfast"},
        {model = "fct", name = "2015 Ferrari California T"},
        {model = "fxxk", name = "Ferrari FXX-K Hybrid Hypercar"},
        {model = "laferrari", name = "2015 Ferrari LaFerrari"},
        {model = "mig", name = "Ferrari Enzo"},
        {model = "yFe458i1", name = "458 Italia"},
        {model = "yFe458i2", name = "458 Speciale"},
        {model = "yFe458s1", name = "458 Spider"},
        {model = "yFe458s2", name = "458 Speciale Aperta"},
        {model = "yFeF12A", name = "Ferrari F60 America"},
        {model = "yFeF12T", name = "Ferrari F12 TRS Roadster"},
    }
},
{
    title = "Ford",
    vehicles = {
        {model = "f15078", name = "1978 Ford F150 XLT Ranger"},
        {model = "f150", name = "2012 Ford F150 SVT Raptor R"},
        {model = "fgt", name = "2005 Ford GT"},
        {model = "gt17", name = "2017 Ford GT"},
        {model = "mustang50th", name = "2015 Ford Mustang GT 50 Years Special Edition"},
        {model = "raptor2017", name = "2017 Ford Raptor"},
        {model = "wildtrak", name = "2021 Ford Bronco Wildtrak"},
    }
},
{
    title = "Honda",
    vehicles = {
        {model = "honcrx91", name = "Honda CRX SiR 1991"},
        {model = "na1", name = "1992 Honda NSX-R (NA1)"},
        {model = "ap2", name = "Honda S2000 AP2"},
        {model = "dragekcivick", name = "1997 Honda Civic Sedan Drag Version"},
        {model = "fk8", name = "2018 Honda Civic Type-R (FK8)"},
        {model = "17civict", name = "2017 Honda Civic Touring"},
    }
},
{
    title = "Italdesign",
    vehicles = {
        {model = "it18", name = "2017 Italdesign Zerouno"},
    }
},
{
    title = "Jaguar",
    vehicles = {
        {model = "fpacehm", name = "Jaguar F-pace 2017 Hamann Edition"},
    }
},
{
    title = "Jeep",
    vehicles = {
        {model = "jeep2012", name = "2012 Jeep Wrangler"},
        {model = "jeepreneg", name = "Jeep Renegade"},
        {model = "srt8", name = "2015 Jeep SRT-8"},
        {model = "trhawk", name = "2018 Jeep Grand Cherokee Trackhawk Series IV"},
    }
},
{
    title = "Koenigsegg",
    vehicles = {
        {model = "agerars", name = "2017 Koenigsegg Agera RS"},
        {model = "regera", name = "Koenigsegg Regera"},
    }
},
{
    title = "Lamborghini",
    vehicles = {
        {model = "huracanst", name = "Lamborghini Huracan Super Trofeo"},
        {model = "lambose", name = "Lamborghini Sesto Elemento"},
        {model = "lp670sv", name = "2009 Lamborghini Murcielago LP 670-4 SV"},
        {model = "lp700r", name = "2013 Lamborghini Aventador LP700-4 Roadster"},
        {model = "svj63", name = "Lamborghini Aventador SVJ"},
        {model = "urus", name = "Lamborghini Urus"},
        {model = "veneno", name = "2013 Lamborghini Veneno LP750-4"},
    }
},
{
    title = "Lexus",
    vehicles = {
        {model = "gs350", name = "Lexus GS 350"},
        {model = "is350mod", name = "2014 Lexus IS 350"},
        {model = "rcf", name = "2015 Lexus RCF"},
    }
},
{
    title = "Land Rover",
    vehicles = {
        {model = "lrrr", name = "1973 Land Rover Range Rover"},
    }
},
{
    title = "Lotus",
    vehicles = {
        {model = "esprit02", name = "2002 Lotus Esprit V8"},
    }
},
{
    title = "Lucid",
    vehicles = {
        {model = "regalia", name = "Quartz Regalia 723"},
    }
},
{
    title = "Maserati",
    vehicles = {
        {model = "levante", name = "Maserati Levante"},
    }
},
{
    title = "Mazda",
    vehicles = {
        {model = "84rx7k", name = "1984 Mazda RX-7 Stanced Version"},
        {model = "dragfd", name = "2002 Mazda RX-7 FD Drag"},
        {model = "fc3s", name = "Mazda RX7 FC3S"},
        {model = "majfd", name = "Mazda RX-7 FD"},
        {model = "miata3", name = "1989 Mazda Miata NA"},
        {model = "na6", name = "Mazda MX-5 Miata (NA6C)"},
    }
},
{
    title = "McLaren",
    vehicles = {
        {model = "650s", name = "McLaren 650S Coupe"},
        {model = "675lt", name = "2016 McLaren 675LT Coupe"},
        {model = "720s", name = "2017 McLaren 720S"},
        {model = "gtr96", name = "1996 McLaren F1 GTR"},
        {model = "mcst", name = "2020 McLaren Speedtail"},
        {model = "mp412c", name = "McLaren MP4-12C"},
        {model = "senna", name = "2019 McLaren Senna"},
    }
},
{
    title = "Mercedes-Benz",
    vehicles = {
        {model = "amggtrr20", name = "2020 Mercedes-Benz AMG GT-R Roadster"},
        {model = "c6320", name = "2020 Mercedes-AMG C63s"},
        {model = "G65", name = "2013 Mercedes-Benz G65 AMG"},
        {model = "e400", name = "2019 Mercedes-Benz E400 Coupe 4matic (C238)"},
        {model = "gl63", name = "Mercedes-Benz GL63 AMG"},
        {model = "mbc63", name = "2012 Mercedes-Benz C63 AMG Coupe Black Series"},
        {model = "s500w222", name = "2014 Mercedes-Benz S500 W222"},
        {model = "sl500", name = "1995 Mercedes-Benz SL500"},
        {model = "v250", name = "Mercedes-Benz V-class 250 Bluetec LWB"},
    }
},
{
    title = "Mitsubishi",
    vehicles = {
        {model = "cp9a", name = "Mitsubishi Lancer Evo VI T.M.E (CP9A)"},
        {model = "fto", name = "Mitsubishi FTO GP Version-R"},
    }
},
{
    title = "Nissan",
    vehicles = {
        {model = "180sx", name = "Nissan 180SX Type-X"},
        {model = "gtr", name = "2017 Nissan GTR"},
        {model = "gtrc", name = "2017 R35 Nissan GTR Convertible"},
        {model = "maj350", name = "Nissan Fairlady Z Z33"},
        {model = "nis15", name = "Nissan Silvia S15 Spec-R"},
        {model = "nissantitan17", name = "2017 Nissan Titan Warrior"},
        {model = "ns350", name = "Nissan 350z Stardast"},
        {model = "nzp", name = "Nissan 370z Pandem"},
        {model = "s14", name = "1998 Nissan Silvia K"},
        {model = "Safari97", name = "1997 Nissan Patrol Super Safari Y60"},
        {model = "skyline", name = "Nissan Skyline GT-R (BNR34)"},
        {model = "z32", name = "Nissan 300ZX Z32"},
    }
},
{
    title = "Porsche",
    vehicles = {
        {model = "maj935", name = "1978 Porsche 935 Moby Dick"},
        {model = "pcs18", name = "2018 Porsche Cayenne S"},
        {model = "718caymans", name = "Porsche 718 Cayman S"},
        {model = "cgt", name = "2003 Porsche Carrera GT (980)"},
        {model = "pm19", name = "2019 Porsche Macan Turbo"},
        {model = "taycan", name = "2020 Porsche Taycan Turbo S"},
    }
},
{
    title = "Range Rover",
    vehicles = {
        {model = "rrevoque", name = "Range Rover Evoque"},
        {model = "rrst", name = "Range Rover Vogue Startech"},
        {model = "rsvr16", name = "2016 Range Rover Sport SVR"},
    }
},
{
    title = "Rolls-Royce",
    vehicles = {
        {model = "dawnonyx", name = "2016 Rolls-Royce Dawn Onyx"},
        {model = "wraith", name = "Rolls-Royce Wraith"},
        {model = "rculi", name = "Rolls Royce Cullinan"},
        {model = "rrphantom", name = "2018 Rolls-Royce Phantom VIII"},
    }
},
{
    title = "Subaru",
    vehicles = {
        {model = "subisti08", name = "2008 Subaru WRX STi"},
        {model = "subwrx", name = "2004 Subaru Impreza WRX STI"},
        {model = "svx", name = "1996 Subaru Alcyone SVX"},
    }
},
{
    title = "Suzuki",
    vehicles = {
        {model = "gsxr19", name = "2019 Suzuki GSX-R1000R"},
        {model = "katana", name = "2019 Suzuki Katana"},
    }
},
{
    title = "Tesla",
    vehicles = {
        {model = "tr22", name = "2020 Tesla Roadster"},
        {model = "p90d", name = "Tesla Model X Unplugged Performance"},
        {model = "models", name = "2016 Tesla Model S P90D"},
        {model = "tmodel", name = "2018 Tesla Model 3"},
        {model = "teslax", name = "2016 Tesla Model X P90D"},
        {model = "teslapd", name = "2017 Tesla Model S Prior design"},
    }
},
{
    title = "Toyota",
    vehicles = {
        {model = "cam8tun", name = "2018 Toyota Camry XSE"},
        {model = "vxr", name = "2016 Toyota Land Cruiser VXR"},
        {model = "toysupmk4", name = "1998 Toyota Supra Turbo (A80)"},
        {model = "mk2100", name = "Toyota Mark II JZX100"},
    }
},
{
    title = "Volkswagen",
    vehicles = {
        {model = "golfgti7", name = "2015 Volkswagen Golf GTI MK7"},
    }
},
{
    title = "Volvo",
    vehicles = {
        {model = "xc90", name = "Volvo XC90 T8"},
    }
},
{
    title = "W Motors",
    vehicles = {
        {model = "wmfenyr", name = "W-Motors Fenyr Supersport"},
        {model = "lykan", name = "W-Motors Lykan HyperSport"},
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