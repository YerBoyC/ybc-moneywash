local logger = require '@qbx_core.modules.logger' -- QBX functionality for logging events to both discord AND API. 
local resource = GetCurrentResourceName()

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        for k,v in pairs(Config.washers) do 
            local stash = {
                id = 'Washer #'..k,
                label = 'Washer #'..k,
                slots = 50,
                weight = 100000,
                owner = false,
            }
            exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)
        end
    end
end)

lib.callback.register('wp-moneywash:server:isWasherBusy', function(source, washerId)
    local src = source
    local result = Config.washers[washerId].washing
    return result
end)

RegisterServerEvent("wp-moneywash:server:startWasher", function(data)
    local src = source

    if not Config.washers[data.washerId].washing then
        Config.washers[data.washerId].washing = true
        logger.log({ -- QBX functionality for logging events to both discord AND API. 
        source = resource,
        webhook = Config.webhook,
        event = 'Washing Started',
        color = 'green',
        message = ('Washer #%s has just started...'):format(data.washerId),
        })
        wash(src, data.washerId)
    else 
        lib.notify(src, {
            title = 'This washer is already started!',
            description = nil,
            type = "error",
            position = 'top-right',
            duration = 5000,
        })
    end
end)

RegisterServerEvent("wp-moneywash:server:collectMoney", function(data, washerId)
    local src = source
    local player = exports.qbx_core:GetPlayer(source)
    local firstName = player.PlayerData.charinfo.firstname
    local lastName = player.PlayerData.charinfo.lastname

    if Config.washers[data.washerId].pickup then
        if Config.washers[data.washerId].cleaned > 0 then
            exports.ox_inventory:AddItem(src, 'cash', Config.washers[data.washerId].cleaned, false, false)
            logger.log({ -- QBX functionality for logging events to both discord AND API. 
                source = resource,
                webhook = Config.webhook,
                event = 'Money Retrieved',
                color = 'orange',
                message = ('%s %s has retrieved $%s clean from washer #%s'):format(firstName, lastName, Config.washers[data.washerId].cleaned, data.washerId),
            })
            Config.washers[data.washerId].cleaned = 0
            Config.washers[data.washerId].pickup = false
            Config.washers[data.washerId].washing = false
        else 
            lib.notify(src, {
                title = 'No clean money to collect!',
                description = nil,
                type = "success",
                position = 'top-right',
                duration = 5000,
            })
            Config.washers[data.washerId].cleaned = 0
            Config.washers[data.washerId].pickup = false
            Config.washers[data.washerId].washing = false
        end
    else
        lib.notify(src, {
            title = 'Nothing is ready to be picked up!',
            description = nil,
            type = "error",
            position = 'top-right',
            duration = 5000,
        })
    end
end)

function wash(src, washerId)
    local stash = 'Washer #'..washerId
    local amount = exports.ox_inventory:GetItem(stash, Config.washableItem, nil, true) -- checks stash for amount of item and returns the amount if true
    local cleaned = (amount * Config.conversionRate)


    if cleaned > 0 then
        Config.washers[washerId].washing = true
        TriggerClientEvent('wp-moneywash:client:email', src, true)
        lib.notify(src, {
            title = 'Cleaning Started',
            description = 'Thank you for trusting us with your clothing! Check your email for more info',
            type = "success",
            position = 'top-right',
            duration = 5000,
        })
        if cleaned <= 5000 then  -- compares potential clean cash with number. if paramaters met, wait that amound of time. 
            Wait(60000) -- 1 min
        elseif cleaned > 5000 and cleaned <= 10000 then 
            Wait(120000) -- 2 min
        elseif cleaned > 10000 and cleaned <= 20000 then 
            Wait(180000) -- 3 min
        else
            Wait(300000) -- 5 min
        end
        Config.washers[washerId].cleaned = cleaned
        Config.washers[washerId].pickup = true
        TriggerClientEvent("wp-moneywash:client:email", src, false)
        exports.ox_inventory:RemoveItem(stash, Config.washableItem, amount, nil, nil, amount)
        logger.log({ -- QBX functionality for logging events to both discord AND API. 
            source = resource,
            webhook = Config.webhook,
            event = 'Washing Complete',
            color = 'yellow',
            message = ('%s has just finished converting $%s dirty to $%s clean. This money has NOT been retrieved'):format(stash, amount, cleaned),
        })
    else
        lib.notify(src, {
            title = 'There is no money to wash!',
            description = nil,
            type = "error",
            position = 'top-right',
            duration = 5000,
        })
        Config.washers[washerId].washing = false
    end
end