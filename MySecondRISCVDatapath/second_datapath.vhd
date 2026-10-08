-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- second_datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of our second RISCV datapath.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity second_datapath is
  generic(
    N : Integer := 32;
    DATA_WIDTH : Natural := 32;
    ADDR_WIDTH : Natural := 10;
    BYTE_WIDTH : Natural := 8
  );
  port(
    RS1       : in std_logic_vector(4 downto 0);
    RS2       : in std_logic_vector(4 downto 0);
    RD        : in std_logic_vector(4 downto 0);
    i_Imm12   : in std_logic_vector(11 downto 0);
    i_Imm20   : in std_logic_vector(19 downto 0);
    ALU_src   : in std_logic;
    nAdd_Sub  : in std_logic;
    imm_type  : in std_logic;
    a_WE      : in std_logic;
    a_BE      : in std_logic_vector(3 downto 0);
    is_Mem    : in std_logic;
    r_WE      : in std_logic;
    i_CLK     : in std_logic;
    i_RST     : in std_logic
  );
end second_datapath;

architecture structural of second_datapath is

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

  component imm_extender is
    port (
        i_Imm12 : in  std_logic_vector(11 downto 0);
        i_Imm20 : in  std_logic_vector(19 downto 0);
        i_Con   : in  std_logic;
        o_O     : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component mux2t1_N is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
         i_S          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0));

  end component;
  
  component  full_adder_N is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
         i_C          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_C	      : out std_logic;
         o_S          : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component mem is
    generic 
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 10;
        BYTE_WIDTH : natural := 8
    );
    port 
    (
        clk        : in std_logic;
        addr            : in std_logic_vector((ADDR_WIDTH-1) downto 0);
        data            : in std_logic_vector((DATA_WIDTH-1) downto 0);
        be              : in std_logic_vector (3 downto 0);   -- 4 bytes per word
        we        : in std_logic := '1';
        q        : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
  end component;
  
  signal o_RS1     : std_logic_vector(N-1 downto 0);
  signal o_RS2     : std_logic_vector(N-1 downto 0);
  signal ext_out   : std_logic_vector(N-1 downto 0);
  signal a_mux_out : std_logic_vector(N-1 downto 0);
  signal b_mux_out : std_logic_vector(N-1 downto 0);  
  signal c_out     : std_logic;
  signal adder_out : std_logic_vector(N-1 downto 0);
  signal mem_read  : std_logic_vector(N-1 downto 0);
  signal data_out  : std_logic_vector(N-1 downto 0);
  signal a_select  : std_logic;
  begin
  
    reg_file : register_file
      generic map(N => N)
      port map(
        i_RS1 => RS1,
        i_RS2 => RS2,
        i_RD => RD,
        i_D  => data_out,
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => r_WE,
        o_RS1 => o_RS1,
        o_RS2 => o_RS2
      );
    
    extender : imm_extender
      port map(
        i_Imm12 => i_Imm12,
        i_Imm20 => i_Imm20,
        i_Con   => imm_type,
        o_O     => ext_out
      );
    
    a_select <= nAdd_Sub and ALU_src;
    
    get_a : mux2t1_N
      generic map(N => N)
      port map(
        i_S  => a_select,
        i_D0 => o_RS1,
        i_D1 => x"FFFFFFFF",
        o_O  => a_mux_out
      );
      
    get_b : mux2t1_N
      generic map(N => N)
      port map(
        i_S  => ALU_src,
        i_D0 => o_RS2,
        i_D1 => ext_out,
        o_O  => b_mux_out
      );
      
    adder : full_adder_N
      generic map(N => N)
      port map(
        i_C => nAdd_Sub,
        i_D0 => a_mux_out,
        i_D1 => b_mux_out,
        o_C => c_out,
        o_S => adder_out
      );
    
    mem_unit : mem
      generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH,
        BYTE_WIDTH => BYTE_WIDTH
      )
      port map(
        clk   => i_CLK,
        addr  => adder_out(11 downto 2),
        data  => o_RS2,
        be    => a_BE,
        we    => a_WE,
        q     => mem_read
    );
    
    final_data : mux2t1_N
      generic map(N => N)
      port map(
        i_S  => is_Mem,
        i_D0 => adder_out,
        i_D1 => mem_read,
        o_O  => data_out
      );                    
 
 end structural; 
