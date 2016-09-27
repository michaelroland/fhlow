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

package ExamplePackage is

  constant cActivated   : std_ulogic := '1';
  constant cInactivated : std_ulogic := '0';

  constant cnActivated   : std_ulogic := '0';
  constant cnInactivated : std_ulogic := '1';
  
  type aSegDigits is array (natural range <>) of std_ulogic_vector(6 downto 0);
  constant cSEGOff : std_ulogic_vector(6 downto 0) := "1111111";
  constant cSEG : aSegDigits := (
          --   +--0--+
          --   |     |
          --   5     1
          --   |     |
          --   +--6--+
          --   |     |
          --   4     2
          --   |     |
          --   +--3--+
          0 => "1000000",  -- 0
          1 => "1111001",  -- 1
          2 => "0100100",  -- 2
          3 => "0110000",  -- 3
          4 => "0011001",  -- 4
          5 => "0010010",  -- 5
          6 => "0000010",  -- 6
          7 => "1111000",  -- 7
          8 => "0000000",  -- 8
          9 => "0011000",  -- 9
         10 => "0001000",  -- A
         11 => "0000011",  -- b
         12 => "1000110",  -- C
         13 => "0100001",  -- d
         14 => "0000110",  -- E
         15 => "0001110",  -- F
         16 => "0111111",  -- -
         17 => "0001001",  -- H
         18 => "0001011",  -- h
         19 => "1001111",  -- I
         20 => "1101111",  -- i
         21 => "1110001",  -- J
         22 => "1000111",  -- L
         23 => "0101011",  -- n
         24 => "0100011",  -- o
         25 => "0001100",  -- P
         26 => "0101111",  -- r
         27 => "0010010",  -- S
         28 => "1001110",  -- T
         29 => "1000001",  -- U
         30 => "1100011",  -- u
         31 => "0001101"); -- Y
  
  -- function log2 returns the logarithm of base 2 as an integer
  function LogDualis(cNumber : natural) return natural;

end ExamplePackage;

package body ExamplePackage is

  function LogDualis(cNumber : natural) return natural is
    variable vClimbUp : natural := 1;
    variable vResult  : natural := 0;
  begin
    while vClimbUp < cNumber loop
      vClimbUp := vClimbUp * 2;
      vResult  := vResult + 1;
    end loop;
    return vResult;
  end LogDualis;

end ExamplePackage;
