
local function moveToLocation(configType, registerNextZone)
  DoScreenFadeOut(500)
  while not IsScreenFadedOut() do
    Wait(10)
  end
  SetEntityCoords(PlayerPedId(), configType.x, configType.y, configType.z + 1, true, false, false, false)
  DoScreenFadeIn(500)
  TriggerEvent('wp-moneywash:client:registerZones')
end

RegisterNetEvent('wp-moneywash:client:registerZones', function()
  lib.zones.box({
    coords = Config.enterCoords,
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = Config.debugPoly,
    onEnter = function()
      lib.showTextUI('[E] - Enter Location')
    end,
    onExit = function()
        local _, text = lib.isTextUIOpen()
        if text =='[E] - Enter Location' then lib.hideTextUI() end
    end,
    inside = function()
        if IsControlJustPressed(0, 38) then
            moveToLocation(Config.exitCoords, 'exit')
            lib.hideTextUI()
        end
    end,
  })
  lib.zones.box({
    coords = Config.exitCoords,
    size = vec3(2, 2, 2),
    rotation = 90,
    debug = Config.debugPoly,
    onEnter = function()
      lib.showTextUI('[E] - Exit Location')
    end,
    onExit = function()
        local _, text = lib.isTextUIOpen()
        if text =='[E] - Exit Location' then lib.hideTextUI() end
    end,
    inside = function()
        if IsControlJustPressed(0, 38) then
            moveToLocation(Config.enterCoords, 'enter')
            lib.hideTextUI()
        end
    end,
  })
end)

CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do
      -- do nothing
      Wait(500)
    end

    for k,v in pairs(Config.washers) do -- Config target locations for washers
      moneywashZone = exports.ox_target:addBoxZone({
          name = 'Washer #'..k,
          coords = Config.washers[k].location,
          rotation = 0.0,
          size = vec3(1.2, 2.65, 2.0),
          distance = 1.0,
          debug = Config.debugPoly,
          options = {
              {
                  icon = 'fa-solid fa-house',
                  type = 'client',
                  event = 'wp-moneywash:client:isWashing',
                  label = 'Open Washer #'..k,
                  distance = 1,
                  washerId = k,
              },
              {
                icon = 'fa-solid fa-house',
                type = 'server',
                serverEvent = 'wp-moneywash:server:startWasher',
                label = 'Start Washing',
                distance = 1,
                washerId = k,
              },
              {
                icon = 'fa-solid fa-house',
                type = 'server',
                serverEvent = 'wp-moneywash:server:collectMoney',
                label = 'Collect From Washer',
                distance = 1,
                washerId = k,
              },
          },
      })
    end
    Wait(100)
    TriggerEvent('wp-moneywash:client:registerZones') -- configure teleports for IPL
end)

RegisterNetEvent('wp-moneywash:client:isWashing', function(data)
  local isWashing = lib.callback.await('wp-moneywash:server:isWasherBusy', false, data.washerId)

    if isWashing == true then
      lib.notify({
				type = 'error',
				icon = 'unlock',
        title = 'This washer is currently running. Try collecting now or again later..',
				description = nil,
        duration = 5000
			})
    else
      exports.ox_inventory:openInventory('stash', 'Washer #'..data.washerId)
    end
end)

RegisterNetEvent('wp-moneywash:client:email', function(isStarting)
  local messageBody = nil

  if isStarting then 
    messageBody = Config.startMessage
  else 
    messageBody = Config.readyMessage
    lib.notify({
      title = 'Your washer completed it\'s cycle!',
      description = nil,
      type = "info",
      position = 'top-right',
      duration = 5000,
  })
  end

  TriggerServerEvent('qb-phone:server:sendNewMail', {
    sender = Config.messageSender,
    subject = Config.messageSubject,
    message = messageBody,
    button = {}
  })
end)