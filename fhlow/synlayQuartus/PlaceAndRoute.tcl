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
puts "Beginning placement and routing."
puts "--------------------------------------------------------------------------------"
# do design flow
execute_flow -compile 
#execute_module -tool map
#execute_module -tool fit
#execute_module -tool sta
#execute_module -tool asm
#execute_module -tool eda

# It's not possible to determine a specific file name for the files
# generated via quartus. We have to rename that
# file now in accordance with our file naming style.
file rename -force ./simulation/modelsim/${UnitName}.vho ../../../src/${UnitName}-structure-ea.vhd 
if [file exists ./simulation/modelsim/${UnitName}_vhd.sdo] then {
    file rename -force ./simulation/modelsim/${UnitName}_vhd.sdo ../../../src/${UnitName}.sdf 
} else {
    set fileSdf [open "../../../src/${UnitName}.sdf" "w"] 
    puts $fileSdf ""
    close $fileSdf
}
