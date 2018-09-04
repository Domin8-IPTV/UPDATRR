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

REM [!!] Busybox's wget only supports http!
REM [!!] HTTPS WILL FAIL! Make sure it isn't enforced.
REM [!!] Check website for HTTPS-support

set infourl=http://rahul.tech/x/getfile.php?file=info

::main
echo -------------------------------------
echo UPDATRR by https://rahul.tech/
echo -------------------------------------

::busybox check
echo STATUS: Checking for Busybox
if exist busybox.exe (
echo --Busybox found!
) else (
echo ERROR: Busybox not found! [1]
echo %date% %time%: Busybox not found! [1] >> updatrr_log.txt
timeout /t 2 >nul
exit /b 1
)

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
echo STATUS: Dowloading new info.txt
busybox wget -O info.txt %infourl%
if exist info.txt (
echo --info.txt download successful!
) else (
echo ERROR: info.txt DOWNLOAD FAILED [3]
echo %date% %time%: info.txt DOWNLOAD FAILED [3] >> updatrr_log.txt
echo   { WGET ERROR: %errorlevel% } >> updatrr_log.txt
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
echo STATUS: Dowloading new commands
busybox wget -O commands.cmd %comurl%
if exist commands.cmd (
echo --New commands downloaded!
) else (
echo ERROR: COULDN'T DOWNLOAD NEW COMMANDS [4]
echo %date% %time%: COMMAND DOWNLOAD FAILED [4] >> updatrr_log.txt
echo   { WGET ERROR: %errorlevel% } >> updatrr_log.txtren info.txt
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
