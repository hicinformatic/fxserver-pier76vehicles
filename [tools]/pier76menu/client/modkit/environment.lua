-- Changer l'heure
RegisterNUICallback('setTime', function(data, cb)
    local hour = tonumber(data.hour) or 12
    local minute = tonumber(data.minute) or 0
    
    NetworkOverrideClockTime(hour, minute, 0)
    
    print("^2[Pier76Menu] Heure changée: " .. hour .. "h" .. string.format("%02d", minute) .. "^0")
    
    cb('ok')
end)
