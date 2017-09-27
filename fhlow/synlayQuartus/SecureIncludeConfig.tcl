#*******************************************************************************
#* This file is part of fhlow (fast handling of a lot of work), a working
#* environment that speeds up the development of and structures FPGA design
#* projects.
#* 
#* Copyright (c) 2003-2005 Markus Pfaff <markus.pfaff@fh-hagenberg.at>
#* Copyright (c) 2005 Christian Kitzler <christian.kitzler@fh-hagenberg.at>
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


set CurrentConfigIncludeFile ""
if {1 == [catch {
    #searching for config.tcl on root level
    set CurrentConfigIncludeFile ${PathLocalSynLayDir}/${PathUnitToRoot}/Config.tcl
    if [file exists $CurrentConfigIncludeFile] then {
        source $CurrentConfigIncludeFile
    }
    #searching for config.tcl on group level
    set CurrentConfigIncludeFile ${PathLocalSynLayDir}/../../../Config.tcl
    if [file exists $CurrentConfigIncludeFile] then {
        source $CurrentConfigIncludeFile
    }
    #searching for config.tcl on unit level
    set CurrentConfigIncludeFile ${PathLocalSynLayDir}/../../Config.tcl
    if [file exists $CurrentConfigIncludeFile] then {
        source $CurrentConfigIncludeFile
    } else {
        error "Configuration file [file normalize $CurrentConfigIncludeFile] not found!"
    }
} err]} {
    error "Failed to include configuration file [file normalize $CurrentConfigIncludeFile]!\n$err"
}

# VHDL input version
if [expr ![info exists VhdlInputVersion]] then {
    set VhdlInputVersion 1993
}

set SynVhdlInputVersion "-93"
if { ${VhdlInputVersion} == 1987 } then {
    set SynVhdlInputVersion "VHDL_1987"
} elseif { ${VhdlInputVersion} == 87 } then {
    set SynVhdlInputVersion "VHDL_1987"
} elseif { ${VhdlInputVersion} == 1993 } then {
    set SynVhdlInputVersion "VHDL_1993"
} elseif { ${VhdlInputVersion} == 93 } then {
    set SynVhdlInputVersion "VHDL_1993"
} elseif { ${VhdlInputVersion} == 2002 } then {
    # automatically fall back to 1993 since Quartus does not support 2002 (!!!)
    set SynVhdlInputVersion "VHDL_1993"
} elseif { ${VhdlInputVersion} == 2008 } then {
    set SynVhdlInputVersion "VHDL_2008"
#} elseif { ${VhdlInputVersion} == 2012 } then {
#    set SynVhdlInputVersion "VHDL_2012"
} else {
    error "VhdlInputVersion \"${VhdlInputVersion}\" is not a supported version!"
}

    
#Check if Config.tcl's are correct

# Verify that Variable Packages exists
if [expr ![info exists Packages]] then {
    error "Variable Packages does not exist in your Config.tcl!"
}

# Verify that Variable Units exists
if [expr ![info exists Units]] then {
    error "Variable Units does not exist in your Config.tcl!"
}

# Verify that Variable ForeignUnits exists
if [expr ![info exists ForeignUnits]] then {
    error "Variable ForeignUnits does not exist in your Config.tcl!"
}

# Verify that Variable ChipManufacturer exists
if [expr ![info exists ChipManufacturer]] then {
    error "Variable ChipManufacturer does not exist in your Config.tcl!"
}

# Verify that Variable ChipFamily exists
if [expr ![info exists ChipFamily]] then {
    error "Variable ChipFamily does not exist in your Config.tcl!"
}

# Verify that Variable ChipPart exists
if [expr ![info exists ChipPart]] then {
    error "Variable ChipPart does not exist in your Config.tcl!"
}

# Verify that Variable ChipPackage exists
if [expr ![info exists ChipPackage]] then {
    error "Variable ChipPackage does not exist in your Config.tcl!"
}

# Verify that Variable ChipSpeedgrade exists
if [expr ![info exists ChipSpeedgrade]] then {
    error "Variable ChipSpeedgrade does not exist in your Config.tcl!"
}

# Verify that Variable ChipFrequency exists
if [expr ![info exists ChipFrequency]] then {
    error "Variable ChipFrequency does not exist in your Config.tcl!"
}

# Verify that Variable Pins exists
if [expr ![info exists Pins]] then {
    error "Variable Pins does not exist in your Config.tcl!"
}
