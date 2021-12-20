ESX.RegisterServerCallback('esx_christmastree:gettreeticket', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        local count = xPlayer.getInventoryItem('treeticket').count

        cb(count)
    end
end)

RegisterServerEvent('esx_christmastree:removeitem')
AddEventHandler('esx_christmastree:removeitem', function(count)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('treeticket', count)
end)

ESX.RegisterServerCallback('esx_christmastree:getalltree', function(source, cb)
    local src = source

    MySQL.Async.fetchAll('SELECT * FROM Tree', {}, function(Tree)

        if Tree[1] ~= nil then
            cb(Tree)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent("esx_christmastree:savechristmastreepositions")
AddEventHandler("esx_christmastree:savechristmastreepositions", function(Data)
    print("PosX : " .. Data.PosX, ", PosY : " .. Data.PosY, ", PosZ : " .. Data.PosZ .. ", RotX : " .. Data.RotX, ", RotY : " .. Data.RotY, ", RotZ : " .. Data.RotZ, ", Heading : " .. Data.Heading)

    MySQL.Async.execute('INSERT INTO Tree (PosX, PosY, PosZ, RotX, RotY, RotZ, Heading) VALUES (@PosX, @PosY, @PosZ, @RotX, @RotY, @RotZ, @Heading)', {
        ['@PosX']  = Data.PosX,
        ['@PosY']  = Data.PosY,
        ['@PosZ']  = Data.PosZ,
        ['@RotX']  = Data.RotX,
        ['@RotY']  = Data.RotY,
        ['@RotZ']  = Data.RotZ,
        ['@Heading']  = Data.Heading
    })
    TriggerClientEvent('esx_christmastree:synchronization', source)
    --print("La synchro des sapins a bien été effectuée")
end)