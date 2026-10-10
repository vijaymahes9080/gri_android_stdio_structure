@echo off
setlocal enabledelayedexpansion

title GRI Official Mobile App - Phone Launcher
color 0A

echo =====================================================================
echo          THE GANDHIGRAM RURAL INSTITUTE (DEEMED TO BE UNIVERSITY)
echo                      Official Mobile Application Launcher
echo =====================================================================
echo.

:: 1. Ensure ADB and JAVA_HOME are set
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

if "%JAVA_HOME%"=="" (
    if exist "C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot" (
        set "JAVA_HOME=C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot"
        set "PATH=!JAVA_HOME!\bin;!PATH!"
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

:: 3. Launch or Install Application
set "PACKAGE=com.aistudio.grist.kxmpzq"
set "ACTIVITY=com.example.MainActivity"
set "APK_PATH=app\build\outputs\apk\debug\app-debug.apk"

echo [2/3] Checking app installation on phone...
adb -s !DEVICE_ID! shell pm list packages --user 0 2>nul | findstr /c:"!PACKAGE!" >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo [OK] App is already installed on your device.
) else (
    if exist "!APK_PATH!" (
        echo [INFO] Installing APK onto your phone...
        adb -s !DEVICE_ID! install -r "!APK_PATH!"
        if %ERRORLEVEL% neq 0 (
            echo Re-installing with clean signature...
            adb -s !DEVICE_ID! uninstall !PACKAGE! >nul 2>nul
            adb -s !DEVICE_ID! install "!APK_PATH!"
        )
    ) else (
        echo [INFO] Building debug APK with Gradle wrapper...
        call gradlew.bat assembleDebug
        adb -s !DEVICE_ID! install -r "!APK_PATH!"
    )
)

echo.
echo [3/3] Launching GRI Mobile App on phone (!DEVICE_ID!)...
adb -s !DEVICE_ID! shell am start -n !PACKAGE!/!ACTIVITY!

if %ERRORLEVEL% equ 0 (
    echo.
    echo =====================================================================
    echo [SUCCESS] App is now running on your phone!
    echo =====================================================================
) else (
    echo [WARNING] Could not start activity directly. Trying launcher...
    adb -s !DEVICE_ID! shell monkey -p !PACKAGE! -c android.intent.category.LAUNCHER 1 >nul 2>nul
)

echo.
pause
exit /b 0

:failed
echo.
echo =====================================================================
echo [FAILED] Unable to launch app on phone.
echo =====================================================================
pause
exit /b 1
