--------------------------------------------------------------------------------
-- This file is part of fhlow (fast handling of a lot of work), a working
-- environment that speeds up the development of and structures FPGA design
-- projects.
-- 
-- Copyright (c) 2011-2017 Michael Roland <michael.roland@fh-hagenberg.at>
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
-- Title       : <Short title for this unit>
-- Project     : <Name of the design project>
--------------------------------------------------------------------------------
-- RevCtrl     : $Id$
-- Authors     : <Names of authors of this file>
--------------------------------------------------------------------------------
-- Description : <Detailed description of this unit's purpose>
--------------------------------------------------------------------------------

architecture Rtl of Template is

  type aRegSet is record
  
    -- TODO

  end record aRegSet;

  constant cRinitVal: aRegSet := (
  
    -- TODO
    
  );

  signal R, NextR : aRegSet;
  
begin
 
  ------------------------------------------------------------------------------
  -- Registers
  ------------------------------------------------------------------------------
  Registers : process(iClk, inResetAsync)
  begin
    if (inResetAsync = '0') then
      R <= cRinitVal;
    elsif rising_edge(iClk) then  -- rising clock edge
      R <= NextR;  
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- Next State and Output Logic: Combinatorial
  ------------------------------------------------------------------------------
  NextStateAndOutput : process (
    
    -- TODO
    
  )

  begin

    ----------------------------------------------------------------------------
    -- Set Next State Defaults
    ----------------------------------------------------------------------------
    NextR <= R;

    -- TODO

    ----------------------------------------------------------------------------
    -- Set Output Defaults
    ----------------------------------------------------------------------------
    
    -- TODO

    ----------------------------------------------------------------------------
    -- Consider Actual States and Inputs
    ----------------------------------------------------------------------------

    -- TODO
    

  end process NextStateAndOutput;

  ------------------------------------------------------------------------------
  -- Write to Outputs
  ------------------------------------------------------------------------------

  -- TODO
  
end Rtl;
