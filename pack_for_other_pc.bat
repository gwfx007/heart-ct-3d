@echo off
setlocal
echo ==================================================
echo   Pack Heart3D for another PC (creates a zip)
echo ==================================================
echo.
echo  1) stop all services (so the MySQL data is consistent)
echo  2) copy the project to a temp folder, skipping:
echo       venv  __pycache__  .git  *.pyc  *.log  and the
echo       API-key configs (research\config.local*.json)
echo  3) zip it to Desktop\heart3d_portable.zip
echo.
echo  Raw size about 3.4 GB, zipped about 0.7 GB.
echo  Need about 5 GB free space and 2-5 minutes.
echo.
pause
call "%~dp0stop.bat"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$root='%~dp0'.TrimEnd('\'); $tmp=Join-Path $env:TEMP 'heart3d_pack'; if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }; New-Item -ItemType Directory -Path $tmp | Out-Null; $dst=Join-Path $tmp 'heart_3d_project'; robocopy $root $dst /E /XD venv __pycache__ .git /XF config.local.json config.local.bak_before_switch.json config.local.json.bak_before_drop_ds *.pyc *.log /NFL /NDL /NJH /NJS /NP | Out-Null; $zip=Join-Path ([Environment]::GetFolderPath('Desktop')) 'heart3d_portable.zip'; if (Test-Path $zip) { Remove-Item $zip -Force }; Compress-Archive -Path $dst -DestinationPath $zip -CompressionLevel Optimal -Force; if (Test-Path $zip) { Remove-Item $tmp -Recurse -Force; Write-Host ('Done: ' + $zip + '   ' + [math]::Round((Get-Item $zip).Length/1GB,2) + ' GB') } else { Write-Host 'ERROR: zip was not created.' }"
echo.
echo Finished. Copy the zip to the other PC, unzip it, then run first_setup.bat.
echo Note: the AI analysis needs research\config.local.json (your model API key) on that PC.
pause
