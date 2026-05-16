-- Main Unified Context Menu
function OpenEbuMenu()
    lib.registerContext({
        id = 'ebu_main_menu',
        title = 'Corey Flagger Menu',
        options = {
            {
                title = 'Setup Single Flagger',
                description = 'Sets up a flagger to run on its own',
                icon = 'fa-solid fa-user',
                iconColor = '#dddddd',
                onSelect = function()
                    ExecuteCommand('snglfl')
                    OpenEbuMenu()
                end
            },
            {
                title = 'Pair Flaggers',
                description = 'Starts the pairing process & Pairs with a second trailer if started pairing',
                icon = 'fa-solid fa-user',
                iconColor = '#0f48e4',
                onSelect = function()
                    ExecuteCommand('pairfl')
                    OpenEbuMenu()
                end
            },
            {
                title = 'Run Flagger',
                description = 'Start the flagger/s or Pause them',
                icon = 'fa-solid fa-user',
                iconColor = '#27d821',
                onSelect = function()
                    ExecuteCommand('runfl')
                    OpenEbuMenu()
                end
            },
            {
                title = 'Stop Flagger',
                description = 'Stop the flagger and can be used on a single flagger or on the First flagger in a pair',
                icon = 'fa-solid fa-user',
                iconColor = '#db2626',
                onSelect = function()
                    ExecuteCommand('stopfl')
                    OpenEbuMenu()
                end
            },
            {
                title = 'Flagger Config',
                description = 'Displays the flagger state, timer, etc on a single flagger or on the First flagger in a pair',
                icon = 'fa-solid fa-user',
                iconColor = '#3498db',
                onSelect = function()
                    ExecuteCommand('getflcfg')
                    OpenEbuMenu()
                end
            },
            {
                title = 'Set Flagger Timer',
                description = 'Set the flagger timer value',
                icon = 'fa-solid fa-clock',
                iconColor = '#e67e22',
                onSelect = function()
                    local input = lib.inputDialog('Set Flagger Timer', {
                        {
                            type = 'number',
                            label = 'Timer Value',
                            description = 'Enter the timer value (in seconds)',
                            required = true,
                            min = 1,
                        }
                    })
                    if input and input[1] then
                        ExecuteCommand('fltimer ' .. tostring(input[1]))
                    end
                    OpenEbuMenu()
                end
            },
            {
                title = 'Set Flagger Delay',
                description = 'Set the flagger delay value',
                icon = 'fa-solid fa-hourglass-half',
                iconColor = '#e67e22',
                onSelect = function()
                    local input = lib.inputDialog('Set Flagger Delay', {
                        {
                            type = 'number',
                            label = 'Delay Value',
                            description = 'Enter the delay value (in seconds)',
                            required = true,
                            min = 1,
                        }
                    })
                    if input and input[1] then
                        ExecuteCommand('fldelay ' .. tostring(input[1]))
                    end
                    OpenEbuMenu()
                end
            },
        }
    })

    lib.showContext('ebu_main_menu')
end

-- Register command to open unified menu
RegisterCommand('flagger', function()
    OpenEbuMenu()
end, false)