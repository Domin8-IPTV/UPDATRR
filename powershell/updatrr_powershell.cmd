@echo off
goto :main
-------------------
UPDATRR v1.0 BusyBox
[-]	Check https://rahul.tech/ for more help,
	additional scripts, tips, updates, bug
	fixes, etc.
[-]	Contact code[at]mydomain for any help/
	queries/suggestions/etc.
-------------------

:main
::CONFIG -- EDIT THIS STUFF!
REM 'infourl' should contain the URL to your `info.txt`
REM file.

REM [!!] Make sure powershell is installed!

set infourl=https://rahul.party/files/info-1519.txt

::main
echo -------------------------------------
echo UPDATRR by https://rahul.tech/
echo -------------------------------------

::PS check
REM no check for powershell - no error code 1

::internetcheck
echo STATUS: Checking internet connection
ping rahul.tech -n 1 -w 1000>nul
if errorlevel 0 (
echo --Internet connection working!
) else (
echo ERROR: NO INTERNET CONNECTION [2]
echo %date% %time%: NO INTERNET CONNECTION [2] >> updatrr_log.txt
timeout /t 2 >nul
exit /b 2
)
::oldcheck
echo STATUS: Checking for old info.txt
if exist oldinfo.txt (
echo --Old oldinfo.txt found!

::readoldvar
echo STATUS: Reading old variables
(
set /p oldver=
)<oldinfo.txt
echo --Variables read!
) else (
echo --No old info.txt found!
set oldver=0
)

::downloadinfo
echo STATUS: Downloading new info.txt
call :psd %infourl% info.txt
if exist info.txt (
echo --info.txt download successful!
) else (
echo ERROR: info.txt DOWNLOAD FAILED [3]
echo %date% %time%: info.txt DOWNLOAD FAILED [3] >> updatrr_log.txt
exit /b 3
)

::readnewvar
echo STATUS: Reading new variables
(
set /p newver=
set /p comurl=
)<info.txt
echo --Variables read!
::comparevar
if exist oldinfo.txt (
echo STATUS: Comparing variables
echo [+] Current version: %oldver%
echo [+] New version: %newver%
	if %newver% GTR %oldver% (
		echo --New commands available!
	) else (
		echo --No new commands, exiting!
		del info.txt
echo %date% %time%: No new commands available, exiting [0] >> updatrr_log.txt
		exit /b 0

	)
)

::downloadnew
echo STATUS: Downloading new commands
call :psd %comurl% commands.cmd
if exist commands.cmd (
echo --New commands downloaded!
) else (
echo ERROR: COULDN'T DOWNLOAD NEW COMMANDS [4]
echo %date% %time%: COMMAND DOWNLOAD FAILED [4] >> updatrr_log.txt
exit /b 4
)

::renaminginfo
if exist oldinfo.txt (
del oldinfo.txt
)
ren info.txt oldinfo.txt

echo STATUS: Running new commands!
start /wait commands.cmd
del commands.cmd
echo Commands have been run! Exiting now!
echo %date% %time%: Commands have been fetched and run, exiting [0] >  updatrr_log.txt
exit /b 0

:psd
powershell ([Net.ServicePointManager]::SecurityProtocol = "[Net.SecurityProtocolType]::tls12, [Net.SecurityProtocolType]::tls11, [Net.SecurityProtocolType]::tls, [Net.SecurityProtocolType]::ssl3") -and (wget %~1 -UseBasicParsing -OutFile %~2) >nul
