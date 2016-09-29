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

PATHGLOBALSYNDIR = ../../../../flw/synlayQuartus/

#targets
main:
	@echo ""
	@echo "usage:"
	@echo "------"
	@echo "make <target>"
	@echo ""
	@echo "Make Targets for Quartus:"
	@echo "-------------------------"
	@echo "SynQuartusSh      -> does synthesis with Quartus on you shell"
	@echo "SynLayQuartusSh   -> does synthesis and place-and-route with Quartus on your shell"
	@echo "SynQuartusGui     -> does synthesis with Quratus using Quratus' GUI"
	@echo "SynLayQuartusGui  -> does synthesis and place-and-route with Quartus using Quartus' GUI"
	@echo "clean             -> cleanup synthesis results"
	@echo ""
	@echo ""

SynQuartusSh:
	$(LICENSE) $(QUARTUS_SH) -t $(PATHGLOBALSYNDIR)SynShell.tcl;

SynQuartusGui:
	$(LICENSE) $(QUARTUS_SH) -t $(PATHGLOBALSYNDIR)SynGui.tcl

SynLayQuartusSh:
	$(LICENSE) $(QUARTUS_SH) -t $(PATHGLOBALSYNDIR)SynLayShell.tcl

SynLayQuartusGui:
	$(LICENSE) QUARTUS_ROOTDIR=$(QUARTUSDIR) $(QUARTUS_SH) -t $(PATHGLOBALSYNDIR)SynLayGui.tcl

clean:
	rm -rf synlayResults
