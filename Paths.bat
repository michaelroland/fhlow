@echo off
rem *******************************************************************************
rem * This file is part of fhlow (fast handling of a lot of work), a working
rem * environment that speeds up the development of and structures FPGA design
rem * projects.
rem * 
rem * Copyright (c) 2011-2017 Michael Roland <michael.roland@fh-hagenberg.at>
rem * 
rem * This program is free software: you can redistribute it and/or modify
rem * it under the terms of the GNU General Public License as published by
rem * the Free Software Foundation, either version 3 of the License, or
rem * (at your option) any later version.
rem * 
rem * This program is distributed in the hope that it will be useful,
rem * but WITHOUT ANY WARRANTY; without even the implied warranty of
rem * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem * GNU General Public License for more details.
rem * 
rem * You should have received a copy of the GNU General Public License
rem * along with this program.  If not, see <http://www.gnu.org/licenses/>.
rem *******************************************************************************

rem *******************************************************************************
rem *****  Path Configuration  ****************************************************
rem *******************************************************************************
rem * 
rem * note:  you can override this configuration by creating a file containing the
rem *        relevant "set" lines at %USERPROFILE%\.fhlow\Paths.bat (this file is
rem *        automatically created when you run fhlow for the first time)
rem * 
rem *******************************************************************************

rem *******************************************************************************
rem * Questasim
set MY_QUESTASIM_PATH=C:\questasim64_10.4
set MY_QUESTASIM_EXECUTABLE_MAIN=
set MY_QUESTASIM_EXECUTABLE_VSIM=
rem *******************************************************************************

rem *******************************************************************************
rem * Quartus
rem set MY_QUARTUS_PATH=C:\intelFPGA\17.0\quartus
set MY_QUARTUS_PATH=%QUARTUS_ROOTDIR%
set MY_QUARTUS_EXECUTABLE_MAIN=
set MY_QUARTUS_EXECUTABLE_SHELL=
rem *******************************************************************************


rem *******************************************************************************
rem *****  End of Configuration  **************************************************
rem *******************************************************************************


rem *******************************************************************************
rem *****  Load/Generate User Configuration  **************************************
rem *******************************************************************************
set FHLOW_USER_DIR=%USERPROFILE%\.fhlow
set FHLOW_USER_PATHCFG=%FHLOW_USER_DIR%\Paths.bat
if not exist "%FHLOW_USER_PATHCFG%" (
    if not exist "%FHLOW_USER_DIR%" mkdir "%FHLOW_USER_DIR%"
    (
        echo @echo off
        echo rem *******************************************************************************
        echo rem * This file is part of fhlow ^(fast handling of a lot of work^), a working
        echo rem * environment that speeds up the development of and structures FPGA design
        echo rem * projects.
        echo rem *******************************************************************************
        echo.
        echo rem *******************************************************************************
        echo rem * Questasim
        echo rem * 
        echo rem set MY_QUESTASIM_PATH=%MY_QUESTASIM_PATH%
        echo rem set MY_QUESTASIM_PATH=C:\questasim64_10.4
        echo rem set MY_QUESTASIM_PATH=ignore
        echo rem * 
        echo rem * 
        echo rem * Advanced configuration options ^(use with care!^)
        echo rem * 
        echo rem set MY_QUESTASIM_EXECUTABLE_MAIN=win64\questasim.exe
        echo rem set MY_QUESTASIM_EXECUTABLE_VSIM=win64\vsim.exe
        echo rem *******************************************************************************
        echo.
        echo rem *******************************************************************************
        echo rem * Quartus
        echo rem * 
        echo rem set MY_QUARTUS_PATH=%MY_QUARTUS_PATH%
        echo rem set MY_QUARTUS_PATH=%%QUARTUS_ROOTDIR%%
        echo rem set MY_QUARTUS_PATH=C:\intelFPGA\17.0\quartus
        echo rem set MY_QUARTUS_PATH=ignore
        echo rem * 
        echo rem * Advanced configuration options ^(use with care!^)
        echo rem * 
        echo rem set MY_QUARTUS_EXECUTABLE_MAIN=bin64\quartus.exe
        echo rem set MY_QUARTUS_EXECUTABLE_SHELL=bin64\quartus_sh.exe
        echo rem *******************************************************************************
        echo.
    )>"%FHLOW_USER_PATHCFG%"
    echo ############################################################################
    echo ##  
    echo ##  fhlow - fast handling of a lot of work
    echo ##  
    echo ############################################################################
    echo.
    echo.
    echo This appears to be the first time you run fhlow.
    echo.
    echo Created user configuration %USERPROFILE%\.fhlow\Paths.bat.
    echo.
    echo IMPORTANT: Make sure to configure the paths for your simulation
    echo            and synthesis environment in
    echo            %USERPROFILE%\.fhlow\Paths.bat
    echo.
    pause
)
if exist "%FHLOW_USER_PATHCFG%" call "%FHLOW_USER_PATHCFG%"


rem *******************************************************************************
rem *****  Automatic Executable Lookup  *******************************************
rem *******************************************************************************

rem *******************************************************************************
rem * Questasim/Modelsim
rem * 
if "%MY_QUESTASIM_PATH%" == "ignore" goto :questasimskip
if "%MY_QUESTASIM_EXECUTABLE_MAIN%" == "" goto :questasimexemainunset
set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\%MY_QUESTASIM_EXECUTABLE_MAIN%
if exist "%MY_QUESTASIM_EXEC_QUESTASIM%" goto :questasimskipguessexemain
:questasimexemainunset
set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win64\questasim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win32\questasim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win64aloem\questasim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win32aloem\questasim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win64\modelsim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win32\modelsim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win64aloem\modelsim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win32aloem\modelsim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\questasim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\modelsim.exe
:questasimskipguessexemain
for %%i in ("%MY_QUESTASIM_EXEC_QUESTASIM%") do set MY_QUESTASIM_EXEC_DIR=%%~dpi
if "%MY_QUESTASIM_EXECUTABLE_VSIM%" == "" goto :questasimexevsimunset
set MY_QUESTASIM_EXEC_VSIM=%MY_QUESTASIM_PATH%\%MY_QUESTASIM_EXECUTABLE_VSIM%
if exist "%MY_QUESTASIM_EXEC_QUESTASIM%" goto :questasimskipguessexevsim
:questasimexevsimunset
set MY_QUESTASIM_EXEC_VSIM=%MY_QUESTASIM_EXEC_DIR%vsim.exe
:questasimskipguessexevsim
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" (
    echo.
    echo.
    echo ERROR: Questasim toolchain not found at configured location!
    echo.
    echo Current configuration:
    echo - Main path: %MY_QUESTASIM_PATH%
    if not "%MY_QUESTASIM_EXECUTABLE_MAIN%" == "" (
        echo - Main executable override: %MY_QUESTASIM_EXECUTABLE_MAIN%
    )
    if not "%MY_QUESTASIM_EXECUTABLE_VSIM%" == "" (
        echo - vsim executable override: %MY_QUESTASIM_EXECUTABLE_VSIM%
    )
    echo.
    pause
)
:questasimskip
rem *******************************************************************************

rem *******************************************************************************
rem * Quartus
rem * 
if "%MY_QUARTUS_PATH%" == "ignore" goto :quartusskip
set QUARTUS_ROOTDIR=%MY_QUARTUS_PATH%
if "%MY_QUARTUS_EXECUTABLE_MAIN%" == "" goto :quartusexemainunset
set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\%MY_QUARTUS_EXECUTABLE_MAIN%
if exist "%MY_QUARTUS_EXEC_QUARTUS%" goto :quartusskipguessexemain
:quartusexemainunset
set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\bin64\quartus.exe
if not exist "%MY_QUARTUS_EXEC_QUARTUS%" set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\bin32\quartus.exe
if not exist "%MY_QUARTUS_EXEC_QUARTUS%" set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\bin\quartus.exe
if not exist "%MY_QUARTUS_EXEC_QUARTUS%" set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\..\quartus\bin64\quartus.exe
if not exist "%MY_QUARTUS_EXEC_QUARTUS%" set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\..\quartus\bin32\quartus.exe
if not exist "%MY_QUARTUS_EXEC_QUARTUS%" set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\..\quartus\bin\quartus.exe
:quartusskipguessexemain
for %%i in ("%MY_QUARTUS_EXEC_QUARTUS%") do set MY_QUARTUS_EXEC_DIR=%%~dpi
if "%MY_QUARTUS_EXECUTABLE_SHELL%" == "" goto :quartusexeshellunset
set MY_QUARTUS_EXEC_SH=%MY_QUARTUS_PATH%\%MY_QUARTUS_EXECUTABLE_SHELL%
if exist "%MY_QUARTUS_EXEC_SH%" goto :quartusskipguessexeshell
:quartusexeshellunset
set MY_QUARTUS_EXEC_SH=%MY_QUARTUS_EXEC_DIR%quartus_sh.exe
:quartusskipguessexeshell
if not exist "%MY_QUARTUS_EXEC_QUARTUS%" (
    echo.
    echo.
    echo ERROR: Quartus toolchain not found at configured location!
    echo.
    echo Current configuration:
    echo - Main path: %MY_QUARTUS_PATH%
    if not "%MY_QUARTUS_EXECUTABLE_MAIN%" == "" (
        echo - Main executable override: %MY_QUARTUS_EXECUTABLE_MAIN%
    )
    if not "%MY_QUARTUS_EXECUTABLE_SHELL%" == "" (
        echo - Shell executable override: %MY_QUARTUS_EXECUTABLE_SHELL%
    )
    echo.
    pause
)
:quartusskip
rem *******************************************************************************
