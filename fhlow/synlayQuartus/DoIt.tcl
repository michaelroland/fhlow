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


# Load Quartus II Tcl Project package
package require ::quartus::project
# Load Quartus II Tcl Flow package
package require ::quartus::flow

# set Pathes
set PathLocalSynLayDir [pwd]
set PathLocalSynDir ${PathLocalSynLayDir}/synlayResults
set PathUnitToRoot ../../../..
set PathGlobalSynLayDir ${PathLocalSynLayDir}/${PathUnitToRoot}/fhlow/synlayQuartus/

puts ""
puts ""
source ${PathGlobalSynLayDir}/../Banner.tcl
puts ""
puts ""

set DoingSynthesis 0

# Packages, Units, Definitions for your Design will be read!
source ${PathGlobalSynLayDir}/SecureIncludeConfig.tcl

#delete Synthesis Directory
while {[file exists ${PathLocalSynDir}]} {
    set err ""
    if {[catch "file delete -force ${PathLocalSynDir}" err]} {
        puts ""
        puts "Failed to delete synthesis results folder at \"${PathLocalSynDir}\""
        puts "${err}"
    }
    after 1000
}
#Make Synthesis Directory
file mkdir ${PathLocalSynDir}
cd ${PathLocalSynDir}

#Search for TopLevelEntity-Name
source ${PathGlobalSynLayDir}/SearchUnitName.tcl

#create new project
source ${PathGlobalSynLayDir}/SetupProject.tcl
# add vhdl files to project
source ${PathGlobalSynLayDir}/AnalyzeVhdlSources.tcl
# handling Technology
source ${PathGlobalSynLayDir}/ReadTechnology.tcl
# setting synthesis constraints
source ${PathGlobalSynLayDir}/SynConstraints.tcl
# do whatever user wants to do before compilation
if [file exists ${PathLocalSynLayDir}/MyAddons.tcl] then {
    source ${PathLocalSynLayDir}/MyAddons.tcl
}

export_assignments
if [expr ${DoLay}] {
    # Analyze, Synthesis, Place and Route
    source ${PathGlobalSynLayDir}/PlaceAndRoute.tcl
} else {
    # Analyze and Synthesis
    source ${PathGlobalSynLayDir}/TranslateRtl.tcl
}

# do whatever user wants to do after compilation
if [file exists ${PathLocalSynLayDir}/MyPostprocessing.tcl] then {
    source ${PathLocalSynLayDir}/MyPostprocessing.tcl
}

# Close project
#project_close

