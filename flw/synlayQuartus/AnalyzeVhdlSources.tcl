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


puts "--------------------------------------------------------------------------------"
puts "Beginning to analyze all VHDL descriptions."
puts "--------------------------------------------------------------------------------"

# define language version
set_global_assignment -name VHDL_INPUT_VERSION ${SynVhdlInputVersion}

# Analyze all packages.
foreach {Package} $Packages {
    set GrpName [lindex ${Package} 0]
    set PackageName [lindex ${Package} 1]
    set LibraryName [lindex ${Package} 2]
    
    if { [string length ${LibraryName}] == 0 } {
        set LibraryName "work"
    }
    set_global_assignment -name VHDL_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/pkg${PackageName}/src/${PackageName}-p.vhd"] -library ${LibraryName}
}

#Compiling ForeignUnits
foreach {ForeignUnit} $ForeignUnits {
    set GrpName [lindex ${ForeignUnit} 0]
    set ForeignUnitName [lindex ${ForeignUnit} 1]
    set ForeignUnitPath [lindex ${ForeignUnit} 2]
    set FileType [lindex ${ForeignUnit} 4]
    set LibraryName [lindex ${ForeignUnit} 5]
    
    if { [string length ${LibraryName}] == 0 } {
        set LibraryName "work"
    }
    if { [string length ${FileType}] == 0 } {
        set FileType "VHDL"
    }
    set FileType [string toupper ${FileType}]

    if [string equal ${FileType} "VHDL"] {
        set_global_assignment -name VHDL_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}"] -library ${LibraryName}
    } elseif [string equal ${FileType} "VERILOG"] {
        set_global_assignment -name VERILOG_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}"] -library ${LibraryName}
    } elseif [string equal ${FileType} "SYSTEMVERILOG"] {
        set_global_assignment -name SYSTEMVERILOG_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}"] -library ${LibraryName}
    } else {
        set_global_assignment -name ${FileType}_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}"]
    }
}

# Analyze all entities before analyzing the architectures allows any
# ordering of units in the unit list $Units.
foreach {Unit} $Units {
    set GrpName [lindex ${Unit} 0]
    set UnitName [lindex ${Unit} 1]
    set EntityName $UnitName
    set LibraryName [lindex ${Unit} 3]
    
    if { [string length ${LibraryName}] == 0 } {
        set LibraryName "work"
    }
    
    # If there is a package containing definitions for the unit compile it.
    if [file exists "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${EntityName}-p.vhd"] then {
    	set_global_assignment -name VHDL_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${EntityName}-p.vhd"] -library ${LibraryName}
    }

    if [file exists "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${EntityName}-e.vhd"] then {
	    set_global_assignment -name VHDL_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${EntityName}-e.vhd"] -library ${LibraryName}
    }
}

# Analyze all architectures after all entities are analyzed.
foreach {Unit} $Units {
    set GrpName [lindex ${Unit} 0]
    set UnitName [lindex ${Unit} 1]
    set EntityName $UnitName
    set ArchitectureName [lindex ${Unit} 2]
    set LibraryName [lindex ${Unit} 3]
    
    if { [string length ${LibraryName}] == 0 } {
        set LibraryName "work"
    }
    
    if [file exists "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${EntityName}-${ArchitectureName}-ea.vhd"] then {
    	set_global_assignment -name VHDL_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${EntityName}-${ArchitectureName}-ea.vhd"] -library ${LibraryName}
    } elseif [file exists "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${EntityName}-${ArchitectureName}-eac.vhd"] then {
	    set_global_assignment -name VHDL_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${EntityName}-${ArchitectureName}-eac.vhd"] -library ${LibraryName}
    } else {
    	set_global_assignment -name VHDL_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${EntityName}-${ArchitectureName}-a.vhd"] -library ${LibraryName}
    }
}

# Analyze all configurations - if they exist - after all architectures are analyzed.
foreach {Unit} $Units {
    set GrpName [lindex ${Unit} 0]
    set UnitName [lindex ${Unit} 1]
    set EntityName $UnitName
    set ArchitectureName [lindex ${Unit} 2]
    set LibraryName [lindex ${Unit} 3]
    
    if { [string length ${LibraryName}] == 0 } {
        set LibraryName "work"
    }
    
    if [file exists "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${EntityName}-c.vhd"] then {
        set_global_assignment -name VHDL_FILE [file normalize "${PathLocalSynLayDir}/${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${EntityName}-${ArchitectureName}-c.vhd"] -library ${LibraryName}
    }
}

# define top level entity
set_global_assignment -name TOP_LEVEL_ENTITY ${UnitName}

export_assignments

puts "Analyzation of VHDL descriptions finished."

