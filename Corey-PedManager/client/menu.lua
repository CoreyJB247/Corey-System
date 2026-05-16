-- client/menu.lua
-- All ox_lib context menu definitions for the appearance system

local savedCharacters = {}

-- Tracks the last context id shown so we can restore it after a model change
-- (SetPlayerModel destroys the ped entity and forces NUI to reset, closing menus)
local _lastContextId = nil

local function ShowContext(id)
    _lastContextId = id
    lib.showContext(id)
end

-- Called from main.lua after applyCharacter finishes changing the model
function ReopenLastMenu()
    if _lastContextId then
        lib.showContext(_lastContextId)
    end
end

-- ─── fivem-appearance exports ────────────────────────────────────────────────

local appearanceConfig = {
    ped          = true,
    headBlend    = true,
    faceFeatures = true,
    headOverlays = true,
    components   = true,
    props        = true,
    allowExit    = true,
    tattoos      = true,
}

function GetAppearance()
    local ok, result = pcall(function()
        return exports['fivem-appearance']:getPedAppearance(PlayerPedId())
    end)
    if ok and type(result) == 'table' then return result end
    print('[appearance_menu] GetAppearance failed: ' .. tostring(result))
    return nil
end

function SetAppearance(data)
    local ok, err = pcall(function()
        exports['fivem-appearance']:setPlayerAppearance(data)
    end)
    if not ok then
        print('[appearance_menu] SetAppearance failed: ' .. tostring(err))
        return false
    end
    return true
end

function OpenEditor(cb, opts)
    local config = opts or appearanceConfig
    CreateThread(function()
        local ok, err = pcall(function()
            exports['fivem-appearance']:startPlayerCustomization(cb, config)
        end)
        if not ok then
            print('[appearance_menu] OpenEditor failed: ' .. tostring(err))
            lib.notify({ title = 'Appearance', description = 'Editor error: ' .. tostring(err), type = 'error' })
            if cb then cb(nil) end
        end
    end)
end

-- ─── Utility ─────────────────────────────────────────────────────────────────

local function notify(ntype, msg)
    lib.notify({ title = 'Appearance Menu', description = msg, type = ntype })
end

local function ResolveModelName(hash)
    if hash == GetHashKey('mp_m_freemode_01') then return 'mp_m_freemode_01' end
    if hash == GetHashKey('mp_f_freemode_01') then return 'mp_f_freemode_01' end
    -- Config.SpawnPeds is now a list of category tables, each with a .peds list
    for _, group in ipairs(Config.SpawnPeds) do
        for _, ped in ipairs(group.peds) do
            if hash == GetHashKey(ped.model) then return ped.model end
        end
    end
    return tostring(hash)
end

local function GetAppearanceSafe()
    Wait(0)
    Wait(0)
    return GetAppearance()
end

-- ─── Category helpers ─────────────────────────────────────────────────────────

local function GetCategoryById(id)
    for _, cat in ipairs(Config.PedCategories) do
        if cat.id == id then return cat end
    end
    return Config.PedCategories[#Config.PedCategories] or { id = 'other', label = 'Other', icon = '📁' }
end

local function CountByCategory(rows)
    local counts = {}
    for _, cat in ipairs(Config.PedCategories) do
        counts[cat.id] = 0
    end
    for _, row in ipairs(rows) do
        local catId = row.category or 'other'
        if counts[catId] ~= nil then
            counts[catId] = counts[catId] + 1
        else
            counts['other'] = (counts['other'] or 0) + 1
        end
    end
    return counts
end

-- ─── Root Menu ───────────────────────────────────────────────────────────────

function OpenAppearanceMenu()
    local items = {}

    -- ── Appearance section ────────────────────────────────────────────────────
    if Config.Categories.SpawnPed then
        items[#items + 1] = {
            title       = '🧬 Spawn Ped',
            description = 'Spawn different ped models',
            arrow       = true,
            onSelect    = OpenSpawnPedMenu,
        }
    end

    if Config.Categories.CreateMPPed then
        items[#items + 1] = {
            title       = '🔥 Create MP Ped',
            description = 'Create a new multiplayer character',
            arrow       = true,
            onSelect    = OpenCreateMPPedMenu,
        }
    end

    if Config.Categories.CustomizePed then
        items[#items + 1] = {
            title       = '⚙️ Customize Ped',
            description = 'Customize your current character',
            onSelect    = function()
                OpenEditor(function(appearance)
                    if appearance then notify('success', 'Appearance updated!') end
                    lib.showContext('appearance_root')
                end)
            end,
        }
    end

    if Config.Categories.SavedPeds then
        items[#items + 1] = {
            title       = '💾 Save Current Ped',
            description = 'Save your current appearance to the database',
            onSelect    = PromptSaveCharacter,
        }
        items[#items + 1] = {
            title       = '📁 My Saved Peds',
            description = 'Browse saved characters by category',
            arrow       = true,
            onSelect    = OpenSavedPedsMenu,
        }
    end

    -- ── Player utilities section (inline, separated by a divider) ─────────────
    if Config.Categories.PlayerUtils then

        -- Divider
        items[#items + 1] = { title = '', disabled = true }

        items[#items + 1] = {
            title       = '❤️ Heal Player',
            description = 'Restore health to full',
            onSelect    = function()
                local ped = PlayerPedId()
                SetEntityHealth(ped, GetEntityMaxHealth(ped))
                notify('success', 'Health fully restored.')
                lib.showContext('appearance_root')
            end,
        }

        items[#items + 1] = {
            title       = '🛡️ Full Armour',
            description = 'Give maximum body armour',
            onSelect    = function()
                SetPedArmour(PlayerPedId(), Config.PlayerUtils.ArmourAmount)
                notify('success', 'Armour set to ' .. Config.PlayerUtils.ArmourAmount .. '.')
                lib.showContext('appearance_root')
            end,
        }

        items[#items + 1] = {
            title       = '⚡ Revive Player',
            description = 'Stand up and restore full health if incapacitated',
            onSelect    = function()
                local ped = PlayerPedId()
                if IsEntityDead(ped) or IsPedDeadOrDying(ped, true) then
                    NetworkResurrectLocalPlayer(
                        GetEntityCoords(ped),
                        GetEntityHeading(ped),
                        true,
                        false
                    )
                end
                SetPedToRagdoll(ped, 0, 0, 0, false, false, false)
                ClearPedTasksImmediately(ped)
                SetEntityHealth(ped, GetEntityMaxHealth(ped))
                notify('success', 'You have been revived.')
                lib.showContext('appearance_root')
            end,
        }

        items[#items + 1] = {
            title       = '🚿 Clean Player',
            description = 'Remove blood, dirt and grime',
            onSelect    = function()
                local ped = PlayerPedId()
                ClearPedBloodDamage(ped)
                ClearPedWetness(ped)
                ClearPedEnvDirt(ped)
                ResetPedVisibleDamage(ped)
                notify('success', 'You have been cleaned up.')
                lib.showContext('appearance_root')
            end,
        }
    end

    lib.registerContext({
        id             = 'appearance_root',
        title          = 'Corey Ped Manager',
        preventClosing = true,
        menu = 'unified_main_menu',
        options        = items,
    })
    ShowContext('appearance_root')
end

-- ─── 1. Spawn Ped Menu — category list ───────────────────────────────────────

function OpenSpawnPedMenu()
    local items = {}

    for _, group in ipairs(Config.SpawnPeds) do
        local groupRef = group
        items[#items + 1] = {
            title       = groupRef.category,
            description = #groupRef.peds .. ' models',
            arrow       = true,
            onSelect    = function()
                OpenSpawnPedCategoryMenu(groupRef)
            end,
        }
    end

    lib.registerContext({
        id             = 'appearance_spawn_ped',
        title          = '🧬 Spawn Ped',
        menu           = 'appearance_root',
        preventClosing = true,
        options        = items,
    })
    ShowContext('appearance_spawn_ped')
end

-- ─── 1b. Spawn Ped — individual model list ────────────────────────────────────

function OpenSpawnPedCategoryMenu(group)
    local items = {}
    -- Safe context id: strip emoji and spaces, lowercase
    local safeId = 'appearance_spawn_cat_' .. group.category:gsub('[^%w]', '_'):lower()

    for _, ped in ipairs(group.peds) do
        local pedRef = ped
        items[#items + 1] = {
            title       = pedRef.label,
            description = 'Model: ' .. pedRef.model,
            onSelect = function()
    _lastContextId = safeId
    ChangePlayerModel(pedRef.model, function(ok)
        if not ok then return end
        notify('success', 'Model changed to ' .. pedRef.label)
        lib.showContext(safeId)
    end)
end,
        }
    end

    lib.registerContext({
        id             = safeId,
        title          = group.category,
        menu           = 'appearance_spawn_ped',
        preventClosing = true,
        options        = items,
    })
    ShowContext(safeId)
end

-- ─── 2. Create MP Ped Menu ───────────────────────────────────────────────────

function OpenCreateMPPedMenu()
    lib.registerContext({
        id             = 'appearance_create_mp',
        title          = '🔥 Create MP Ped',
        menu           = 'appearance_root',
        preventClosing = true,
        options        = {
            {
                title       = '👨 Male Freemode',
                description = 'Start fresh with mp_m_freemode_01',
                onSelect    = function()
                    ChangePlayerModel('mp_m_freemode_01', function(ok)
                        if not ok then return end
                        OpenEditor(function(appearance)
                            if appearance then notify('success', 'Character created!') end
                            lib.showContext('appearance_create_mp')
                        end)
                    end)
                end,
            },
            {
                title       = '👩 Female Freemode',
                description = 'Start fresh with mp_f_freemode_01',
                onSelect    = function()
                    ChangePlayerModel('mp_f_freemode_01', function(ok)
                        if not ok then return end
                        OpenEditor(function(appearance)
                            if appearance then notify('success', 'Character created!') end
                            lib.showContext('appearance_create_mp')
                        end)
                    end)
                end,
            },
        },
    })
    ShowContext('appearance_create_mp')
end

-- ─── 3. Save Current Ped ─────────────────────────────────────────────────────

function PromptSaveCharacter()
    local categoryOptions = {}
    for _, cat in ipairs(Config.PedCategories) do
        categoryOptions[#categoryOptions + 1] = { value = cat.id, label = cat.icon .. ' ' .. cat.label }
    end

    local input = lib.inputDialog('Save Character', {
        {
            type        = 'input',
            label       = 'Character Name',
            placeholder = 'e.g. My Main Character',
            required    = true,
            max         = 32,
        },
        {
            type     = 'select',
            label    = 'Category',
            options  = categoryOptions,
            required = true,
        },
    })

    if not input or not input[1] then return end

    local name      = input[1]
    local category  = input[2] or 'other'
    local modelHash = GetEntityModel(PlayerPedId())
    local modelName = ResolveModelName(modelHash)

    local appearance = GetAppearanceSafe()
    if not appearance then
        notify('error', 'Could not read appearance. Is fivem-appearance running?')
        return
    end

    TriggerServerEvent('appearance_menu:server:saveCharacter', name, modelName, category, json.encode(appearance))
end

-- ─── 4. Saved Peds — category browser ────────────────────────────────────────

function OpenSavedPedsMenu()
    TriggerServerEvent('appearance_menu:server:getSaved')
end

RegisterNetEvent('appearance_menu:client:receiveSaved', function(rows)
    savedCharacters = rows
    local counts = CountByCategory(rows)
    local items = {}

    for _, cat in ipairs(Config.PedCategories) do
        local count = counts[cat.id] or 0
        local catRef = cat
        items[#items + 1] = {
            title       = catRef.icon .. ' ' .. catRef.label .. ' (' .. count .. ')',
            description = 'View peds in this category',
            arrow       = true,
            disabled    = count == 0,
            onSelect    = function()
                OpenCategoryMenu(catRef)
            end,
        }
    end

    lib.registerContext({
        id             = 'appearance_saved',
        title          = '📁 Saved Peds',
        menu           = 'appearance_root',
        preventClosing = true,
        options        = items,
    })
    ShowContext('appearance_saved')
end)

-- ─── 5. Peds within a category ───────────────────────────────────────────────

function OpenCategoryMenu(cat)
    local items = {}
    local found = false

    for _, row in ipairs(savedCharacters) do
        local rowCat = row.category or 'other'
        if rowCat == cat.id then
            found = true
            local ref = row
            items[#items + 1] = {
                title       = '👤 ' .. ref.name,
                description = 'Model: ' .. (ref.model or 'unknown') .. '  |  Saved: ' .. (ref.created_at or ''),
                arrow       = true,
                onSelect    = function()
                    OpenSavedCharacterOptions(ref)
                end,
            }
        end
    end

    if not found then
        items[#items + 1] = {
            title    = 'No saved peds in this category',
            disabled = true,
        }
    end

    lib.registerContext({
        id             = 'appearance_category_' .. cat.id,
        title          = cat.icon .. ' ' .. cat.label,
        menu           = 'appearance_saved',
        preventClosing = true,
        options        = items,
    })
    ShowContext('appearance_category_' .. cat.id)
end

-- ─── 6. Individual character options ─────────────────────────────────────────

function OpenSavedCharacterOptions(char)
    local categoryOptions = {}
    for _, cat in ipairs(Config.PedCategories) do
        categoryOptions[#categoryOptions + 1] = { value = cat.id, label = cat.icon .. ' ' .. cat.label }
    end

    local currentCat = GetCategoryById(char.category or 'other')
    local catContextId = 'appearance_category_' .. currentCat.id

    lib.registerContext({
        id             = 'appearance_saved_char_' .. char.id,
        title          = '👤 ' .. char.name,
        menu           = catContextId,
        preventClosing = true,
        options        = {
            {
                title       = '▶️ Load Character',
                description = 'Apply this appearance',
                onSelect    = function()
                    -- Remember where we are so applyCharacter can reopen here
                    _lastContextId = 'appearance_saved_char_' .. char.id
                    TriggerServerEvent('appearance_menu:server:loadCharacter', char.id)
                end,
            },
            {
                title       = '🔄 Overwrite with Current',
                description = 'Replace saved data with your current look',
                onSelect    = function()
                    local modelHash = GetEntityModel(PlayerPedId())
                    local modelName = ResolveModelName(modelHash)
                    local appearance = GetAppearanceSafe()
                    if not appearance then
                        notify('error', 'Could not read appearance. Is fivem-appearance running?')
                        return
                    end
                    TriggerServerEvent('appearance_menu:server:updateCharacter', char.id, char.name, modelName, char.category or 'other', json.encode(appearance))
                end,
            },
            {
                title       = '✏️ Rename',
                description = "Change this character's display name",
                onSelect    = function()
                    local input = lib.inputDialog('Rename Character', {
                        { type = 'input', label = 'New Name', placeholder = char.name, required = true, max = 32 },
                    })
                    if input and input[1] then
                        TriggerServerEvent('appearance_menu:server:updateCharacter', char.id, input[1], char.model, char.category or 'other', char.appearance_data)
                    end
                end,
            },
            {
                title       = '🗂️ Change Category',
                description = 'Move to a different category',
                onSelect    = function()
                    local input = lib.inputDialog('Change Category', {
                        {
                            type     = 'select',
                            label    = 'Category',
                            options  = categoryOptions,
                            required = true,
                        },
                    })
                    if input and input[1] then
                        TriggerServerEvent('appearance_menu:server:updateCharacter', char.id, char.name, char.model, input[1], char.appearance_data)
                    end
                end,
            },
            {
                title       = '🗑️ Delete',
                description = 'Permanently remove this character',
                onSelect    = function()
                    local confirm = lib.alertDialog({
                        header   = 'Delete Character',
                        content  = ('Are you sure you want to delete **%s**? This cannot be undone.'):format(char.name),
                        centered = true,
                        cancel   = true,
                    })
                    if confirm == 'confirm' then
                        TriggerServerEvent('appearance_menu:server:deleteCharacter', char.id)
                    end
                end,
            },
        },
    })
    ShowContext('appearance_saved_char_' .. char.id)
end