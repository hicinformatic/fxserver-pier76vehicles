-- Charger les mods du véhicule actuel
RegisterNUICallback('loadModkit', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        SendNUIMessage({
            action = "updateModkit",
            mods = {}
        })
        SendNUIMessage({
            action = "updateAnimations",
            doors = {}
        })
        cb('ok')
        return
    end
    
    -- Envoyer l'état initial du véhicule
    SendVehicleState(vehicle)
    
    -- IMPORTANT: Initialiser le modkit du véhicule
    local modkitSet = SetVehicleModKit(vehicle, 0)
    print("^3[Pier76Menu] SetVehicleModKit(0) retourne: " .. tostring(modkitSet) .. "^0")
    
    -- Attendre un peu pour que le modkit soit appliqué
    Citizen.Wait(100)
    
    -- Charger les animations disponibles
    local availableDoors = GetAvailableDoors(vehicle)
    SendNUIMessage({
        action = "updateAnimations",
        doors = availableDoors
    })
    print("^3[Pier76Menu] " .. #availableDoors .. " animations détectées^0")
    
    local mods = {}
    
    print("^3[Pier76Menu] Chargement des mods par catégorie...^0")
    
    -- Charger les mods par catégorie
    LoadExteriorMods(vehicle, mods)
    LoadInteriorMods(vehicle, mods)
    LoadPropertiesMods(vehicle, mods)
    
    SendNUIMessage({
        action = "updateModkit",
        mods = mods
    })
    cb('ok')
end)

-- Appliquer un mod
RegisterNUICallback('applyMod', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        -- Initialiser le modkit avant d'appliquer
        local modkitSet = SetVehicleModKit(vehicle, 0)
        Citizen.Wait(50)
        
        print("^3[Pier76Menu] Applying mod - type: " .. tostring(data.type) .. ", value: " .. tostring(data.value) .. "^0")
        
        if data.type == 'color' then
            local _, secondary = GetVehicleColours(vehicle)
            SetVehicleColours(vehicle, tonumber(data.value), secondary)
            print("^2[Pier76Menu] Couleur primaire: " .. data.value .. "^0")
            
        elseif data.type == 'color2' then
            local primary, _ = GetVehicleColours(vehicle)
            SetVehicleColours(vehicle, primary, tonumber(data.value))
            print("^2[Pier76Menu] Couleur secondaire: " .. data.value .. "^0")
            
        elseif data.type == 'interior1' then
            SetVehicleDashboardColour(vehicle, tonumber(data.value))
            print("^2[Pier76Menu] Intérieur 1: " .. data.value .. "^0")
            
        elseif data.type == 'interior2' then
            SetVehicleInteriorColour(vehicle, tonumber(data.value))
            print("^2[Pier76Menu] Intérieur 2: " .. data.value .. "^0")
            
        elseif data.type == 'neon' then
            if tonumber(data.value) == 0 then
                SetVehicleNeonLightEnabled(vehicle, 0, false)
                SetVehicleNeonLightEnabled(vehicle, 1, false)
                SetVehicleNeonLightEnabled(vehicle, 2, false)
                SetVehicleNeonLightEnabled(vehicle, 3, false)
                print("^2[Pier76Menu] Néons désactivés^0")
            else
                local colors = {
                    {255, 255, 255},  -- Blanc
                    {0, 0, 255},      -- Bleu
                    {0, 255, 0},      -- Vert
                    {255, 0, 0},      -- Rouge
                    {255, 255, 0},    -- Jaune
                    {255, 0, 255},    -- Rose
                    {255, 128, 0}     -- Orange
                }
                local color = colors[tonumber(data.value)] or {255, 255, 255}
                SetVehicleNeonLightsColour(vehicle, color[1], color[2], color[3])
                SetVehicleNeonLightEnabled(vehicle, 0, true)
                SetVehicleNeonLightEnabled(vehicle, 1, true)
                SetVehicleNeonLightEnabled(vehicle, 2, true)
                SetVehicleNeonLightEnabled(vehicle, 3, true)
                print("^2[Pier76Menu] Néons activés: R" .. color[1] .. " G" .. color[2] .. " B" .. color[3] .. "^0")
            end
            
        elseif data.type == 'window' then
            SetVehicleWindowTint(vehicle, tonumber(data.value))
            print("^2[Pier76Menu] Teinte vitres: " .. data.value .. "^0")
            
        elseif data.type == 'wheel' then
            SetVehicleWheelType(vehicle, tonumber(data.value))
            print("^2[Pier76Menu] Type de roues: " .. data.value .. "^0")
            
        elseif data.type == 'wheelcolor' then
            local pearlColor, _ = GetVehicleExtraColours(vehicle)
            SetVehicleExtraColours(vehicle, pearlColor, tonumber(data.value))
            print("^2[Pier76Menu] Couleur des roues: " .. data.value .. "^0")
            
        elseif data.type == 'livery' then
            local liveryValue = tonumber(data.value)
            SetVehicleLivery(vehicle, liveryValue)
            Citizen.Wait(100)
            local newLivery = GetVehicleLivery(vehicle)
            print("^2[Pier76Menu] Livrée appliquée: " .. liveryValue .. " (vérification: " .. newLivery .. ")^0")
            
        else
            -- Mod standard (pièces du véhicule)
            local modType = tonumber(data.type)
            local modValue = tonumber(data.value)
            SetVehicleMod(vehicle, modType, modValue, false)
            Citizen.Wait(50)
            local verif = GetVehicleMod(vehicle, modType)
            print("^2[Pier76Menu] Mod appliqué - Type: " .. modType .. ", Value: " .. modValue .. ", Vérif: " .. verif .. "^0")
        end
    end
    cb('ok')
end)
