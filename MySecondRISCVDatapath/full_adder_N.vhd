-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- full_adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide ripple
-- carry adder unit.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_C          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_C	    : out std_logic;
       o_S          : out std_logic_vector(N-1 downto 0)
  );

end full_adder_N;

architecture structural of full_adder_N is

  component full_adder is
  port(
    i_D0 : in std_logic;
    i_D1 : in std_logic;
    i_D2 : in std_logic;
    o_C : out std_logic;
    o_S : out std_logic
  );
  end component;

  signal s_carry : std_logic_vector(N downto 0);
  
begin

  s_carry(0) <= i_C;
   
  -- Instantiate N-1 adder instances.
  G_NBit_ADDER: for i in 0 to N-1 generate
    ADDERI: full_adder 
      port map(
              i_D0     => i_D0(i),  
              i_D1     => i_D1(i),
              i_D2     => s_carry(i),
              o_C      => s_carry(i+1),
              o_S      => o_S(i)
      );
  end generate G_NBit_ADDER;
  
  o_C <= s_Carry(N);
  
end structural;
