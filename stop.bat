@echo off
echo Stopping all Heart3D services ...
taskkill /FI "WINDOWTITLE eq Heart3D-Backend*" /T /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq Heart3D-Frontend*" /T /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq Heart3D-MySQL*" /T /F >nul 2>&1

echo Waiting for MySQL (port 3306) to shut down ...
powershell -NoProfile -Command "$ok=$false; for($i=0;$i -lt 20;$i++){ $c=New-Object Net.Sockets.TcpClient; try{ $c.Connect('127.0.0.1',3306); $c.Close(); Start-Sleep -Seconds 1 } catch { $ok=$true; break } }; if(-not $ok){ Write-Host '  WARNING: port 3306 still busy. Close it manually before copying or zipping the folder.' } else { Write-Host '  MySQL stopped, data files are safe to copy.' }"
echo All stopped. You can close this window.
timeout /t 3 >nul
