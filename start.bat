@echo off
setlocal
set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"
set "NODE_DIR=%ROOT%\_tools\node_extract\node-v22.23.4-win-x64"
set "MYSQL_BIN=%ROOT%\_tools\mysql_extract\mysql-8.0.42-winx64\bin"
set "MYSQLD=%MYSQL_BIN%\mysqld.exe"
set "PY=%ROOT%\backend\venv\Scripts\python.exe"
set "PSEXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

echo ==================================================
echo   Heart3D System - One-Click Start
echo ==================================================
echo.

if not exist "%PY%" (
  echo [ERROR] Python environment missing.
  echo         Run first_setup.bat once, then start again.
  echo.
  pause
  exit /b 1
)

if not exist "%ROOT%\data\dicom\case_01\IM0001.dcm" (
  echo [0/3] Generating DICOM series from volume data ...
  "%PY%" "%ROOT%\backend\make_dicom.py"
)

echo [1/3] Starting MySQL (port 3306) ...
"%PSEXE%" -NoProfile -Command "$c=New-Object Net.Sockets.TcpClient; try { $c.Connect('127.0.0.1',3306); $c.Close(); exit 0 } catch { exit 1 }"
if errorlevel 1 (
  if not exist "%ROOT%\mysql-data\mysql" (
    echo   First run: initializing data dir ...
    "%MYSQLD%" --initialize-insecure --datadir="%ROOT%\mysql-data"
    "%PSEXE%" -NoProfile -Command "Start-Sleep -Seconds 5"
  )
  start "Heart3D-MySQL" /min /d "%MYSQL_BIN%" "%MYSQLD%" --datadir="%ROOT%\mysql-data" --port=3306
  "%PSEXE%" -NoProfile -Command "Start-Sleep -Seconds 12"
) else (
  echo   MySQL already running.
)

echo [2/3] Starting API (127.0.0.1:8000) ...
"%PSEXE%" -NoProfile -Command "$c=New-Object Net.Sockets.TcpClient; try { $c.Connect('127.0.0.1',8000); $c.Close(); exit 0 } catch { exit 1 }"
if errorlevel 1 (
  start "Heart3D-Backend" /min "%ROOT%\_run_backend.bat"
  "%PSEXE%" -NoProfile -Command "Start-Sleep -Seconds 8"
) else (
  echo   Backend already running.
)

echo [3/3] Starting Frontend (http://localhost:5176) ...
"%PSEXE%" -NoProfile -Command "$c=New-Object Net.Sockets.TcpClient; try { $c.Connect('127.0.0.1',5176); $c.Close(); exit 0 } catch { exit 1 }"
if errorlevel 1 (
  start "Heart3D-Frontend" /min "%ROOT%\_run_frontend.bat"
  "%PSEXE%" -NoProfile -Command "Start-Sleep -Seconds 12"
) else (
  echo   Frontend already running.
)

start "" http://127.0.0.1:5176
echo.
echo System started.
echo Login: root / root
echo Stop system: run stop.bat
"%PSEXE%" -NoProfile -Command "Start-Sleep -Seconds 8"