ESX = exports["es_extended"]:getSharedObject()

function randomPrice(nwm)
    return Config.Price[math.random(1, #nwm)]
end

local price = randomPrice(Config.Price)
local inventory = exports.ox_inventory:Inventory()
RegisterNetEvent('cb_carHeist:server:payout')
AddEventHandler('cb_carHeist:server:payout', function ()
    inventory.AddItem(source,'money', price)
end)