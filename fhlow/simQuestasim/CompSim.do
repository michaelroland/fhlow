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
    #setting the paths for files and tools

    puts ""
    puts ""
    puts "--------------------------------------------------------------------------------"
    puts "    Begin script for Questasim."
    puts "--------------------------------------------------------------------------------"
    puts ""
    
    set PathLocalSimDir .
    set PathUnitToRoot ../../../..
    set PathGlobalSimDir ${PathUnitToRoot}/fhlow/[file tail [pwd]]

    # compile
    source ${PathGlobalSimDir}/Comp.do

    # look if we had an error on compiling with current configuration
    if [expr $ConfigError] then {
        do ${PathGlobalSimDir}/UnsetVariables.tcl
    } else {

        # compilation worked fine
        source ${PathLocalSimDir}/../../Config.tcl
        if [expr $tbSuccess] then {
            
            if [expr ! [info exists UnitName]] then {
                set UnitName IdoNotExist
            }
            
            
            if [info exists PostLayoutSim] {
                if [file exists ${PathLocalSimDir}/../../src/${UnitName}.sdf] then {
                    puts ""
                    puts "---------- start of simulation (using delay information form SDF file) ---------"
                    puts ""
                    
                    vsim -quiet ${VsimOptions} -sdfmax /DUT=[file normalize ${PathLocalSimDir}/../../src/${UnitName}.sdf] -noglitch -t ps work.tb${tbName}
                    source ${PathLocalSimDir}/Wave.do
                    
                    set DurationBegin [clock seconds]
                    source ${PathGlobalSimDir}/RunSim.do
                    
                    puts ""
                    puts "----------- end of simulation (using delay information form SDF file) ----------"
                    puts ""
                    puts ""
                } else {
                    puts "no sdf file found"
                }
            } else {

                puts ""
                puts "---------------------------- start of simulation -------------------------------"
                puts ""

                # simulate either with custom Wave.do
                # or with default Wave.do
                if [file exists ${PathLocalSimDir}/Wave.do] then {
                    vsim -quiet ${VsimOptions} work.tb${tbName}
                    source ${PathLocalSimDir}/Wave.do
                    
                    set DurationBegin [clock seconds]
                    source ${PathGlobalSimDir}/RunSim.do
                    
                } else {
                    vsim -quiet ${VsimOptions} work.tb${tbName}
                    source ${PathGlobalSimDir}/Wave.do
                    
                    set DurationBegin [clock seconds]
                    source ${PathGlobalSimDir}/RunSim.do
                }
                
                puts ""
                puts "----------------------------- end of simulation --------------------------------"
                puts ""
                puts ""
                
            }	
            
            set DurationEnd [clock seconds]
            set Duration [expr ${DurationEnd} - ${DurationBegin}]
            
            if [info exists Shell] then {
                puts "Duration of Simulation: ${Duration} sec"
                
            } else {		
                # Display Simulation Duration in a MessageBox
                tk_messageBox -message "${Duration} sec                                     " \
                    -title "Duration of Simulation" 
            }
            
        } else {
            # tell user that something went wrong with his testbench
            if [info exists Shell] then {
                puts "Specified Testbench was not found!"
                puts "Check Config.tcl!" 
                puts "Can't Simulate!"
            } else {
                tk_messageBox -message "Specified Testbench was not found!\nCheck Config.tcl!\nCan't Simulate!" \
                    -title "Testbench Warning" -icon warning
            }
        }
        # unset tcl variables
        source $PathGlobalSimDir/UnsetVariables.tcl
    }
    
    puts ""
    puts ""
    puts "--------------------------------------------------------------------------------"
    puts "    End of script for Questasim."
    puts "--------------------------------------------------------------------------------"
    puts ""
    puts ""
    
    #exit
}
