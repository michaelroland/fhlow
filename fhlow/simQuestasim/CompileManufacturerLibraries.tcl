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
puts "--------------------------------------------------------------------------------"
puts "   Begin post-synthesis manufacturer libraries handling."
puts "--------------------------------------------------------------------------------"
puts ""

set CurrentConfigIncludeFile ${PathUnitToRoot}/lib/lib${ChipManufacturer}/ConfigLib.tcl
if {1 == [catch {
    if [expr [file exists $CurrentConfigIncludeFile]] {
        source $CurrentConfigIncludeFile
    } else {
        error "Post-synthesis library configuration file [file normalize $CurrentConfigIncludeFile] not found!"
    }
} err]} {
    error "Failed to include post-synthesis library configuration file [file normalize $CurrentConfigIncludeFile]!\n$err"
}

set comperror ""
foreach {Lib} $LibFiles {
    set LibName [lindex $Lib 0]
    set Files [lindex $Lib 1]

    if [expr ![file exists ${PathGlobalSimDir}/simComp/${LibName}]] then {
        vlib ${PathGlobalSimDir}/simComp/${LibName}
        vmap ${LibName} ${PathGlobalSimDir}/simComp/${LibName}
        
        puts "---------------------------- start of compilation ------------------------------"
        foreach {File} $Files {
            if {1 == [catch {
                puts "Compiling    library file                                   $LibName, $File"
                eval "vcom -quiet ${VcomOptions} ${VcomVhdlInputVersion} -work ${LibName} [file normalize ${PathUnitToRoot}/lib/lib${ChipManufacturer}/src/$File]"
            } err]} {
                set comperror "$err"
            }
        }
        puts "----------------------------- end of compilation -------------------------------"
    } else {
        puts "--------------------------------------------------------------------------------"
        puts "-- There is no need to compile ${LibName}, <fhlowroot>/fhlow/simQuestasim/simComp/${LibName} exists!"
        puts "-- If you want to renew this library, you have to delete the directory containing the library."
        puts "--------------------------------------------------------------------------------"
    }
    puts ""
    puts ""
}

if [expr  {${comperror}!=""}] then {
    error "Post-synthesis library compilation failed due to errors!\n$comperror"
}

puts ""
puts "--------------------------------------------------------------------------------"
puts "   End post-synthesis manufacturer libraries handling."
puts "--------------------------------------------------------------------------------"
puts ""
