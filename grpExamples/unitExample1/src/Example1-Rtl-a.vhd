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

architecture Rtl of Example1 is

  constant cClkFrequency   : natural := 50E6;
  constant cClkCycPerCyc   : natural := cClkFrequency / 1;
  constant cClkCounterBits : natural := LogDualis(cClkCycPerCyc);

  subtype aSegCounter is natural range 0 to 9;
  signal ClkCounter         : unsigned(cClkCounterBits-1 downto 0);
  signal Counter0, Counter1 : aSegCounter;
  signal Seg0, Seg1         : std_ulogic_vector(6 downto 0);

begin  -- architecture Rtl

  Count : process (iClk, inResetAsync) is
  begin
    if (inResetAsync = cnActivated) then
      ClkCounter <= (others => '0');
      Counter0 <= 0;
      Counter1 <= 0;
      Seg0 <= cSEGOff;
      Seg1 <= cSEGOff;

    elsif (rising_edge(iClk)) then  -- rising clock edge
      if (ClkCounter = cClkCycPerCyc) then
        ClkCounter <= (others => '0');

        if (Counter0 = 9) then
          Counter0 <= 0;

          if (Counter1 = 9) then
            Counter1 <= 0;

          else
            Counter1 <= Counter1 + 1;
          end if;
        else
          Counter0 <= Counter0 + 1;
        end if;
      else
        ClkCounter <= ClkCounter + 1;
      end if;

      Seg1 <= cSEG(Counter1);
      Seg0 <= cSEG(Counter0);
    end if;
  end process Count;

  oSEG5 <= cSEG(14);  -- E
  oSEG4 <= cSEG(1);   -- 1
  oSEG3 <= cSEG(16);  -- -
  oSEG2 <= cSEG(16);  -- -
  oSEG1 <= Seg1;
  oSEG0 <= Seg0;
end architecture Rtl;
