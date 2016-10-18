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

#Paths
include ../../../../Paths.config
-include ~/.fhlow/Paths.config

PATHGLOBALSIMDIR = ../../../../fhlow/simQuestasim/

#targets
main:
	@echo ""
	@echo "Usage:"
	@echo "------"
	@echo "make <target>"
	@echo ""
	@echo "Make Targets for Modelsim:"
	@echo "--------------------------"
	@echo "CompQuestasimSh      -> compiles VHDL sources with Questasim using your shell; hit 'q' to quit!"
	@echo "CompSimQuestasimSh   -> compiles and simulates VHDL sources with Questasim using your shell; hit 'q' to quit!"
	@echo "CompQuestasimGui     -> compiles VHDL sources with Questasim using Questasim GUI"
	@echo "CompSimQuestasimGui  -> compiles and simulates VHDL sources with Questasim using Questasim GUI"
	@echo "clean                 -> cleanup synthesis results"
	@echo ""
	@echo ""

CompQuestasimSh:
	$(LICENSE) $(MODELSIM) -do $(PATHGLOBALSIMDIR)CompShell.do -c

CompSimQuestasimSh:
	$(LICENSE) $(MODELSIM) -do $(PATHGLOBALSIMDIR)CompSimShell.do -c

CompQuestasimGui:
	$(LICENSE) $(MODELSIM) -do $(PATHGLOBALSIMDIR)Comp.do

CompSimQuestasimGui:
	$(LICENSE) $(MODELSIM) -do $(PATHGLOBALSIMDIR)CompSim.do

clean:
	rm -f transcript
	rm -f *.wlf
	rm -f *.raw
	rm -f *.sfk
	rm -f *.ini
	rm -rf simComp
