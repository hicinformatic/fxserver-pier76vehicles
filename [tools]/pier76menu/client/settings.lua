-- Charger les réglages du véhicule actuel
RegisterNUICallback('loadSettings', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        SendNUIMessage({
            action = "updateSettings",
            settings = {}
        })
        cb('ok')
        return
    end
    
    -- Créer un véhicule temporaire pour récupérer les valeurs par défaut
    local model = GetEntityModel(vehicle)
    local tempVehicle = CreateVehicle(model, 0.0, 0.0, -200.0, 0.0, false, false)
    
    -- Fonction helper pour récupérer une valeur (sauvegardée ou actuelle)
    local function getHandlingValue(key, index, baseKey)
        local saved = GetSavedHandlingValue(vehicle, key)
        if saved then
            return saved
        end
        if index ~= nil then
            return GetVehicleHandlingFloat(vehicle, "CHandlingData", baseKey or key, index)
        else
            return GetVehicleHandlingFloat(vehicle, "CHandlingData", key)
        end
    end
    
    -- Fonction pour récupérer la valeur par défaut
    local function getDefaultValue(key, index)
        if index then
            return GetVehicleHandlingFloat(tempVehicle, "CHandlingData", key, index)
        else
            return GetVehicleHandlingFloat(tempVehicle, "CHandlingData", key)
        end
    end
    
    -- Liste complète des paramètres de handling GTA V
    -- Note: FiveM ne permet pas de les énumérer dynamiquement, donc on liste tous ceux connus
    local handlingParams = {
        "fMass", "fInitialDragCoeff", "fPercentSubmerged", "vecCentreOfMassOffset",
        "vecInertiaMultiplier", "fDriveBiasFront", "nInitialDriveGears", "fInitialDriveForce",
        "fDriveInertia", "fClutchChangeRateScaleUpShift", "fClutchChangeRateScaleDownShift",
        "fInitialDriveMaxFlatVel", "fBrakeForce", "fBrakeBiasFront", "fHandBrakeForce",
        "fSteeringLock", "fTractionCurveMax", "fTractionCurveMin", "fTractionCurveLateral",
        "fTractionSpringDeltaMax", "fLowSpeedTractionLossMult", "fCamberStiffnesss",
        "fTractionBiasFront", "fTractionLossMult", "fSuspensionForce", "fSuspensionCompDamp",
        "fSuspensionReboundDamp", "fSuspensionUpperLimit", "fSuspensionLowerLimit",
        "fSuspensionRaise", "fSuspensionBiasFront", "fAntiRollBarForce", "fAntiRollBarBiasFront",
        "fRollCentreHeightFront", "fRollCentreHeightRear", "fCollisionDamageMult",
        "fWeaponDamageMult", "fDeformationDamageMult", "fEngineDamageMult", "fPetrolTankVolume",
        "fOilVolume", "fSeatOffsetDistX", "fSeatOffsetDistY", "fSeatOffsetDistZ",
        "nMonetaryValue"
    }
    
    -- Parcourir tous les paramètres
    local settings = {}
    for _, param in ipairs(handlingParams) do
        -- Gérer les vecteurs spéciaux
        if param == "vecCentreOfMassOffset" or param == "vecInertiaMultiplier" then
            for i = 0, 2 do
                local axis = i == 0 and "X" or (i == 1 and "Y" or "Z")
                local key = param .. "_" .. axis
                local value = getHandlingValue(key, i, param)
                local default = getDefaultValue(param, i)
                if value then
                    table.insert(settings, {
                        tag = key,
                        value = value,
                        default = default,
                        isNumber = true
                    })
                end
            end
        else
            local value = getHandlingValue(param)
            local default = getDefaultValue(param)
            if value then
                table.insert(settings, {
                    tag = param,
                    value = value,
                    default = default,
                    isNumber = true
                })
            end
        end
    end
    
    -- Supprimer le véhicule temporaire
    DeleteVehicle(tempVehicle)
    
    SendNUIMessage({
        action = "updateSettings",
        settings = settings
    })
    cb('ok')
end)

-- Appliquer un réglage
RegisterNUICallback('applySetting', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        local value = tonumber(data.value)
        local tag = data.type
        
        print("^3[Pier76Menu] Application: " .. tag .. " = " .. value .. "^0")
        
        -- Sauvegarder la valeur
        SaveHandlingValue(vehicle, tag, value)
        
        -- Gérer les vecteurs (vecCentreOfMassOffset et vecInertiaMultiplier)
        if tag:match("^vecCentreOfMassOffset_") then
            local x = GetSavedHandlingValue(vehicle, "vecCentreOfMassOffset_X") or GetVehicleHandlingFloat(vehicle, "CHandlingData", "vecCentreOfMassOffset", 0)
            local y = GetSavedHandlingValue(vehicle, "vecCentreOfMassOffset_Y") or GetVehicleHandlingFloat(vehicle, "CHandlingData", "vecCentreOfMassOffset", 1)
            local z = GetSavedHandlingValue(vehicle, "vecCentreOfMassOffset_Z") or GetVehicleHandlingFloat(vehicle, "CHandlingData", "vecCentreOfMassOffset", 2)
            
            if tag == "vecCentreOfMassOffset_X" then x = value
            elseif tag == "vecCentreOfMassOffset_Y" then y = value
            elseif tag == "vecCentreOfMassOffset_Z" then z = value
            end
            
            SetVehicleHandlingVector(vehicle, "CHandlingData", "vecCentreOfMassOffset", vector3(x, y, z))
            SetVehicleHandlingVector(vehicle, "CHandlingData", "vecCentreOfMassOffset", vector3(x, y, z))
            
        elseif tag:match("^vecInertiaMultiplier_") then
            local x = GetSavedHandlingValue(vehicle, "vecInertiaMultiplier_X") or GetVehicleHandlingFloat(vehicle, "CHandlingData", "vecInertiaMultiplier", 0)
            local y = GetSavedHandlingValue(vehicle, "vecInertiaMultiplier_Y") or GetVehicleHandlingFloat(vehicle, "CHandlingData", "vecInertiaMultiplier", 1)
            local z = GetSavedHandlingValue(vehicle, "vecInertiaMultiplier_Z") or GetVehicleHandlingFloat(vehicle, "CHandlingData", "vecInertiaMultiplier", 2)
            
            if tag == "vecInertiaMultiplier_X" then x = value
            elseif tag == "vecInertiaMultiplier_Y" then y = value
            elseif tag == "vecInertiaMultiplier_Z" then z = value
            end
            
            SetVehicleHandlingVector(vehicle, "CHandlingData", "vecInertiaMultiplier", vector3(x, y, z))
            SetVehicleHandlingVector(vehicle, "CHandlingData", "vecInertiaMultiplier", vector3(x, y, z))
        else
            -- Pour les autres valeurs simples
            SetVehicleHandlingFloat(vehicle, "CHandlingData", tag, value)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", tag, value)
        end
        
        print("^2[Pier76Menu] Appliqué avec succès^0")
    end
    cb('ok')
end)

-- Réinitialiser le handling aux valeurs par défaut
RegisterNUICallback('resetHandling', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        print("^3[Pier76Menu] Réinitialisation du handling...^0")
        
        -- Supprimer les valeurs sauvegardées
        local plate = GetVehicleNumberPlateText(vehicle)
        vehicleHandling[plate] = nil
        
        -- Récupérer les coordonnées et l'orientation actuelles
        local coords = GetEntityCoords(vehicle)
        local heading = GetEntityHeading(vehicle)
        local model = GetEntityModel(vehicle)
        
        -- Supprimer et recréer le véhicule pour réinitialiser le handling
        DeleteVehicle(vehicle)
        
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(10)
        end
        
        local newVehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
        SetPedIntoVehicle(playerPed, newVehicle, -1)
        SetModelAsNoLongerNeeded(model)
        
        print("^2[Pier76Menu] Handling réinitialisé par défaut^0")
        
        -- Recharger le menu après un court délai
        Citizen.Wait(500)
        SendNUIMessage({
            action = "reloadSettings"
        })
    end
    
    cb('ok')
end)
