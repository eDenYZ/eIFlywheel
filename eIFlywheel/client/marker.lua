ESX = nil
local JobZone = false

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(10)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        ESX.PlayerData = ESX.GetPlayerData()

        InitBlips()
        InitPed()
        InitMarkerJob()
    end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        ESX.PlayerData = xPlayer
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        ESX.PlayerData.job = job
    end
)

InitMarkerJob = function()
    JobZone = true
    Citizen.CreateThread(
        function()
            while JobZone do
                local InZone = false
                local playerPos = GetEntityCoords(PlayerPedId())
                for _, v in pairs(eIFlywheels.KitPosition) do
                    if ESX.PlayerData.job and ESX.PlayerData.job.name == "flywheels" then
                        local dst1 = GetDistanceBetweenCoords(playerPos, v.pos, true)
                        if dst1 < 2.0 then
                            InZone = true
                            DrawMarker(
                                20,
                                v.pos,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.3,
                                0.3,
                                0.3,
                                0,
                                180,
                                0,
                                255,
                                true,
                                true,
                                p19,
                                true
                            )
                            if dst1 < 2.0 then
                                ESX.ShowHelpNotification(eIFlywheels.Notif.ShowHelpNotification)
                                if IsControlJustReleased(1, 38) then
                                    KitFlywheels()
                                end
                            end
                        end
                    end
                end
                for _, v in pairs(eIFlywheels.CustomPosition) do
                    if ESX.PlayerData.job and ESX.PlayerData.job.name == "flywheels" then
                        if IsPedSittingInAnyVehicle(PlayerPedId(), -1) then
                            local dst1 = GetDistanceBetweenCoords(playerPos, v.pos, true)
                            if dst1 < 2.0 then
                                InZone = true
                                DrawMarker(
                                    20,
                                    v.pos,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.3,
                                    0.3,
                                    0.3,
                                    0,
                                    180,
                                    0,
                                    255,
                                    true,
                                    true,
                                    p19,
                                    true
                                )
                                if dst1 < 2.0 then
                                    ESX.ShowHelpNotification(eIFlywheels.Notif.ShowHelpNotification)
                                    if IsControlJustReleased(1, 38) then
                                        CustomFlywheel()
                                    end
                                end
                            end
                        end
                    end
                end
                for _, v in pairs(eIFlywheels.GaragePosition) do
                    if ESX.PlayerData.job and ESX.PlayerData.job.name == "flywheels" then
                        local dst1 = GetDistanceBetweenCoords(playerPos, v.pos, true)
                        if dst1 < 2.0 then
                            InZone = true
                            DrawMarker(
                                20,
                                v.pos,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.3,
                                0.3,
                                0.3,
                                0,
                                180,
                                0,
                                255,
                                true,
                                true,
                                p19,
                                true
                            )
                            if dst1 < 2.0 then
                                ESX.ShowHelpNotification(eIFlywheels.Notif.ShowHelpNotification)
                                if IsControlJustReleased(1, 38) then
                                    GarageFlywheels()
                                end
                            end
                        end
                    end
                end
                for _, v in pairs(eIFlywheels.VehiculeSuppression) do
                    if ESX.PlayerData.job and ESX.PlayerData.job.name == "flywheels" then
                        if IsPedSittingInAnyVehicle(PlayerPedId(), -1) then
                            local dst1 = GetDistanceBetweenCoords(playerPos, v.pos, true)
                            if dst1 < 2.0 then
                                InZone = true
                                DrawMarker(
                                    20,
                                    v.pos,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.3,
                                    0.3,
                                    0.3,
                                    0,
                                    180,
                                    0,
                                    255,
                                    true,
                                    true,
                                    p19,
                                    true
                                )
                                if dst1 < 2.0 then
                                    ESX.ShowHelpNotification(eIFlywheels.Notif.ShowHelpNotification)
                                    if IsControlJustReleased(1, 38) then
                                        TriggerEvent("esx:deleteVehicle")
                                    end
                                end
                            end
                        end
                    end
                end
                for _, v in pairs(eIFlywheels.TenuePosition) do
                    if ESX.PlayerData.job and ESX.PlayerData.job.name == "flywheels" then
                        local dst1 = GetDistanceBetweenCoords(playerPos, v.pos, true)
                        if dst1 < 2.0 then
                            InZone = true
                            DrawMarker(
                                20,
                                v.pos,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.3,
                                0.3,
                                0.3,
                                0,
                                180,
                                0,
                                255,
                                true,
                                true,
                                p19,
                                true
                            )
                            if dst1 < 2.0 then
                                ESX.ShowHelpNotification(eIFlywheels.Notif.ShowHelpNotification)
                                if IsControlJustReleased(1, 38) then
                                    TenueFlywheels()
                                end
                            end
                        end
                    end
                end
                for _, v in pairs(eIFlywheels.Appel) do
                    local dst1 = GetDistanceBetweenCoords(playerPos, v.pos, true)
                    if dst1 < 2.0 then
                        InZone = true
                        DrawMarker(
                            20,
                            v.pos,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.3,
                            0.3,
                            0.3,
                            0,
                            180,
                            0,
                            255,
                            true,
                            true,
                            p19,
                            true
                        )
                        if dst1 < 2.0 then
                            ESX.ShowHelpNotification(eIFlywheels.Notif.ShowHelpNotification)
                            if IsControlJustReleased(1, 38) then
                                TriggerServerEvent("Appel:Flywheel")
                                ESX.ShowNotification("~g~Votre message a bien été envoyé aux mecano.")
                            end
                        end
                    end
                end
                if not InZone then
                    Wait(500)
                else
                    Wait(1)
                end
            end
        end
    )
end
