local ox_inventory = exports.ox_inventory

RegisterServerEvent('shark-genericrob:server:reward', function(type)
	local src = source
	local count = math.random(Config.stations[type].rewards.min, Config.stations[type].rewards.max)
	ox_inventory:AddItem(src, Config.stations[type].rewards.name, count)
end)