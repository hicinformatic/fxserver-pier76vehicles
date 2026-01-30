local menuOpen = false
local cameraFree = false
vehicleHandling = {}

-- Ouvrir/Fermer le menu
function ToggleMenu()
    menuOpen = not menuOpen
    cameraFree = false
    print("^2[Pier76Menu] Menu état: " .. tostring(menuOpen) .. "^0")
    SetNuiFocus(menuOpen, menuOpen)
    SendNUIMessage({
        action = "toggle",
        show = menuOpen,
        vehicles = Config.Vehicles
    })
end

-- Basculer le mode caméra (pour Modkit)
function ToggleCamera()
    if not menuOpen then return end
    
    cameraFree = not cameraFree
    print("^2[Pier76Menu] Mode caméra libre: " .. tostring(cameraFree) .. "^0")
    
    if cameraFree then
        -- Désactiver le curseur, activer la caméra
        SetNuiFocus(true, false)
        SendNUIMessage({
            action = "cameraMode",
            enabled = true
        })
    else
        -- Réactiver le curseur
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "cameraMode",
            enabled = false
        })
    end
end

-- Sauvegarder les valeurs de handling pour un véhicule
function SaveHandlingValue(vehicle, key, value)
    local plate = GetVehicleNumberPlateText(vehicle)
    if not vehicleHandling[plate] then
        vehicleHandling[plate] = {}
    end
    vehicleHandling[plate][key] = value
end

-- Récupérer une valeur de handling sauvegardée
function GetSavedHandlingValue(vehicle, key)
    local plate = GetVehicleNumberPlateText(vehicle)
    if vehicleHandling[plate] and vehicleHandling[plate][key] then
        return vehicleHandling[plate][key]
    end
    return nil
end

-- Commande pour ouvrir le menu
RegisterCommand('pier76menu', function()
    ToggleMenu()
end, false)

-- Callback pour basculer le mode caméra depuis le NUI
RegisterNUICallback('toggleCamera', function(data, cb)
    cameraFree = data.enabled
    print("^2[Pier76Menu] Mode caméra: " .. tostring(cameraFree) .. "^0")
    
    if cameraFree then
        -- Désactiver le curseur, activer la caméra
        SetNuiFocus(true, false)
    else
        -- Réactiver le curseur
        SetNuiFocus(true, true)
    end
    
    cb('ok')
end)

-- Écouter les messages de l'interface
RegisterNUICallback('close', function(data, cb)
    print("^3[Pier76Menu] Callback 'close' reçu^0")
    cameraFree = false
    ToggleMenu()
    cb('ok')
end)
