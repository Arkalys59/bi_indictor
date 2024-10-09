local leftIndicator = false
local rightIndicator = false
local hazardLights = false


local clignotantGauche = Config.Keys.Left or 174  
local clignotantDroit = Config.Keys.Right or 175  
local feuxDetresse = Config.Keys.Hazard or 172   
local keepEngineOnKey = Config.Keys.KeepEngineOn or 173 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)

            if IsControlJustPressed(1, clignotantGauche) then
                leftIndicator = not leftIndicator
                TriggerServerEvent('syncIndicators', GetVehicleNumberPlateText(vehicle), 1, leftIndicator)
                if rightIndicator then
                    rightIndicator = false
                    TriggerServerEvent('syncIndicators', GetVehicleNumberPlateText(vehicle), 0, false)
                end
            end

            if IsControlJustPressed(1, clignotantDroit) then
                rightIndicator = not rightIndicator
                TriggerServerEvent('syncIndicators', GetVehicleNumberPlateText(vehicle), 0, rightIndicator)
                if leftIndicator then
                    leftIndicator = false
                    TriggerServerEvent('syncIndicators', GetVehicleNumberPlateText(vehicle), 1, false)
                end
            end

            if IsControlJustPressed(1, feuxDetresse) then
                hazardLights = not hazardLights
                TriggerServerEvent('syncHazardLights', GetVehicleNumberPlateText(vehicle), hazardLights)
            end

            if IsControlJustPressed(1, keepEngineOnKey) then
                SetVehicleEngineOn(vehicle, true, true, false)
                TaskLeaveVehicle(ped, vehicle, 0)
                Citizen.Wait(1000)
                SetVehicleEngineOn(vehicle, true, true, false)
            end
        end
    end
end)

RegisterNetEvent('updateIndicators')
AddEventHandler('updateIndicators', function(plate, indicator, state)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if GetVehicleNumberPlateText(vehicle) == plate then
        SetVehicleIndicatorLights(vehicle, indicator, state)
    end
end)

RegisterNetEvent('updateHazardLights')
AddEventHandler('updateHazardLights', function(plate, state)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if GetVehicleNumberPlateText(vehicle) == plate then
        SetVehicleIndicatorLights(vehicle, 0, state) 
        SetVehicleIndicatorLights(vehicle, 1, state) 
    end
end)
