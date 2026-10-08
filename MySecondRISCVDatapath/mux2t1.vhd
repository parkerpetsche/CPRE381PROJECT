-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 2 to 1 mux structural unit.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

--creating the mux entity
entity mux2t1 is
	
  port(
    i_S		: in std_logic;
    i_D0	: in std_logic;
    i_D1	: in std_logic;
    o_O		: out std_logic
  );
  	
end mux2t1;

architecture structural of mux2t1 is

  --needed components
  component andg2 is
    port(
       i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic
    );
  end component;
  
  component org2 is
    port(
       i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic
    );
  end component;
  
  component invg is
    port(
      i_A          : in std_logic;
      o_F          : out std_logic
    );
  end component;
  
  --internal signals
  signal i_S_not	: std_logic;
  signal and_1		: std_logic;
  signal and_2		: std_logic;
  
begin

  --invert select bit for one and gate
  inv_sel : invg
    port map(
      i_A => i_S,
      o_F => i_S_not
    );  
  
  --first and gate
  gate_and1 : andg2
    port map(
      i_A => i_D0,
      i_B => i_S_not,
      o_F => and_1
    );
  
  --second and gate 
  gate_and2 : andg2
    port map(
      i_A => i_D1,
      i_B => i_S,
      o_F => and_2
    );  

  --final or gate
  gate_final : org2
    port map(
      i_A => and_1,
      i_B => and_2,
      o_F => o_O
    );

end structural;
 
