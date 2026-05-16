--------------------------------------------------------
-- Blip Save Handler (server-side)
-- Place this file in your resource and add it to
-- fxmanifest.lua under server_scripts
--
-- When a blip is added in-game it is appended to
-- blips_pending.txt — copy the entries from there
-- into Config.TheBlips in config.lua when ready.
--------------------------------------------------------

RegisterNetEvent("smallresources:saveBlip", function(name, sprite, colour, x, y, z)
    local src = source

    -- Permission check
    if not IsPlayerAceAllowed(src, "smallresources.addblip") then
        print(string.format("[smallresources] Player %d tried to add a blip but lacks permission.", src))
        TriggerClientEvent("smallresources:blipDenied", src)
        return
    end

    -- Basic server-side validation
    if type(name) ~= "string" or name == "" then return end
    if type(sprite) ~= "number" or sprite < 1 or sprite > 826 then return end
    if type(colour) ~= "number" or colour < 0 or colour > 85 then return end
    if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then return end

    -- Round coords to 2 decimal places
    x = math.floor(x * 100 + 0.5) / 100
    y = math.floor(y * 100 + 0.5) / 100
    z = math.floor(z * 100 + 0.5) / 100

    -- Build the config-ready line
    local playerName = GetPlayerName(src) or "Unknown"
    local entry = string.format(
        '    { title = "%s", colour = %d, id = %d, vector3 = vec3(%s, %s, %s) }, -- Added by %s\n',
        name, colour, sprite, tostring(x), tostring(y), tostring(z), playerName
    )

    -- Read existing file contents (if any) so we can append
    local existing = LoadResourceFile(GetCurrentResourceName(), "blips_pending.txt") or ""
    local newContent = existing .. entry

    local success = SaveResourceFile(GetCurrentResourceName(), "blips_pending.txt", newContent, -1)

    if not success then
        print("[smallresources] ERROR: Could not write to blips_pending.txt")
        return
    end

    print(string.format("[smallresources] Blip '%s' by %s saved to blips_pending.txt", name, playerName))

    -- Confirm back to client so it draws the blip and shows success
    TriggerClientEvent("smallresources:blipSaved", src, name, sprite, colour, x, y, z)
end)