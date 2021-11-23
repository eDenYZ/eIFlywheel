ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("Ouvre:flywheels")
AddEventHandler(
    "Ouvre:flywheels",
    function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent(
                "esx:showAdvancedNotification",
                xPlayers[i],
                "<C>~y~Flywheels",
                "<C>~p~Annonce",
                "Le Flywheels est désormais ~g~Ouvert~s~!",
                eIFlywheels.Notif.Char,
                8
            )
        end
    end
)

RegisterServerEvent("Ferme:flywheels")
AddEventHandler(
    "Ferme:flywheels",
    function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent(
                "esx:showAdvancedNotification",
                xPlayers[i],
                "<C>~y~Flywheels",
                "<C>~p~Annonce",
                "Le Flywheels est désormais ~r~Fermer~s~!",
                eIFlywheels.Notif.Char,
                8
            )
        end
    end
)

RegisterServerEvent("flywheels:krick")
AddEventHandler(
    "flywheels:krick",
    function(ped, coords, veh)
        local _source = source
        TriggerClientEvent("mettrecrick", _source, ped, coords, veh)
    end
)

RegisterServerEvent("Recru:flywheels")
AddEventHandler(
    "Recru:flywheels",
    function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent(
                "esx:showAdvancedNotification",
                xPlayers[i],
                "<C>~y~Flywheels",
                "<C>~r~Annonce",
                "~y~Recrutement en cours, rendez-vous au Flywheels!",
                eIFlywheels.Notif.Char,
                8
            )
        end
    end
)

RegisterCommand(
    "fly",
    function(source, args, rawCommand)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.job.name == "flywheels" then
            local src = source
            local msg = rawCommand:sub(5)
            local args = msg
            if player ~= false then
                local name = GetPlayerName(source)
                local xPlayers = ESX.GetPlayers()
                for i = 1, #xPlayers, 1 do
                    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                    TriggerClientEvent(
                        "esx:showAdvancedNotification",
                        xPlayers[i],
                        "<C>~y~Flywheels",
                        "<C>~r~Annonce",
                        "" .. msg .. "",
                        eIFlywheels.Notif.Char,
                        0
                    )
                end
            else
                TriggerClientEvent(
                    "esx:showAdvancedNotification",
                    _source,
                    "<C>~y~Avertisement",
                    "<C>~r~Erreur",
                    "~r~Tu n'es pas membre de cette entreprise pour faire cette commande",
                    eIFlywheels.Notif.Char,
                    0
                )
            end
        else
            TriggerClientEvent(
                "esx:showAdvancedNotification",
                _source,
                "<C>~y~Avertisement",
                "<C>~r~Erreur",
                "~r~Tu n'es pas membre de cette entreprise pour faire cette commande",
                eIFlywheels.Notif.Char,
                0
            )
        end
    end,
    false
)

ESX.RegisterServerCallback(
    "eDen:getItemAmount",
    function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local quantity = xPlayer.getInventoryItem(item).count

        cb(quantity)
    end
)

RegisterNetEvent("eDen:gazbottle")
AddEventHandler(
    "eDen:gazbottle",
    function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = "gazbottle"
        xPlayer.removeInventoryItem(item, 1)
    end
)

RegisterNetEvent("eDen:moteurkit")
AddEventHandler(
    "eDen:moteurkit",
    function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = "moteurkit"
        xPlayer.removeInventoryItem(item, 1)
    end
)

RegisterNetEvent("eDen:carokit")
AddEventHandler(
    "eDen:carokit",
    function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = "carokit"
        xPlayer.removeInventoryItem(item, 1)
    end
)

RegisterNetEvent("eDen:chiffon")
AddEventHandler(
    "eDen:chiffon",
    function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = "chiffon"
        xPlayer.removeInventoryItem(item, 1)
    end
)

RegisterServerEvent("Appel:Flywheel")
AddEventHandler(
    "Appel:Flywheel",
    function()
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers, 1 do
            local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
            if thePlayer.job.name == "flywheels" then
                TriggerClientEvent(
                    "esx:showAdvancedNotification",
                    xPlayers[i],
                    "<C>~y~Flywheel",
                    "<C>~r~Accueil",
                    "Un mecano est appelé à l'accueil !",
                    eIFlywheels.Notif.Char,
                    8
                )
            end
        end
    end
)

RegisterServerEvent("Kit:giveItem")
AddEventHandler(
    "Kit:giveItem",
    function(Nom, Item)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local qtty = xPlayer.getInventoryItem(Item).count

        if qtty < 10 then
            xPlayer.addInventoryItem(Item, 1)
            TriggerClientEvent(
                "esx:showNotification",
                _source,
                "<C>- ~y~Flywheels\n~s~- ~g~Tu as recu des " .. Item .. " ~o~(+1)"
            )
        else
            TriggerClientEvent(
                "esx:showNotification",
                _source,
                "<C>- ~g~Flywheels\n~s~- ~o~Limite : 10 \n~s~- ~r~Maximum : ~r~" .. Item .. " atteints"
            )
        end
    end
)

ESX.RegisterServerCallback(
    "flywheel:playerinventory",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.inventory
        local all_items = {}

        for k, v in pairs(items) do
            if v.count > 0 then
                table.insert(all_items, {label = v.label, item = v.name, nb = v.count})
            end
        end

        cb(all_items)
    end
)

ESX.RegisterServerCallback(
    "flywheel:getStockItems",
    function(source, cb)
        local all_items = {}
        TriggerEvent(
            "esx_addoninventory:getSharedInventory",
            "society_flywheels",
            function(inventory)
                for k, v in pairs(inventory.items) do
                    if v.count > 0 then
                        table.insert(all_items, {label = v.label, item = v.name, nb = v.count})
                    end
                end
            end
        )
        cb(all_items)
    end
)

RegisterServerEvent("flywheel:putStockItems")
AddEventHandler(
    "flywheel:putStockItems",
    function(itemName, count)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item_in_inventory = xPlayer.getInventoryItem(itemName).count

        TriggerEvent(
            "esx_addoninventory:getSharedInventory",
            "society_flywheels",
            function(inventory)
                if item_in_inventory >= count and count > 0 then
                    xPlayer.removeInventoryItem(itemName, count)
                    inventory.addItem(itemName, count)
                    TriggerClientEvent(
                        "esx:showNotification",
                        xPlayer.source,
                        "<C>- ~y~Dépot\n~s~- ~g~Item ~s~: " .. itemName .. "\n~s~- ~o~Quantitée ~s~: " .. count .. ""
                    )
                else
                    TriggerClientEvent(
                        "esx:showNotification",
                        xPlayer.source,
                        "<C>~r~Vous n'en avez pas assez sur vous"
                    )
                end
            end
        )
    end
)

RegisterServerEvent("flywheel:takeStockItems")
AddEventHandler(
    "flywheel:takeStockItems",
    function(itemName, count)
        local xPlayer = ESX.GetPlayerFromId(source)

        TriggerEvent(
            "esx_addoninventory:getSharedInventory",
            "society_flywheels",
            function(inventory)
                xPlayer.addInventoryItem(itemName, count)
                inventory.removeItem(itemName, count)
                TriggerClientEvent(
                    "esx:showNotification",
                    xPlayer.source,
                    "<C>- ~r~Retrait\n~s~- ~g~Item ~s~: " .. itemName .. "\n~s~- ~o~Quantitée ~s~: " .. count .. ""
                )
            end
        )
    end
)

RegisterServerEvent("flywheel:withdrawMoney")
AddEventHandler(
    "flywheel:withdrawMoney",
    function(society, amount, money_soc)
        local xPlayer = ESX.GetPlayerFromId(source)
        local src = source

        TriggerEvent(
            "esx_addonaccount:getSharedAccount",
            society,
            function(account)
                if account.money >= tonumber(amount) then
                    xPlayer.addMoney(amount)
                    account.removeMoney(amount)
                    TriggerClientEvent(
                        "esx:showNotification",
                        src,
                        "<C>- ~o~Retiré \n~s~- ~g~Somme : " .. amount .. "$"
                    )
                else
                    TriggerClientEvent("esx:showNotification", src, "<C>- ~r~L'entreprise \n~s~- ~g~Pas assez d'argent")
                end
            end
        )
    end
)

RegisterServerEvent("flywheel:depositMoney")
AddEventHandler(
    "flywheel:depositMoney",
    function(society, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        local src = source

        TriggerEvent(
            "esx_addonaccount:getSharedAccount",
            society,
            function(account)
                if money >= tonumber(amount) then
                    xPlayer.removeMoney(amount)
                    account.addMoney(amount)
                    TriggerClientEvent(
                        "esx:showNotification",
                        src,
                        "<C>- ~o~Déposé \n~s~- ~g~Somme : " .. amount .. "$"
                    )
                else
                    TriggerClientEvent("esx:showNotification", src, "<C>- ~r~Erreur \n~s~- ~g~Pas assez d'argent")
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "flywheel:getSocietyMoney",
    function(source, cb, soc)
        local money = nil
        MySQL.Async.fetchAll(
            "SELECT * FROM addon_account_data WHERE account_name = @society ",
            {
                ["@society"] = soc
            },
            function(data)
                for _, v in pairs(data) do
                    money = v.money
                end
                cb(money)
            end
        )
    end
)
