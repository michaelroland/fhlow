#*******************************************************************************
#* This file is part of fhlow (fast handling of a lot of work), a working
#* environment that speeds up the development of and structures FPGA design
#* projects.
#* 
#* Copyright (c) 2005 Christian Kitzler <christian.kitzler@fh-hagenberg.at>
#* Copyright (c) 2005 Markus Pfaff <markus.pfaff@fh-hagenberg.at>
#* Copyright (c) 2005 Simon Lasselsberger <simon.lasselsberger@fh-hagenberg.at>
#* Copyright (c) 2011-2016 Michael Roland <michael.roland@fh-hagenberg.at>
#* 
#* This program is free software: you can redistribute it and/or modify
#* it under the terms of the GNU General Public License as published by
#* the Free Software Foundation, either version 3 of the License, or
#* (at your option) any later version.
#* 
#* This program is distributed in the hope that it will be useful,
#* but WITHOUT ANY WARRANTY; without even the implied warranty of
#* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#* GNU General Public License for more details.
#* 
#* You should have received a copy of the GNU General Public License
#* along with this program.  If not, see <http://www.gnu.org/licenses/>.
#*******************************************************************************

#*******************************************************************************
#* 
#* Find documentation and grab the latest version at
#* <https://github.com/michaelroland/fhlow>
#* 
#*******************************************************************************


#*******************************************************************************
#*****  Source Files  **********************************************************
#*******************************************************************************

#*******************************************************************************
#* ExtraLibraries
#* 
#* purpose:  declares additional libraries (besides "work") that are used by
#*           this project
#* 
#* syntax:
#*     append ExtraLibraries {
#*         {SomeLibrary}
#*         {AnotherLibrary}
#*     }
#* 
#*     -> SomeLibrary:  name of a library that needs to be created for this unit
#* 
#* WARNING:  DO NOT TRY TO CREATE STANDARD LIBRARIES LIKE "ieee"! THERE IS NO
#*           NEED TO CREATE THE LIBRARY "work", THIS IS DONE BY DEFAULT!
#* 
#* see also:  parameter TargetLibrary
#* 
#*******************************************************************************
append ExtraLibraries {
    {example_library}
}


#*******************************************************************************
#* Packages
#* 
#* purpose:  declares packages needed by all units in this group
#* 
#* syntax:
#*     append Packages {
#*         {SomeGroup SomePackage TargetLibrary}
#*         {AnotherGroup AnotherPackage AnotherTargetLibrary}
#*     }
#* 
#*     -> SomeGroup:      name of the group which contains the package
#*     -> SomePackage:    name of the package that needs to be included for this group
#*     -> TargetLibrary:  [optional] target library which this package should be compiled into;
#*                        librararies must be declared in ExtraLibraries (default: work)
#*
#* note:  DO NOT ADD "grp" OR "pkg" TO YOUR GROUP/PACKAGE NAME
#* 
#*******************************************************************************
append Packages {
    {Examples ExamplePackage example_library}
}


#*******************************************************************************
#* Units
#* 
#* purpose:  declares units needed by all units in this group
#* 
#* syntax:
#*     append Units {
#*         {SomeGroup SomeUnit SomeArchitecture TargetLibrary}
#*         {AnotherGroup AnotherUnit AnotherArchtecture AnotherTargetLibrary}
#*     }
#* 
#*     -> SomeGroup:         name of the group which contains the unit
#*     -> SomeUnit:          name of the unit that needs to be included for this group
#*     -> SomeArchitecture:  name of the architecture of SomeUnit
#*     -> TargetLibrary:     [optional] target library which this unit should be compiled into;
#*                           librararies must be declared in ExtraLibraries (default: work)
#* 
#* note:  DO NOT ADD "grp" OR "unit" TO YOUR GROUP/UNIT NAME
#*        The last unit is automatically used as top-level unit
#* 
#*******************************************************************************
append Units {
}


#*******************************************************************************
#* BhvUnits
#* 
#* purpose:  declares behavioral units (simulation-only) needed by all units
#*           in this group
#* 
#* syntax:
#*     append BhvUnits {
#*         {SomeGroup SomeUnit SomeBhvArchitecture TargetLibrary}
#*         {AnotherGroup AnotherUnit AnotherBhvArchtecture AnotherTargetLibrary}
#*     }
#* 
#*     -> SomeGroup:            name of the group which contains the unit
#*     -> SomeUnit:             name of the unit that needs to be included for this group
#*     -> SomeBhvArchitecture:  name of the behavioral architecture of SomeUnit
#*     -> TargetLibrary:        [optional] target library which this unit should be compiled into;
#*                              librararies must be declared in ExtraLibraries (default: work)
#* 
#* note:  DO NOT ADD "grp" OR "unit" TO YOUR GROUP/UNIT NAME
#*        These units are not used for synthesis
#* 
#*******************************************************************************
append BhvUnits {
}


#*******************************************************************************
#* ForeignUnits
#* 
#* purpose:  declares units needed by all units in this group that do not
#*           follow the fhlow file structure; this can also be used to include
#*           e.g. Verilog source code or Quartus IP files
#* 
#* syntax:
#*     append ForeignUnits {
#*         {SomeGroup SomeUnit SomeFile IncludeInSimulation FileType TargetLibrary}
#*     }
#* 
#*     -> SomeGroup:            name of the group which contains the unit
#*     -> SomeUnit:             name of the unit that needs to be included for this group
#*     -> SomeFile:             name of the source file of SomeUnit (path relative to unit path)
#*     -> IncludeInSimulation:  [optional] if true, the file is compiled for simulation and
#*                              synthesis, else the file is only used for synthesis (default: false)
#*     -> FileType:             [optional] type of foreign file, can be VHDL, VERILOG, SYSTEMVERILOG,
#*                              or any file type specifier supported by the synthesis tool (e.g. QIP)
#*                              (default: VHDL)
#*     -> TargetLibrary:        [optional] target library which this unit should be compiled into;
#*                              librararies must be declared in ExtraLibraries (default: work)
#* 
#* note:  DO NOT ADD "grp" OR "unit" TO YOUR GROUP/UNIT NAME
#* 
#*******************************************************************************
append ForeignUnits {
}


#*******************************************************************************
#* ForeignTbUnits
#* 
#* purpose:  declares testbenches and behavioral units needed by all units in
#*           this group that do not follow the fhlow file structure; this can
#*           also be used to include Verilog and SystemVerilog source code
#* 
#* syntax:
#*     append ForeignTbUnits {
#*         {SomeGroup SomeUnit SomeFile FileType TargetLibrary}
#*     }
#* 
#*     -> SomeGroup:      name of the group which contains the unit
#*     -> SomeUnit:       name of the unit
#*     -> SomeFile:       name of the source file of SomeUnit (path relative to unit path)
#*     -> FileType:       [optional] type of foreign file, can be VHDL, VERILOG, or SYSTEMVERILOG
#*                        (default: VHDL)
#*     -> TargetLibrary:  [optional] target library which this unit should be compiled into;
#*                        librararies must be declared in ExtraLibraries (default: work)
#* 
#* note:  DO NOT ADD "grp" OR "unit" TO YOUR GROUP/UNIT NAME
#* 
#*******************************************************************************
append ForeignTbUnits {
}

