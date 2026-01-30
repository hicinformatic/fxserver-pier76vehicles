-- Types de mods intérieurs
interiorModTypes = {
    {type = 26, label = "Garnitures"},
    {type = 27, label = "Ornements"},
    {type = 28, label = "Tableau de bord"},
    {type = 29, label = "Cadran"},
    {type = 30, label = "Haut-parleur porte"},
    {type = 31, label = "Sièges"},
    {type = 32, label = "Volant"},
    {type = 33, label = "Levier vitesse"},
    {type = 35, label = "Haut-parleurs"},
    {type = 45, label = "Fenêtre"},
    {type = 47, label = "Siège passager"}
}

-- Charger les mods intérieurs
function LoadInteriorMods(vehicle, mods)
    print("^3[Pier76Menu] Chargement des mods intérieurs...^0")
    
    -- Mods d'intérieur
    for _, modType in ipairs(interiorModTypes) do
        local maxMods = GetNumVehicleMods(vehicle, modType.type)
        
        if maxMods > 0 then
            local currentMod = GetVehicleMod(vehicle, modType.type)
            local options = {{label = "Stock", value = -1, current = currentMod == -1}}
            
            for i = 0, maxMods - 1 do
                local modName = GetModTextLabel(vehicle, modType.type, i)
                local label = modName ~= "NULL" and GetLabelText(modName) or (modType.label .. " " .. i)
                if label == "NULL" then label = modType.label .. " " .. i end
                
                table.insert(options, {
                    label = label,
                    value = i,
                    current = currentMod == i
                })
            end
            
            table.insert(mods, {
                type = modType.type,
                label = modType.label,
                category = 'interior',
                options = options
            })
        end
    end
    
    -- Intérieur 1 (Dashboard)
    local interior1Color = GetVehicleDashboardColour(vehicle)
    local interior1Options = {}
    for i = 0, 160 do
        local label = colorNames[i] or ("Couleur " .. i)
        table.insert(interior1Options, {
            label = label,
            value = i,
            current = (i == interior1Color)
        })
    end
    
    table.insert(mods, {
        type = 'interior1',
        label = "Intérieur 1",
        category = 'interior',
        options = interior1Options
    })
    
    -- Intérieur 2 (Interior)
    local interior2Color = GetVehicleInteriorColour(vehicle)
    local interior2Options = {}
    for i = 0, 160 do
        local label = colorNames[i] or ("Couleur " .. i)
        table.insert(interior2Options, {
            label = label,
            value = i,
            current = (i == interior2Color)
        })
    end
    
    table.insert(mods, {
        type = 'interior2',
        label = "Intérieur 2",
        category = 'interior',
        options = interior2Options
    })
    
    print("^3[Pier76Menu] Mods intérieurs chargés^0")
end
