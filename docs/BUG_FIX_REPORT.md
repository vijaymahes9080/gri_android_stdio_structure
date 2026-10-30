# Bug Fix & Remediation Report: `gri-updated`

**Application ID:** `com.aistudio.grist.kxmpzq`  
**Test Environment:** Windows 11 host + Samsung Galaxy A15 5G (`RZCX2175PPX`)  
**Status:** All confirmed issues resolved, verified, and re-tested on physical device.  

---

## 1. Remediation Summary Table

| Issue ID | Severity | Problem Description | Root Cause | File(s) Modified | Verification Status |
|----------|----------|---------------------|------------|------------------|---------------------|
| BUG-001 | High | App display name showed generic "GRI Portal" instead of requested "gri-updated". | `android:label` and string resources defined as `GRI Portal`. | `android/app/src/main/AndroidManifest.xml`, `res/values/strings.xml`, `lib/main.dart` | VERIFIED (Verified on device home screen and aapt badging) |
| BUG-002 | High | `launch_app.bat` skipped APK push if package was already installed on phone. | Logic in batch script used `pm list packages` and exited install block on match. | `launch_app.bat` | VERIFIED (Script now forces streaming install `-r -d` on every run) |
| BUG-003 | Medium | Cross-drive Kotlin incremental compilation failure (`C:` pub cache vs `D:` project). | Windows cross-drive path relativity bug in Kotlin 2.2/2.3 incremental caches. | `android/gradle.properties` | VERIFIED (`kotlin.incremental=false` and in-process strategy configured) |
| BUG-004 | High | Signature mismatch install error on device (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`). | Previous build on phone had a mismatched debug keystore signature. | `launch_app.bat` | VERIFIED (Automated fallback detects signature error, uninstalls old APK, and installs cleanly) |
| BUG-005 | Medium | Batch file syntax crash (`. was unexpected at this time`) during install error handling. | Unquoted parenthesis inside `if (...)` block in Windows CMD. | `launch_app.bat` | VERIFIED (Reformatted batch syntax without nested parenthesis) |

---

## 2. Detailed Root-Cause Analyses

### BUG-001: App Display Name Customization
- **Reproduction:** On phone home launcher and app info drawer, app showed "GRI Portal".
- **Source of Defect:** Android application manifest `android:label` attribute and localized string resource `@string/app_name`.
- **Fix:** Updated `android:label="gri-updated"` in `android/app/src/main/AndroidManifest.xml`, updated `<string name="app_name">gri-updated</string>` in `strings.xml`, and updated `MaterialApp(title: 'gri-updated')` in `lib/main.dart`.
- **Retest:** Ran `aapt dump badging` on assembled APK. Confirmed `application-label:'gri-updated'` across all locales.

### BUG-002: Batch Script Device Push Bypassing
- **Reproduction:** Executing `launch_app.bat` on a device that already had an older build printed `[OK] App is already installed` and did not push newly compiled changes.
- **Source of Defect:** `launch_app.bat` lines 94-96 treated presence of package as terminal condition.
- **Fix:** Rewrote execution block to unconditionally stream and install the target APK using `adb install -r -d "!APK_PATH!"`.
- **Retest:** Executed `launch_app.bat` with connected phone. Verified `Performing Streamed Install -> Success`.

### BUG-003: Windows Cross-Drive Kotlin Cache Crash
- **Reproduction:** During `assembleDebug` / `assembleRelease`, Kotlin compiler daemon crashed with:
  `IllegalArgumentException: this and base files have different roots: C:\Users\vijay\AppData\Local\Pub\Cache\... and D:\current project\gri\android`.
- **Source of Defect:** Windows toolchain files on `C:\` and project sources on `D:\` caused Kotlin's incremental cache path relativization to fail.
- **Fix:** Added compiler flags to `android/gradle.properties`:
  ```properties
  kotlin.incremental=false
  kotlin.incremental.useClasspathSnapshot=false
  kotlin.compiler.execution.strategy=in-process
  ```
- **Retest:** Full Gradle build completed cleanly in 250s, producing 66MB release APK without daemon crashes.

### BUG-004 & BUG-005: Incompatible Signature Recovery & Batch Parsing
- **Reproduction:** Pushing newly signed APK over older build triggered `INSTALL_FAILED_UPDATE_INCOMPATIBLE`, followed by CMD terminating with `. was unexpected at this time`.
- **Source of Defect:** Mismatched key signature required package uninstallation; unquoted parenthesis in batch script comment broke CMD interpreter tokenization.
- **Fix:** Corrected batch syntax and added automated clean re-installation sequence (`adb uninstall !PACKAGE!` then `adb install "!APK_PATH!"`).
- **Retest:** Tested on live phone `RZCX2175PPX`. Package cleanly uninstalled, reinstalled, and launched into foreground.

