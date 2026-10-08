-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- register_file.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a RISC-V register file 
-- with async read, sync write, and built for 32 bit values.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.helpful_stuff.all;

entity register_file is
  generic(N : Integer := 32);
  port (
    i_RS1 : in std_logic_vector(4 downto 0);
    i_RS2 : in std_logic_vector(4 downto 0);
    i_RD  : in std_logic_vector(4 downto 0);
    i_D   : in std_logic_vector(N-1 downto 0);
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_WE  : in std_logic;
    o_RS1 : out std_logic_vector(N-1 downto 0);
    o_RS2 : out std_logic_vector(N-1 downto 0)
  );
end register_file;

architecture structural of register_file is

  component decoder_5t32 is
    port ( 
      i_WE : in std_logic;
      i_S  : in std_logic_vector(4 downto 0);
      o_Q  : out std_logic_vector(31 downto 0)
    );
  end component;    
  
  component register_N is
    generic(N : Integer := 32);
      port (
	  i_D   : in std_logic_vector(N-1 downto 0);
	  i_CLK : in std_logic;
	  i_RST : in std_logic;
	  i_WE  : in std_logic;
	  o_Q   : out std_logic_vector(N-1 downto 0)
      );

  end component;
  
  component mux32t1_N is
    generic(N : Integer := 32);
    port(
        i_D : in bus_32x32;
        i_S : in std_logic_vector(4 downto 0);
        o_O : out std_logic_vector(N-1 downto 0)
    );
  end component;
  
  signal decoder_out   : std_logic_vector(N-1 downto 0);
  signal registers_out : bus_32x32;
  
  begin
  
  decoder : decoder_5t32
    port map (
      i_WE => i_WE,
      i_S  => i_RD,
      o_Q  => decoder_out
    );
  
  reg0 : register_N
    generic map(N => N)
    port map (
      i_D   => i_D,
      i_CLK => i_CLK,
      i_RST => '1',
      i_WE  => decoder_out(0),
      o_Q   => registers_out(0)
    );
    
  G_registers : for i in 1 to N-1 generate
    reg_i : register_N
      generic map(N => N)
      port map(
        i_D   => i_D,
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => decoder_out(i),
        o_Q   => registers_out(i)
      );
  end generate G_registers;
  
  mux_rs1 : mux32t1_N
    generic map (N => N)
    port map (
      i_D => registers_out,
      i_S => i_RS1,
      o_O => o_RS1
    );
  
  mux_rs2 : mux32t1_N
    generic map (N => N)
    port map (
      i_D => registers_out,
      i_S => i_RS2,
      o_O => o_RS2
    );  

end structural;
