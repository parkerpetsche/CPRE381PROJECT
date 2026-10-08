-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- ones_comp_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an N-bit ones complement unit.
--            

library IEEE;
use IEEE.std_logic_1164.all;

entity ones_comp_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(
       I         : in std_logic_vector(N-1 downto 0);
       O          : out std_logic_vector(N-1 downto 0)
  );

end ones_comp_N;

architecture structural of ones_comp_N is

  component invg is
    port(i_A      : in std_logic;
         o_F      : out std_logic);
  end component;   

begin

  -- Instantiate N inverter instances.
  G_NBit_ONES: for idx in 0 to N-1 generate
    INVI: invg port map(
              i_A => I(idx),
              o_F => O(idx)
              );  
  end generate G_NBit_ONES;
  
end structural;
