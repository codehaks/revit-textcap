@echo off
setlocal enabledelayedexpansion

rem Build all Revit-version targets of TextCap and collect the
rem produced DLL + .addin into .\dist\Revit <year>\.
rem
rem Usage:
rem   build.bat              -> Release (default)
rem   build.bat Debug        -> Debug
rem   build.bat Release      -> Release

set "CONFIG=%~1"
if "%CONFIG%"=="" set "CONFIG=Release"

set "REPO=%~dp0"
set "DIST=%REPO%dist"

echo ==^> Configuration: %CONFIG%
echo ==^> Repo:          %REPO%
echo ==^> Dist:          %DIST%
echo.

if not exist "%DIST%" mkdir "%DIST%"

call :build 2024 "src\TextCap 2024\TextCap 2024.csproj" "src\TextCap 2024\bin\%CONFIG%\TextCap.dll" "src\TextCap 2024\bin\%CONFIG%\TextCap.addin" || goto :fail
call :build 2025 "src\TextCap 2025\TextCap 2025.csproj" "src\TextCap 2025\bin\%CONFIG%\net8.0-windows\TextCap.dll" "src\TextCap 2025\bin\%CONFIG%\net8.0-windows\TextCap.addin" || goto :fail
call :build 2026 "src\TextCap 2026\TextCap 2026.csproj" "src\TextCap 2026\bin\%CONFIG%\net8.0-windows\TextCap.dll" "src\TextCap 2026\bin\%CONFIG%\net8.0-windows\TextCap.addin" || goto :fail

echo.
echo ==^> All builds succeeded. Output: %DIST%
endlocal
exit /b 0

:build
set "YEAR=%~1"
set "PROJ=%~2"
set "OUTDLL=%~3"
set "OUTADDIN=%~4"
set "DESTDIR=%DIST%\Revit %YEAR%"

echo ----------------------------------------------------------------------
echo Building TextCap %YEAR% (%CONFIG%)
echo ----------------------------------------------------------------------
msbuild "%REPO%%PROJ%" /t:Restore;Rebuild /p:Configuration=%CONFIG% /p:Platform=AnyCPU /nologo
if errorlevel 1 exit /b 1

if not exist "%REPO%%OUTDLL%" (
    echo [FAIL] Expected build output not found: %REPO%%OUTDLL%
    exit /b 1
)

if not exist "%DESTDIR%" mkdir "%DESTDIR%"
copy /Y "%REPO%%OUTDLL%" "%DESTDIR%\" >nul
set "OUTPDB=%REPO%%OUTDLL:.dll=.pdb%"
if exist "%OUTPDB%" copy /Y "%OUTPDB%" "%DESTDIR%\" >nul
if exist "%REPO%%OUTADDIN%" copy /Y "%REPO%%OUTADDIN%" "%DESTDIR%\" >nul

echo [OK] %YEAR% -^> %DESTDIR%\TextCap.dll
exit /b 0

:fail
echo.
echo ==^> Build FAILED.
endlocal
exit /b 1
