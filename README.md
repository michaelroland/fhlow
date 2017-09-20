# fhlow: fast handling of a lot of work

This is fhlow (**f**ast **h**andling of a **l**ot **o**f **w**ork), a build and working
environment that speeds up the development of and structures FPGA design projects.


## GETTING STARTED
The directory [`grpTemplate/unitTemplate/`](grpTemplate/unitTemplate/) contains an
empty structure for a design unit.
See [`grpExamples/unitExample1/`](grpExamples/unitExample1/) for a working example.


## STRUCTURE

A fhlow project is structured into groups, units, and packages. A group is a
collection of design units (unit, package) that serve one common purpose. A
package is a single VHDL package. A unit is a single VHDL module (a single
entity with one or more architectures).

### Core Build Scripts

The heart of fhlow, a collection of common build scripts that automate the simulation
and synthesis flow, is located at [`fhlow/`](fhlow/). There is no need to ever touch
this folder or any of its sub-folders unless you want to enhance and develop the core
code of fhlow itself.

### Global Configuration

The global configuration consists of four files:

1. [`Config.tcl`](Config.tcl): This is the main configuration file where you set up
   your overall project configuration.
2. [`TimingConstraints.sdc`](TimingConstraints.sdc): This file configures the overall
   timing constraints for your project.
3. [`Paths.bat`](Paths.bat): On Windows, this file configures the paths to your
   simulation and synthesis toolchains. Note that you can override these paths on a
   per-user basis using a file `%USERPROFILE%\.fhlow\Paths.bat`. This per-user
   configuration file is automatically created upon running fhlow for the first time.
4. [`Paths.config`](Paths.config): On Linux (or when using the `make` based version
   of fhlow), this file configures the paths to your simulation and synthesis
   toolchains. It follows GNU make syntax. Note that you can override these paths on
   a per-user basis using a file `~/.fhlow/Paths.config`. You can simply use a copy
   of the main `Paths.config` file.

### Groups

Groups are collections of one or more design units. Each group consists of a
directory starting with the prefix `grp`, e.g. [`grpExamples/`](grpExamples/).

Each group may have two optional configuration files that are used for all
design-entry units within this group (i.e. these configuration files are only used
whenever you *start* fhlow for a unit within this group):

1. `Config.tcl`: Optional fhlow configuration for this group.
2. `TimingConstraints.sdc`: Optional timing constraints that are specific to this group.

### Packages

Packages encapsulate a single VHDL package. Each package consists of a directory
starting with the prefix `pkg` located within a group directory, e.g.
[`grpExamples/pkgExample1/`](grpExamples/pkgExample1/). A package has its source
files located in a directory named [`src/`](grpExamples/pkgExample1/src/). The name
of the source file of a package has the form `PackageName-p.vhd`.

### Units

Units encapsulate a single VHDL entity and its architectures. Each unit consists
of a directory starting with the prefix `unit` located within a group directory,
e.g. [`grpExamples/unitExample1/`](grpExamples/unitExample1/). A unit has its source
files located in a directory named [`src/`](grpExamples/unitExample1/src/). The
names of the source files of a unit are as follows:

- Entity: `UnitName-e.vhd`
- Architecture: `UnitName-ArchitectureName-a.vhd`
- Combined entity and architecture: `UnitName-ArchitectureName-ea.vhd`
- Testbench entity: `tbUnitName-e.vhd`
- Testbench architecture: `tbUnitName-ArchitectureName-a.vhd`
- Testbench with combined entity and architecture: `tbUnitName-ArchitectureName-ea.vhd`

When a unit is a design-entry (i.e. when fhlow is to be *started* for this unit),
the unit may have two configuration files that are used only when this unit is the
design-entry:

1. [`Config.tcl`](grpExamples/unitExample1/Config.tcl): Mandatory fhlow configuration
   for this unit.
2. [`TimingConstraints.sdc`](grpExamples/unitExample1/TimingConstraints.sdc): Optional
   timing constraints that are specific to this unit.

Moreover, when a unit is the design-entry, it must have the fhlow control directory
([`flw/`](grpExamples/unitExample1/flw/)). This directory, in turn, must contain the
control directories for starting the simulation and/or synthesis flow. These
directories are

- [`simQuestasim/`](grpExamples/unitExample1/flw/simQuestasim/) for simulation using
  Questasim or Modelsim. This directory further contains
  - Several Windows batch files (`.bat`) for starting the simulation flow on Windows.
  - A [`Makefile`](grpExamples/unitExample1/flw/simQuestasim/Makefile) for starting
    the simulation flow on Linux (or on any platform using `make`).
  - A file [`Wave.do`](grpExamples/unitExample1/flw/simQuestasim/Wave.do) for
    configuraing the waveform recording of the simulator.


- [`synlayQuartus/`](grpExamples/unitExample1/flw/synlayQuartus/) for synthesis using
  Altera Quartus/Intel Quartus Prime. This directory further contains
  - Several Windows batch files (`.bat`) for starting the synthesis flow on Windows.
  - A [`Makefile`](grpExamples/unitExample1/flw/synlayQuartus/Makefile) for starting
    the synthesis flow on Linux (or on any platform using `make`).
  - A file [`MyAddons.tcl`](grpExamples/unitExample1/flw/synlayQuartus/MyAddons.tcl)
    for defining additional QSF directives that should be used for this unit.
  - A file [`MyPostprocessing.tcl`](grpExamples/unitExample1/flw/synlayQuartus/MyPostprocessing.tcl)
    for defining additional commands that should be executed after synthesis.
  - An automatically (re-)generated directory `synlayResults/` containing the
    generated Quartus project files and synthesis results.


## GET LATEST VERSION

Find documentation and grab the latest version on GitHub
<https://github.com/michaelroland/fhlow>


## COPYRIGHT

- Copyright (c) 2003-2005 Markus Pfaff <<markus.pfaff@fh-hagenberg.at>>
- Copyright (c) 2005 Christian Kitzler <<christian.kitzler@fh-hagenberg.at>>
- Copyright (c) 2005 Simon Lasselsberger <<simon.lasselsberger@fh-hagenberg.at>>
- Copyright (c) 2011-2017 Michael Roland <<michael.roland@fh-hagenberg.at>>


## DISCLAIMER

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.


## LICENSE

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

**License**: [GNU General Public License v3.0](http://www.gnu.org/licenses/gpl-3.0.txt)
