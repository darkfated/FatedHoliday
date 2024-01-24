--[[
    * FatedHoliday *
    GitHub: https://github.com/darkfated/fatedholiday
    Author's discord: darkfated
]]--

local function run_scripts()
    Mantle.run_cl('config.lua')
    Mantle.run_sv('config.lua')
    
    Mantle.run_cl('client.lua')
    Mantle.run_sv('server.lua')
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
