KitFlywheels = function()
    local main = RageUI.CreateMenu("Kit", "Flywheels")
    RageUI.Visible(main, not RageUI.Visible(main))
    while main do
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.Wait(0)

        RageUI.IsVisible(
            main,
            function()
                for k, v in pairs(eIFlywheels.Kit) do
                    RageUI.Button(
                        v.Nom,
                        nil,
                        {RightLabel = "(x1)"},
                        true,
                        {
                            onSelected = function()
                                TriggerServerEvent("Kit:giveItem", v.Nom, v.Item)
                            end
                        }
                    )
                end
            end
        )
        if not RageUI.Visible(main) then
            main = RMenu:DeleteType("main", true)
        end
        FreezeEntityPosition(PlayerPedId(), false)
    end
end
