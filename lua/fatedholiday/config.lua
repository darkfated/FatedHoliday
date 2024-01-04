// Текст с информацией о том, сколько осталось до праздника
FatedHoliday.config.txt_left = {
    'До Нового Года',
    'Осталось: '
}

// Текст с поздравлением
FatedHoliday.config.txt_congratulation = 'С Новым Годом!'

// Дата самого праздника
FatedHoliday.config.time = os.time({year = 2024, month = 1, day = 1, hour = 0, min = 0})

// Список призов на выбор игрока
FatedHoliday.config.prizes = {
    {
        name = '60 тысяч игровой валюты',
        func = function(pl)
            pl:addMoney(60000)
        end
    },
    {
        name = '120 донат-валюты',
        func = function(pl)
            pl:AddIGSFunds(120, 'Подарок на праздник') -- Сделано через IGS донат
        end
    }
}
