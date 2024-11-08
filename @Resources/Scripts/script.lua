local startTime = nil
local delay = 3
local messageShown = false

local User = os.getenv("USERNAME")
local desktopPath = os.getenv("USERPROFILE") .. "\\Desktop\\"
local tempPath = os.getenv("TEMP")
local diskPath = "C:\\"

local buttonsVisible = false

------------------------ANIMATION SETTINGS------------------------
function ToggleButtons()

    buttonsVisible = not buttonsVisible

    if buttonsVisible then
        SKIN:Bang('!SetOption', 'CleanBinButton', 'Hidden', 0)
        SKIN:Bang('!SetOption', 'FilterButton', 'Hidden', 0)
        SKIN:Bang('!SetOption', 'CleanTempButton', 'Hidden', 0)
        SKIN:Bang('!SetOption', 'AnalyzeDiskButton', 'Hidden', 0)
		SKIN:Bang('!SetOption', 'FilterButtonDownloads', 'Hidden', 0)
    else
        SKIN:Bang('!SetOption', 'CleanBinButton', 'Hidden', 1)
        SKIN:Bang('!SetOption', 'FilterButton', 'Hidden', 1)
        SKIN:Bang('!SetOption', 'CleanTempButton', 'Hidden', 1)
        SKIN:Bang('!SetOption', 'AnalyzeDiskButton', 'Hidden', 1)
		SKIN:Bang('!SetOption', 'FilterButtonDownloads', 'Hidden', 1)
    end

    SKIN:Bang('!Update')
end


------------------------CHARACTER SETTINGS------------------------

function ShowMessage(text)
    SKIN:Bang("!SetOption", "MeterText", "Text", text)
    SKIN:Bang("!UpdateMeter", "MeterText")
    SKIN:Bang("!Redraw")
    
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
    local scriptPath = "C:\\Users\\" .. User .. "\\Documents\\Rainmeter\\Skins\\MaidSkin\\@Resources\\Scripts\\Sorting.bat"
    
    local command = 'powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "' .. scriptPath .. '"'
    os.execute(command)
    
	ChangeImage("character3.png")
    ShowMessage("Files sorted on desktop!")
end

function FilterDownloadsFiles()
    local scriptPath = "C:\\Users\\" .. User .. "\\Documents\\Rainmeter\\Skins\\MaidSkin\\@Resources\\Scripts\\SortingDownloads.bat"
    
    local command = 'powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "' .. scriptPath .. '"'
    os.execute(command)
    
    ChangeImage("character6.png")
    ShowMessage("Files sorted in \"Downloads\" folder!")
end


function CleanTempFolder()
    local tempPath = os.getenv("TEMP")

    local command = 'powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Remove-Item -Path \'' .. tempPath .. '\\*\' -Recurse -Force"'

    os.execute(command)

	ChangeImage("character6.png")
    ShowMessage("\"Temp\" folder cleaned!")
end

function AnalyzeDiskC()
    local freeSpace = SKIN:GetMeasure("MeasureDriveFreeC"):GetValue()
    if freeSpace < 10 * 1024 * 1024 * 1024 then
	ChangeImage("character4.png")
        ShowMessage("You have only " .. string.format("%.2f", freeSpace / (1024 * 1024 * 1024)) .. " GB on C.\nPlease clear space \nor close unnecessary \nprograms.")
    else
		ChangeImage("character1.png")
        ShowMessage("There's enough space on disk C: " .. string.format("%.2f", freeSpace / (1024 * 1024 * 1024)) .. " GB.")
    end
end



