--[[
    * FatedHoliday *
    GitHub: https://github.com/darkfated/fatedholiday
    Author's discord: darkfated
]]

local function run_scripts()
    local cl = SERVER and AddCSLuaFile or include
    local sv = SERVER and include or function() end

    cl('config.lua')
    sv('config.lua')
    
    cl('client.lua')
    sv('server.lua')
end

local function init()
    if SERVER then
        resource.AddFile('materials/fatedholiday/star.png')
        resource.AddFile('sound/fatedholiday/background.mp3')
    end

    FatedHoliday = FatedHoliday or {
        config = {}
    }

    run_scripts()
end

init()
