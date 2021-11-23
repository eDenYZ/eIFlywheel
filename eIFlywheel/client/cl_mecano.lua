CustomFlywheel = function()
    local main = RageUI.CreateMenu("Custom", "Flywheels")
    local test = RageUI.CreateSubMenu(main, "Vérification", "Êtat")
    local extra = RageUI.CreateSubMenu(main, "Menu Extra", "Extra")
    local CustomListe = {"Avant", "Arrière", "Gauche", "Droit"}
    local Camindex = 1
    RageUI.Visible(main, not RageUI.Visible(main))
    local camveh = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamActive(camveh, true)
    SetFocusArea(1763.2087402344, 3326.6770019531, 41.80, 0.0, 0.0, 0.0)
    SetCamParams(camveh, 1763.2087402344, 3326.6770019531, 41.80, 10, 0.0, 300.0, 60.0, 0, 1, 1, 2)
    RenderScriptCams(true, true, 3000, true, true)
    Wait(3500)
    while main do
        Citizen.Wait(0)

        RageUI.IsVisible(
            main,
            function()
                RageUI.List(
                    "Caméra",
                    CustomListe,
                    Camindex,
                    nil,
                    {},
                    true,
                    {
                        onListChange = function(Index)
                            Camindex = Index
                        end,
                        onSelected = function(Index)
                            if Index == 1 then
                                SetCamParams(
                                    camveh,
                                    1763.2087402344,
                                    3326.6770019531,
                                    41.80,
                                    10,
                                    0.0,
                                    300.0,
                                    60.0,
                                    0,
                                    1,
                                    1,
                                    2
                                )
                            elseif Index == 2 then
                                SetCamParams(
                                    camveh,
                                    1772.7561035156,
                                    3332.3471679688,
                                    41.80,
                                    10,
                                    0.0,
                                    120.0,
                                    60.0,
                                    0,
                                    1,
                                    1,
                                    2
                                )
                            elseif Index == 3 then
                                SetCamParams(
                                    camveh,
                                    1770.0395507812,
                                    3325.912109375,
                                    41.80,
                                    10,
                                    0.0,
                                    28.0,
                                    60.0,
                                    0,
                                    1,
                                    1,
                                    2
                                )
                            elseif Index == 4 then
                                SetCamParams(
                                    camveh,
                                    1765.8857421875,
                                    3332.8483886719,
                                    41.80,
                                    10,
                                    0.0,
                                    206.0,
                                    60.0,
                                    0,
                                    1,
                                    1,
                                    2
                                )
                            end
                        end
                    }
                )

                RageUI.Button(
                    "Effectuer un diagnostic",
                    nil,
                    {},
                    true,
                    {
                        onSelected = function()
                        end
                    },
                    test
                )

                RageUI.Button(
                    "Menu extra",
                    nil,
                    {},
                    true,
                    {
                        onSelected = function()
                        end
                    },
                    extra
                )
            end
        )

        RageUI.IsVisible(
            test,
            function()
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local vievehicule = GetVehicleEngineHealth(vehicle) / 10
                local vievehicule = math.floor(vievehicule)
                RageUI.Button(
                    "Etat du moteur : ",
                    nil,
                    {RightLabel = "~g~" .. vievehicule .. "~s~/100"},
                    true,
                    {LeftBadge = RageUI.BadgeStyle.Star}
                )

                vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                fuel = tostring(math.ceil(GetVehicleFuelLevel(vehicle)))
                RageUI.Button("Réservoir : ", nil, {RightLabel = "~g~" .. fuel .. "~s~/100L"}, true, {})

                vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                OilLevel = GetVehicleOilLevel(vehicle)
                local OilLevle1 = math.floor(OilLevel)
                RageUI.Button(
                    "Niveau du réservoir d'huile :~r~ ",
                    nil,
                    {RightLabel = "~g~" .. OilLevle1 .. "~s~/5L"},
                    true,
                    {LeftBadge = RageUI.BadgeStyle.Star}
                )

                vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local model = GetEntityModel(vehicle)
                local name = GetDisplayNameFromVehicleModel(model)
                RageUI.Button(
                    "Nom du vehicule :~g~ ",
                    nil,
                    {RightLabel = "~g~" .. name .. ""},
                    true,
                    {LeftBadge = RageUI.BadgeStyle.Star}
                )

                vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                plaque = GetVehicleNumberPlateText(vehicle)
                RageUI.Button("Plaque : ", nil, {RightLabel = "~g~" .. plaque}, true, {})

                vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                Temp = GetVehicleEngineTemperature(vehicle)
                local Temperature = math.floor(Temp)
                RageUI.Button(
                    "Température du moteur :~r~ ",
                    nil,
                    {RightLabel = "~g~" .. Temperature .. "°C"},
                    true,
                    {LeftBadge = RageUI.BadgeStyle.Star}
                )
            end
        )

        RageUI.IsVisible(
            extra,
            function()
                local pPed = GetPlayerPed(-1)
                local pCoords = GetEntityCoords(pPed)
                local pInVeh = IsPedInAnyVehicle(pPed, false)
                if pInVeh then
                    local pVeh = GetVehiclePedIsIn(pPed, false)
                    local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
                    if isInRightSeat then
                        for i = 1, 9 do
                            if DoesExtraExist(pVeh, i) then
                                if IsVehicleExtraTurnedOn(pVeh, i) then
                                    RageUI.Button(
                                        "~r~Désactiver~s~ l'extra " .. i,
                                        nil,
                                        {LeftBadge = RageUI.BadgeStyle.Star},
                                        true,
                                        {
                                            onSelected = function()
                                                SetVehicleExtra(pVeh, i, true)
                                            end
                                        }
                                    )
                                else
                                    RageUI.Button(
                                        "~g~Activer~s~ l'extra " .. i,
                                        nil,
                                        {LeftBadge = RageUI.BadgeStyle.Star},
                                        true,
                                        {
                                            onSelected = function()
                                                SetVehicleExtra(pVeh, i, false)
                                            end
                                        }
                                    )
                                end
                            end
                        end
                    end
                end
            end
        )
        if not RageUI.Visible(main) and not RageUI.Visible(test) and not RageUI.Visible(extra) then
            main = RMenu:DeleteType("main", true, camDel())
            test = RMenu:DeleteType("test", true)
            test = RMenu:DeleteType("extra", true)
        end
    end
end
