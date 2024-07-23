Config = {}

local seconds = 1000
local minutes = 60 * seconds

Config.dispatch = 'cd'

Config.police = { 'police', 'sheriff' }

Config.stations = {
    ['gumball'] = {
        name = "Gumball Machine",
        models = { 'prop_gumball_01', 'prop_gumball_02', 'prop_gumball_03' }, -- [[table]] of models
        rewards = {                                                           -- [[table]] or [[array]]
            rewardCount = 2,                                                  -- How many rewards are being selected?
            [1] = { name = 'gum', min = 1, max = 5 },                         -- [[table]] - Name of item, minimum reward, max reward
            [2] = { name = 'gum2', min = 1, max = 5 },
            [3] = { name = 'gum3', min = 1, max = 5 },
        },
        item = 'screwdriverset',        -- [[string]] - Required item to see target option
        cooldown = 5 * minutes,         -- [[int]] - Cooldown between theft of this type per player
        policeChance = false,           -- [[false]] or [[int]] Chance of contacting police
        minigame = 'lib-skillCheck',    -- [[string]] Minigame as defined in Minigame()
        difficulty = { 'easy', 'easy' } -- Difficulty for minigame
    },
    ['parking'] = {
        name = "Parking Meter",
        models = { 'prop_parkingpay', 'prop_parknmeter_01', 'prop_parknmeter_02' },
        rewards = { name = 'money', min = 5, max = 50 },
        item = 'WEAPON_CROWBAR',
        cooldown = 5 * minutes,
        policeChance = 35,
        minigame = 'lockpick',
        difficulty = false
    },
    ['payphone'] = {
        name = "Payphone",
        models = { 'sf_prop_sf_phonebox_01b_straight', 'prop_phonebox_01a', 'prop_phonebox_01b', 'prop_phonebox_01c', 'prop_phonebox_02', 'prop_phonebox_03', 'prop_phonebox_04' },
        rewards = { name = 'money', min = 5, max = 15 },
        item = 'lockpick',
        cooldown = 5 * minutes,
        policeChance = 40,
        minigame = 'lib-skillCheck',
        difficulty = { 'easy', 'easy', 'easy' },
    },
    ['wirebox'] = {
        name = "Electrical Box",
        models = {
            'prop_elecbox_07a',
            'prop_elecbox_06a',
            'prop_elecbox_01a',
            'prop_elecbox_04a',
            'prop_elecbox_02a',
            'prop_elecbox_09',
            'prop_elecbox_08',
            'prop_elecbox_18',
            'prop_elecbox_13',
            'prop_elecbox_05a',
            'prop_elecbox_03a',
            'prop_elecbox_01b',
            'prop_elecbox_08b',
            'prop_elecbox_02b',
            'prop_elecbox_17'
        },
        rewards = { name = 'copper', min = 5, max = 15 },
        item = 'screwdriverset',
        cooldown = 5 * minutes,
        policeChance = 50,
        minigame = 'boii_wirecut',
        difficulty = 60000,
        failEffect = 'shock'
    },
}

function Dispatch(type)
    if Config.dispatch == "qs" then
        local playerData = exports['qs-dispatch']:GetPlayerInfo()
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config.police,
            callLocation = playerData.coords,
            callCode = { code = Config.stations[type].name .. ' Robbery' },
            message = Config.stations[type].name .. " Robbery In Progress",
            flashes = false,
            blip = {
                sprite = 311,
                scale = 1.5,
                colour = 4,
                flashes = true,
                text = Config.stations[type].name .. ' Robbery',
                time = (20 * 1000),
            }
        })
    elseif Config.dispatch == "ps" then
        exports["ps-dispatch"]:CustomAlert({
            coords = GetEntityCoords(PlayerPedId()),
            message = Config.stations[type].name .. " Robbery",
            dispatchCode = "10-15",
            description = Config.stations[type].name .. " Robbery In Progress",
            radius = 0,
            sprite = 311,
            color = 4,
            scale = 1.5,
            length = 2,
        })
    elseif Config.dispatch == "cd" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.police,
            coords = data.coords,
            title = '10-15 - ' .. Config.stations[type].name .. ' Robbery',
            message = 'An anonymous caller has reported a ' .. data.sex .. ' robbing a ' .. Config.stations[type].name .. ' at ' .. data.street,
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 311,
                scale = 1.2,
                colour = 4,
                flashes = false,
                text = '911 - ' .. Config.stations[type].name .. ' Robbery',
                time = 2,
                radius = 50,
            }
        })
    end
end

function Minigame(type, difficulty)
    local p = promise.new()
    if type == 'lib-skillCheck' then
        local result = lib.skillCheck(difficulty, { 'w', 'a', 's', 'd' })
        p:resolve(result)
    elseif type == 'lockpick' then
        local result = exports['lockpick']:startLockpick()
        p:resolve(result)
    elseif type == 'boii_safecrack' then
        exports['boii_minigames']:safe_crack({
            style = 'default',      -- Style template
            difficulty = difficulty -- Difficuly; This increases the amount of lock a player needs to unlock this scuffs out a little above 6 locks I would suggest to use levels 1 - 5 only.
        }, function(success)
            p:resolve(success)
        end)
    elseif type == 'boii_wirecut' then
        exports['boii_minigames']:wire_cut({
            style = 'default', -- Style template
            timer = difficulty -- Time allowed to complete game in (ms)
        }, function(success)
            p:resolve(success)
        end)
    end
    return Citizen.Await(p)
end

function FailEffect(type)
    local playerPed = GetPlayerPed()
    if type == 'shock' then
        PlayPain(playerPed, 20, 0.0)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
        SetPedToRagdollWithFall(playerPed, 5000, 5000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Wait(500)
    end
end
