-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- mux4t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N-bit input, 4-1 multiplexer.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1_N is
  generic(N : Integer := 32);
  port (
    i_S0 : in std_logic;
    i_S1 : in std_logic;
    i_D0 : in std_logic_vector(N-1 downto 0);
    i_D1 : in std_logic_vector(N-1 downto 0);
    i_D2 : in std_logic_vector(N-1 downto 0);
    i_D3 : in std_logic_vector(N-1 downto 0); 
    o_O : out std_logic_vector(N-1 downto 0)
  );
end mux4t1_N;

architecture dataflow of mux4t1_N is
  
  signal s_select : std_logic_vector(1 downto 0);

  
  begin
    s_select <= i_S1 & i_S0;
    with s_select select
        o_O <= i_D0 when "00",
               i_D1 when "01",
               i_D2 when "10",
               i_D3 when "11",
               (others => '0') when others;

end dataflow;  
