-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- register_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide register.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity register_N is
    generic(N : Integer := 32);
	port (
	  i_D : in std_logic_vector(N-1 downto 0);
	  i_CLK : in std_logic;
	  i_RST : in std_logic;
	  i_WE : in std_logic;
	  o_Q : out std_logic_vector(N-1 downto 0)
	);

end register_N;

architecture structural of register_N is
  
  component dffg is
    port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

  end component;
   
  begin
  
  
  G_Nbit_Register: for i in 0 to N-1 generate
    flip_flop : dffg
      port map(
        i_CLK => i_CLK,
        i_RST => I_RST,
        i_WE => i_WE,
        i_D => i_D(i),
        o_Q => o_Q(i)
      );
  end generate G_Nbit_Register;
  
end structural;
        
  
