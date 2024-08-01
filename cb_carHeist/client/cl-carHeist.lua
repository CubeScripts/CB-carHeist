ESX = exports["es_extended"]:getSharedObject()

local target = exports.ox_target 

local npc = {}
local TSE = TriggerServerEvent
local currentVehicle = nil

function randomDeveliry(nwm)
    return Config.Develiry[math.random(1, #nwm)]
end

function randomVehicle(nwm)
    return Config.Cars[math.random(1, #nwm)]
end


function notify(title,msg,type)
    lib.notify({title=title, description = msg, type = type})
end

local coords = randomDeveliry(Config.Develiry)
local vehicle = randomVehicle(Config.Cars)

CreateThread(function()
    for k,v in pairs(Config.Start) do
        target:addSphereZone({
            coords = vector3(752.9344, -3198.6931, 6.1865), 
            radius = 1.0,
            debug = false,
            options = {
                name = 'startHeist',
                icon = "fa-solid fa-car",
                label = "zeptat se na praci",
                onSelect = function ()
                    local CarSpawn = vec3(772.6454, -3194.5818, 5.9008)
                    local heading = 269.6491
                    local car = GetHashKey(vehicle)
                    RequestModel(car)
                    while not HasModelLoaded(car) do 
                        Wait(500)
                    end
                    currentVehicle = CreateVehicle(car, CarSpawn.x, CarSpawn.y, CarSpawn.z, heading, true, true)
                    SetNewWaypoint(coords.x, coords.y)
                    local model = "g_m_m_armgoon_01"
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(500)
                    end
                    local ped = CreatePed(4, model, coords, false, true)
                    SetEntityAsMissionEntity(ped, true, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    SetPedDiesWhenInjured(ped, false)
                    SetPedCanRagdollFromPlayerImpact(ped, false)
                    SetPedCanRagdoll(ped, false)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    table.insert(npc, ped)

                    CreateThread(function ()
                        target:addLocalEntity(npc, { 
                            name = 'develiry',
                            icon = "fa-solid fa-car",
                            label = "vratit vozidlo",
                            onSelect = function ()
                                if currentVehicle then
                                    if DoesEntityExist(currentVehicle) then
                                        DeleteEntity(currentVehicle)
                                        notify('Vozidlo', "Úspěšně si odevzdal vozidlo", "sucess")
                                    end
                                    currentVehicle = nil
                                    TSE("cb_carHeist:server:payout", Config.Price) 
                                end
                            end
                        })
                    end)
                end
            }
        })
    end
end)
