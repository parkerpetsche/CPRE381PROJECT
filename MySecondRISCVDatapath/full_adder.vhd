-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- full_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a full adder unit.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity full_adder is
  port(
    i_D0 : in std_logic;
    i_D1 : in std_logic;
    i_D2 : in std_logic;
    o_C : out std_logic;
    o_S : out std_logic
  );
end full_adder;

architecture structural of full_adder is
  
  component andg2 is
    port(
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic
    );
  end component;
  
  component org2 is
    port(
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic
    );
  end component;
  
  component xorg2 is
    port(
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic
    );
  end component;    
    
  signal and_1 : std_logic;
  signal and_2 : std_logic;
  signal and_3 : std_logic;
--  signal and_4 : std_logic;
  signal xor_1 : std_logic;
  signal xor_2 : std_logic;
  signal or_1 : std_logic;
  
  begin 
  
  and_D0_D1 : andg2
    port map(
      i_A => i_D0,
      i_B => i_D1,
      o_F => and_1
    );
  
  and_D2_D1 : andg2
    port map(
      i_A => i_D1,
      i_B => i_D2,
      o_F => and_2
    );
  
  and_D0_D2 : andg2
    port map(
      i_A => i_D0,
      i_B => i_D2,
      o_F => and_3
    );
  
--  and_all : andg2
--    port map(
--      i_A => and_1,
--      i_B => i_D2,
--      o_F => and_4
--    );
    
  xor_D0_D1 : xorg2
    port map(
      i_A => i_D0,
      i_B => i_D1,
      o_F => xor_1
    );
  
  xor_all : xorg2
    port map(
      i_A => i_D2,
      i_B => xor_1,
      o_F => xor_2
    );
  
  or_a1_a2 : org2
    port map(
      i_A => and_1,
      i_B => and_2,
      o_F => or_1
    );
  
--  sum : org2
--    port map(
--      i_A => and_4,
--      i_B => xor_2,
--      o_F => o_S
--    );
  o_S <= xor_2;
  
  carry : org2
    port map(
      i_A => or_1,
      i_B => and_3,
      o_F => o_C
    );

end structural;
  
