local cooldownList = {}

for k, v in pairs(Config.stations) do
    exports.ox_target:addModel(v.models,
        {
            name = 'shark:rob' .. v.name,
            onSelect = function(data)
                TriggerEvent('shark-genericrob:client:startTheft', k, data)
            end,
            icon = 'fa-solid fa-hand',
            label = 'Rob ' .. v.name,
            items = v.item or nil,
            canInteract = function(entity, distance, coords, name, bone)
                return not IsEntityDead(entity) and distance < 1.5
            end
        })
end


RegisterNetEvent('shark-genericrob:client:startTheft')
AddEventHandler('shark-genericrob:client:startTheft', function(type, data)
    local robType = Config.stations[type]
    if cooldownList[type] == nil then
        local success = false
        if robType.minigame then
            success = Minigame(robType.minigame, robType.difficulty)
        else
            success = true
        end
        print(success)
        if success then
            lib.progressBar({
                duration = 3000,
                label = 'Stealing...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = true,
                },
                anim = {
                    dict = 'mp_car_bomb',
                    clip = 'car_bomb_mechanic'
                }
            })
            TriggerServerEvent('shark-genericrob:server:reward', type, data.coords)
            Citizen.CreateThread(function()
                Wait(robType.coodlown or 10)
                cooldownList[type] = false
            end)
            if robType.policeChance then
                if math.random(1, 100) <= robType.policeChance then
                    Dispatch(type)
                end
            end
        end
    else
        lib.notify({
            title = 'Cannot Rob',
            description = 'You cannot steal this soon!',
            type = 'error'
        })
    end
end)
