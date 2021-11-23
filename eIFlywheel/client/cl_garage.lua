GarageFlywheels = function()
    local main = RageUI.CreateMenu("Garage", "Flywheels")
    RageUI.Visible(main, not RageUI.Visible(main))
    camgarage()
    while main do
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.Wait(0)

        RageUI.IsVisible(
            main,
            function()
                for k, v in pairs(eIFlywheels.Garage) do
                    RageUI.Button(
                        v.Label,
                        nil,
                        {RightLabel = "→"},
                        not codesCooldown,
                        {
                            onActive = function()
                                UpdateCam(v.Name, v.PositionVeh, v.HeadingVeh)
                            end,
                            onSelected = function()
                                codesCooldown = true
                                RageUI.CloseAll()
                                DoScreenFadeOut(1000)
                                Citizen.Wait(1000)
                                Wait(200)
                                local model = GetHashKey(v.Name)
                                RequestModel(model)
                                while not HasModelLoaded(model) do
                                    Citizen.Wait(10)
                                end
                                local pos = GetEntityCoords(PlayerPedId())
                                local vehicle = CreateVehicle(model, v.PositionVeh, v.HeadingVeh, true, true)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                DoScreenFadeIn(2000)
                                Wait(1000)
                                Citizen.SetTimeout(
                                    2000,
                                    function()
                                        codesCooldown = false
                                    end
                                )
                            end
                        }
                    )
                end
            end
        )
        if not RageUI.Visible(main) then
            main = RMenu:DeleteType("main", true, stopprevue())
        end
        FreezeEntityPosition(PlayerPedId(), false)
    end
end
