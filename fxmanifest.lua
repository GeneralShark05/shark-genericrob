---@diagnostic disable: undefined-global
fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'General Shark'
description 'Get yourself a nice cup of coffee.'
version '1.5'

dependencies { 'ox_lib', 'ox_target', 'ox_inventory'}

shared_scripts {
    '@ox_lib/init.lua',
    "config.lua",
}

server_scripts {
	'server.lua'
}

client_scripts {
	'client.lua'
}