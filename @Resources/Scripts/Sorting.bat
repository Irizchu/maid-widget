@echo off
cd /d "C:\Users\User\Documents\Rainmeter\Skins\MaidSkin"
set desktopPath=%USERPROFILE%\Desktop\
setlocal enabledelayedexpansion

rem Категории и расширения
set categories=Images Documents Videos Music
set extensions_Images=.png .jpg .jpeg .gif .webp
set extensions_Documents=.txt .docx .pdf .xlsx
set extensions_Videos=.mp4 .avi .mov .webm
set extensions_Music=.mp3

for %%c in (%categories%) do (
    set folderPath=%desktopPath%%%c
    if not exist "!folderPath!" mkdir "!folderPath!"
    for %%e in (!extensions_%%c!) do (
        move /y "%desktopPath%*%%e" "!folderPath!" >nul 2>&1
    )
)
