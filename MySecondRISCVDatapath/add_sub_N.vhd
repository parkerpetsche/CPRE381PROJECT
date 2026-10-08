-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- add_sub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an N-bit add-sub unit, modified to include immediates.
--            

library IEEE;
use IEEE.std_logic_1164.all;


entity add_sub_N is
  generic(N : Integer := 32);
    port (
      i_X : in std_logic_vector(N-1 downto 0);
      i_Y : in std_logic_vector(N-1 downto 0);
      i_Imm : in std_logic_vector(N-1 downto 0);
      i_Con : in std_logic;
      i_ALU : in std_logic;
      o_Carry : out std_logic;
      o_Res : out std_logic_vector(N-1 downto 0)
    );
end add_sub_N;

architecture structural of add_sub_N is

  component ones_comp_N is
    generic(N : Integer := 32);
      port (
        I : in std_logic_vector(N-1 Downto 0);
        O : out std_logic_vector(N-1 downto 0)
      );
  end component;
  
  component mux2t1_N is
    generic(N : integer := 32); 
      port(i_S          : in std_logic;
           i_D0         : in std_logic_vector(N-1 downto 0);
           i_D1         : in std_logic_vector(N-1 downto 0);
           o_O          : out std_logic_vector(N-1 downto 0)
      );
  end component;
  
  component full_adder_N is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
      port(i_C          : in std_logic;
           i_D0         : in std_logic_vector(N-1 downto 0);
           i_D1         : in std_logic_vector(N-1 downto 0);
           o_C	        : out std_logic;
           o_S          : out std_logic_vector(N-1 downto 0)
      );
  end component; 
  
  
  signal s_inv_out : std_logic_vector(N-1 downto 0);
  signal s_twos_out : std_logic_vector(N-1 downto 0);
  signal s_mux_out : std_logic_vector(N-1 downto 0);
  signal s_a_out : std_logic_vector(N-1 downto 0);
  signal s_b_out : std_logic_vector(N-1 downto 0);
  signal twos_carry : std_logic;
  signal a_select : std_logic;
  begin
    
    inverter : ones_comp_N
      port map(
        I => i_Y,
        O => s_inv_out
      );
      
    mux_twos : mux2t1_N
      port map(
        i_S => i_Con, -- nAdd_sub
        i_D0 => i_Y,
        i_D1 => s_inv_out,
        o_O => s_mux_out
      );
    
    a_select <= i_Con and i_ALU;
    mux_A : mux2t1_N
      port map(
        i_S => a_select, -- 11 case
        i_D0 => i_X,
        i_D1 => x"FFFFFFFF", -- carry in bit will be 1, so this offsets that
        o_O => s_a_out
      );
    
    mux_B : mux2t1_N
      port map(
        i_S => i_ALU,
        i_D0 => s_mux_out,
        i_D1 => i_Imm,
        o_O => s_b_out
      );
      
    big_adder : full_adder_N
      port map(
        i_C => i_Con, --nAdd_Sub
        i_D0 => s_a_out,
        i_D1 => s_b_out,
        o_C => o_Carry,
        o_S => o_Res
      );
      
end structural;
