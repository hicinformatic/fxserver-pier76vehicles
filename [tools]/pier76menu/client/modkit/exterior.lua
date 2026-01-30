-- Types de mods extérieurs
exteriorModTypes = {
    {type = 0, label = "Aileron"},
    {type = 1, label = "Pare-choc avant"},
    {type = 2, label = "Pare-choc arrière"},
    {type = 3, label = "Bas de caisse"},
    {type = 4, label = "Échappement"},
    {type = 5, label = "Arceau"},
    {type = 6, label = "Grille"},
    {type = 7, label = "Capot"},
    {type = 8, label = "Aile gauche"},
    {type = 9, label = "Aile droite"},
    {type = 10, label = "Toit"},
    {type = 20, label = "Façade"},
    {type = 23, label = "Roues avant"},
    {type = 24, label = "Roues arrière"},
    {type = 25, label = "Support plaque"},
    {type = 42, label = "Antenne"},
    {type = 43, label = "Extérieur"},
    {type = 46, label = "Stickers/Livrée"},
    {type = 48, label = "Livery 2"}
}

-- Palette de couleurs GTA V
colorNames = {
    [0] = "Noir métallique", [1] = "Noir graphite", [2] = "Noir acier", [3] = "Gris foncé",
    [4] = "Argent", [5] = "Gris bleuté", [11] = "Anthracite", [12] = "Noir mat",
    [27] = "Rouge", [28] = "Rouge torino", [29] = "Rouge formule", [30] = "Rouge flamme",
    [31] = "Rouge grâce", [32] = "Rouge cabernet", [33] = "Rouge candy", [34] = "Orange sunrise",
    [35] = "Or classique", [36] = "Orange", [37] = "Jaune", [38] = "Jaune course",
    [49] = "Vert forêt", [50] = "Vert olive", [51] = "Vert lime", [52] = "Vert gazon",
    [53] = "Vert olive foncé", [54] = "Vert anis", [55] = "Vert teal",
    [61] = "Bleu nuit", [62] = "Bleu foncé", [63] = "Bleu saxon", [64] = "Bleu",
    [65] = "Bleu marin", [66] = "Bleu port", [67] = "Bleu diamant", [68] = "Bleu surf",
    [69] = "Bleu nautique", [70] = "Bleu racing", [71] = "Bleu ultra", [72] = "Bleu clair",
    [73] = "Violet métallique", [94] = "Violet", [95] = "Violet foncé", [96] = "Violet schafter",
    [111] = "Blanc", [112] = "Blanc glacé", [131] = "Crème", [132] = "Beige",
    [134] = "Brun", [135] = "Brun foncé", [136] = "Chocolat", [137] = "Café",
    [138] = "Orange métallique", [141] = "Jaune taxi", [142] = "Jaune course",
    [143] = "Bronze", [145] = "Rose", [146] = "Rose bonbon", [147] = "Rose vif"
}

-- Charger les mods extérieurs
function LoadExteriorMods(vehicle, mods)
    print("^3[Pier76Menu] Chargement des mods extérieurs...^0")
    
    -- Mods de carrosserie
    for _, modType in ipairs(exteriorModTypes) do
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
                category = 'exterior',
                options = options
            })
        end
    end
    
    -- Couleurs
    local currentPrimaryColor, currentSecondaryColor = GetVehicleColours(vehicle)
    
    local colorOptions = {}
    for id = 0, 159 do
        local label = colorNames[id] or ("Couleur " .. id)
        table.insert(colorOptions, {
            label = label, 
            value = id, 
            current = (id == currentPrimaryColor)
        })
    end
    
    table.insert(mods, {
        type = 'color',
        label = "Couleur primaire",
        category = 'exterior',
        options = colorOptions
    })
    
    local colorOptions2 = {}
    for id = 0, 159 do
        local label = colorNames[id] or ("Couleur " .. id)
        table.insert(colorOptions2, {
            label = label, 
            value = id, 
            current = (id == currentSecondaryColor)
        })
    end
    
    table.insert(mods, {
        type = 'color2',
        label = "Couleur secondaire",
        category = 'exterior',
        options = colorOptions2
    })
    
    -- Néons
    local neonEnabled = IsVehicleNeonLightEnabled(vehicle, 0)
    local currentNeon = neonEnabled and 1 or 0
    if neonEnabled then
        local r, g, b = GetVehicleNeonLightsColour(vehicle)
        if r == 255 and g == 255 and b == 255 then currentNeon = 1
        elseif r == 0 and g == 0 and b == 255 then currentNeon = 2
        elseif r == 0 and g == 255 and b == 0 then currentNeon = 3
        elseif r == 255 and g == 0 and b == 0 then currentNeon = 4
        elseif r == 255 and g == 255 and b == 0 then currentNeon = 5
        elseif r == 255 and g == 0 and b == 255 then currentNeon = 6
        elseif r == 255 and g == 128 and b == 0 then currentNeon = 7
        end
    end
    
    table.insert(mods, {
        type = 'neon',
        label = "Néons",
        category = 'exterior',
        options = {
            {label = "Désactivé", value = 0, current = (currentNeon == 0)},
            {label = "Blanc", value = 1, current = (currentNeon == 1)},
            {label = "Bleu", value = 2, current = (currentNeon == 2)},
            {label = "Vert", value = 3, current = (currentNeon == 3)},
            {label = "Rouge", value = 4, current = (currentNeon == 4)},
            {label = "Jaune", value = 5, current = (currentNeon == 5)},
            {label = "Rose", value = 6, current = (currentNeon == 6)},
            {label = "Orange", value = 7, current = (currentNeon == 7)}
        }
    })
    
    -- Teinte vitres
    local currentWindowTint = GetVehicleWindowTint(vehicle)
    table.insert(mods, {
        type = 'window',
        label = "Teinte vitres",
        category = 'exterior',
        options = {
            {label = "Aucune", value = 0, current = (currentWindowTint == 0)},
            {label = "Noir pur", value = 1, current = (currentWindowTint == 1)},
            {label = "Noir foncé", value = 2, current = (currentWindowTint == 2)},
            {label = "Noir clair", value = 3, current = (currentWindowTint == 3)},
            {label = "Stock", value = 4, current = (currentWindowTint == 4)},
            {label = "Limousine", value = 5, current = (currentWindowTint == 5)},
            {label = "Vert", value = 6, current = (currentWindowTint == 6)}
        }
    })
    
    -- Type de roues
    local currentWheelType = GetVehicleWheelType(vehicle)
    table.insert(mods, {
        type = 'wheel',
        label = "Type de roues",
        category = 'exterior',
        options = {
            {label = "Sport", value = 0, current = (currentWheelType == 0)},
            {label = "Muscle", value = 1, current = (currentWheelType == 1)},
            {label = "Lowrider", value = 2, current = (currentWheelType == 2)},
            {label = "SUV", value = 3, current = (currentWheelType == 3)},
            {label = "Offroad", value = 4, current = (currentWheelType == 4)},
            {label = "Tuner", value = 5, current = (currentWheelType == 5)},
            {label = "Moto", value = 6, current = (currentWheelType == 6)},
            {label = "High End", value = 7, current = (currentWheelType == 7)}
        }
    })
    
    -- Couleur des roues
    local _, currentWheelColor = GetVehicleExtraColours(vehicle)
    local wheelColorOptions = {}
    for id = 0, 159 do
        local label = colorNames[id] or ("Couleur " .. id)
        table.insert(wheelColorOptions, {
            label = label, 
            value = id, 
            current = (id == currentWheelColor)
        })
    end
    
    table.insert(mods, {
        type = 'wheelcolor',
        label = "Couleur des roues",
        category = 'exterior',
        options = wheelColorOptions
    })
    
    -- Livrées
    local liveryCount = GetVehicleLiveryCount(vehicle)
    if liveryCount > 0 then
        local currentLivery = GetVehicleLivery(vehicle)
        local liveryOptions = {{label = "Aucune", value = -1, current = currentLivery == -1}}
        
        for i = 0, liveryCount - 1 do
            table.insert(liveryOptions, {
                label = "Livrée " .. (i + 1),
                value = i,
                current = currentLivery == i
            })
        end
        
        table.insert(mods, {
            type = 'livery',
            label = "Livrées véhicule",
            category = 'exterior',
            options = liveryOptions
        })
    end
    
    print("^3[Pier76Menu] Mods extérieurs chargés^0")
end
