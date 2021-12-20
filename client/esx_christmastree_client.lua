local YouHaveATicket    = false
local YouHaveATree       = false
local TreeOnTheRoof      = false
prop_pot_plant          = nil
local Tree              = {}

Citizen.CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(500)
    end

    if ESX.IsPlayerLoaded() then
        ESX.TriggerServerCallback('esx_christmastree:getalltree', function(Tree)
            if Tree ~= nil then
                for i=1, #Tree, 1 do
                    TriggerEvent('esx_christmastree:spawntreetoclient', Tree[i].PosX, Tree[i].PosY, Tree[i].PosZ, Tree[i].Heading)
                end
            end
        end)
        Citizen.Wait(30000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)

        if not IsPedInAnyVehicle(PlayerPedId(), false) and YouHaveATicket == false and YouHaveATree == false and TreeOnTheRoof == false then

            ESX.TriggerServerCallback('esx_christmastree:gettreeticket', function(count)
                if count >= 1 then
                    YouHaveATicket  = true
                    YouHaveATree     = false
                    TreeOnTheRoof    = false
                --else
                --    ESX.ShowNotification(_U('NoTreeTicket'))
                end
            end)

        end

    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if YouHaveATree == true then
            DisableControlAction(0, 21, true) -- Disable LEFT SHIFT     -- INPUT_SPRINT
            DisableControlAction(0, 23, true) -- Disable LEFT SHIFT     -- INPUT_ENTER
            DisableControlAction(0, 75, true) -- Disable F              -- INPUT_VEH_EXIT
            DisableControlAction(0, 22, true) -- Disable SPACEBAR       -- INPUT_JUMP
        --    DisableControlAction(0, 45, true) -- Disable R            -- INPUT_RELOAD
        --    DisableControlAction(0, 80, true) -- Disable R            -- INPUT_VEH_CIN_CAM
            DisableControlAction(0, 140, true) -- Disable R             -- INPUT_MELEE_ATTACK_LIGHT
        --    DisableControlAction(0, 250, true) -- Disable R           -- INPUT_CREATOR_LS
            DisableControlAction(0, 263, true) -- Disable R             -- INPUT_MELEE_ATTACK1
        --    DisableControlAction(0, 310, true) -- Disable R           -- INPUT_REPLAY_RESTART

        end

        if YouHaveATicket == true and not IsPedInAnyVehicle(PlayerPedId(), false) and YouHaveATree == false and TreeOnTheRoof == false then
            local PlayerPed     = PlayerPedId()
            local PlayerCoords  = GetEntityCoords(PlayerPed)
            local CoordsMarker  = vector3(2747.4, 3460.6, 55.8 - 0.95)
            local Distance      = #(PlayerCoords - CoordsMarker)

            if Distance < 100 then
                DrawMarker( 1, CoordsMarker, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.3, 0, 255, 0, 100, false, true, 2, true, false, false, false)
            end

            if Distance < 1.5 then
                ESX.ShowHelpNotification(_U('PressForTakeTheTree'))

                if IsControlJustReleased(0, 38) then
                    local ModelHash     = GetHashKey('prop_pot_plant_03a')
                    local PlayerPed     = PlayerPedId()
                    local playerCoords  = GetEntityCoords(PlayerPed)

                    LoadModel(ModelHash)
                    prop_pot_plant = CreateObject(ModelHash, playerCoords.x, playerCoords.y, playerCoords.z - 3.0,  true,  true, true)
                    AttachEntityToEntity(prop_pot_plant, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, 0.0, -0.80, 25.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                    LoadAnim("anim@heists@box_carry@")
                    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
                    Citizen.Wait(100)

                    YouHaveATicket  = false
                    YouHaveATree     = true
                    TreeOnTheRoof    = false

                    TriggerServerEvent('esx_christmastree:removeitem', 1)
                    ESX.ShowNotification("Vous avez donné votre ticket")
                end
            end
        end

        if YouHaveATicket == false and not IsPedInAnyVehicle(PlayerPedId(), false) and YouHaveATree == true and TreeOnTheRoof == false then
            local PlayerPed     = PlayerPedId()
            local PlayerCoords  = GetEntityCoords(PlayerPed)
            local Vehicle       = ESX.Game.GetVehicleInDirection()
            local VehicleCoords = GetEntityCoords(Vehicle)
            local Distance      = #(VehicleCoords - PlayerCoords)

            if Distance < 6 and not IsPedInAnyVehicle(PlayerPed, false) then
                ESX.ShowHelpNotification(_U('PressToPutTheTreeOnTheVehicle'))

                if IsControlJustReleased(0, 38) then
                    local BoneIndex = GetEntityBoneIndexByName(Vehicle, 'interiorlight')

                    AttachEntityToEntity( prop_pot_plant, Vehicle, BoneIndex, 0.00, 0.00, 0.55, 90.0, 0.00, 0.00, false, true, true, false, 0, true)
                    Citizen.Wait(10)
                    ClearPedTasksImmediately(PlayerPed)
                    Citizen.Wait(100)

                    YouHaveATicket  = false
                    YouHaveATree     = false
                    TreeOnTheRoof    = true
                end
            else
                ESX.ShowHelpNotification(_U('PressToPlaceAndDecorateYourTree'))

                if IsControlJustReleased(0, 173) then
                    if ESX.Game.IsSpawnPointClear(PlayerCoords, 3) then
                        local ModelHash = GetHashKey('prop_xmas_tree_int')
                        local forward   = GetEntityForwardVector(PlayerPed)
                        local x, y, z   = table.unpack(PlayerCoords + forward * 1.0)
                        local PlayerRotations   = GetEntityRotation(PlayerPed, 2)
                        Tree = nil

                        LoadModel(ModelHash)
                        Tree = CreateObject(ModelHash, x, y, z -1.0,  true,  true, true)
                        Citizen.Wait(10)
                        SetEntityRotation(Tree, PlayerRotations.x, PlayerRotations.y, PlayerRotations.z, 2, false)
                        PlaceObjectOnGroundProperly(Tree)
                        Citizen.Wait(10)
                        DeleteEntity(prop_pot_plant)
                        Citizen.Wait(10)
                        ClearPedTasksImmediately(PlayerPed)
                        Citizen.Wait(100)
                        prop_pot_plant = nil
                        Citizen.Wait(10)

                        YouHaveATicket  = false
                        YouHaveATree     = false
                        TreeOnTheRoof    = false
                        local TreeRotations  = GetEntityRotation(Tree, 2)
                        local PlayerHeading     = GetEntityHeading(PlayerPed)
                        Citizen.Wait(10)
                        local Data = {}
                        Data.PosX = x
                        Data.PosY = y
                        Data.PosZ = z - 1.0
                        Data.RotX = TreeRotations.x
                        Data.RotY = TreeRotations.y
                        Data.RotZ = TreeRotations.z
                        Data.Heading = PlayerHeading

                        print("PosX : " .. Data.PosX, ", PosY : " .. Data.PosY, ", PosZ : " .. Data.PosZ)
                        print("RotX : " .. Data.RotX, ", RotY : " .. Data.RotY, ", RotZ : " .. Data.RotZ)
                        Citizen.Wait(10)
                        TriggerServerEvent('esx_christmastree:savechristmastreepositions', Data)
                        Citizen.Wait(10)
                        DeleteObject(Tree)
                        Citizen.Wait(10)
                        Tree = nil
                    else
                        ESX.ShowNotification(_U('CanNotPutTheTreeHere'))
                    end
                end
            end
        end

        if YouHaveATicket == false and not IsPedInAnyVehicle(PlayerPedId(), false) and YouHaveATree == false and TreeOnTheRoof == true then
            local PlayerPed     = PlayerPedId()
            local PlayerCoords  = GetEntityCoords(PlayerPed)
            local Vehicle       = ESX.Game.GetVehicleInDirection()
            local VehicleCoords = GetEntityCoords(Vehicle)
            local Distance      = #(VehicleCoords - PlayerCoords)

            if Distance < 6 and not IsPedInAnyVehicle(PlayerPed, false) then
                ESX.ShowHelpNotification(_U('PressToTakeTheTreeFromTheVehicle'))

                if IsControlJustReleased(0, 38) then
                    local ModelHash     = GetHashKey('prop_pot_plant_03a')

                    LoadModel(ModelHash)
                    AttachEntityToEntity(prop_pot_plant, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, 0.0, -0.80, 25.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                    LoadAnim("anim@heists@box_carry@")
                    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
                    Citizen.Wait(100)

                    YouHaveATicket  = false
                    YouHaveATree     = true
                    TreeOnTheRoof    = false
                end
            else
                Citizen.Wait(300)
            end
        end
    end
end)

function LoadAnim(animDict)
    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
end

function LoadModel(ModelHash)
    RequestModel(ModelHash)

    while not HasModelLoaded(ModelHash) do
        Citizen.Wait(10)
    end
end

RegisterNetEvent('esx_christmastree:synchronization')
AddEventHandler('esx_christmastree:synchronization', function()

    ESX.TriggerServerCallback('esx_christmastree:getalltree', function(Tree)
        if Tree ~= nil then
            for i=1, #Tree, 1 do
                TriggerEvent('esx_christmastree:spawntreetoclient', Tree[i].PosX, Tree[i].PosY, Tree[i].PosZ, Tree[i].RotX, Tree[i].RotY, Tree[i].RotZ, Tree[i].Heading)
            end
        end
    end)

end)

RegisterNetEvent('esx_christmastree:spawntreetoclient')
AddEventHandler('esx_christmastree:spawntreetoclient', function( PosX, PosY, PosZ, RotX, RotY, RotZ)

    local coords3 = {
        x = PosX,
        y = PosY,
        z = PosZ
    }

    if PosX ~= nil then
        local ModelHash = GetHashKey('prop_xmas_tree_int')

        ESX.Game.SpawnObject(ModelHash, coords3, function(respawnTree)
            --SetEntityRotation(respawnTree, RotX, RotY, RotZ, 2, true)
            Citizen.Wait(10)
            SetEntityHeading(respawnTree, respawnTreeHeading)
            Citizen.Wait(10)
            --PlaceObjectOnGroundProperly(respawnTree)
            SetEntityAsMissionEntity(respawnTree, true, true)
            SetEntityCollision(respawnTree, true, true)
            SetEntityInvincible(respawnTree, true)
            FreezeEntityPosition(respawnTree, true)
        end)
    end
end)