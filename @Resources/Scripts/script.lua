local startTime = nil
local delay = 3 -- Пауза в секундах
local messageShown = false

-- Получаем имя пользователя
local User = os.getenv("USERNAME")  -- Получаем имя пользователя системы
local desktopPath = os.getenv("USERPROFILE") .. "\\Desktop\\"
local tempPath = os.getenv("TEMP")
local diskPath = "C:\\"
-- Переменная для отслеживания состояния кнопок
local buttonsVisible = false

------------------------ANIMATION SETTINGS------------------------
function ToggleButtons()
    -- Проверяем текущее состояние видимости кнопок
    buttonsVisible = not buttonsVisible

    if buttonsVisible then
        -- Сделать кнопки видимыми
        SKIN:Bang('!SetOption', 'CleanBinButton', 'Hidden', 0)
        SKIN:Bang('!SetOption', 'FilterButton', 'Hidden', 0)
        SKIN:Bang('!SetOption', 'CleanTempButton', 'Hidden', 0)
        SKIN:Bang('!SetOption', 'AnalyzeDiskButton', 'Hidden', 0)
		SKIN:Bang('!SetOption', 'FilterButtonDownloads', 'Hidden', 0)
    else
        -- Скрыть кнопки
        SKIN:Bang('!SetOption', 'CleanBinButton', 'Hidden', 1)
        SKIN:Bang('!SetOption', 'FilterButton', 'Hidden', 1)
        SKIN:Bang('!SetOption', 'CleanTempButton', 'Hidden', 1)
        SKIN:Bang('!SetOption', 'AnalyzeDiskButton', 'Hidden', 1)
		SKIN:Bang('!SetOption', 'FilterButtonDownloads', 'Hidden', 1)
    end

    -- Перезагрузить скин, чтобы применить изменения
    SKIN:Bang('!Update')
end


------------------------CHARACTER SETTINGS------------------------

function ShowMessage(text)
    SKIN:Bang("!SetOption", "MeterText", "Text", text)
    SKIN:Bang("!UpdateMeter", "MeterText")
    SKIN:Bang("!Redraw")
    
    -- Запускаем таймер
    startTime = os.clock()
    messageShown = true
end

function ChangeImage(imageName)
    SKIN:Bang("!SetVariable", "CharacterImage", "#@#Images/" .. imageName)
    SKIN:Bang("!UpdateMeter", "Background")
    SKIN:Bang("!Redraw")
end

function Update()
    if messageShown then
        local currentTime = os.clock()
        if currentTime - startTime >= delay then
            SKIN:Bang("!SetOption", "MeterText", "Text", " ")
            SKIN:Bang("!UpdateMeter", "MeterText")
            SKIN:Bang("!Redraw")
            ChangeImage("character.png")
            messageShown = false
        end
    end
end

------------------------FUNCTION SETTINGS------------------------

function EmptyBin()
    local binCount = SKIN:GetMeasure("MeasureBinCount"):GetValue()
    if binCount > 0 then
        SKIN:Bang("!CommandMeasure RecycleMeasure EmptyBin")
		ChangeImage("character6.png")
        ShowMessage("Bin is clean!")
        return
    else
		ChangeImage("character5.png")
        ShowMessage("Bin is already empty.")
    end
end

function FilterDesktopFiles()
    -- Обновляем путь к бат-файлу, используя переменную User
    local scriptPath = "C:\\Users\\" .. User .. "\\Documents\\Rainmeter\\Skins\\MaidSkin\\@Resources\\Scripts\\Sorting.bat"
    
    -- Используем PowerShell для скрытого выполнения
    local command = 'powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "' .. scriptPath .. '"'
    os.execute(command)
    
    -- Выводим сообщение после выполнения
	ChangeImage("character3.png")
    ShowMessage("Files sorted on desktop!")
end

function FilterDownloadsFiles()
    -- Обновляем путь к бат-файлу, используя переменную User
    local scriptPath = "C:\\Users\\" .. User .. "\\Documents\\Rainmeter\\Skins\\MaidSkin\\@Resources\\Scripts\\SortingDownloads.bat"
    
    -- Используем PowerShell для скрытого выполнения
    local command = 'powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "' .. scriptPath .. '"'
    os.execute(command)
    
    -- Выводим сообщение после выполнения
    ChangeImage("character6.png")
    ShowMessage("Files sorted in \"Downloads\" folder!")
end


function CleanTempFolder()
    local tempPath = os.getenv("TEMP")  -- Путь к папке Temp текущего пользователя

    -- Команда для PowerShell, которая удаляет все файлы и папки в Temp
    local command = 'powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Remove-Item -Path \'' .. tempPath .. '\\*\' -Recurse -Force"'

    os.execute(command)

    -- Выводим сообщение после выполнения
	ChangeImage("character6.png")
    ShowMessage("\"Temp\" folder cleaned!")
end

function AnalyzeDiskC()
    local freeSpace = SKIN:GetMeasure("MeasureDriveFreeC"):GetValue()  -- Получаем значение свободного места
    if freeSpace < 10 * 1024 * 1024 * 1024 then  -- Если свободное место меньше 10 ГБ
	ChangeImage("character4.png")
        ShowMessage("You have only " .. string.format("%.2f", freeSpace / (1024 * 1024 * 1024)) .. " GB on C.\nPlease clear space \nor close unnecessary \nprograms.")
    else
		ChangeImage("character1.png")
        ShowMessage("There's enough space on disk C: " .. string.format("%.2f", freeSpace / (1024 * 1024 * 1024)) .. " GB.")
    end
end



