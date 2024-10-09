RegisterServerEvent('syncIndicators')
AddEventHandler('syncIndicators', function(plate, indicator, state)
    TriggerClientEvent('updateIndicators', -1, plate, indicator, state)
end)

RegisterServerEvent('syncHazardLights')
AddEventHandler('syncHazardLights', function(plate, state)
    TriggerClientEvent('updateHazardLights', -1, plate, state)
end)
