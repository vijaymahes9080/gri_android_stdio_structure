@echo off
setlocal enabledelayedexpansion

title GRI Official Mobile App - Phone Launcher
color 0A

echo =====================================================================
echo          THE GANDHIGRAM RURAL INSTITUTE (DEEMED TO BE UNIVERSITY)
echo                      Official Mobile Application Launcher
echo =====================================================================
echo.

:: 1. Ensure ADB is in PATH
where adb >nul 2>nul
if %ERRORLEVEL% neq 0 (
    if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" (
        set "PATH=%LOCALAPPDATA%\Android\Sdk\platform-tools;%PATH%"
    ) else (
        echo [!] ADB was not found in PATH or standard Android SDK location.
        echo Please ensure Android SDK platform-tools is installed.
        goto :failed
    )
)

:: 2. Check for connected Android device with auto-retry
echo [1/3] Detecting connected Android phone...
set "RETRIES=0"

:check_device
set "DEVICE_FOUND=0"
set "DEVICE_UNAUTH=0"
set "DEVICE_ID="

for /f "skip=1 tokens=1,2" %%A in ('adb devices') do (
    if "%%B"=="device" (
        set "DEVICE_FOUND=1"
        set "DEVICE_ID=%%A"
    ) else if "%%B"=="unauthorized" (
        set "DEVICE_UNAUTH=1"
        set "DEVICE_ID=%%A"
    )
)

if "!DEVICE_FOUND!"=="1" (
    echo [OK] Authorized Phone connected: !DEVICE_ID!
    goto :device_ready
)

if "!DEVICE_UNAUTH!"=="1" (
    echo.
    echo [*] Phone detected (!DEVICE_ID!), waiting for USB Debugging permission...
    echo     -------------------------------------------------------------------
    echo     1. UNLOCK your phone screen right now.
    echo     2. Look for the prompt: 'Allow USB debugging?'
    echo     3. Check '[x] Always allow from this computer' and tap 'ALLOW'.
    echo     -------------------------------------------------------------------
    set /a RETRIES+=1
    if !RETRIES! lss 20 (
        timeout /t 2 /nobreak >nul
        goto :check_device
    )
)

if "!DEVICE_FOUND!"=="0" (
    echo.
    echo [ERROR] No authorized Android device detected!
    echo.
    echo Troubleshooting Steps:
    echo   1. Connect your phone via USB cable (set USB mode to 'File Transfer' / 'MTP').
    echo   2. Enable 'Developer Options' on your phone:
    echo      Settings - About Phone - Tap 'Build Number' 7 times.
    echo   3. Enable 'USB Debugging' in Settings - Developer Options.
    echo   4. On your phone screen, check 'Always allow from this computer' and tap 'Allow'.
    echo.
    goto :failed
)

:device_ready
echo.

:: 3. Check for Flutter SDK
echo [2/3] Checking Flutter SDK...
set "FLUTTER_CMD="

where flutter >nul 2>nul
if %ERRORLEVEL% equ 0 (
    set "FLUTTER_CMD=flutter"
) else if exist "D:\current project\flutter\bin\flutter.bat" (
    set "FLUTTER_CMD=D:\current project\flutter\bin\flutter.bat"
    set "PATH=D:\current project\flutter\bin;%PATH%"
) else if exist "C:\flutter\bin\flutter.bat" (
    set "FLUTTER_CMD=C:\flutter\bin\flutter.bat"
    set "PATH=C:\flutter\bin;%PATH%"
) else if exist "%LOCALAPPDATA%\flutter\bin\flutter.bat" (
    set "FLUTTER_CMD=%LOCALAPPDATA%\flutter\bin\flutter.bat"
    set "PATH=%LOCALAPPDATA%\flutter\bin;%PATH%"
)

if defined FLUTTER_CMD (
    echo [OK] Flutter SDK found: !FLUTTER_CMD!
    echo.
    echo Resolving Flutter dependencies...
    call !FLUTTER_CMD! pub get
    if %ERRORLEVEL% neq 0 (
        echo [WARNING] 'flutter pub get' exited with a warning, proceeding to run...
    )
    echo.
    echo [3/3] Launching GRI Flutter App directly on your phone (!DEVICE_ID!)...
    call !FLUTTER_CMD! run -d !DEVICE_ID!
    goto :finished
) else (
    echo [INFO] Flutter CLI is not yet in system PATH.
    echo Checking for existing Android build wrapper...
    
    if exist "gradlew.bat" (
        echo Building and installing native debug APK via Gradle wrapper...
        call gradlew.bat installDebug
        if %ERRORLEVEL% equ 0 (
            echo.
            echo [3/3] Starting GRI App on phone via ADB...
            adb -s !DEVICE_ID! shell am start -n com.aistudio.grist.kxmpzq/com.example.MainActivity
            goto :finished
        )
    )
    
    echo.
    echo [INFO] To run via Flutter:
    echo   1. Clone/extract Flutter SDK into 'D:\current project\flutter'
    echo   2. Run 'flutter run -d !DEVICE_ID!'
    echo.
)

:finished
echo.
echo =====================================================================
echo [SUCCESS] Operation finished. Press any key to exit.
echo =====================================================================
pause
exit /b 0

:failed
echo.
echo =====================================================================
echo [FAILED] Unable to launch app on phone.
echo =====================================================================
pause
exit /b 1
