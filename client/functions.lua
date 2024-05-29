local QBCore = exports['qb-core']:GetCoreObject()

Hud = {}
Hud.Round = function(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

Hud.Start = function(hudUpdate, cb)
    CreateThread(function()
        local status = {}
        local statusLabels = { 'hunger', 'thirst' }
        hudUpdate = hudUpdate or true
        
        while (hudUpdate) do 
            for _, v in pairs(statusLabels) do
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    local hunger = QBCore.Functions.GetPlayerData().metadata["hunger"]
                    local thirst = QBCore.Functions.GetPlayerData().metadata["thirst"]
                    
                    if v == 'hunger' then
                        status[v] = Hud.Round(hunger / 100)
                    elseif v == 'thirst' then
                        status[v] = Hud.Round(thirst / 100)
                    end
                end)
            end
            
            status['health'] = Hud.Round(GetEntityHealth(PlayerPedId()) - 100)
            status['shield'] = Hud.Round(GetPedArmour(PlayerPedId()))
            
            SendNUIMessage({
                type = 'updateHud',
                map = IsPauseMenuActive() == 1,
                radar = IsRadarEnabled() == 1,
                status = status
            })
            
            DisplayRadar(IsPedInAnyVehicle(PlayerPedId()))
            Wait(1000)
        end
    end)
    
    if (cb) then
        cb()
    end
end

Hud.Stop = function()
    return Hud.Start(false, function()
        SendNUIMessage({
            type = 'updateHud',
            map = false,
            radar = false,
            status = {}
        })
    end)
end
