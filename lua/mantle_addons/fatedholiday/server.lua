util.AddNetworkString('FatedHoliday-StartEvent')
util.AddNetworkString('FatedHoliday-GetPrize')

local function CheckHoliday()
    local time_left = os.difftime(FatedHoliday.config.time, os.time())

    if time_left == 0 then
        net.Start('FatedHoliday-StartEvent')
        net.Broadcast()
    
        hook.Remove('Think', 'FatedHoliday.Check')
    end
end

hook.Add('Think', 'FatedHoliday.Check', CheckHoliday)

net.Receive('FatedHoliday-GetPrize', function(_, pl)
    if os.difftime(FatedHoliday.config.time, os.time()) > 0 then
        return
    end

    if pl:GetPData('fh_prize_received') == '1' then
        pl:ChatPrint('Вы уже получали подарок!')
    else
        local id = net.ReadUInt(5)
        local prize = FatedHoliday.config.prizes[id]

        if !prize then
            return
        end

        prize.func(pl)

        pl:SetPData('fh_prize_received', '1')
    end
end)

hook.Add('PlayerInitialSpawn', 'FatedHoliday.CheckPrize', function(pl)
    if pl:GetPData('fh_prize_received') == '1' and os.difftime(FatedHoliday.config.time, os.time()) > 0 then
        pl:SetPData('fh_prize_received', nil)
    end
end)
