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

catch {

    #Setting Pathes for tools and files
    set PathLocalSimDir .
    set PathUnitToRoot ../../../..
    set PathGlobalSimDir ${PathUnitToRoot}/fhlow/[file tail [pwd]]

    source ${PathGlobalSimDir}/../Banner.tcl
    puts ""
    puts ""

    source ${PathGlobalSimDir}/SecureIncludeConfig.tcl

    #look for testbench
    if [info exists tbUnits] then {                                                           
        puts "---------------------------- start of compilation ------------------------------"
        
        source ${PathGlobalSimDir}/CompileVhdlSource.do
        source ${PathGlobalSimDir}/UnsetVariables.tcl
        
        puts "----------------------------- end of compilation -------------------------------"
        puts ""
        puts ""

        # signalize configuration is ok
        set ConfigError 0

    } else {
        # look if shell or gui is used
        if [info exists Shell] then {
            puts "Set tbUnits in Config.tcl at least to {}! Configuration Error!"
        } else {
            tk_messageBox -message "Set tbUnits in Config.tcl at least to {}!" -title "Configuration Error" -icon error
        }

        # signalize configuration error
        set ConfigError 1
    }
} test
