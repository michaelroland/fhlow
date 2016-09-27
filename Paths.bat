@echo off
rem *******************************************************************************
rem * This file is part of fhlow (fast handling of a lot of work), a working
rem * environment that speeds up the development of and structures FPGA design
rem * projects.
rem * 
rem * Copyright (c) 2011-2016 Michael Roland <michael.roland@fh-hagenberg.at>
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
set MY_QUESTASIM_PATH=C:\questasim64_10.4c
rem set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win64\questasim.exe
rem set MY_QUESTASIM_EXEC_VSIM=%MY_QUESTASIM_PATH%\win64\vsim.exe
rem *******************************************************************************

rem *******************************************************************************
rem * Quartus
set QUARTUS_ROOTDIR=C:\altera\16.0\quartus
set MY_QUARTUS_PATH=%QUARTUS_ROOTDIR%
rem set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\bin64\quartus.exe
rem set MY_QUARTUS_EXEC_SH=%MY_QUARTUS_PATH%\bin64\quartus_sh.exe
rem *******************************************************************************


rem rem *******************************************************************************
rem rem * Alternative configuration if %USERDOMAIN% is not mydomain
rem rem * 
rem if [%USERDOMAIN%]==[mydomain] goto :skip
rem rem * Questasim
rem set MY_QUESTASIM_PATH=C:\questasim64_10.4c
rem rem * 
rem rem * Quartus
rem set QUARTUS_ROOTDIR=C:\altera\16.0\quartus
rem set MY_QUARTUS_PATH=%QUARTUS_ROOTDIR%
rem rem * 
rem :skip
rem rem *******************************************************************************


rem *******************************************************************************
rem *****  End of Configuration  **************************************************
rem *******************************************************************************


rem *******************************************************************************
rem *****  Load/Generate User Configuration  **************************************
rem *******************************************************************************
set FHLOW_USER_DIR=%USERPROFILE%\.fhlow
set FHLOW_USER_PATHCFG=%FHLOW_USER_DIR%\Paths.bat
if exist "%FHLOW_USER_PATHCFG%" call "%FHLOW_USER_PATHCFG%"
if not exist "%FHLOW_USER_PATHCFG%" (
    mkdir "%FHLOW_USER_DIR%"
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
        echo rem set MY_QUESTASIM_PATH=%MY_QUESTASIM_PATH%
        echo rem *******************************************************************************
        echo.
        echo rem *******************************************************************************
        echo rem * Quartus
        echo rem set QUARTUS_ROOTDIR=%QUARTUS_ROOTDIR%
        echo rem set MY_QUARTUS_PATH=%%QUARTUS_ROOTDIR%%
        echo rem *******************************************************************************
        echo.
    )>"%FHLOW_USER_PATHCFG%"
)


rem *******************************************************************************
rem *****  Automatic Executable Lookup  *******************************************
rem *******************************************************************************

rem *******************************************************************************
rem * Questasim
rem * 
if "%MY_QUESTASIM_EXEC_QUESTASIM%" == ""     set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win64\questasim.exe
if not exist "%MY_QUESTASIM_EXEC_QUESTASIM%" set MY_QUESTASIM_EXEC_QUESTASIM=%MY_QUESTASIM_PATH%\win32\questasim.exe
if "%MY_QUESTASIM_EXEC_VSIM%" == ""     set MY_QUESTASIM_EXEC_VSIM=%MY_QUESTASIM_PATH%\win64\vsim.exe
if not exist "%MY_QUESTASIM_EXEC_VSIM%" set MY_QUESTASIM_EXEC_VSIM=%MY_QUESTASIM_PATH%\win32\vsim.exe
rem *******************************************************************************

rem *******************************************************************************
rem * Quartus
rem * 
if "%MY_QUARTUS_EXEC_QUARTUS%" == ""     set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\bin64\quartus.exe
if not exist "%MY_QUARTUS_EXEC_QUARTUS%" set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\bin32\quartus.exe
if not exist "%MY_QUARTUS_EXEC_QUARTUS%" set MY_QUARTUS_EXEC_QUARTUS=%MY_QUARTUS_PATH%\bin\quartus.exe
if "%MY_QUARTUS_EXEC_SH%" == ""     set MY_QUARTUS_EXEC_SH=%MY_QUARTUS_PATH%\bin64\quartus_sh.exe
if not exist "%MY_QUARTUS_EXEC_SH%" set MY_QUARTUS_EXEC_SH=%MY_QUARTUS_PATH%\bin32\quartus_sh.exe
if not exist "%MY_QUARTUS_EXEC_SH%" set MY_QUARTUS_EXEC_SH=%MY_QUARTUS_PATH%\bin\quartus_sh.exe
rem *******************************************************************************
