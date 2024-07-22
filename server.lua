local ox_inventory = exports.ox_inventory
local cooldownPos = {}
RegisterServerEvent('shark-genericrob:server:reward', function(type, coords)
	local src = source
	cooldownPos[#cooldownPos + 1] = coords
	if Config.stations[type].rewards[1] then
		for i = 1, Config.stations[type].rewards.rewardCount do
			local rewarded = math.random(#Config.stations[type].rewards)
			local count = math.random(Config.stations[type].rewards[rewarded].min, Config.stations[type].rewards[rewarded].max)
			ox_inventory:AddItem(src, Config.stations[type].rewards[rewarded].name, count)
		end
	else
		local count = math.random(Config.stations[type].rewards.min, Config.stations[type].rewards.max)
		ox_inventory:AddItem(src, Config.stations[type].rewards.name, count)
	end
end)