-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- helpful_stuff.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N-bit input, 32-1 multiplexer 
-- using the 8-1 and 4-1 mutliplexers.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package helpful_stuff is
  constant thirtytwo_bit_zero : std_logic_vector := x"00000000";
  type bus_32x32 is array (0 to 31) of std_logic_vector(31 downto 0);
end package helpful_stuff;
