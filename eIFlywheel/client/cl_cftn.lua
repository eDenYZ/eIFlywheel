TenueFlywheels = function()
    local main = RageUI.CreateMenu("Flywheels", "Flywheels")
    local coffre = RageUI.CreateSubMenu(main, "Coffre", "Coffre")
    local DepObjet = RageUI.CreateSubMenu(main, "Inventaire", "Déposer des Objets")
    local PreObjet = RageUI.CreateSubMenu(main, "Inventaire", "Retirer des Objets")
    local tenue = RageUI.CreateSubMenu(main, "Tenue", "Tenue")
    local boss = RageUI.CreateSubMenu(main, "Menu Boss", "Boss")
    local flitreliste = {"Coffre", "Vestaire", "Patron"}
    local flitreindex = 1
    local cftn = 1
    RageUI.Visible(main, not RageUI.Visible(main))
    while main do
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.Wait(0)

        RageUI.IsVisible(
            main,
            function()
                RageUI.List(
                    "Flitre :",
                    flitreliste,
                    flitreindex,
                    nil,
                    {},
                    true,
                    {
                        onListChange = function(Index)
                            flitreindex = Index
                            cftn = Index
                        end
                    }
                )

                if cftn == 1 then
                    RageUI.Button(
                        "Déposer Objet(s)",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onSelected = function()
                                getInventory()
                            end
                        },
                        DepObjet
                    )

                    RageUI.Button(
                        "Prendre Objet(s)",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onSelected = function()
                                getStock()
                            end
                        },
                        PreObjet
                    )
                elseif cftn == 2 then
                    RageUI.Button(
                        "Tenue de Service",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onSelected = function()
                                TriggerEvent(
                                    "skinchanger:getSkin",
                                    function(skin)
                                        if skin.sex == 0 then
                                            TriggerEvent("skinchanger:loadClothes", skin, eIFlywheels.Tenues.male)
                                        elseif skin.sex == 1 then
                                            TriggerEvent("skinchanger:loadClothes", skin, eIFlywheels.Tenues.female)
                                        end
                                    end
                                )
                            end
                        }
                    )

                    RageUI.Button(
                        "Tenue Civil",
                        nil,
                        {RightLabel = "→"},
                        true,
                        {
                            onSelected = function()
                                ESX.TriggerServerCallback(
                                    "esx_skin:getPlayerSkin",
                                    function(skin)
                                        TriggerEvent("skinchanger:loadSkin", skin)
                                    end
                                )
                            end
                        }
                    )
                elseif cftn == 3 then
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" then
                        if societyflywheel ~= nil then
                            RageUI.Button(
                                "Argent de la société:",
                                nil,
                                {RightLabel = "~g~" .. societyflywheel .. "$"},
                                true,
                                {onSelected = function()
                                    end}
                            )
                        end

                        RageUI.Separator("↓ Actions ↓")

                        RageUI.Button(
                            "Retirer de l'argent.",
                            nil,
                            {RightLabel = ">"},
                            true,
                            {
                                onSelected = function()
                                    local money = KeyboardInput("Combien voulez vous retirer :", "", 10)
                                    TriggerServerEvent(
                                        "flywheel:withdrawMoney",
                                        "society_" .. ESX.PlayerData.job.name,
                                        money
                                    )
                                    RefreshMoney()
                                end
                            }
                        )

                        RageUI.Button(
                            "Déposer de l'argent.",
                            nil,
                            {RightLabel = ">"},
                            true,
                            {
                                onSelected = function()
                                    local money = KeyboardInput("Combien voulez vous retirer :", "", 10)
                                    TriggerServerEvent(
                                        "flywheel:depositMoney",
                                        "society_" .. ESX.PlayerData.job.name,
                                        money
                                    )
                                    RefreshMoney()
                                end
                            }
                        )

                        RageUI.Button(
                            "Rafraichir le compte.",
                            nil,
                            {RightLabel = ">"},
                            true,
                            {
                                onSelected = function()
                                    RefreshMoney()
                                end
                            }
                        )
                    else
                        RageUI.Separator("")
                        RageUI.Separator("Vous n'êtes pas patron")
                        RageUI.Separator("")
                    end
                end
            end
        )

        RageUI.IsVisible(
            coffre,
            function()
                RageUI.Button(
                    "Déposer Objet(s)",
                    nil,
                    {},
                    true,
                    {
                        onSelected = function()
                            getInventory()
                        end
                    },
                    DepObjet
                )

                RageUI.Button(
                    "Prendre Objet(s)",
                    nil,
                    {},
                    true,
                    {
                        onSelected = function()
                            getStock()
                        end
                    },
                    PreObjet
                )
            end
        )

        RageUI.IsVisible(
            PreObjet,
            function()
                for k, v in pairs(all_items) do
                    RageUI.Button(
                        v.label,
                        nil,
                        {RightLabel = "~g~x" .. v.nb},
                        true,
                        {
                            onSelected = function()
                                local count = KeyboardInput("Combien voulez vous en déposer", nil, 4)
                                count = tonumber(count)
                                if count <= v.nb then
                                    TriggerServerEvent("flywheel:takeStockItems", v.item, count)
                                else
                                    ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                                end
                                getStock()
                            end
                        }
                    )
                end
            end
        )

        RageUI.IsVisible(
            DepObjet,
            function()
                for k, v in pairs(all_items) do
                    RageUI.Button(
                        v.label,
                        nil,
                        {RightLabel = "~g~x" .. v.nb},
                        true,
                        {
                            onSelected = function()
                                local count = KeyboardInput("Combien voulez vous en déposer", nil, 4)
                                count = tonumber(count)
                                TriggerServerEvent("flywheel:putStockItems", v.item, count)
                                getInventory()
                            end
                        }
                    )
                end
            end
        )

        RageUI.IsVisible(
            tenue,
            function()
                RageUI.Button(
                    "Tenue de Service",
                    nil,
                    {RightLabel = "→"},
                    true,
                    {
                        onSelected = function()
                            TriggerEvent(
                                "skinchanger:getSkin",
                                function(skin)
                                    if skin.sex == 0 then
                                        TriggerEvent("skinchanger:loadClothes", skin, eIFlywheels.Tenues.male)
                                    elseif skin.sex == 1 then
                                        TriggerEvent("skinchanger:loadClothes", skin, eIFlywheels.Tenues.male)
                                    end
                                end
                            )
                        end
                    }
                )

                RageUI.Button(
                    "Tenue Civil",
                    nil,
                    {RightLabel = "→"},
                    true,
                    {
                        onSelected = function()
                            ESX.TriggerServerCallback(
                                "esx_skin:getPlayerSkin",
                                function(skin)
                                    TriggerEvent("skinchanger:loadSkin", skin)
                                end
                            )
                        end
                    }
                )
            end
        )
        if
            not RageUI.Visible(main) and not RageUI.Visible(tenue) and not RageUI.Visible(coffre) and
                not RageUI.Visible(PreObjet) and
                not RageUI.Visible(DepObjet)
         then
            main = RMenu:DeleteType("main", true)
            tenue = RMenu:DeleteType("tenue", true)
            coffre = RMenu:DeleteType("coffre", true)
            PreObjet = RMenu:DeleteType("PreObjet", true)
            DepObjet = RMenu:DeleteType("DepObjet", true)
        end
        FreezeEntityPosition(PlayerPedId(), false)
    end
end
