@echo off
chcp 65001 > nul

for /f "tokens=2 delims='" %%a in (
  'aapt dump badging app.apk ^| findstr /b "package: name="'
) do set PKG=%%a

for /f "tokens=2 delims='" %%a in (
  'aapt dump badging app.apk ^| findstr /b "launchable-activity: name="'
) do set ACT=%%a

echo 包名：%PKG%
echo Activity：%ACT%

for /f "skip=1 tokens=1" %%i in ('adb devices') do (
  adb -s %%i install -r app.apk >nul && (
    echo ---- %%i 安装成功，正在启动 ----
    adb -s %%i shell am start -n %PKG%/%ACT%
  ) || echo ---- %%i 安装失败 ----
)

pause