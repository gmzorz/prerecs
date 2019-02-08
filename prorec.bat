@echo off
setlocal enabledelayedexpansion
pushd %~dp0
if [%1]==[] goto scan
	REM single file converting 
set file=%1
set name=%~n1
for %%a in (%1) do ( pushd %%~da%%~pa ) 
	REM set current dir to file destination
set /p format=convert to [tga, png, xvid, prores]: %=%
call :settings
if not exist "converted_!format!" ( mkdir "converted_!format!" )
!%format%!
goto end

:scan
	REM batch file converting 
echo convertable files found:
echo.
for %%a in (*.mp4, *.avi, *.wmv, *.mov) do ( echo   %%a )
echo. 
set /p format=convert to [tga, png, xvid, prores]: %=%
for %%a in (*.mp4, *.avi, *.wmv, *.mov) do ( 
	set file=%%a
	set name=%%~na
	call :settings
	if not exist "converted_!format!" ( mkdir "converted_!format!" )
	!%format%!
)
:end 
exit
:settings
set "tga=ffmpeg -i ^"!file!^" -y ^"converted_!format!^"/^"!name!^"-%%05d.tga"
set "png=ffmpeg -i ^"!file!^" -y ^"converted_!format!^"/^"!name!^"-%%05d.png"
set "xvid=ffmpeg -i ^"!file!^" -c:v mpeg4 -vtag xvid -qscale:v 1 -qscale:a 1 -g 32 -vsync 1 -y ^"converted_!format!^"/^"!name!^".avi"
set "prores=ffmpeg -i ^"!file!^" -c:v prores_ks -profile:v 3 -c:a pcm_s16le -y ^"converted_!format!^"/^"!name!^".mov"
rem set "h264=ffmpeg -i ^"!file!^" -c:v libx264 -crf 1 -y ^"converted_!format!^"/^"!name!^".mp4" (barely compatible)