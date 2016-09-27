--------------------------------------------------------------------------------
-- This file is part of fhlow (fast handling of a lot of work), a working
-- environment that speeds up the development of and structures FPGA design
-- projects.
-- 
-- Copyright (c) 2003-2009 Markus Pfaff <markus.pfaff@fh-hagenberg.at>
-- Copyright (c) 2011-2016 Michael Roland <michael.roland@fh-hagenberg.at>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Oscillator is
  
  generic (
    -- Frequency of the oscillator output in Hz
    gFrequency                  : natural := 48E6;
    -- Low period of the duty cycle in percent
    gIsLowPercentageOfDutyCycle : natural := 50);

  port (
    oRectangleWave : out std_ulogic);

end Oscillator;
