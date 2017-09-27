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


puts ""
puts ""
puts "--------------------------------------------------------------------------------"
puts "    Begin script for Questasim."
puts "--------------------------------------------------------------------------------"
puts ""

#setting the paths for files and tools

set PathLocalSimDir .
set PathUnitToRoot ../../../..
set PathGlobalSimDir ${PathUnitToRoot}/fhlow/[file tail [pwd]]

if {1 == [catch {
	source ${PathGlobalSimDir}/../Banner.tcl
	puts ""
	puts ""

	source ${PathGlobalSimDir}/SecureIncludeConfig.tcl

	puts "---------------------------- start of compilation ------------------------------"

	source ${PathGlobalSimDir}/CompileVhdlSource.do

	puts "----------------------------- end of compilation -------------------------------"
	puts ""
	puts ""
	# compilation worked fine
	
	if [expr $tbSuccess] then {
		if [expr ! [info exists UnitName]] then {
			set UnitName IdoNotExist
		}
		
		puts ""
		puts "---------------------------- start of simulation -------------------------------"
		puts ""
		if [info exists PostLayoutSim] {
			if [file exists ${PathLocalSimDir}/../../src/${UnitName}.sdf] then {
				puts "Using delay information from SDF file [file normalize ${PathLocalSimDir}/../../src/${UnitName}.sdf] ..."
				puts ""
				vsim -quiet ${VsimOptions} -sdfmax /DUT=[file normalize ${PathLocalSimDir}/../../src/${UnitName}.sdf] -noglitch -t ps work.tb${tbName}
			} else {
				error "SDF file [file normalize ${PathLocalSimDir}/../../src/${UnitName}.sdf] not found!"
			}
		} else {
			vsim -quiet ${VsimOptions} work.tb${tbName}
		}
			
		# simulate either with custom Wave.do
		# or with default Wave.do
		if [file exists ${PathLocalSimDir}/Wave.do] then {
			if {1 == [catch {
				source ${PathLocalSimDir}/Wave.do
			} err]} {
				error "Failed to include waveform configuration file [file normalize ${PathLocalSimDir}/Wave.do]!\n$err"
			}
		} else {
			puts stderr "Warning: [file normalize ${PathLocalSimDir}/Wave.do] not found. Using default Wave.do ..."
			if {1 == [catch {
				source ${PathGlobalSimDir}/Wave.do
			} err]} {
				error "Failed to include waveform configuration file [file normalize ${PathGlobalSimDir}/Wave.do]!\n$err"
			}
		}
		
		set DurationBegin [clock seconds]
		source ${PathGlobalSimDir}/RunSim.do
		
		puts ""
		puts "----------------------------- end of simulation --------------------------------"
		puts ""
		puts ""
		
		set DurationEnd [clock seconds]
		set Duration [expr ${DurationEnd} - ${DurationBegin}]
		
		puts "Duration of Simulation: ${Duration} sec"
	} else {
		# tell user that something went wrong with their testbench
		error "Failed to start simulation!\nSpecified Testbench was not found!\nCheck your configuration!"
	}
	
	puts ""
	puts ""
	puts "--------------------------------------------------------------------------------"
	puts "    End of script for Questasim."
	puts "--------------------------------------------------------------------------------"
	puts ""
	puts ""
} err]} {
	puts ""
	puts ""
	puts stderr "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	puts stderr ""
	puts stderr "$err"
	puts stderr ""
	puts stderr "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}

if [info exists Shell] then {
	exit
}
