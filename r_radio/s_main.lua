ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent("r_radio:checkAccess")
AddEventHandler("r_radio:checkAccess", function(channel)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob().name
    local allowedJobs = Config.Frequencies[channel].jobs

    if #allowedJobs == 0 then
        TriggerClientEvent("r_radio:accessGranted", source, channel)
    else
        for _, j in pairs(allowedJobs) do
            if job == j then
                TriggerClientEvent("r_radio:accessGranted", source, channel)
                return
            end
        end
        TriggerClientEvent("r_radio:accessDenied", source)
    end
end)
