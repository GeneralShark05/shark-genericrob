Config =  {}

local minutes = 60000

Config.dispatch = 'cd'

Config.police = {'police', 'sheriff'}

Config.stations = {
    ['gumball'] = {
        name = "Gumball Machine",
        models = {'prop_gumball_01', 'prop_gumball_02', 'prop_gumball_03'},
        rewards = {name = 'money', min = 1, max = 5},
        item = 'screwdriverset',
        cooldown = 5 * minutes,
        callPolice = false,
        difficulty = {'easy', 'easy'}
    },
    ['parking'] = {
        name = "Parking Meter",
        models = {'prop_parkingpay', 'prop_parknmeter_01', 'prop_parknmeter_02'},
        rewards = {name = 'money', min = 5, max = 50},
        item = 'WEAPON_CROWBAR',
        cooldown = 5 * minutes,
        callPolice = true,
        difficulty = {'easy', 'easy', 'easy'}
    },
    ['payphone'] = {
        name = "Payphone",
        models = {'sf_prop_sf_phonebox_01b_straight', 'prop_phonebox_01a', 'prop_phonebox_01b', 'prop_phonebox_01c', 'prop_phonebox_02', 'prop_phonebox_03', 'prop_phonebox_04'},
        rewards = {name = 'money', min = 5, max = 15},
        item = 'lockpick',
        cooldown = 5 * minutes,
        callPolice = true,
        difficulty = {'easy', 'easy', 'easy'}
    },
}

function Dispatch(type)
    if Config.Dispatch == "qs" then
        local playerData = exports['qs-dispatch']:GetPlayerInfo()
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config.police,
            callLocation = playerData.coords,
            callCode = { code = Config.stations[type].name..' Robbery' },
            message = Config.stations[type].name.." Robbery In Progress",
            flashes = false,
            blip = {
                sprite = 311,
                scale = 1.5,
                colour = 4,
                flashes = true,
                text = Config.stations[type].name..' Robbery',
                time = (20 * 1000),
            }
        })
    elseif Config.Dispatch == "ps" then
        exports["ps-dispatch"]:CustomAlert({
            coords = GetEntityCoords(PlayerPedId()),
            message = Config.stations[type].name.." Robbery",
            dispatchCode = "10-90",
            description = Config.stations[type].name.." Robbery In Progress",
            radius = 0,
            sprite = 311,
            color = 4,
            scale = 1.5,
            length = 2,
        })
    elseif Config.Dispatch == "cd" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.police,
            coords = data.coords,
            title = '10-90 - '..Config.stations[type].name..' Robbery',
            message = 'An anonymous caller has reported a ' .. data.sex .. ' robbing a '..Config.stations[type].name..' at ' .. data.street,
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 311,
                scale = 1.2,
                colour = 4,
                flashes = false,
                text = '911 - '..Config.stations[type].name..' Robbery',
                time = 2,
                radius = 50,
            }
        })
    end
end