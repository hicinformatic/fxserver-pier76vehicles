-- Spawner un véhicule
function SpawnVehicle(model)
    print("^3[Pier76Menu] Tentative de spawn: " .. model .. "^0")
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Calculer position devant le joueur
    local forwardX = GetEntityForwardX(playerPed)
    local forwardY = GetEntityForwardY(playerPed)
    local spawnCoords = vector3(
        coords.x + forwardX * 5.0,
        coords.y + forwardY * 5.0,
        coords.z
    )
    
    local modelHash = GetHashKey(model)
    print("^3[Pier76Menu] Hash du modèle: " .. modelHash .. "^0")
    
    RequestModel(modelHash)
    
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 5000 do
        Citizen.Wait(10)
        timeout = timeout + 10
    end
    
    if HasModelLoaded(modelHash) then
        print("^2[Pier76Menu] Modèle chargé, création du véhicule^0")
        local vehicle = CreateVehicle(modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
        
        if DoesEntityExist(vehicle) then
            print("^2[Pier76Menu] Véhicule créé avec succès!^0")
            SetPedIntoVehicle(playerPed, vehicle, -1)
            SetEntityAsNoLongerNeeded(vehicle)
        else
            print("^1[Pier76Menu] Erreur: le véhicule n'a pas été créé^0")
        end
        
        SetModelAsNoLongerNeeded(modelHash)
    else
        print("^1[Pier76Menu] Erreur: impossible de charger le modèle " .. model .. "^0")
        print("^1[Pier76Menu] Vérifiez que la ressource du véhicule est démarrée^0")
    end
end

-- Supprimer le véhicule actuel ou le plus proche
function DeleteCurrentVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    -- Si pas dans un véhicule, chercher le plus proche
    if vehicle == 0 then
        local coords = GetEntityCoords(playerPed)
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        print("^3[Pier76Menu] Tentative de suppression du véhicule ID: " .. vehicle .. "^0")
        
        -- Sortir du véhicule si on est dedans
        if IsPedInVehicle(playerPed, vehicle, false) then
            TaskLeaveVehicle(playerPed, vehicle, 0)
            Citizen.Wait(500)
        end
        
        -- Supprimer avec contrôle réseau
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        
        -- Vérifier si supprimé
        if not DoesEntityExist(vehicle) then
            print("^2[Pier76Menu] Véhicule supprimé avec succès^0")
        else
            print("^1[Pier76Menu] Erreur lors de la suppression^0")
        end
    else
        print("^1[Pier76Menu] Aucun véhicule à proximité^0")
    end
end

-- Réparer le véhicule actuel ou le plus proche
function RepairCurrentVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    -- Si pas dans un véhicule, chercher le plus proche
    if vehicle == 0 then
        local coords = GetEntityCoords(playerPed)
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
        print("^2[Pier76Menu] Véhicule réparé^0")
    else
        print("^1[Pier76Menu] Aucun véhicule à proximité^0")
    end
end

-- Callbacks NUI
RegisterNUICallback('spawn', function(data, cb)
    if data.model then
        SpawnVehicle(data.model)
    end
    cb('ok')
end)

RegisterNUICallback('delete', function(data, cb)
    DeleteCurrentVehicle()
    cb('ok')
end)

RegisterNUICallback('repair', function(data, cb)
    RepairCurrentVehicle()
    cb('ok')
end)

-- Commande de test pour spawner directement un véhicule
RegisterCommand('spawnveh', function(source, args)
    if args[1] then
        SpawnVehicle(args[1])
    else
        print("^1Usage: /spawnveh [model]^0")
        print("^3Exemple: /spawnveh peanut^0")
    end
end, false)
