local scrw, scrh = ScrW(), ScrH()
local mat_star = Material('fatedholiday/star.png')
local color_btn_prize = Color(243, 66, 66)
local color_btn_prize_hovered = Color(186, 74, 74)
local function DrawText(txt, font, x, y, color, align_x, align_y)
    draw.SimpleText(txt, font, x + 1, y + 1, color_black, align_x, align_y)
    draw.SimpleText(txt, font, x, y, color, align_x, align_y)
end

function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainingSeconds = seconds % 60

    return string.format('%d ч. %d мин. %d сек.', hours, minutes, remainingSeconds)
end

local function Paint()
    local time_left = os.difftime(FatedHoliday.config.time, os.time())

    if time_left < 0 then
        return
    end

    DrawText(FatedHoliday.config.txt_left[1], 'Fated.17', scrw - 10, scrh * 0.5 - 1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    DrawText(FatedHoliday.config.txt_left[2], 'Fated.17', scrw - 10, scrh * 0.5 + 21, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    DrawText(FormatTime(time_left), 'Fated.17', scrw - 10, scrh * 0.5 + 41, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
end

hook.Add('HUDPaint', 'FatedHoliday.Hud', Paint)

local function CreateMenu()
    if IsValid(FatedHoliday.menu) then
        FatedHoliday.menu:Remove()
    end

    FatedHoliday.menu = vgui.Create('DPanel')
    FatedHoliday.menu:SetSize(500, 300)
    FatedHoliday.menu:Center()
    FatedHoliday.menu:MakePopup()
    FatedHoliday.menu.Paint = function(_, w, h)
        draw.RoundedBox(16, 0, 0, w, h, Mantle.color.background)
        draw.RoundedBoxEx(16, 0, 0, w, 30, Mantle.color.header, true, true, false, false)
    
        draw.SimpleText(FatedHoliday.config.txt_congratulation, 'Fated.24', w * 0.5, 14, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText('В честь праздника выберите призы...', 'Fated.16', w * 0.5, 39, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
    
    FatedHoliday.menu.sp = vgui.Create('DScrollPanel', FatedHoliday.menu)
    Mantle.ui.sp(FatedHoliday.menu.sp)
    FatedHoliday.menu.sp:Dock(FILL)
    FatedHoliday.menu.sp:DockMargin(4, 64, 4, 4)
    
    for prize_id, prize in ipairs(FatedHoliday.config.prizes) do
        local btn = vgui.Create('DButton', FatedHoliday.menu.sp)
        Mantle.ui.btn(btn, nil, nil, color_btn_prize, nil, nil, color_btn_prize_hovered)
        btn:Dock(TOP)
        btn:DockMargin(0, 0, 0, 4)
        btn:SetTall(34)
        btn:SetText(prize.name)
        btn.DoClick = function()
            FatedHoliday.menu:Remove()

            net.Start('FatedHoliday-GetPrize')
                net.WriteUInt(prize_id, 5)
            net.SendToServer()

            chat.AddText(Color(30, 111, 49), 'Ты получил: ' .. prize.name)
            chat.PlaySound()
        end
    end
end

local function FireworkEffect()
    local totalStars = 150
    local duration = 3
    local startTime = CurTime()
    local playCount = 0
    local stars
    local star_size = 24

    local function CreateStars()
        local newStars = {}

        for i = 1, totalStars do
            local star = {
                x = math.random(0, scrw), -- Стартовая позиция по горизонтали
                y = scrh, -- Стартовая позиция по вертикали
                velX = math.random(-4, 4), -- Начальную скорость по горизонтали
                velY = math.random(-15, -0.5), -- Начальную скорость по вертикали
                rotation = math.random(0, 360) -- Начальный угол вращения
            }

            table.insert(newStars, star)
        end

        return newStars
    end

    stars = CreateStars()

    local soundStation

    sound.PlayFile('sound/fatedholiday/background.mp3', '', function(station, errCode, errStr)
        if IsValid(station) then
            soundStation = station
            soundStation:Play()
        else
            print('Ошибка загрузки медиа-файла:', errCode, errStr)
        end
    end)

    local function Paint()
        local currentTime = CurTime()
        local elapsed = currentTime - startTime
        local progress = elapsed / duration

        if progress < 1 then
            surface.SetMaterial(mat_star)

            for _, star in ipairs(stars) do
                star.x = star.x + star.velX
                star.y = star.y + star.velY

                star.velY = star.velY + math.random(0.04, 0.06)
                star.rotation = star.rotation

                if star.x < 0 or star.x > scrw or star.y < 0 or star.y > scrh then
                    star.velX = -star.velX
                end

                surface.SetDrawColor(color_white)

                local halfSize = star_size * 0.5
                surface.DrawTexturedRectRotated(star.x + halfSize, star.y + halfSize, star_size, star_size, star.rotation)
            end
        else
            playCount = playCount + 1

            if playCount < 3 then
                startTime = CurTime()
                totalStars = totalStars + math.ceil(totalStars / 3)
                stars = CreateStars()
            else
                hook.Remove('HUDPaint', 'FatedHoliday.FireworkEffect')

                if IsValid(soundStation) then
                    soundStation:Stop()
                end

                CreateMenu()
            end
        end
    end

    hook.Add('HUDPaint', 'FatedHoliday.FireworkEffect', Paint)
end

net.Receive('FatedHoliday-StartEvent', function()
    FireworkEffect()
end)

hook.Add('KeyPress', 'FatedHoliday.CreateStars', function(ply, key)
    if key == IN_ATTACK then
        FireworkEffect()
    end
end)
