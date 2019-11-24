@echo off
setlocal enabledelayedexpansion
	REM enable batch extensions 

if exist settings.ini ( ren settings.ini s.cmd & call s.cmd & ren s.cmd settings.ini )
	REM loads optional config
	
pushd %~dp0
	REM change current dir to where this batch file resides (eg running as admin will change default dir to sys32, this will prevent that from happening)
if [%1]==[] goto scan
	REM this checks if there is a file being dropped onto the batch file itself, if %1 (dropped file) is non existant, goto :scan

	REM ----- Drag & drop -----
set file=%1
set name=%~n1
	REM set variables !file! and !name! to current file, %1 prints file + filepath, %~n1 will print just the name

pushd %~dp1
	REM push input file destination
	
set /p format=convert to [tga, png, xvid, prores]: %=%
	REM ask for format, !format! will return prompt input
	
call :settings
	REM see :settings, presets are called after !file! and !name! are set
	
if not exist "converted_!format!" ( mkdir "converted_!format!" )
	REM check if output dir exists, if not, make one
!%format%!
	REM tricky one, we can use both !! and %% to call variables, if prompt input (!format!) is xvid, this line will be seen as !xvid! and will execute the variable !xvid!
goto end

:scan
	REM ----- Scan for files -----
echo convertable files found:
echo.
for %%a in (*.mp4, *.avi, *.wmv, *.mov, *.m4v) do ( echo   %%a )
	REM list all files ending with suffix in current directory (for each file ending with *.mp4, print, or echo to cmd.exe)
echo. 
	REM side note, echo. means blank line :)
	
set /p format=convert to [tga, png, xvid, prores]: %=%
for %%a in (*.mp4, *.avi, *.wmv, *.mov, *.m4v) do ( 
	set file=%%a
	set name=%%~na
	call :settings
	if not exist "converted_!format!" ( mkdir "converted_!format!" )
	!%format%!
)
	REM for every file ending with suffix, set the the variables !file! and !name! to the current file
	REM load presets again using !file! and !name!
	REM check for existing dir, if not, create one
	REM if prompted input equals xvid, %format% will display: xvid, !%format%! will be seen as !xvid!, and the variable !xvid! will be executed
	
:end 
exit
:settings
set "tga=ffmpeg -i ^"!file!^" -y ^"converted_!format!^"/^"!name!^"-%%05d.tga"
set "png=ffmpeg -i ^"!file!^" -y ^"converted_!format!^"/^"!name!^"-%%05d.png"
set "xvid=ffmpeg -i ^"!file!^" -c:v mpeg4 -vtag xvid -qscale:v 1 -qscale:a 1 -g 32 -vsync 1 -y ^"converted_!format!^"/^"!name!^".avi"
set "prores=ffmpeg -i ^"!file!^" -c:v prores_ks -profile:v 3 -c:a pcm_s16le -y ^"converted_!format!^"/^"!name!^".mov"
rem set "h264=ffmpeg -i ^"!file!^" -c:v libx264 -crf 1 -y ^"converted_!format!^"/^"!name!^".mp4" (barely compatible)

	REM presets as seen above, using ffmpeg.exe and it's parameters
