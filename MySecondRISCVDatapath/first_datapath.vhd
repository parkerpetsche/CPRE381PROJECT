-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- first_datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the first RISC-V datapath.

library IEEE;
use IEEE.std_logic_1164.all;

entity first_datapath is
  generic(N : Integer := 32);
  port(
    i_ALU     : in std_logic;
    i_Add_Sub : in std_logic;
    i_RS1     : in std_logic_vector(4 downto 0);
    i_RS2     : in std_logic_vector(4 downto 0);
    i_RD      : in std_logic_vector(4 downto 0);
    i_Imm     : in std_logic_vector(N-1 downto 0);
    i_WE      : in std_logic;
    i_CLK     : in std_logic;
    i_RST     : in std_logic
  );
end first_datapath;

architecture structural of first_datapath is
  
  component register_file is
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
  end component;
  
  component add_sub_N is
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
  end component;
  
  signal s_o_RS1 : std_logic_vector(N-1 downto 0);
  signal s_o_RS2 : std_logic_vector(N-1 downto 0);
  signal s_o_ALU : std_logic_vector(N-1 downto 0);
  signal s_o_Carry : std_logic;
  
  begin
  reg_file : register_file
    generic map(N => N)
    port map(
      i_RS1 => i_RS1,
      i_RS2 => i_RS2,
      i_RD  => i_RD,
      i_D   => s_o_ALU,
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE  => i_WE,
      o_RS1 => s_o_RS1,
      o_RS2 => s_o_RS2
    );
  
  ALU : add_sub_N
    generic map(N => N)
    port map(
      i_X => s_o_RS1,
      i_Y => s_o_RS2,
      i_Imm => i_Imm,
      i_Con => i_Add_Sub,
      i_ALU => i_ALU,
      o_Carry => s_o_Carry,
      o_Res => s_o_ALU
    );
 
 end structural;
  
  
  
  
