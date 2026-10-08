-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- mux32t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N-bit input, 32-1 multiplexer 
-- using the 8-1 and 4-1 mutliplexers.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.helpful_stuff.all;


entity mux32t1_N is
    generic(N : Integer := 32);
    port(
        i_D : in bus_32x32;
        i_S : in std_logic_vector(4 downto 0);
        o_O : out std_logic_vector(N-1 downto 0)
    );
end mux32t1_N;


architecture structural of mux32t1_N is

  component mux8t1_N is
  generic(N : Integer := 32);
  port (
    i_S0 : in std_logic;
    i_S1 : in std_logic;
    i_S2 : in std_logic;
    i_D0 : in std_logic_vector(N-1 downto 0);
    i_D1 : in std_logic_vector(N-1 downto 0);
    i_D2 : in std_logic_vector(N-1 downto 0);
    i_D3 : in std_logic_vector(N-1 downto 0);
    i_D4 : in std_logic_vector(N-1 downto 0);
    i_D5 : in std_logic_vector(N-1 downto 0);
    i_D6 : in std_logic_vector(N-1 downto 0);
    i_D7 : in std_logic_vector(N-1 downto 0);  
    o_O : out std_logic_vector(N-1 downto 0)
  );
end component;

  component mux4t1_N is
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
end component;

  signal s_mux0 : std_logic_vector(N-1 downto 0);
  signal s_mux1 : std_logic_vector(N-1 downto 0);
  signal s_mux2 : std_logic_vector(N-1 downto 0);
  signal s_mux3 : std_logic_vector(N-1 downto 0);
  

  begin

  MUX0 : mux8t1_N
    generic map(N => N)
    port map(
      i_S0 => i_S(2),
      i_S1 => i_S(3),
      i_S2 => i_S(4),
      i_D0 => i_D(0),
      i_D1 => i_D(4),
      i_D2 => i_D(8),
      i_D3 => i_D(12),
      i_D4 => i_D(16),
      i_D5 => i_D(20),
      i_D6 => i_D(24),
      i_D7 => i_D(28),
      o_O  => s_mux0
    );

  MUX1 : mux8t1_N
    generic map(N => N)
    port map(
      i_S0 => i_S(2),
      i_S1 => i_S(3),
      i_S2 => i_S(4),
      i_D0 => i_D(1),
      i_D1 => i_D(5),
      i_D2 => i_D(9),
      i_D3 => i_D(13),
      i_D4 => i_D(17),
      i_D5 => i_D(21),
      i_D6 => i_D(25),
      i_D7 => i_D(29),
      o_O  => s_mux1
    );

  MUX2 : mux8t1_N
    generic map(N => N)
    port map(
      i_S0 => i_S(2),
      i_S1 => i_S(3),
      i_S2 => i_S(4),
      i_D0 => i_D(2),
      i_D1 => i_D(6),
      i_D2 => i_D(10),
      i_D3 => i_D(14),
      i_D4 => i_D(18),
      i_D5 => i_D(22),
      i_D6 => i_D(26),
      i_D7 => i_D(30),
      o_O  => s_mux2
    );

  MUX3 : mux8t1_N
    generic map(N => N)
    port map(
      i_S0 => i_S(2),
      i_S1 => i_S(3),
      i_S2 => i_S(4),
      i_D0 => i_D(3),
      i_D1 => i_D(7),
      i_D2 => i_D(11),
      i_D3 => i_D(15),
      i_D4 => i_D(19),
      i_D5 => i_D(23),
      i_D6 => i_D(27),
      i_D7 => i_D(31),
      o_O  => s_mux3
    );

  MUX4 : mux4t1_N
    generic map(N => N)
    port map(
      i_S0 => i_S(0),
      i_S1 => i_S(1),
      i_D0 => s_mux0,
      i_D1 => s_mux1,
      i_D2 => s_mux2,
      i_D3 => s_mux3,
      o_O  => o_O
    );
    

end structural;
