-- client/main.lua
-- Entry point: keybind, model change helper, apply character event

-- ─── Open menu keybind ───────────────────────────────────────────────────────
RegisterKeyMapping('appearance_menu', 'Open Appearance Menu', 'keyboard', Config.MenuKey)

RegisterCommand('appearance_menu', function()
    OpenAppearanceMenu()
end, false)

-- ─── Shared helper: safely change player model ───────────────────────────────
-- Fixes the invisible ped bug by calling SetPedDefaultComponentVariation after
-- model change, which populates drawable slots (without it MP peds are invisible).
function ChangePlayerModel(modelName, cb)
    local hash = GetHashKey(modelName)

    if not IsModelInCdimage(hash) or not IsModelValid(hash) then
        lib.notify({ title = 'Corey Ped Manager', description = 'Invalid model: ' .. modelName, type = 'error' })
        if cb then cb(false) end
        return
    end

    local loaded = lib.requestModel(modelName, 10000)
    if not loaded then
        lib.notify({ title = 'Corey Ped Manager', description = 'Model timed out: ' .. modelName, type = 'error' })
        if cb then cb(false) end
        return
    end

    SetPlayerModel(PlayerId(), hash)
    SetModelAsNoLongerNeeded(hash)
    SetPedDefaultComponentVariation(PlayerPedId()) -- prevents invisible ped
    SetPedHeadBlendData(PlayerPedId(), 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.0, false) -- initialises head blend so hair colour works
    Wait(0)
    Wait(0) -- two frames for engine to finish building the ped

    if cb then cb(true) end
end

-- ─── Helper: change model then open fivem-appearance editor ─────────────────
function SetPlayerModelAndCustomize(modelName)
    ChangePlayerModel(modelName, function(ok)
        if not ok then return end
        -- Use the same safe wrapper defined in menu.lua
        OpenEditor(function(appearance)
            if appearance then
                lib.notify({ title = 'Corey Ped Manager', description = 'Character created!', type = 'success' })
            end
        end)
    end)
end

-- ─── Apply character received from server ────────────────────────────────────
RegisterNetEvent('appearance_menu:client:applyCharacter', function(row)
    if not row or not row.appearance_data then
        lib.notify({ title = 'Corey Ped Manager', description = 'Failed to load character data.', type = 'error' })
        return
    end

    local appearance = json.decode(row.appearance_data)
    if not appearance then
        lib.notify({ title = 'Corey Ped Manager', description = 'Corrupt appearance data.', type = 'error' })
        return
    end

    local currentHash = GetEntityModel(PlayerPedId())
    local targetHash  = GetHashKey(row.model)

    local function doApply()
        -- Use the safe wrapper from menu.lua
        if not SetAppearance(appearance) then
            lib.notify({ title = 'Corey Ped Manager', description = 'Failed to apply appearance.', type = 'error' })
            return
        end
        lib.notify({ title = 'Corey Ped Manager', description = ('Loaded: %s'):format(row.name), type = 'success' })
        -- Reopen the character options menu now that everything has settled
        ReopenLastMenu()
    end

    if currentHash ~= targetHash then
        ChangePlayerModel(row.model, function(ok)
            if ok then doApply() end
        end)
    else
        doApply()
    end
end)

-- ─── Notification relay ───────────────────────────────────────────────────────
RegisterNetEvent('appearance_menu:client:notify', function(ntype, msg)
    lib.notify({ title = 'Appearance Menu', description = msg, type = ntype })
end)