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
		
		if {1 == [catch {
			if [file exists ${PathUnitToRoot}/grp${GrpName}/pkg${PackageName}/src/${PackageName}-p.vhd] then {
				puts "Compiling    package                                        grp$GrpName, pkg$PackageName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/pkg${PackageName}/src/${PackageName}-p.vhd]"
			} else {
				puts stderr "Missing      package                                        grp$GrpName, pkg$PackageName"
			}
		} err]} {
			set comperror "$err"
		}
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
        
		if {1 == [catch {
			if [string is true -strict ${ForeignUnitIncludeSim}] {
				if [string equal ${FileType} "VHDL"] {
					puts "Compiling    foreign VHDL unit                              grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
					eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]"
				} elseif [string equal ${FileType} "VERILOG"] {
					puts "Compiling    foreign Verilog unit                           grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
					eval "vlog -quiet ${VcomOptions} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]"
				} elseif [string equal ${FileType} "SYSTEMVERILOG"] {
					puts "Compiling    foreign SystemVerilog unit                     grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
					eval "vlog -quiet ${VcomOptions} -sv -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]"
				} else {
					puts "Skipping     foreign unit (${FileType} unsupported in simulation)   grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
				}
			} else {
				puts "Skipping     foreign unit                                   grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
			}
		} err]} {
			set comperror "$err"
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
            
        #if [expr ${PostSynNetSim} == ${PostSynSDFSim}] {}
        if [expr ![info exists PostLayoutSim]] {
			if {1 == [catch {
				# compiling interface packages for unit if it exists
				if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${UnitName}-p.vhd] then {
					puts "Compiling    interface package                              grp$GrpName, unit$UnitName"
					eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${UnitName}-p.vhd]"
				}
				
				# compiling entity if exists
				if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-e.vhd] then {
					puts "Compiling    entity                                         grp$GrpName, unit$UnitName"
					eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-e.vhd]"
				}
			} err]} {
				set comperror "$err"
			}
        }
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
			if {1 == [catch {
				if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-ea.vhd] then {
					# if file for entity and architecture exists, compile it
					puts "Compiling    entity-architecture                            grp$GrpName, unit$UnitName, $ArchitectureName"
					eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-ea.vhd]"
				} elseif [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-eac.vhd] then {
					# if entity architecture configuration exists, compile it
					puts "Compiling    entity-architecture-configuration              grp$GrpName, unit$UnitName, $ArchitectureName"
					eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-eac.vhd]"
				} elseif [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-a.vhd] then {
					# compile architecture
					puts "Compiling    architecture                                   grp$GrpName, unit$UnitName, $ArchitectureName"
					eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${UnitName}-${ArchitectureName}-a.vhd]"
				} else {
					puts stderr "Missing      architecture                                   grp$GrpName, unit$UnitName, $ArchitectureName"
				}
			} err]} {
				set comperror "$err"
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
			if {1 == [catch {
				if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${UnitName}-c.vhd] then {
					puts "Compiling    configuration                                  grp$GrpName, unit$UnitName, $ArchitectureName"
					eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/If${UnitName}-c.vhd]"
				}
			} err]} {
				set comperror "$err"
			}
        }
    }
}



#############################################
# compile netlist for PostLayout Simulation #
#############################################
if [info exists PostLayoutSim] {
    # uses the GrpName, UnitName, LibraryName of the last analyzed unit (i.e. the last unit in $Units)
	set PostLayoutVhdFile "${UnitName}-structure-ea.vhd"
    if [string match "Xilinx" ${ChipManufacturer}] then {
		set PostLayoutVhdFile "${UnitName}-PostLayout-a.vhd"
	}
	if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${PostLayoutVhdFile}] then {
		if {1 == [catch {
			# if file for entity and architecture exists, compile it
			puts "Compiling    netlist                                        grp$GrpName, unit$UnitName."
			eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${UnitName}/src/${PostLayoutVhdFile}]"
		} err]} {
			set comperror "$err"
		}
	} else {
		error "Post-layout netlist ${PostLayoutVhdFile} does not exists! Run place & route first!"
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

		if {1 == [catch {
			if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/If${BhvUnitName}-p.vhd] then {
				puts "Compiling    bhv interface package                          grp$GrpName, unit$BhvUnitName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/If${BhvUnitName}-p.vhd]"
			}
			if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-e.vhd] then {
				puts "Compiling    bhv entity                                     grp$GrpName, unit$BhvUnitName, $BhvUnitName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-e.vhd]"
			}
		} err]} {
			set comperror "$err"
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

		if {1 == [catch {
			if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-ea.vhd] then {
				puts "Compiling    bhv entity-architecture                        grp$GrpName, unit$BhvUnitName, $BhvArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-ea.vhd]"
			} elseif [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-eac.vhd] then {
				puts "Compiling    bhv entity-architecture-coniguration           grp$GrpName, unit$BhvUnitName, $BhvArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-eac.vhd]"
			} elseif [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-a.vhd] then {
				puts "Compiling    bhv architecture                               grp$GrpName, unit$BhvUnitName, $BhvArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/${BhvUnitName}-${BhvArchitectureName}-a.vhd]"
			} else {
				puts stderr "Missing      bhv architecture                               grp$GrpName, unit$BhvUnitName, $BhvArchitectureName"
			}
		} err]} {
			set comperror "$err"
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
    
		if {1 == [catch {
			if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/If${BhvUnitName}-c.vhd] then {
				puts "Compiling    configuration                                  grp$GrpName, unit$BhvUnitName, $BhvArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${BhvUnitName}/src/If${BhvUnitName}-${BhvArchitectureName}-c.vhd]"
			}
		} err]} {
			set comperror "$err"
		}
    }
}

set tbSuccess 0

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
        
        # because we need to know which one is the desired testbench! (i.e. the last testbench in the list)
        set tbName $ForeignUnitName   
		
		if {1 == [catch {
			if [string equal ${FileType} "VHDL"] {
				puts "Compiling    foreign VHDL testbench                         grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]"
				set tbSuccess 1
			} elseif [string equal ${FileType} "VERILOG"] {
				puts "Compiling    foreign Verilog testbench                      grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
				eval "vlog -quiet ${VcomOptions} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]"
				set tbSuccess 1
			} elseif [string equal ${FileType} "SYSTEMVERILOG"] {
				puts "Compiling    foreign SystemVerilog testbench                grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
				eval "vlog -quiet ${VcomOptions} -sv -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${ForeignUnitName}/${ForeignUnitPath}]"
				set tbSuccess 1
			} else {
				puts "Skipping     foreign testbench (${FileType} unsupported in simulation)    grp$GrpName, unit$ForeignUnitName, $ForeignUnitPath"
			}
		} err]} {
			set comperror "$err"
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
        
		if {1 == [catch {
			if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-e.vhd] then {
				puts "Compiling    testbench entity                               grp$GrpName, unit$tbUnitName, $tbUnitName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-e.vhd]"
			}
		} err]} {
			set comperror "$err"
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
        
		if {1 == [catch {
			if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-ea.vhd] then {
				puts "Compiling    testbench entity-architecture                  grp$GrpName, unit$UnitName, $tbArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-ea.vhd]"
				set tbSuccess 1
			} elseif [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-eac.vhd] then {
				puts "Compiling    testbench entity-architecture-configuration    grp$GrpName, unit$UnitName, $tbArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-eac.vhd]"
				set tbSuccess 1
			} elseif [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-a.vhd] then {
				puts "Compiling    testbench architecture                         grp$GrpName, unit$tbUnitName, $tbArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/tb${tbUnitName}-${tbArchitectureName}-a.vhd]"
				set tbSuccess 1
			} else {
				puts stderr "Missing      testbench architecture                         grp$GrpName, unit$tbUnitName, $tbArchitectureName"
			}
		} err]} {
			set comperror "$err"
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
        
		if {1 == [catch {
			if [file exists ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/Iftb${tbUnitName}-c.vhd] then {
				puts "Compiling    testbench configuration                        grp$GrpName, unit$tbUnitName, $tbArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/unit${tbUnitName}/src/Iftb${tbUnitName}-${tbArchitectureName}-c.vhd]"
			}
		} err]} {
			set comperror "$err"
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

		if {1 == [catch {
			if [file exists ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbPkgName}-e.vhd] then {
				puts "Compiling    pkg testbench entity                             grp$GrpName, pkg$tbPkgName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbPkgName}-e.vhd]"
			}
		} err]} {
			set comperror "$err"
		}
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
        
    	set tbSuccess 0
		
		if {1 == [catch {
			if [file exists ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbPkgName}-${tbArchitectureName}-ea.vhd] then {
				puts "Compiling    pkg testbench entity-architecture                grp$GrpName, pkg$UnitName, $tbArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbPkgName}-${tbArchitectureName}-ea.vhd]"
				set tbSuccess 1
			} elseif [file exists ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbPkgName}-${tbArchitectureName}-eac.vhd] then {
				puts "Compiling    pkg testbench entity-architecture-configuration  grp$GrpName, pkg$UnitName, $tbArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbPkgName}-${tbArchitectureName}-eac.vhd]"
				set tbSuccess 1
			} elseif [file exists ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbPkgName}-${tbArchitectureName}-a.vhd] then {
				puts "Compiling    pkg testbench architecture                       grp$GrpName, pkg$tbPkgName, $tbArchitectureName"
				eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibraryName} [file normalize ${PathUnitToRoot}/grp${GrpName}/pkg${tbPkgName}/src/tb${tbPkgName}-${tbArchitectureName}-a.vhd]"
				set tbSuccess 1
			} else {
				puts stderr "Missing      pkg testbench architecture                       grp$GrpName, pkg$tbPkgName, $tbArchitectureName"
			}
		} err]} {
			set comperror "$err"
		}
    }
}

if [expr  {${comperror}!=""}] then {
    error "Compilation failed due to errors!\n$comperror"
}
