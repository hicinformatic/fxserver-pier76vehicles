-- Types de mods de performance/propriétés
propertiesModTypes = {
    {type = 11, label = "Moteur"},
    {type = 12, label = "Freins"},
    {type = 13, label = "Transmission"},
    {type = 14, label = "Klaxon"},
    {type = 15, label = "Suspension"},
    {type = 16, label = "Blindage"},
    {type = 17, label = "Turbo"},
    {type = 18, label = "Fumée pneus"},
    {type = 19, label = "Phares xenon"},
    {type = 21, label = "Plaques custom"},
    {type = 22, label = "Plaques arrière"},
    {type = 34, label = "Plaques custom 2"},
    {type = 36, label = "Coffre"},
    {type = 37, label = "Hydraulique"},
    {type = 38, label = "Moteur bloc"},
    {type = 39, label = "Filtre à air"},
    {type = 40, label = "Entretoises"},
    {type = 41, label = "Arceau cage"},
    {type = 44, label = "Réservoir"}
}

-- Charger les mods de performance
function LoadPropertiesMods(vehicle, mods)
    print("^3[Pier76Menu] Chargement des mods de performance...^0")
    
    for _, modType in ipairs(propertiesModTypes) do
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
                category = 'properties',
                options = options
            })
        end
    end
    
    print("^3[Pier76Menu] Mods de performance chargés^0")
end
