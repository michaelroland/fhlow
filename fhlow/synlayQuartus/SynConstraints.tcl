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


puts "--------------------------------------------------------------------------------"
puts "Setting synthesis constraints."
puts "--------------------------------------------------------------------------------"

# define Pins
foreach {Pin} ${Pins} {
    set SignalName [lindex ${Pin} 0]
    set PinNr [lindex ${Pin} 1]
    set PullUp [lindex ${Pin} 2]
    set IOStandard [lindex ${Pin} 3]
    set PinParams [lindex ${Pin} 4]
    set TagId [lindex ${Pin} 5]

    set TagIdParam ""
    if { [string length ${TagId}] != 0 } {
        set TagIdParam "-tag"
    }
    
    if { [string length ${PinNr}] != 0 } {
        set_location_assignment PIN_${PinNr} -to ${SignalName} ${TagIdParam} ${TagId}
    }
    # define Pullups on Inputs
    if { [string length ${PullUp}] != 0 } {
        if [expr $PullUp] {
            set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to ${SignalName} ${TagIdParam} ${TagId}
        }
    }
    if { [string length ${IOStandard}] != 0 } {
        set_instance_assignment -name IO_STANDARD "${IOStandard}" -to ${SignalName} ${TagIdParam} ${TagId}
    }
    if { [string length ${PinParams}] != 0 } {
        foreach {PinParam} ${PinParams} {
            set ParamName [lindex ${PinParam} 0]
            set ParamValue [lindex ${PinParam} 1]
            if { [string length ${ParamName}] != 0 } {
                if { [string length ${ParamValue}] != 0 } {
                    set_instance_assignment -name ${ParamName} "${ParamValue}" -to ${SignalName} ${TagIdParam} ${TagId}
                } else {
                    set_instance_assignment -name ${ParamName} -to ${SignalName} ${TagIdParam} ${TagId}
                }
            }
        }
    }
}

if [info exists ChipInstanceAssignments] then {
    foreach {ChipInstanceAssignment} ${ChipInstanceAssignments} {
        set Target [lindex ${ChipInstanceAssignment} 0]
        set ParamName [lindex ${ChipInstanceAssignment} 1]
        set ParamValue [lindex ${ChipInstanceAssignment} 2]
        set TagId [lindex ${ChipInstanceAssignment} 3]
        if { [string length ${ParamName}] != 0 } {
            set TagIdParam ""
            if { [string length ${TagId}] != 0 } {
                set TagIdParam "-tag"
            }
            if { [string length ${ParamValue}] != 0 } {
                set_instance_assignment -name ${ParamName} "${ParamValue}" -to "${Target}" ${TagIdParam} ${TagId}
            } else {
                set_instance_assignment -name ${ParamName} -to "${Target}" ${TagIdParam} ${TagId}
            }
        }
    }
}

if [info exists ChipDefaultIOStandard] then {
    set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "${ChipDefaultIOStandard}"
}

if [info exists ChipGlobalAssignments] then {
    foreach {ChipGlobalAssignment} ${ChipGlobalAssignments} {
        set ParamName [lindex ${ChipGlobalAssignment} 0]
        set ParamValue [lindex ${ChipGlobalAssignment} 1]
        if { [string length ${ParamName}] != 0 } {
            if { [string length ${ParamValue}] != 0 } {
                set_global_assignment -name ${ParamName} "${ParamValue}"
            } else {
                set_global_assignment -name ${ParamName}
            }
        }
    }
}

# Define Modelsim as eda_simulation_tool so that we get an netlist
# for postlayout simulation
#set_global_assignment -section_id "${UnitName}" -name EDA_SIMULATION_TOOL "MODELSIM (VHDL OUTPUT FROM QUARTUS II)"
set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim (VHDL)"
set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation

set_global_assignment -name FMAX_REQUIREMENT ${ChipFrequency}MHz
set_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER ON
set_global_assignment -name SDC_FILE [file normalize ${PathGlobalSynLayDir}/TimingConstraints.tcl]

set_global_assignment -name GENERATE_RBF_FILE ON
