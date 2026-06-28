@echo off
chcp 65001 >nul
REM ============================================
REM 高校校园助手 APP 构建脚本
REM 用法: build.bat          (默认debug构建)
REM       build.bat release  (release构建)
REM ============================================

set JAVA_HOME=F:\HarmonyOS\Download\DevEco Studio\jbr
set PATH=%JAVA_HOME%\bin;%PATH%
set DEVECO_SDK_HOME=F:\HarmonyOS\Download\DevEco Studio\sdk

set MODE=debug
if not "%1"=="" set MODE=%1

echo ========================================
echo  Building... Mode: %MODE%
echo ========================================

"F:\HarmonyOS\Download\DevEco Studio\tools\node\node.exe" ^
  "F:\HarmonyOS\Download\DevEco Studio\tools\hvigor\bin\hvigorw.js" ^
  --mode module -p module=entry@default -p product=default ^
  -p buildMode=%MODE% -p requiredDeviceType=phone ^
  assembleHap --analyze=normal --parallel --incremental --daemon

if %ERRORLEVEL% EQU 0 (
  echo ========================================
  echo  BUILD SUCCESSFUL
  echo ========================================
) else (
  echo ========================================
  echo  BUILD FAILED (Error: %ERRORLEVEL%)
  echo ========================================
)

pause
