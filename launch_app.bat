@echo off
setlocal enabledelayedexpansion

title gri-updated - Phone Launcher
color 0A

echo =====================================================================
echo          THE GANDHIGRAM RURAL INSTITUTE (DEEMED TO BE UNIVERSITY)
echo                       gri-updated Mobile App Launcher
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
    if !RETRIES! lss 30 (
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
set "ACTIVITY=com.aistudio.grist.kxmpzq.MainActivity"
set "APK_PATH=build\app\outputs\flutter-apk\app-release.apk"

if not exist "!APK_PATH!" (
    if exist "build\app\outputs\apk\release\app-release.apk" (
        set "APK_PATH=build\app\outputs\apk\release\app-release.apk"
    ) else if exist "build\app\outputs\flutter-apk\app-debug.apk" (
        set "APK_PATH=build\app\outputs\flutter-apk\app-debug.apk"
    )
)

if not exist "!APK_PATH!" (
    echo [INFO] APK not found. Building gri-updated release APK...
    call flutter build apk --release
)

if not exist "!APK_PATH!" (
    echo [ERROR] Failed to locate or build APK at: !APK_PATH!
    goto :failed
)

echo [2/3] Pushing and installing gri-updated onto phone (!DEVICE_ID!)...
adb -s !DEVICE_ID! install -r -d "!APK_PATH!"
if %ERRORLEVEL% neq 0 (
    echo [!] In-place update failed (possible signature mismatch). Performing clean re-install...
    adb -s !DEVICE_ID! uninstall !PACKAGE! >nul 2>nul
    adb -s !DEVICE_ID! install "!APK_PATH!"
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] Installation failed.
        goto :failed
    )
)
echo [OK] gri-updated installed successfully on phone.

echo.
echo [3/3] Launching gri-updated on phone (!DEVICE_ID!)...
adb -s !DEVICE_ID! shell am start -n !PACKAGE!/!ACTIVITY!

if %ERRORLEVEL% equ 0 (
    echo.
    echo =====================================================================
    echo [SUCCESS] gri-updated is now running on your phone!
    echo =====================================================================
) else (
    echo [WARNING] Could not start activity directly. Trying launcher monkey...
    adb -s !DEVICE_ID! shell monkey -p !PACKAGE! -c android.intent.category.LAUNCHER 1 >nul 2>nul
)

echo.
pause
exit /b 0

:failed
echo.
echo =====================================================================
echo [FAILED] Unable to push/launch gri-updated on phone.
echo =====================================================================
pause
exit /b 1
