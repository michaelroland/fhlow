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


# we want to compile in gui, so we have to tell other tcl-files
set PostLayoutSim 1
set PostSynNetSim 1
set PostSynSDFSim 0

set PathLocalSimDir .
set PathUnitToRoot ../../../..
set PathGlobalSimDir ${PathUnitToRoot}/fhlow/[file tail [pwd]]

if {1 == [catch {
	source ${PathGlobalSimDir}/SecureIncludeConfig.tcl
		
	#Compile necessary Libraries if not yet compiled!
	source ${PathGlobalSimDir}/CompileManufacturerLibraries.tcl	

	# compile
	source ${PathGlobalSimDir}/CompSim.do
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
