--------------------------------------------------------------------------------
-- This file is part of fhlow (fast handling of a lot of work), a working
-- environment that speeds up the development of and structures FPGA design
-- projects.
-- 
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

library example_library;
use example_library.ExamplePackage.all;

--------------------------------------------------------------------------------

entity tbExample1 is
end entity tbExample1;

--------------------------------------------------------------------------------

architecture Bhv of tbExample1 is

  constant cClkFrequency               : natural := 50E6;
  constant cIsLowPercentageOfDutyCycle : natural := 65;
  constant cInResetDuration            : time    := 200 ns;

  -- component ports
  signal Clk         : std_ulogic;
  signal nResetAsync : std_ulogic;
  
  signal SEG0, SEG1, SEG2, SEG3, SEG4, SEG5 : std_ulogic_vector(6 downto 0);

begin  -- architecture Bhv

  DUT : entity work.Example1
    port map (
      iClk          => Clk,
      inResetAsync  => nResetAsync,
      oSEG0         => SEG0,
      oSEG1         => SEG1,
      oSEG2         => SEG2,
      oSEG3         => SEG3,
      oSEG4         => SEG4,
      oSEG5         => SEG5);


  -- clock generation
  ClkGenerator : entity work.Oscillator
    generic map (
      gFrequency                  => cClkFrequency,
      gIsLowPercentageOfDutyCycle => cIsLowPercentageOfDutyCycle)
    port map (
      oRectangleWave => Clk);

  -- reset generation
  PwrOnResetSource : entity work.PwrOnReset
    generic map (
      gInResetDuration => cInResetDuration,
      gResetLevel      => '0')
    port map (
      onResetAsync => nResetAsync);

end architecture Bhv;
