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


catch {
    #searching for config.tcl on group level
    if [file exists ${PathUnitToRoot}/Config.tcl] then {
        set DoingSynthesis 0
        source ${PathUnitToRoot}/Config.tcl
    }
    #searching for config.tcl on unit level
    if [file exists ${PathLocalSimDir}/../../../Config.tcl] then {
        source ${PathLocalSimDir}/../../../Config.tcl
    }
    #doing config.tcl in unit
    source ${PathLocalSimDir}/../../Config.tcl

    # VHDL input version
    if [expr ![info exists VhdlInputVersion]] then {
        set VhdlInputVersion 1993
    }
    
    set VcomVhdlInputVersion "-93"
    if { ${VhdlInputVersion} == 1987 } then {
        set VcomVhdlInputVersion "-87"
    } elseif { ${VhdlInputVersion} == 87 } then {
        set VcomVhdlInputVersion "-87"
    } elseif { ${VhdlInputVersion} == 1993 } then {
        set VcomVhdlInputVersion "-93"
    } elseif { ${VhdlInputVersion} == 93 } then {
        set VcomVhdlInputVersion "-93"
    } elseif { ${VhdlInputVersion} == 2002 } then {
        set VcomVhdlInputVersion "-2002"
    } elseif { ${VhdlInputVersion} == 2008 } then {
        set VcomVhdlInputVersion "-2008"
    #} elseif { ${VhdlInputVersion} == 2012 } then {
    #    set VcomVhdlInputVersion "-2012"
    } else {
        puts "VhdlInputVersion: Version \"${VhdlInputVersion}\" not supported!"
        after 5000
        exit
    }


    #Check if Config.tcl's are correct

    # Verify that Variable Packages exists
    if [expr ![info exists Packages]] then {
        puts "Packages: Variable Packages does not exist in your Config.tcl!"
        after 5000
        exit
    }

    # Verify that Variable Units exists
    if [expr ![info exists Units]] then {
        puts "Units: Variable Units does not exist in your Config.tcl!"
        after 5000
        exit
    }

    # Verify that Variable ForeignUnits exists
    if [expr ![info exists ForeignUnits]] then {
        puts "ForeignUnits: Variable ForeignUnits does not exist in your Config.tcl!"
        after 5000
        exit
    }

    # Verify that Variable BhvUnits exists
    if [expr ![info exists BhvUnits]] then {
        puts "BhvUnits: Variable ForeignUnits does not exist in your Config.tcl!"
        after 5000
        exit
    }

    # Verify that Variable ForeignTbUnits exists
    if [expr ![info exists ForeignTbUnits]] then {
        puts "ForeignUnits: Variable ForeignTbUnits does not exist in your Config.tcl!"
        after 5000
        exit
    }

    # Verify that Variable tbUnits exists
    if [expr ![info exists tbUnits]] then {
        puts "tbUnits: Variable tbUnits does not exist in your Config.tcl!"
        after 5000
        exit
    }

    # Verify that Variable SimTime exists
    if [expr ![info exists SimTime]] then {
        puts "SimTime: Variable SimTime does not exist in your Config.tcl!"
        after 5000
        exit
    }
}
