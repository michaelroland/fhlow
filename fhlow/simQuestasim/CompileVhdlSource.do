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


## Delete the complete library: We do not want to simulate wrong versions and
## the simulator should notify us if we forgot some package or a unit.

set tbSuccess 0
set comperror ""
while {[file exists ${PathLocalSimDir}/simComp]} {
    set err ""
    if {[catch "file delete -force ${PathLocalSimDir}/simComp" err]} {
        puts ""
        puts "Failed to delete compilation folder at \"${PathLocalSimDir}/simComp\""
        puts "${err}"
    }
    after 1000
}
file mkdir ${PathLocalSimDir}/simComp

vlib ${PathLocalSimDir}/simComp/work
vmap work ${PathLocalSimDir}/simComp/work

############################
# creating extra libraries #
############################
if [info exists ExtraLibraries] then {
    foreach {ExtraLibrary} $ExtraLibraries {
        set LibName [lindex ${ExtraLibrary} 0]
		
        puts "Preparing    library                                        $LibName"
        vlib ${PathLocalSimDir}/simComp/${LibName}
        vmap ${LibName} ${PathLocalSimDir}/simComp/${LibName}
    }
}


######################
# compiling packages #
######################
if [info exists Packages] then {
    # Analyze all packages.
    foreach {Package} $Packages {
        set GrpName [lindex ${Package} 0]
        set PackageName [lindex ${Package} 1]
        set LibraryName [lindex ${Package} 2]
		
		if { [string length ${LibraryName}] == 0 } {
		    set LibraryName "work"
		}
		
        puts "Compiling    package                                        grp$GrpName, pkg$PackageName"
        catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/pkg${PackageName}/src/${PackageName}-p.vhd]" comperror
    }
}

######################################
# compiling files from $ForeignUnits #
######################################
if [info exists ForeignUnits] then {
    foreach {ForeignUnit} $ForeignUnits {
        set GrpName [lindex ${ForeignUnit} 0]
        set ForeignUnitName [lindex ${ForeignUnit} 1]
        set ForeignUnitPath [lindex ${ForeignUnit} 2]
        set ForeignUnitIncludeSim [lindex ${ForeignUnit} 3]
        set FileType [lindex ${ForeignUnit} 4]
        set LibraryName [lindex ${ForeignUnit} 5]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }

        if { [string length ${FileType}] == 0 } {
            set FileType "VHDL"
        }
        set FileType [string toupper ${FileType}]
        
        if [string is true -strict ${ForeignUnitIncludeSim}] {
            if [string equal ${FileType} "VHDL"] {
                puts "Compiling    foreign VHDL unit                              grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
                catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]" comperror
            } elseif [string equal ${FileType} "VERILOG"] {
                puts "Compiling    foreign Verilog unit                           grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
                catch "vlog -quiet ${VcomOptions} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]" comperror
            } elseif [string equal ${FileType} "SYSTEMVERILOG"] {
                puts "Compiling    foreign SystemVerilog unit                     grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
                catch "vlog -quiet ${VcomOptions} -sv -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]" comperror
            } else {
                puts "Skipping     foreign unit (${FileType} unsupported in simulation)   grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
            }
        } else {
            puts "Skipping     foreign unit                                   grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
        }
    }
}

####################################################
# compiling entities and architectures from $Units #
####################################################
if [info exists Units] then {    

    # Analyze all entities before analyzing the architectures allows any
    # ordering of units depends on the unit list $Units.
    foreach {Unit} $Units {
        set GrpName [lindex ${Unit} 0]
        set UnitName [lindex ${Unit} 1]
        set LibraryName [lindex ${Unit} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }
            
        #if [expr ${PostSynNetSim} == ${PostSynSDFSim}] {
            # compiling interface packages for unit if it exists
            if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${UnitName}-p.vhd] then {
                puts "Compiling    interface package                              grp$GrpName, unit$UnitName"
                catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${UnitName}-p.vhd]" comperror
            }
            
            # compiling entity if exists
            if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-e.vhd] then {
                puts "Compiling    entity                                         grp$GrpName, unit$UnitName"
                catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-e.vhd]" comperror
            }
        #}
    }
    
    # Analyze all architectures after all entities are analyzed.
    foreach {Unit} $Units {
        set GrpName [lindex ${Unit} 0]
        set UnitName [lindex ${Unit} 1]
        set ArchitectureName [lindex ${Unit} 2]
        set LibraryName [lindex ${Unit} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }
        
        if [expr ![info exists PostLayoutSim]] {
            if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-ea.vhd] then {
                # if file for entity and architecture exists, compile it
                puts "Compiling    entity-architecture                            grp$GrpName, unit$UnitName, $ArchitectureName"
                catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-ea.vhd]" comperror
            } elseif [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-eac.vhd] then {
                # if entity architecture configuration exists, compile it
                puts "Compiling    entity-architecture-configuration              grp$GrpName, unit$UnitName, $ArchitectureName"
                catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-eac.vhd]" comperror
            } else {
                # compile architecture
                puts "Compiling    architecture                                   grp$GrpName, unit$UnitName, $ArchitectureName"
                catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-a.vhd]" comperror
            }
        }
    }
    
    # Analyze all configurations - if they exist - after all architectures are analyzed.
    foreach {Unit} $Units {
        set GrpName [lindex ${Unit} 0]
        set UnitName [lindex ${Unit} 1]
        set LibraryName [lindex ${Unit} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }
            
        if ![info exists PostLayoutSim] {
            if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${UnitName}-c.vhd] then {
                puts "Compiling    configuration                                  grp$GrpName, unit$UnitName, $ArchitectureName"
                catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${UnitName}-c.vhd]" comperror
            }
        }
    }
}



#############################################
# compile netlist for PostLayout Simulation #
#############################################
if [info exists PostLayoutSim] {
    # uses the GrpName, UnitName, LibraryName of the last analyzed unit (i.e. the last unit in $Units)
    if [string match "Xilinx" ${ChipManufacturer}] then {
        if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-PostLayout-a.vhd] then {
            # if file for entity and architecture exists, compile it
            puts "Compiling    netlist                                        grp$GrpName, unit$UnitName, PostLayout."
            catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-PostLayout-a.vhd]" comperror
        } else {
            #error "${UnitName}-PostLayout-a.vhd does not exists!" 
            puts ""
            puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            puts "~ ${UnitName}-PostLayout-a.vhd not found! run Place & Route!"
            puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            puts ""
            puts ""
            puts "--------------------------------------------------------------------------------"
            puts "    Terminating script for Questasim because of an error."
            puts "--------------------------------------------------------------------------------"
            puts ""
            puts ""
            exit
        } 
     } else {
        if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-structure-ea.vhd] then {
            # if file for entity and architecture exists, compile it
            puts "Compiling    netlist                                        grp$GrpName, unit$UnitName, structure."
            catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-structure-ea.vhd]" comperror
        } else {
            #error "${UnitName}-structure-ea.vhd does not exists!" 
            puts ""
            puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            puts "~ ${UnitName}-structure-a.vhd not found! run Place & Route!"
            puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            puts ""
            puts ""
            puts "--------------------------------------------------------------------------------"
            puts "    Terminating script for Questasim because of an error."
            puts "--------------------------------------------------------------------------------"
            puts ""
            puts ""
            exit
        }
    }
}



###########################################
# compile behavioral units from $BhvUnits #
###########################################
if [info exists BhvUnits] then {

    # Analyze all entities before analyzing the architectures allows any
    # ordering of units in the unit list $BhvUnits.
    foreach {BhvUnit} $BhvUnits {
        set GrpName [lindex ${BhvUnit} 0]
        set BhvUnitName [lindex ${BhvUnit} 1]
        set LibraryName [lindex ${BhvUnit} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }

        if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/If${BhvUnitName}-p.vhd] then {
            puts "Compiling    bhv interface package                          grp$GrpName, unit$BhvUnitName"
            catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/If${BhvUnitName}-p.vhd]" comperror
        }
	    if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-e.vhd] then {
        	puts "Compiling    bhv entity                                     grp$GrpName, unit$BhvUnitName, $BhvUnitName"
        	catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-e.vhd]" comperror
    	}
    }
    
    # Analyze all architectures after all entities are analyzed.
    foreach {BhvUnit} $BhvUnits {
        set GrpName [lindex ${BhvUnit} 0]
        set BhvUnitName [lindex ${BhvUnit} 1]
        set BhvArchitectureName [lindex ${BhvUnit} 2]
        set LibraryName [lindex ${BhvUnit} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }

	    if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-ea.vhd] then {
		    puts "Compiling    bhv entity-architecture                        grp$GrpName, unit$BhvUnitName, $BhvArchitectureName"
        	catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-ea.vhd]" comperror
	    } elseif [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-eac.vhd] then {
		    puts "Compiling    bhv entity-architecture-coniguration           grp$GrpName, unit$BhvUnitName, $BhvArchitectureName"
        	catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-eac.vhd]" comperror
	    } else {
        	puts "Compiling    bhv architecture                               grp$GrpName, unit$BhvUnitName, $BhvArchitectureName"
        	catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-a.vhd]" comperror
	    }
    }
    
    # Analyze all configurations - if they exist - after all architectures are analyzed.
    foreach {BhvUnit} $BhvUnits {
        set GrpName [lindex ${BhvUnit} 0]
        set BhvUnitName [lindex ${BhvUnit} 1]
        set BhvArchitectureName [lindex ${BhvUnit} 2]
        set LibraryName [lindex ${BhvUnit} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }
    
        if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/If${BhvUnitName}-c.vhd] then {
            puts "Compiling    configuration                                  grp$GrpName, unit$BhvUnitName, $BhvArchitectureName"
            catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/If${BhvUnitName}-${BhvArchitectureName}-c.vhd]" comperror
        }
    }
}


########################################
# compiling files from $ForeignTbUnits #
########################################
if [info exists ForeignTbUnits] then {
    foreach {ForeignTbUnit} $ForeignTbUnits {
        set GrpName [lindex ${ForeignTbUnit} 0]
        set ForeignUnitName [lindex ${ForeignTbUnit} 1]
        set ForeignUnitPath [lindex ${ForeignTbUnit} 2]
        set FileType [lindex ${ForeignTbUnit} 3]
        set LibraryName [lindex ${ForeignTbUnit} 4]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }

        if { [string length ${FileType}] == 0 } {
            set FileType "VHDL"
        }
        set FileType [string toupper ${FileType}]
        
        if [string equal ${FileType} "VHDL"] {
            puts "Compiling    foreign VHDL testbench                         grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
            catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]" comperror
        } elseif [string equal ${FileType} "VERILOG"] {
            puts "Compiling    foreign Verilog testbench                      grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
            catch "vlog -quiet ${VcomOptions} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]" comperror
        } elseif [string equal ${FileType} "SYSTEMVERILOG"] {
            puts "Compiling    foreign SystemVerilog testbench                grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
            catch "vlog -quiet ${VcomOptions} -sv -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]" comperror
        } else {
            puts "Skipping     foreign testbench (${FileType} unsupported in simulation)    grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
        }
    }
}

#####################################
# compile testbenches from $tbUnits #
#####################################
if [info exists tbUnits] then {

    # Testbenches
    # Analyze all entities before analyzing the architectures allows any
    # ordering of units in the unit list $tbUnits.
    foreach {tbUnit} $tbUnits {
        set GrpName [lindex ${tbUnit} 0]
        set tbUnitName [lindex ${tbUnit} 1]
        set LibraryName [lindex ${tbUnit} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }
        
        # because we need to know which one is the desired testbench! (i.e. the last testbench in the list)
        set tbName $tbUnitName   
        
        if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-e.vhd] then {
            puts "Compiling    testbench entity                               grp$GrpName, unit$tbUnitName, $tbUnitName"
            catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-e.vhd]" comperror
        }
    }
    
    # Analyze all architectures after all entities are analyzed.
    foreach {tbUnit} $tbUnits {
        set GrpName [lindex ${tbUnit} 0]
        set tbUnitName [lindex ${tbUnit} 1]
        set tbArchitectureName [lindex ${tbUnit} 2]
        set LibraryName [lindex ${tbUnit} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }

    	set tbSuccess 0
        
	    if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-ea.vhd] then {
		    puts "Compiling    testbench entity-architecture                  grp$GrpName, unit$UnitName, $tbArchitectureName"
        	catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-ea.vhd]" comperror
		    set tbSuccess 1
	    } elseif [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-eac.vhd] then {
		    puts "Compiling    testbench entity-architecture-configuration    grp$GrpName, unit$UnitName, $tbArchitectureName"
        	catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-eac.vhd]" comperror
		    set tbSuccess 1
	    } else {
		    if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-a.vhd] then {
           		puts "Compiling    testbench architecture                         grp$GrpName, unit$tbUnitName, $tbArchitectureName"
          		catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-a.vhd]" comperror
			    set tbSuccess 1
        	} else {
    			# signalize user that testbench was not found
	    		if [info exists Shell] then {
	   	    		puts ""
	   		    	puts "Specified Testbench was not found!"
	   			    puts "Check Config.tcl!"
    	   			puts ""
	    			set tbSuccess 0	
		    	} else {
			    	puts ""
	   			    puts "Specified Testbench was not found!"
    	   			puts "Check Config.tcl!"
	       			puts ""
		    		tk_messageBox -message "No Architecture found for your testbench!\nCheck Config.tcl!" \
			    		-title "Testbench Warning" -icon warning
				    set tbSuccess 0	
			    }
           	}
        }
    }
    # Analyze all configurations - if they exist - after all architectures are analyzed.
    foreach {tbUnit} $tbUnits {
        set GrpName [lindex ${tbUnit} 0]
        set tbUnitName [lindex ${tbUnit} 1]
        set tbArchitectureName [lindex ${tbUnit} 2]
        set LibraryName [lindex ${tbUnit} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }
        
        if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/Iftb${tbUnitName}-c.vhd] then {
            puts "Compiling    testbench configuration                        grp$GrpName, unit$tbUnitName, $tbArchitectureName"
            catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/Iftb${tbUnitName}-${tbArchitectureName}-c.vhd]" comperror
        }
    }
}

#################################################
# compile testbenches for packages from $tbPkgs #
#################################################
if [info exists tbPkgs] then {
    # Testbenches for packages
    # Analyze all entities before analyzing the architectures allows any
    # ordering of units in the unit list $tbUnits.
    foreach {tbPkg} $tbPkgs {
        set GrpName [lindex ${tbPkg} 0]
        set tbPkgName [lindex ${tbPkg} 1]
        set LibraryName [lindex ${tbPkg} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }
        
        # because we need to know which one is the desired testbench! (i.e. the last testbench in the list)
        set tbName tbPkgName

        puts "Compiling    pkg testbench entity                           grp$GrpName, pkg$tbPkgName"
        catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbUnitName}-e.vhd]" comperror
    }
    
    # Analyze all architectures after all entities are analyzed.
    foreach {tbPkg} $tbPkgs {
        set GrpName [lindex ${tbPkg} 0]
        set tbPkgName [lindex ${tbPkg} 1]
        set tbArchitectureName [lindex ${tbPkg} 2]
        set LibraryName [lindex ${tbPkg} 3]
        
        if { [string length ${LibraryName}] == 0 } {
            set LibraryName "work"
        }
        
        puts "Compiling    architecture                                   grp$GrpName, pkg$tbPkgName, $tbArchitectureName"
        catch "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbUnitName}-${tbArchitectureName}-a.vhd]" comperror

    }
}

if [expr  {${comperror}!=""}] then {
    puts ""
    puts ""
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "~ There were several errors during compilation!"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts ""
    puts ""
    puts "--------------------------------------------------------------------------------"
    puts "    Terminating script for Questasim because of an compilation error."
    puts "--------------------------------------------------------------------------------"
    puts ""
    exit    
}
