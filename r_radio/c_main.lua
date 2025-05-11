local currentChannel = nil

RegisterCommand("radio", function(source, args)
    if #args < 1 then
        checkHasRadio(function(hasRadio)
            if hasRadio then
                openRadioMenu()
            else
                notify(Locales[Config.Locale]['no_radio'])
            end
        end)
        return
    end

    local freq = tonumber(args[1])
    if not freq or not Config.Frequencies[freq] then
        notify("CHANGE_HERE")
        return
    end

    checkHasRadio(function(hasRadio)
        if hasRadio then
            TriggerServerEvent("r_radio:checkAccess", freq)
        else
            notify(Locales[Config.Locale]['no_radio'])
        end
    end)
end)

RegisterCommand("radiooff", function()
    leaveRadioChannel()
end)

RegisterNetEvent('r_radio:accessGranted', function(channel)
    local freq = Config.Frequencies[channel]
    playRadioAnim()
    exports["pma-voice"]:setRadioChannel(channel)
    currentChannel = channel
    notify(string.format(Locales[Config.Locale]['joined_channel'], channel, freq.label))
end)

RegisterNetEvent('r_radio:accessDenied', function()
    notify(Locales[Config.Locale]['not_authorized'])
end)

function playRadioAnim()
    RequestAnimDict(Config.AnimDict)
    while not HasAnimDictLoaded(Config.AnimDict) do Wait(10) end
    TaskPlayAnim(PlayerPedId(), Config.AnimDict, Config.AnimName, 8.0, -8.0, Config.AnimationTime, 49, 0, false, false, false)
end

function leaveRadioChannel()
    if currentChannel then
        exports["pma-voice"]:setRadioChannel(0)
        currentChannel = nil
        notify("CHANGE_HERE")
    end
end

function notify(msg)
    if exports['sy_notify'] then
        exports['sy_notify']:Notify(msg)
    elseif exports['okokTextUI'] then
        exports['okokTextUI']:Open(msg, 'darkblue', 3000)
    else
        ESX.ShowNotification(msg)
    end
end

function checkHasRadio(cb)
    local has = exports.ox_inventory:Search('count', Config.RadioItem)
    cb(has > 0)
end

AddEventHandler('esx:onPlayerDeath', function()
    leaveRadioChannel()
end)

CreateThread(function()
    while true do
        Wait(5000)
        local has = exports.ox_inventory:Search('count', Config.RadioItem)
        if has <= 0 and currentChannel then
            leaveRadioChannel()
            notify("CHANGE_HERE")
        end
    end
end)

function openRadioMenu()
    notify("CHANGE_HERE")
end
