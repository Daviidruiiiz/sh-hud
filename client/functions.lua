local QBCore = exports['qb-core']:GetCoreObject()

Hud = {}

Hud.Round = function(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

Hud.status = {}  -- Initialize status here to make it globally accessible

Hud.Start = function(hudUpdate, cb)
    -- Ensure hudUpdate is true if not explicitly set to false
    hudUpdate = hudUpdate ~= false

    CreateThread(function()
        local statusLabels = { 'hunger', 'thirst' }

        while hudUpdate do
            for _, v in pairs(statusLabels) do
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData and PlayerData.metadata then
                        local hunger = PlayerData.metadata["hunger"]
                        local thirst = PlayerData.metadata["thirst"]

                        if v == 'hunger' then
                            Hud.status[v] = Hud.Round(hunger / 100)
                        elseif v == 'thirst' then
                            Hud.status[v] = Hud.Round(thirst / 100)
                        end
                    else
                        print("Error: PlayerData or PlayerData.metadata is nil")
                    end
                end)
            end
            Hud.status['health'] = Hud.Round(GetEntityHealth(PlayerPedId()) - 100)
            Hud.status['shield'] = Hud.Round(GetPedArmour(PlayerPedId()))

            SendNUIMessage({
                type = 'updateHud',
                map = IsPauseMenuActive() == 1,
                radar = IsRadarEnabled() == 1,
                status = Hud.status
            })

            DisplayRadar(IsPedInAnyVehicle(PlayerPedId()))
            Wait(1000)
        end
    end)

    if cb then
        cb()
    end
end

Hud.Stop = function()
    -- This will stop the loop in Hud.Start by setting hudUpdate to false
    Hud.Start(false, function()
        SendNUIMessage({
            type = 'updateHud',
            map = false,
            radar = false,
            status = {}
        })
    end)
end

-- Ensure you call Hud.Start before trying to print status values
Hud.Start(true, function()
    -- After the HUD starts, you can print the values
    Wait(2000)  -- Wait for a couple of seconds to let the thread run and fetch values
    print("Hunger:", Hud.status['hunger'], "Thirst:", Hud.status['thirst'])
    print("Health:", Hud.status['health'], "Shield:", Hud.status['shield'])
end)
