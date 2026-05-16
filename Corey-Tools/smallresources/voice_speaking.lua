local talkingPlayers = {}

function UpdateTalkingPlayers()
    local localPlayer = PlayerId()
    local localPlayerTalking = NetworkIsPlayerTalking(localPlayer)

    talkingPlayers = {}

    for _, player in ipairs(GetActivePlayers()) do
        local isTalking = NetworkIsPlayerTalking(player)
        if isTalking then
            if player ~= localPlayer then
                table.insert(talkingPlayers, GetPlayerName(player))
            end
        end
    end

    if localPlayerTalking then
        table.insert(talkingPlayers, GetPlayerName(localPlayer))
    end
end

function DisplayTalkingPlayers()
    if #talkingPlayers > 0 then
        local currentlyTalkingText = "Currently Talking:"
        SetTextScale(0.5, 0.5)
        SetTextColour(255, 255, 0, 255)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(false) -- Disabled centering for left alignment
        SetTextDropshadow(6, 0, 0, 0, 255)
        SetTextEdge(6, 0, 0, 0, 255)

        SetTextEntry("STRING")
        AddTextComponentString(currentlyTalkingText)
        DrawText(0.01, 0.45) -- X=0.01 (left edge), Y=0.45 (vertical center)

        local text = table.concat(talkingPlayers, "\n")
        SetTextScale(0.5, 0.5)
        SetTextColour(255, 255, 255, 255)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(false) -- Disabled centering for left alignment
        SetTextDropshadow(6, 0, 0, 0, 255)
        SetTextEdge(6, 0, 0, 0, 255)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(0.01, 0.48) -- X=0.01 (left edge), Y=0.50 (just below header)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        UpdateTalkingPlayers()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DisplayTalkingPlayers()
    end
end)