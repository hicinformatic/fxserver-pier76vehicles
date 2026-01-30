-- Détecter les portes/éléments disponibles sur le véhicule
function GetAvailableDoors(vehicle)
    local doors = {}
    
    -- Toujours afficher capot et coffre
    table.insert(doors, {index = 4, label = "Capot"})
    table.insert(doors, {index = 5, label = "Coffre"})
    
    -- Détecter le nombre de portes (basé sur le nombre de sièges)
    local maxSeats = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))
    
    if maxSeats >= 2 then
        -- Portes avant
        table.insert(doors, {index = 0, label = "Porte AV Gauche"})
        table.insert(doors, {index = 1, label = "Porte AV Droite"})
    end
    
    if maxSeats >= 4 then
        -- Portes arrière
        table.insert(doors, {index = 2, label = "Porte AR Gauche"})
        table.insert(doors, {index = 3, label = "Porte AR Droite"})
    end
    
    return doors
end

-- Toggle une porte
RegisterNUICallback('toggleDoor', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        local doorIndex = tonumber(data.index)
        local doorAngle = GetVehicleDoorAngleRatio(vehicle, doorIndex)
        
        if doorAngle > 0.0 then
            SetVehicleDoorShut(vehicle, doorIndex, false)
            print("^2[Pier76Menu] Porte " .. doorIndex .. " fermée^0")
        else
            SetVehicleDoorOpen(vehicle, doorIndex, false, false)
            print("^2[Pier76Menu] Porte " .. doorIndex .. " ouverte^0")
        end
    end
    
    cb('ok')
end)

-- Fermer toutes les portes
RegisterNUICallback('closeAllDoors', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        for i = 0, 5 do
            SetVehicleDoorShut(vehicle, i, false)
        end
        print("^2[Pier76Menu] Toutes les portes fermées^0")
    end
    
    cb('ok')
end)
