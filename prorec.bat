@echo off
	REM original code belongs to gmzorz, my additional code is just my ametuer attempts at creating working batch script code. comments might also be inaccurate in some places, ill fix those later maybe

setlocal enabledelayedexpansion
	REM enable batch extensions 

if exist settings.ini ( ren settings.ini s.cmd & call s.cmd & ren s.cmd settings.ini )
	REM loads optional config

pushd %~dp0
	REM change current dir to where this batch file resides (eg running as admin will change default dir to sys32, this will prevent that from happening)
if [%1]==[] goto foldercheck
	REM this checks if there is a file being dropped onto the batch file itself, if %1 (dropped file) is non existant, goto :scan

	REM ----- Drag & drop -----
set file=%1
set name=%~n1
	REM set variables !file! and !name! to current file, %1 prints file + filepath, %~n1 will print just the name

pushd %~dp1
	REM push input file destination
	
set /p format=convert to [tga, png, xvid, prores, h264(barely compatible)]: %=%
	REM ask for format, !format! will return prompt input
	
set /p fps=enter fps: %=%
	REM askes for fps you want to convert it to. You should do this even if the video is in the fps you want.

call :settings
	REM see :settings, presets are called after !file! and !name! are set
	
if not exist "converted_!format!" ( mkdir "converted_!format!" )
	REM check if output dir exists, if not, make one
!%format%!
	REM tricky one, we can use both !! and %% to call variables, if prompt input (!format!) is xvid, this line will be seen as !xvid! and will execute the variable !xvid!
goto end

:foldercheck
set /p confirm=are the files in folders? [0-no, 1-yes]: %=%
	REM asks user if there are folders that need to be queued

if %confirm%==0 goto confirm
	REM if there are none, go to scan

set /a foldernum = 0
	REM setting up variable foldernum for the folder num?(idk how else to explain this)

echo enter 'stop' to stop and 'all' for all folders

:nextfolder
set /p foldernext=name of folder[#%foldernum%]: %=%
	REM asks for the folder name

if !foldernext!==stop goto confirm
	REM if the user enters in -stopbatch, continue to scan

if !foldernext!==all (
	set /a foldernum = 0
	for /f "delims=" %%D in ('dir /a:d /b') do (
		set folders[!foldernum!]=%%~nxD
		set /a foldernum += 1
	)
	goto confirm
)

if not exist !foldernext! (echo does not exist
goto nextfolder)
	REM if the foldername does not exist, go back to nextfolder

set folders[%foldernum%]=!foldernext!
	REM set the input as the name of a folder on an index

set /a foldernum += 1
	REM increment foldernum

goto nextfolder

:confirm
if !confirm! ==0 (
	echo.
	echo convertable files found:
	echo.
	for %%a in (*.mp4, *.avi, *.wmv, *.mov, *.m4v) do ( echo   %%a )
		REM list all files ending with suffix in current directory (for each file ending with *.mp4, print, or echo to cmd.exe)
	pause
	goto scan
) else (
	echo.
	echo folders:
	echo.
	for /F "tokens=2 delims==" %%s in ('set folders[') do ( echo %%s )
	pause
	goto scan
)


:scan
	REM ----- Scan for files -----

echo.

set /p format="convert to [tga, png, xvid, prores, h264(barely compatible)]: %=%"
set /p fps="enter fps: %=%"
if not !confirm!==0 (
		REM checking to see if confirm is toggled(This is to make sure it doesn't try to loop through array values that don't exist)
	for /F "tokens=2 delims==" %%s in ('set folders[') do (
			REM loops though all array values
		pushd %~dp0\%%s
		REM change current directory to the directory of queued folder
		echo.
		echo convertable files found:
		echo.
		for %%a in (*.mp4, *.avi, *.wmv, *.mov, *.m4v) do ( echo   %%a )
			REM list all files ending with suffix in current directory (for each file ending with *.mp4, print, or echo to cmd.exe)
		echo. 
			REM side note, echo. means blank line :)
		for %%a in (*.mp4, *.avi, *.wmv, *.mov, *.m4v) do (
			set file=%%a
			set name=%%~na
			call :settings
			if not exist "converted_!format!" ( mkdir "converted_!format!" )
			!%format%!
		)
		if %confirm% == 0 goto end
		popd
	)
)
echo. 
	REM side note, echo. means blank line :)
for %%a in (*.mp4, *.avi, *.wmv, *.mov, *.m4v) do (
	set file=%%a
	set name=%%~na
	call :settings
	if not exist "converted_!format!" ( mkdir "converted_!format!" )
	!%format%!
)
goto end
goto end
	REM for every file ending with suffix, set the the variables !file! and !name! to the current file
	REM load presets again using !file! and !name!
	REM check for existing dir, if not, create one
	REM if prompted input equals xvid, %format% will display: xvid, !%format%! will be seen as !xvid!, and the variable !xvid! will be executed
	
:end
echo Finished.
pause >nul
exit
:settings
set "tga=ffmpeg -i ^"!file!^" -y ^"converted_!format!^"/^"!name!^"-%%05d.tga"
set "png=ffmpeg -i ^"!file!^" -y ^"converted_!format!^"/^"!name!^"-%%05d.png"
set "xvid=ffmpeg -r ^"!fps!^" -i ^"!file!^" -c:v mpeg4 -vtag xvid -qscale:v 1 -qscale:a 1 -g 32 -vsync 1 -y ^"converted_!format!^"/^"!name!^".avi"
set "prores=ffmpeg -r ^"!fps!^" -i ^"!file!^" -c:v prores_ks -profile:v 3 -c:a pcm_s16le -y ^"converted_!format!^"/^"!name!^".mov"
set "h264=ffmpeg -r ^"!fps!^" -i ^"!file!^" -c:v libx264 -crf 1 -y ^"converted_!format!^"/^"!name!^".mp4"

	REM presets as seen above, using ffmpeg.exe and it's parameters
