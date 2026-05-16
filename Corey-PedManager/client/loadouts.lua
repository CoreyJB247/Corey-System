-- client/loadouts.lua
-- Applies emergency / pre-set appearance loadouts via fivem-appearance exports

---Apply a preset loadout by name
---@param preset string Preset key from Config.EmergencyLoadouts
function ApplyEmergencyLoadout(loadout)
    if not loadout then return end

    -- Change ped model first if needed
    local currentModel = GetEntityModel(PlayerPedId())
    local targetModel = GetHashKey(loadout.model)

    local function applyAppearance()
        -- If the preset field is a string, attempt to load from a stored appearance JSON
        -- In production you'd store actual fivem-appearance data objects here
        -- For now we trigger the fivem-appearance editor so the player can customise
        -- after the uniform is applied, or you can pass a full data table.
        if loadout.appearance and loadout.appearance.data then
            -- Full data object provided – apply directly
            exports['fivem-appearance']:setPlayerAppearance(loadout.appearance.data)
            lib.notify({ title = 'Appearance', description = 'Loadout applied: ' .. loadout.label, type = 'success' })
        else
            -- No raw data – open editor so player can finish customising
            lib.notify({ title = 'Appearance', description = 'Opening editor for: ' .. loadout.label, type = 'inform' })
            exports['fivem-appearance']:startPlayerCustomization(function(appearance)
                if appearance then
                    lib.notify({ title = 'Appearance', description = 'Uniform set!', type = 'success' })
                end
            end)
        end
    end

    if currentModel ~= targetModel then
        -- Validate before requesting
        if not IsModelInCdimage(targetModel) or not IsModelValid(targetModel) then
            lib.notify({ title = 'Appearance', description = 'Invalid model: ' .. loadout.model, type = 'error' })
            return
        end
        local loaded = lib.requestModel(loadout.model, 10000)
        if not loaded then
            lib.notify({ title = 'Appearance', description = 'Model failed to load.', type = 'error' })
            return
        end
        SetPlayerModel(PlayerId(), targetModel)
        SetModelAsNoLongerNeeded(targetModel)
        Wait(500)
        applyAppearance()
    else
        applyAppearance()
    end
end

---Spawn a non-MP ped model (replaces player model temporarily)
---@param model string Ped model name (must be exact GTA V internal name)
function SpawnPedModel(model)
    local hash = GetHashKey(model)

    -- Validate the model exists in the game before requesting
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then
        lib.notify({ title = 'Ped Spawner', description = 'Invalid model: ' .. model, type = 'error' })
        return
    end

    -- lib.requestModel returns false if it times out
    local loaded = lib.requestModel(model, 10000)
    if not loaded then
        lib.notify({ title = 'Ped Spawner', description = 'Model failed to load: ' .. model, type = 'error' })
        return
    end

    SetPlayerModel(PlayerId(), hash)
    SetModelAsNoLongerNeeded(hash)
    lib.notify({ title = 'Ped Spawner', description = 'Model changed to ' .. model, type = 'success' })
end
