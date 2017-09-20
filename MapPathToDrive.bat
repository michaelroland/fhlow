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

echo ############################################################################
echo ##  
echo ##  fhlow - fast handling of a lot of work
echo ##  
echo ############################################################################
echo.
echo.

set CURR_ROOT_DIRECTORY=%~dp0
set NEW_ROOT_DRIVE=Y:

echo Source directory: %CURR_ROOT_DIRECTORY%
echo Destination drive: %NEW_ROOT_DRIVE%
echo.
echo Mapping directory to drive to achieve shorter paths for compilation . . .

subst %NEW_ROOT_DRIVE% "%CURR_ROOT_DIRECTORY%."
if errorlevel 1 goto :substmapfailed

start %NEW_ROOT_DRIVE%\

echo.
echo Press any key to unmap the drive . . .
pause >NUL

subst %NEW_ROOT_DRIVE% /D 

echo Done.
echo.

goto :substcompleted

:substmapfailed
echo.
echo Failed to map directory to drive.
echo.
pause

:substcompleted
