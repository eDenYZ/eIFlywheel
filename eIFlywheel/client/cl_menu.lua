OpenMenuFlywheels = function()
    local main = RageUI.CreateMenu("Flywheels", "Interaction")
    local IntVeh = RageUI.CreateSubMenu(main, "Interaction véhicule", "Interaction")
    local AnnonceList = {"Ouvertures", "Fermetures", "Recrutement", "Personnalisé"}
    local AnnonceIndex = 1
    RageUI.Visible(main, not RageUI.Visible(main))
    while main do
        Wait(0)

        RageUI.IsVisible(
            main,
            function()
                if serviceflywheels then
                    RageUI.Separator("Status : ~g~En service")
                else
                    RageUI.Separator("Status : ~r~Hors service")
                end
                RageUI.Checkbox(
                    "Prendre son service",
                    nil,
                    serviceflywheels,
                    {},
                    {
                        onChecked = function(index, items)
                            serviceflywheels = true
                        end,
                        onUnChecked = function(index, items)
                            serviceflywheels = false
                        end
                    }
                )
                if serviceflywheels then
                    RageUI.Button(
                        "Interaction sur véhicule",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onSelected = function()
                            end
                        },
                        IntVeh
                    )

                    RageUI.List(
                        "Annonce",
                        AnnonceList,
                        AnnonceIndex,
                        nil,
                        {},
                        true,
                        {
                            onListChange = function(Index)
                                AnnonceIndex = Index
                            end,
                            onSelected = function(Index)
                                if Index == 1 then
                                    TriggerServerEvent("Ouvre:flywheels")
                                elseif Index == 2 then
                                    TriggerServerEvent("Ferme:flywheels")
                                elseif Index == 3 then
                                    TriggerServerEvent("Recru:flywheels")
                                elseif Index == 4 then
                                    local te = KeyboardInput("flywheels", "", 100)
                                    ExecuteCommand("fly " .. te)
                                end
                            end
                        }
                    )

                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    RageUI.Button(
                        "Faire une Facture",
                        nil,
                        {RightLabel = "→"},
                        closestPlayer ~= -1 and closestDistance <= 3.0,
                        {
                            onActive = function()
                                PlayerMarker()
                            end,
                            onSelected = function()
                                amount = KeyboardInput("Montant de la facture", nil, 3)
                                amount = tonumber(amount)
                                local player, distance = ESX.Game.GetClosestPlayer()

                                if player ~= -1 and distance <= 3.0 then
                                    if amount == nil then
                                        ESX.ShowNotification("~r~Problèmes~s~: Montant invalide")
                                    else
                                        local playerPed = GetPlayerPed(-1)
                                        Citizen.Wait(5000)
                                        TriggerServerEvent(
                                            "esx_billing:sendBill",
                                            GetPlayerServerId(player),
                                            "society_flywheels",
                                            ("Flywheels"),
                                            amount
                                        )
                                        Citizen.Wait(100)
                                        ESX.ShowNotification("~g~Vous avez bien envoyer la facture")
                                    end
                                else
                                    ESX.ShowNotification("~r~Problèmes~s~: Aucun joueur à proximitée")
                                end
                            end
                        }
                    )
                end
            end
        )

        RageUI.IsVisible(
            IntVeh,
            function()
                local pos = GetEntityCoords(PlayerPedId())
                local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                pos = GetEntityCoords(veh)
                local target, distance = ESX.Game.GetClosestVehicle()
                if distance <= 5.0 then
                    RageUI.Button(
                        "Réparer le moteur",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onActive = function()
                                MarqueurVehicule()
                            end,
                            onSelected = function()
                                ESX.TriggerServerCallback(
                                    "eDen:getItemAmount",
                                    function(quantity)
                                        if quantity > 0 then
                                            local ped = PlayerPedId()
                                            local coords = GetEntityCoords(ped)
                                            local veh = ObjectInFront(ped, coords)
                                            if DoesEntityExist(veh) then
                                                if IsEntityAVehicle(veh) then
                                                    SetEntityAsMissionEntity(veh, true, true)
                                                    TriggerServerEvent("flywheels:krick", ped, coords, veh)
                                                    createProgressBar("Reparation en cours", 102, 187, 106, 200, 30000)
                                                    TriggerServerEvent("eDen:moteurkit", "moteurkit")
                                                end
                                            end
                                        else
                                            ESX.ShowNotification("<C>~r~Erreur~s~\n</C>Vous n'avez pas ~b~Kit Moteur.")
                                        end
                                    end,
                                    "moteurkit"
                                )
                            end
                        }
                    )
                else
                    RageUI.Button(
                        "Réparer le moteur",
                        nil,
                        {RightLabel = "→"},
                        false,
                        {
                            onSelected = function()
                            end
                        }
                    )
                end

                local pos = GetEntityCoords(PlayerPedId())
                local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                pos = GetEntityCoords(veh)
                local target, distance = ESX.Game.GetClosestVehicle()
                if distance <= 5.0 then
                    RageUI.Button(
                        "Réparer la carosserie",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onActive = function()
                                MarqueurVehicule()
                            end,
                            onSelected = function()
                                local playerPed = GetPlayerPed(-1)
                                local coords = GetEntityCoords(playerPed)
                                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
                                    local vehicle = nil
                                    if IsPedInAnyVehicle(playerPed, false) then
                                        vehicle = GetVehiclePedIsIn(playerPed, false)
                                    else
                                        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
                                    end
                                    ESX.TriggerServerCallback(
                                        "eDen:getItemAmount",
                                        function(quantity)
                                            if quantity > 0 then
                                                if DoesEntityExist(vehicle) then
                                                    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
                                                    createProgressBar("Reparation en cours", 102, 187, 106, 200, 22000)
                                                    Citizen.CreateThread(
                                                        function()
                                                            Citizen.Wait(22000)
                                                            TriggerServerEvent("eDen:carokit", "carokit")
                                                            SetVehicleFixed(vehicle)
                                                            SetVehicleDeformationFixed(vehicle)
                                                            SetVehicleUndriveable(vehicle, false)
                                                            SetVehicleEngineOn(vehicle, true, true)
                                                            ClearPedTasksImmediately(playerPed)
                                                            ESX.ShowNotification(
                                                                "<C>~y~Succés~s~\n</C>La carosserie a été réparé"
                                                            )
                                                            ESX.ShowNotification(
                                                                "<C>~y~Succés~s~\n</C>Vous avez utilisé ~b~x1 Kit Carrosserie"
                                                            )
                                                        end
                                                    )
                                                end
                                            else
                                                ESX.ShowNotification(
                                                    "<C>~r~Erreur~s~\n</C>Vous n'avez pas ~b~Kit Carosserie."
                                                )
                                            end
                                        end,
                                        "carokit"
                                    )
                                end
                            end
                        }
                    )
                else
                    RageUI.Button(
                        "Réparer la carosserie",
                        nil,
                        {RightLabel = "→"},
                        false,
                        {
                            onSelected = function()
                            end
                        }
                    )
                end

                local pos = GetEntityCoords(PlayerPedId())
                local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                pos = GetEntityCoords(veh)
                local target, distance = ESX.Game.GetClosestVehicle()
                if distance <= 5.0 then
                    RageUI.Button(
                        "Crocheter le véhicule",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onActive = function()
                                MarqueurVehicule()
                            end,
                            onSelected = function()
                                local playerPed = PlayerPedId()
                                local vehicle = ESX.Game.GetVehicleInDirection()
                                local coords = GetEntityCoords(playerPed)

                                if IsPedSittingInAnyVehicle(playerPed) then
                                    ESX.ShowNotification(
                                        "<C>~r~Erreur~s~\n</C>Vous ne pouvez pas effectuer cette action depuis un véhicule."
                                    )
                                    return
                                end

                                ESX.TriggerServerCallback(
                                    "eDen:getItemAmount",
                                    function(quantity)
                                        if quantity > 0 then
                                            if DoesEntityExist(vehicle) then
                                                TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                                                createProgressBar("Crochetage en cours", 102, 187, 106, 200, 10000)
                                                Citizen.CreateThread(
                                                    function()
                                                        Citizen.Wait(10000)
                                                        TriggerServerEvent("eDen:gazbottle", "gazbottle")
                                                        SetVehicleDoorOpen(vehicle, 0, false, false)
                                                        SetVehicleDoorsLocked(vehicle, 1)
                                                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                                                        ClearPedTasksImmediately(playerPed)
                                                        ESX.ShowNotification(
                                                            "<C>~y~Succés~s~\n</C>Le Véhicule à été ouvert."
                                                        )
                                                        ESX.ShowNotification(
                                                            "<C>~y~Succés~s~\n</C>Vous avez utilisé ~b~x1 Bouteille de gaz"
                                                        )
                                                    end
                                                )
                                            end
                                        else
                                            ESX.ShowNotification(
                                                "<C>~r~Erreur~s~\n</C>Vous n'avez pas ~b~Bouteille de Gaz."
                                            )
                                        end
                                    end,
                                    "gazbottle"
                                )
                            end
                        }
                    )
                else
                    RageUI.Button(
                        "Crocheter le véhicule",
                        nil,
                        {RightLabel = "→"},
                        false,
                        {
                            onSelected = function()
                            end
                        }
                    )
                end

                local pos = GetEntityCoords(PlayerPedId())
                local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                pos = GetEntityCoords(veh)
                local target, distance = ESX.Game.GetClosestVehicle()
                if distance <= 5.0 then
                    RageUI.Button(
                        "Mettre en fourrière",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onActive = function()
                                MarqueurVehicule()
                            end,
                            onSelected = function()
                                local playerPed = PlayerPedId()
                                local coords = GetEntityCoords(playerPed)
                                if IsPedInAnyVehicle(playerPed, false) then
                                    vehicle = GetVehiclePedIsIn(playerPed, false)
                                else
                                    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
                                end
                                TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, false)
                                createProgressBar("Fourrière en cours", 102, 187, 106, 200, 13000)
                                Citizen.Wait(8000)
                                ClearPedTasks(playerPed)
                                Citizen.Wait(5000)
                                ESX.ShowNotification("<C>~y~Succés~s~\n</C>Vehicule mis en fourrière.")
                                TriggerEvent("esx:deleteVehicle")
                                local vehicleInfo = ESX.Game.GetVehicleProperties(vehicle)
                            end
                        }
                    )
                else
                    RageUI.Button(
                        "Mettre en fourrière",
                        nil,
                        {RightLabel = "→"},
                        false,
                        {
                            onSelected = function()
                            end
                        }
                    )
                end

                local pos = GetEntityCoords(PlayerPedId())
                local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                pos = GetEntityCoords(veh)
                local target, distance = ESX.Game.GetClosestVehicle()
                if distance <= 5.0 then
                    RageUI.Button(
                        "Nettoyer le véhicule",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onActive = function()
                                MarqueurVehicule()
                            end,
                            onSelected = function()
                                local playerPed = PlayerPedId()
                                local coords = GetEntityCoords(playerPed)
                                if IsPedInAnyVehicle(playerPed, false) then
                                    vehicle = GetVehiclePedIsIn(playerPed, false)
                                else
                                    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
                                end
                                if IsPedSittingInAnyVehicle(playerPed) then
                                    ESX.ShowNotification(
                                        "<C>~r~Erreur~s~\n</C>Vous devez être a l'extérieur du véhicule"
                                    )
                                    return
                                end
                                ESX.TriggerServerCallback(
                                    "eDen:getItemAmount",
                                    function(quantity)
                                        if quantity > 0 then
                                            if DoesEntityExist(vehicle) then
                                                TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
                                                createProgressBar("Nettoyage en cours", 102, 187, 106, 200, 10000)
                                                Citizen.CreateThread(
                                                    function()
                                                        Citizen.Wait(10000)
                                                        TriggerServerEvent("eDen:chiffon", "chiffon")
                                                        SetVehicleDirtLevel(vehicle, 0)
                                                        ClearPedTasksImmediately(playerPed)
                                                        ESX.ShowNotification("<C>~y~Succés~s~\n</C>Véhicule nettoyé.")
                                                        ESX.ShowNotification(
                                                            "<C>~y~Succés~s~\n</C>Vous avez utilisé ~b~x1 Chiffon"
                                                        )
                                                    end
                                                )
                                            end
                                        else
                                            ESX.ShowNotification("<C>~r~Erreur~s~\n</C>Vous n'avez pas ~b~Chiffon.")
                                        end
                                    end,
                                    "chiffon"
                                )
                            end
                        }
                    )
                else
                    RageUI.Button(
                        "Nettoyer le véhicule",
                        nil,
                        {RightLabel = "→"},
                        false,
                        {
                            onSelected = function()
                            end
                        }
                    )
                end

                local pos = GetEntityCoords(PlayerPedId())
                local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                pos = GetEntityCoords(veh)
                local target, distance = ESX.Game.GetClosestVehicle()
                if distance <= 5.0 then
                    RageUI.Button(
                        "Placer sur la remorque",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onActive = function()
                                MarqueurVehicule()
                            end,
                            onSelected = function()
                                local playerPed = PlayerPedId()
                                local vehicle = GetVehiclePedIsIn(playerPed, true)

                                local towmodel = GetHashKey("flatbed")
                                local isVehicleTow = IsVehicleModel(vehicle, towmodel)

                                if isVehicleTow then
                                    local targetVehicle = ESX.Game.GetVehicleInDirection()

                                    if CurrentlyTowedVehicle == nil then
                                        if targetVehicle ~= 0 then
                                            if not IsPedInAnyVehicle(playerPed, true) then
                                                if vehicle ~= targetVehicle then
                                                    AttachEntityToEntity(
                                                        targetVehicle,
                                                        vehicle,
                                                        20,
                                                        -0.5,
                                                        -5.0,
                                                        1.0,
                                                        0.0,
                                                        0.0,
                                                        0.0,
                                                        false,
                                                        false,
                                                        false,
                                                        false,
                                                        20,
                                                        true
                                                    )
                                                    CurrentlyTowedVehicle = targetVehicle
                                                    ESX.ShowNotification(
                                                        "<C>~y~Succés~s~\n</C>Vehicule ~b~attaché~s~ avec succès!"
                                                    )

                                                    if NPCOnJob then
                                                        if NPCTargetTowable == targetVehicle then
                                                            ESX.ShowNotification(
                                                                "Veuillez déposer le véhicule à la concession"
                                                            )
                                                            Config.Zones.VehicleDelivery.Type = 1

                                                            if Blips["NPCTargetTowableZone"] then
                                                                RemoveBlip(Blips["NPCTargetTowableZone"])
                                                                Blips["NPCTargetTowableZone"] = nil
                                                            end

                                                            Blips["NPCDelivery"] =
                                                                AddBlipForCoord(
                                                                Config.Zones.VehicleDelivery.Pos.x,
                                                                Config.Zones.VehicleDelivery.Pos.y,
                                                                Config.Zones.VehicleDelivery.Pos.z
                                                            )
                                                            SetBlipRoute(Blips["NPCDelivery"], true)
                                                        end
                                                    end
                                                else
                                                    ESX.ShowNotification(
                                                        "<C>~r~Erreur~s~\n</C>Impossible~s~ d'attacher votre propre dépanneuse"
                                                    )
                                                end
                                            end
                                        else
                                            ESX.ShowNotification(
                                                "<C>~r~Erreur~s~\n</C>Il n'y a ~r~pas de véhicule~s~ à attacher"
                                            )
                                        end
                                    else
                                        AttachEntityToEntity(
                                            CurrentlyTowedVehicle,
                                            vehicle,
                                            20,
                                            -0.5,
                                            -12.0,
                                            1.0,
                                            0.0,
                                            0.0,
                                            0.0,
                                            false,
                                            false,
                                            false,
                                            false,
                                            20,
                                            true
                                        )
                                        DetachEntity(CurrentlyTowedVehicle, true, true)

                                        if NPCOnJob then
                                            if NPCTargetDeleterZone then
                                                if CurrentlyTowedVehicle == NPCTargetTowable then
                                                    ESX.Game.DeleteVehicle(NPCTargetTowable)
                                                    TriggerServerEvent("esx_bennysjob:onNPCJobMissionCompleted")
                                                    StopNPCJob()
                                                    NPCTargetDeleterZone = false
                                                else
                                                    ESX.ShowNotification(
                                                        "<C>~r~Erreur~s~\n</C>Ce n'est pas le bon véhicule"
                                                    )
                                                end
                                            else
                                                ESX.ShowNotification(
                                                    "<C>~r~Erreur~s~\n</C>Vous devez être au bon endroit pour faire cela"
                                                )
                                            end
                                        end

                                        CurrentlyTowedVehicle = nil
                                        ESX.ShowNotification("<C>~y~Succés~s~\n</C>Vehicule ~b~détaché~s~ avec succès!")
                                    end
                                else
                                    ESX.ShowNotification(
                                        "<C>~r~Erreur~s~\n</C>Impossible! ~s~Vous devez avoir un ~b~Flatbed ~s~pour ça"
                                    )
                                end
                            end
                        }
                    )
                else
                    RageUI.Button(
                        "Placer sur la remorque",
                        nil,
                        {RightLabel = "→"},
                        false,
                        {
                            onSelected = function()
                            end
                        }
                    )
                end
            end
        )
        if not RageUI.Visible(main) and not RageUI.Visible(IntVeh) then
            main = RMenu:DeleteType("main", true)
            IntVeh = RMenu:DeleteType("IntVeh", true)
        end
    end
end

Keys.Register(
    "F6",
    "flywheels",
    "Ouvrir le menu flywheels",
    function()
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "flywheels" then
            OpenMenuFlywheels()
        end
    end
)
