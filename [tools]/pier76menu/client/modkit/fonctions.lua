-- Variables pour l'état des lumières
brakeLightOn = false
currentVehicleWithLights = 0

-- Variable pour le klaxon
hornActive = false

-- Variables pour les clignotants
indicatorState = {
    left = false,
    right = false,
    both = false
}

-- Thread pour maintenir les feux allumés
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if currentVehicleWithLights ~= 0 and DoesEntityExist(currentVehicleWithLights) then
            if brakeLightOn then
                SetVehicleBrakeLights(currentVehicleWithLights, true)
            end
        end
    end
end)

-- Thread pour gérer le klaxon en continu (simule l'appui sur E)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if hornActive then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= 0 then
                -- Simuler l'appui continu sur la touche klaxon (E)
                SetControlNormal(0, 86, 1.0) -- INPUT_VEH_HORN
            else
                hornActive = false
            end
        else
            Citizen.Wait(100)
        end
    end
end)

-- Envoyer l'état du véhicule au NUI
function SendVehicleState(vehicle)
    if vehicle == 0 then return end
    
    local engineOn = GetIsVehicleEngineRunning(vehicle)
    local _, lightsOn = GetVehicleLightsState(vehicle)
    
    SendNUIMessage({
        action = "updateVehicleState",
        state = {
            engine = engineOn,
            lights = (lightsOn == 1),
            brakeLight = brakeLightOn,
            indicatorLeft = indicatorState.left,
            indicatorRight = indicatorState.right,
            indicatorBoth = indicatorState.both,
            horn = hornActive
        }
    })
end

-- Toggle moteur
RegisterNUICallback('toggleEngine', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        local engineOn = GetIsVehicleEngineRunning(vehicle)
        local newEngineState = not engineOn
        SetVehicleEngineOn(vehicle, newEngineState, false, true)
        print("^2[Pier76Menu] Moteur: " .. (newEngineState and "ON" or "OFF") .. "^0")
        
        -- Envoyer l'état directement
        local _, lightsOn = GetVehicleLightsState(vehicle)
        SendNUIMessage({
            action = "updateVehicleState",
            state = {
                engine = newEngineState,
                lights = (lightsOn == 1),
                brakeLight = brakeLightOn,
                indicatorLeft = indicatorState.left,
                indicatorRight = indicatorState.right,
                indicatorBoth = indicatorState.both,
                horn = hornActive
            }
        })
    end
    
    cb('ok')
end)

-- Toggle lumières
RegisterNUICallback('toggleLights', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        local _, lightsOn = GetVehicleLightsState(vehicle)
        
        if lightsOn == 1 then
            SetVehicleLights(vehicle, 0) -- Éteindre (mode normal/auto)
            print("^2[Pier76Menu] Lumières: OFF^0")
        else
            SetVehicleLights(vehicle, 2) -- Allumer (forcer ON)
            print("^2[Pier76Menu] Lumières: ON^0")
        end
        
        Citizen.Wait(50)
        SendVehicleState(vehicle)
    end
    
    cb('ok')
end)

-- Toggle feux de stop
RegisterNUICallback('toggleBrakeLight', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        brakeLightOn = not brakeLightOn
        currentVehicleWithLights = brakeLightOn and vehicle or 0
        
        if not brakeLightOn then
            SetVehicleBrakeLights(vehicle, false)
        end
        
        print("^2[Pier76Menu] Feux de stop: " .. (brakeLightOn and "ON" or "OFF") .. "^0")
        
        SendNUIMessage({
            action = "updateVehicleState",
            state = {
                engine = GetIsVehicleEngineRunning(vehicle),
                lights = select(2, GetVehicleLightsState(vehicle)) == 1,
                brakeLight = brakeLightOn,
                indicatorLeft = indicatorState.left,
                indicatorRight = indicatorState.right,
                indicatorBoth = indicatorState.both,
                horn = hornActive
            }
        })
    end
    
    cb('ok')
end)

-- Toggle clignotants
RegisterNUICallback('toggleIndicator', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        if data.type == 'left' then
            indicatorState.left = not indicatorState.left
            indicatorState.right = false
            indicatorState.both = false
            SetVehicleIndicatorLights(vehicle, 1, indicatorState.left)
            SetVehicleIndicatorLights(vehicle, 0, false)
            print("^2[Pier76Menu] Clignotant gauche: " .. (indicatorState.left and "ON" or "OFF") .. "^0")
        elseif data.type == 'right' then
            indicatorState.right = not indicatorState.right
            indicatorState.left = false
            indicatorState.both = false
            SetVehicleIndicatorLights(vehicle, 0, indicatorState.right)
            SetVehicleIndicatorLights(vehicle, 1, false)
            print("^2[Pier76Menu] Clignotant droit: " .. (indicatorState.right and "ON" or "OFF") .. "^0")
        elseif data.type == 'both' then
            indicatorState.both = not indicatorState.both
            indicatorState.left = false
            indicatorState.right = false
            SetVehicleIndicatorLights(vehicle, 0, indicatorState.both)
            SetVehicleIndicatorLights(vehicle, 1, indicatorState.both)
            print("^2[Pier76Menu] Warning: " .. (indicatorState.both and "ON" or "OFF") .. "^0")
        end
        
        SendNUIMessage({
            action = "updateVehicleState",
            state = {
                engine = GetIsVehicleEngineRunning(vehicle),
                lights = select(2, GetVehicleLightsState(vehicle)) == 1,
                brakeLight = brakeLightOn,
                indicatorLeft = indicatorState.left,
                indicatorRight = indicatorState.right,
                indicatorBoth = indicatorState.both,
                horn = hornActive
            }
        })
    end
    
    cb('ok')
end)

-- Toggle klaxon
RegisterNUICallback('toggleHorn', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        hornActive = not hornActive
        
        print("^2[Pier76Menu] Klaxon: " .. (hornActive and "ON" or "OFF") .. "^0")
        
        SendNUIMessage({
            action = "updateVehicleState",
            state = {
                engine = GetIsVehicleEngineRunning(vehicle),
                lights = select(2, GetVehicleLightsState(vehicle)) == 1,
                brakeLight = brakeLightOn,
                indicatorLeft = indicatorState.left,
                indicatorRight = indicatorState.right,
                indicatorBoth = indicatorState.both,
                horn = hornActive
            }
        })
    end
    
    cb('ok')
end)
