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

--------------------------------------------------------------------------------
-- Title      : <Short title for this testbench>
-- Project    : <Name of the design project>
--------------------------------------------------------------------------------
-- RevCtrl    : $Id$
--------------------------------------------------------------------------------
-- Description: <Detailed description of this testbench's purpose>
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------------

entity tbTemplate is
end entity tbTemplate;

---------------------------------------------------------------------------------

architecture Bhv of tbTemplate is

  constant cClkFrequency               : natural := 50E6;
  constant cIsLowPercentageOfDutyCycle : natural := 65;
  constant cInResetDuration            : time    := 200 ns;
  
  -- component ports
  signal Clk         : std_ulogic;
  signal nResetAsync : std_ulogic;

begin  -- architecture Bhv

  DUT : entity work.Template
    port map (
      iClk                    => Clk,
      inResetAsync            => nResetAsync,
      
      -- TODO: Add your port mapping
      
      );


  -- TODO: Add your testbench code

  
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
      gResetLevel      => cnActivated)
    port map (
      onResetAsync => nResetAsync);

end architecture Bhv;

