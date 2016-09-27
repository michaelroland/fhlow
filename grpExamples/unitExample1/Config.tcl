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
}


#*******************************************************************************
#* Packages
#* 
#* purpose:  declares packages needed by this unit
#* 
#* syntax:
#*     append Packages {
#*         {SomeGroup SomePackage TargetLibrary}
#*         {AnotherGroup AnotherPackage AnotherTargetLibrary}
#*     }
#* 
#*     -> SomeGroup:      name of the group which contains the package
#*     -> SomePackage:    name of the package that needs to be included for this unit
#*     -> TargetLibrary:  [optional] target library which this package should be compiled into;
#*                        librararies must be declared in ExtraLibraries (default: work)
#*
#* note:  DO NOT ADD "grp" OR "pkg" TO YOUR GROUP/PACKAGE NAME
#* 
#*******************************************************************************
append Packages {
}


#*******************************************************************************
#* Units
#* 
#* purpose:  declares units needed by this unit
#* 
#* syntax:
#*     append Units {
#*         {SomeGroup SomeUnit SomeArchitecture TargetLibrary}
#*         {AnotherGroup AnotherUnit AnotherArchtecture AnotherTargetLibrary}
#*     }
#* 
#*     -> SomeGroup:         name of the group which contains the unit
#*     -> SomeUnit:          name of the unit that needs to be included for this unit
#*     -> SomeArchitecture:  name of the architecture of SomeUnit
#*     -> TargetLibrary:     [optional] target library which this unit should be compiled into;
#*                           librararies must be declared in ExtraLibraries (default: work)
#* 
#* note:  DO NOT ADD "grp" OR "unit" TO YOUR GROUP/UNIT NAME
#*        The last unit is automatically used as top-level unit
#* 
#*******************************************************************************
append Units {
    {Examples Example1 Rtl}
}


#*******************************************************************************
#* BhvUnits
#* 
#* purpose:  declares behavioral units (simulation-only) needed by this unit
#* 
#* syntax:
#*     append BhvUnits {
#*         {SomeGroup SomeUnit SomeBhvArchitecture TargetLibrary}
#*         {AnotherGroup AnotherUnit AnotherBhvArchtecture AnotherTargetLibrary}
#*     }
#* 
#*     -> SomeGroup:            name of the group which contains the unit
#*     -> SomeUnit:             name of the unit that needs to be included for this unit
#*     -> SomeBhvArchitecture:  name of the behavioral architecture of SomeUnit
#*     -> TargetLibrary:        [optional] target library which this unit should be compiled into;
#*                              librararies must be declared in ExtraLibraries (default: work)
#* 
#* note:  DO NOT ADD "grp" OR "unit" TO YOUR GROUP/UNIT NAME
#*        These units are not used for synthesis
#* 
#*******************************************************************************
append BhvUnits {
    {StrobesClocks PwrOnReset Bhv}
    {StrobesClocks Oscillator Bhv}
}


#*******************************************************************************
#* ForeignUnits
#* 
#* purpose:  declares units needed by this unit that do not follow the fhlow
#*           file structure; this can also be used to include e.g. Verilog
#*           source code or Quartus IP files
#* 
#* syntax:
#*     append ForeignUnits {
#*         {SomeGroup SomeUnit SomeFile IncludeInSimulation FileType TargetLibrary}
#*     }
#* 
#*     -> SomeGroup:            name of the group which contains the unit
#*     -> SomeUnit:             name of the unit that needs to be included for this unit
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
#* purpose:  declares testbenches and behavioral units needed by this unit that
#*           do not follow the fhlow file structure; this can also be used to
#*           include Verilog and SystemVerilog source code
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


#*******************************************************************************
#* tbUnits
#* 
#* purpose:  declares testbenches for this unit
#* 
#* syntax:
#*     append tbUnits {
#*         {SomeGroup SomeUnit SomeTestbenchArchitecture TargetLibrary}
#*     }
#* 
#*     -> SomeGroup:                  name of the group which contains the unit
#*     -> SomeUnit:                   name of the unit that contains the testbench
#*     -> SomeTestbenchArchitecture:  name of the testbench architecture
#*     -> TargetLibrary:              [optional] target library which this unit should be compiled into;
#*                                    librararies must be declared in ExtraLibraries (default: work)
#* 
#* note:  DO NOT ADD "grp" OR "unit" TO YOUR GROUP/UNIT NAME
#*        DO NOT ADD "tb" TO YOUR TESTBENCH UNIT/ARCHITECTURE NAME
#*        The last unit is automatically loaded for simulation
#* 
#*******************************************************************************
set tbUnits  {
    {Examples Example1 Bhv}
}


#*******************************************************************************
#*****  Simulation  ************************************************************
#*******************************************************************************

#*******************************************************************************
#* SimTime
#* 
#* purpose:  time period that should be simulated
#* 
#* examples:
#*     set SimTime "100 fs"
#*     set SimTime "10 ns"
#* 
#*******************************************************************************
set SimTime "100 us"


#*******************************************************************************
#*****  Synthesis  *************************************************************
#*******************************************************************************

#*******************************************************************************
#* Pins
#* 
#* purpose:  defines to which pins the output signals of the top-level entity
#*           should be connected to
#* 
#* syntax:
#*     set Pins {
#*         {Signal FPGAPin}
#*         {Signal FPGAPin Pullup}
#*         {Signal FPGAPin Pullup IOStandard}
#*         {Signal FPGAPin Pullup IOStandard AdditionalParams}
#*         {Signal FPGAPin Pullup IOStandard {
#*             {Name Value}
#*             {Name Value}
#*         }}
#*     }
#* 
#*     -> Signal:            signal/port of top level entity (e.g. iClk)
#*     -> FPGAPin:           number/name of PIN on FPGA (e.g. A12)
#*     -> Pullup:            [optional] enable weak pull-up resistor (1=yes, 0=no)
#*     -> IOStandard:        [optional] I/O standard to use on this PIN (e.g. "3.3-V LVTTL")
#*     -> AdditionalParams:  [optional] list of additional parameters for use with set_instance_assignment on this pin
#*          -> Name:   name of parameter (e.g. INPUT_TERMINATION)
#*          -> Value:  [optional] value of parameter (e.g. "PARALLEL 50 OHM WITH CALIBRATION")
#* 
#* examples:
#*     set Pins {
#*         {oTest A88 0}
#*         {iTest B23 1 "3.3-V LVTTL"}
#*         {oAbc  C44 0 "" {
#*             {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"}
#*         }}
#*     }
#* 
#* WARNING: be very careful with this setting! check your pad reports!
#* 
#*******************************************************************************

#============================================================
# Pinout for Altera DE1-SoC Rev. E
#============================================================
set Pins {
}

# CLOCKS
append Pins {
    {iClk AF14 0 "3.3-V LVTTL"}
}

# BUTTONS (KEY0..KEY3)
append Pins {
    {inResetAsync AA14 0 "3.3-V LVTTL"}
}

# 7 SEGMENT (HEX0..HEX5)
append Pins {
    {oSEG0[0] AE26 0 "3.3-V LVTTL"}
    {oSEG0[1] AE27 0 "3.3-V LVTTL"}
    {oSEG0[2] AE28 0 "3.3-V LVTTL"}
    {oSEG0[3] AG27 0 "3.3-V LVTTL"}
    {oSEG0[4] AF28 0 "3.3-V LVTTL"}
    {oSEG0[5] AG28 0 "3.3-V LVTTL"}
    {oSEG0[6] AH28 0 "3.3-V LVTTL"}

    {oSEG1[0] AJ29 0 "3.3-V LVTTL"}
    {oSEG1[1] AH29 0 "3.3-V LVTTL"}
    {oSEG1[2] AH30 0 "3.3-V LVTTL"}
    {oSEG1[3] AG30 0 "3.3-V LVTTL"}
    {oSEG1[4] AF29 0 "3.3-V LVTTL"}
    {oSEG1[5] AF30 0 "3.3-V LVTTL"}
    {oSEG1[6] AD27 0 "3.3-V LVTTL"}

    {oSEG2[0] AB23 0 "3.3-V LVTTL"}
    {oSEG2[1] AE29 0 "3.3-V LVTTL"}
    {oSEG2[2] AD29 0 "3.3-V LVTTL"}
    {oSEG2[3] AC28 0 "3.3-V LVTTL"}
    {oSEG2[4] AD30 0 "3.3-V LVTTL"}
    {oSEG2[5] AC29 0 "3.3-V LVTTL"}
    {oSEG2[6] AC30 0 "3.3-V LVTTL"}

    {oSEG3[0] AD26 0 "3.3-V LVTTL"}
    {oSEG3[1] AC27 0 "3.3-V LVTTL"}
    {oSEG3[2] AD25 0 "3.3-V LVTTL"}
    {oSEG3[3] AC25 0 "3.3-V LVTTL"}
    {oSEG3[4] AB28 0 "3.3-V LVTTL"}
    {oSEG3[5] AB25 0 "3.3-V LVTTL"}
    {oSEG3[6] AB22 0 "3.3-V LVTTL"}

    {oSEG4[0] AA24 0 "3.3-V LVTTL"}
    {oSEG4[1] Y23  0 "3.3-V LVTTL"}
    {oSEG4[2] Y24  0 "3.3-V LVTTL"}
    {oSEG4[3] W22  0 "3.3-V LVTTL"}
    {oSEG4[4] W24  0 "3.3-V LVTTL"}
    {oSEG4[5] V23  0 "3.3-V LVTTL"}
    {oSEG4[6] W25  0 "3.3-V LVTTL"}

    {oSEG5[0] V25  0 "3.3-V LVTTL"}
    {oSEG5[1] AA28 0 "3.3-V LVTTL"}
    {oSEG5[2] Y27  0 "3.3-V LVTTL"}
    {oSEG5[3] AB27 0 "3.3-V LVTTL"}
    {oSEG5[4] AB26 0 "3.3-V LVTTL"}
    {oSEG5[5] AA26 0 "3.3-V LVTTL"}
    {oSEG5[6] AA25 0 "3.3-V LVTTL"}
}
