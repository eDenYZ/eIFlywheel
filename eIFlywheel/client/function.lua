tempVeh = nil
local tempModel = nil

function MarqueurVehicule()
    local pos = GetEntityCoords(PlayerPedId())
    local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
    pos = GetEntityCoords(veh)
    local target, distance = ESX.Game.GetClosestVehicle()
    if distance <= 8.0 then
        DrawMarker(
            20,
            pos.x,
            pos.y,
            pos.z + 1.7,
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
    end
end

all_items = {}

function getInventory()
    ESX.TriggerServerCallback(
        "flywheel:playerinventory",
        function(inventory)
            all_items = inventory
        end
    )
end

function getStock()
    ESX.TriggerServerCallback(
        "flywheel:getStockItems",
        function(inventory)
            all_items = inventory
        end
    )
end

societyflywheel = nil

function RefreshMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" then
        ESX.TriggerServerCallback(
            "flywheel:getSocietyMoney",
            function(money)
                societyflywheel = money
            end,
            "society_" .. ESX.PlayerData.job.name
        )
    end
end

function Updatessocietyflywheelmoney(money)
    societyflywheel = ESX.Math.GroupDigits(money)
end

function ObjectInFront(ped, pos)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.5, 0.0)
    local car = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 30, ped, 0)
    local _, _, _, _, result = GetRaycastResult(car)
    return result
end

function camDel()
    DestroyCam(camveh)
    ClearFocus()
    RenderScriptCams(0, 0, 300, 1, 1, 0)
    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), false)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", 10)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

local haveprogress
function DoesAnyProgressBarExists()
    return haveprogress
end
function DrawNiceText(Text, Text3, Taille, Text2, Font, Justi, havetext)
    SetTextFont(Font)
    SetTextScale(Taille, Taille)
    SetTextColour(255, 255, 255, 255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
    if havetext then
        SetTextWrap(Text, Text + .1)
    end
    AddTextComponentString(Text2)
    DrawText(Text, Text3)
end
local petitpoint = {".", "..", "...", ""}
function getObjInSight()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped) + vector3(.0, .0, -.4)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0) + vector3(.0, .0, -.4)
    local rayHandle = StartShapeTestRay(pos, entityWorld, 16, ped, 0)
    local _, _, _, _, ent = GetRaycastResult(rayHandle)

    if not IsEntityAnObject(ent) then
        return
    end
    return ent
end
function createProgressBar(Text, r, g, b, a, Timing, NoTiming)
    if not Timing then
        return
    end
    killProgressBar()
    haveprogress = true
    Citizen.CreateThread(
        function()
            local Timing1, Timing2 = .0, GetGameTimer() + Timing
            local E, Timing3 = ""
            while haveprogress and (not NoTiming and Timing1 < 1) do
                Citizen.Wait(0)
                if not NoTiming or Timing1 < 1 then
                    Timing1 = 1 - ((Timing2 - GetGameTimer()) / Timing)
                end
                if not Timing3 or GetGameTimer() >= Timing3 then
                    Timing3 = GetGameTimer() + 500
                    E = petitpoint[string.len(E) + 1] or ""
                end
                DrawRect(.5, .875, .15, .03, 0, 0, 0, 100)
                local y, endroit = .15 - .0025, .03 - .005
                local chance = math.max(0, math.min(y, y * Timing1))
                DrawRect((.5 - y / 2) + chance / 2, .875, chance, endroit, r, g, b, a) -- 0,155,255,125
                DrawNiceText(.5, .875 - .0125, .3, (Text or "Action en cours") .. E, 0, 0, false)
            end
            killProgressBar()
        end
    )
end
function killProgressBar()
    haveprogress = nil
end

function camgarage()
    cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
    SetCamCoord(cam, 1782.6988525391, 3320.5319824219, 41.378051757812, 0.0, 0.0, 116.22047424316, 15.0, false, 0)
    RenderScriptCams(1000, 1000, 1000, 1000, 1000)
    PointCamAtCoord(cam, 1782.6988525391, 3320.5319824219, 41.378051757812)
end

function stopprevue()
    RenderScriptCams(0, 0, 500, 0, 0)
    TriggerEvent("InitCamModulePause", false)
    DeleteEntity(tempVeh)
    tempVeh = nil
    tempModel = nil
end

function UpdateCam(model, coords, heading)
    if model == tempModel then
        return
    else
        if tempVeh ~= nil then
            DeleteEntity(tempVeh)
            tempVeh = nil
        end

        RequestModel(GetHashKey(model))
        while not HasModelLoaded(GetHashKey(model)) do
            Wait(1)
        end

        tempModel = model
        tempVeh = CreateVehicle(GetHashKey(model), coords, heading, 0, 0)
        FreezeEntityPosition(tempVeh, true)
        SetEntityAlpha(tempVeh, 180, 180)

        local camCoords = GetOffsetFromEntityInWorldCoords(tempVeh, 3.0, 2.0, 2.0)
    end
end

function InitBlips()
    for i = 1, #eIFlywheels.BlipsJob.Blip, 1 do
        local CreateBlip = AddBlipForCoord(eIFlywheels.BlipsJob.Blip[i].pos)

        SetBlipSprite(CreateBlip, eIFlywheels.BlipsJob.Blip[i].id)
        SetBlipScale(CreateBlip, eIFlywheels.BlipsJob.Blip[i].scale)
        SetBlipDisplay(CreateBlip, eIFlywheels.BlipsJob.Blip[i].display)
        SetBlipColour(CreateBlip, eIFlywheels.BlipsJob.Blip[i].color)
        SetBlipAsShortRange(CreateBlip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(eIFlywheels.BlipsJob.Blip[i].name)
        EndTextCommandSetBlipName(CreateBlip)
    end
end

function InitPed()
    for i = 1, #eIFlywheels.PedJob.Ped, 1 do
        local hash = GetHashKey(eIFlywheels.PedJob.Ped[i].PedName)
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end
        ped =
            CreatePed(
            "PED_TYPE_CIVFEMALE",
            eIFlywheels.PedJob.Ped[i].PedName,
            eIFlywheels.PedJob.Ped[i].pos,
            false,
            true
        )
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
    end
end

RegisterNetEvent("mettrecrick")
AddEventHandler(
    "mettrecrick",
    function(ped, coords, veh)
        local dict
        local model = "prop_carjack"
        local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, -2.0, 0.0)
        local headin = GetEntityHeading(ped)
        local vehicle = ESX.Game.GetVehicleInDirection()
        FreezeEntityPosition(veh, true)
        local vehpos = GetEntityCoords(veh)
        dict = "mp_car_bomb"
        RequestAnimDict(dict)
        RequestModel(model)
        while not HasAnimDictLoaded(dict) or not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
        local vehjack = CreateObject(GetHashKey(model), vehpos.x, vehpos.y, vehpos.z - 0.5, true, true, true)
        AttachEntityToEntity(vehjack, veh, 0, 0.0, 0.0, -1.0, 0.0, 0.5, 0.5, false, false, false, false, 0, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
        Citizen.Wait(1250)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.3, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        dict = "move_crawl"
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.4, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.5, true, true, true)
        SetEntityCollision(veh, false, false)
        TaskPedSlideToCoord(ped, offset, headin, 1050)
        Citizen.Wait(1000)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(100)
        end
        TaskPlayAnimAdvanced(ped, dict, "onback_bwd", coords, 0.0, 0.0, headin - 180, 1.0, 0.5, 3000, 1, 0.0, 1, 1)
        dict = "amb@world_human_vehicle_mechanic@male@base"
        Citizen.Wait(3000)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
        TaskPlayAnim(ped, dict, "base", 8.0, -8.0, 5000, 1, 0, false, false, false)
        dict = "move_crawl"
        Citizen.Wait(5000)
        local coords2 = GetEntityCoords(ped)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
        TaskPlayAnimAdvanced(ped, dict, "onback_fwd", coords2, 0.0, 0.0, headin - 180, 1.0, 0.5, 4000, 1, 0.0, 1, 1)
        Citizen.Wait(4200)
        dict = "mp_car_bomb"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
        Citizen.Wait(50)
        ClearPedTasksImmediately(playerPed)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
        Citizen.Wait(1250)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.4, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.3, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        dict = "move_crawl"
        Citizen.Wait(1000)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)
        TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
        SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z, true, true, true)
        FreezeEntityPosition(veh, false)
        DetachEntity(vehkack, veh, true)
        DeleteObject(vehjack)
        SetEntityCollision(veh, true, true)
        ESX.ShowNotification("<C>~y~Réparation~s~\n</C>~g~Votre moteur a était reparer correctement")
        ESX.ShowNotification("<C>~y~Succés~s~\n</C>Vous avez utilisé ~b~x1 Kit Moteur")
    end
)
