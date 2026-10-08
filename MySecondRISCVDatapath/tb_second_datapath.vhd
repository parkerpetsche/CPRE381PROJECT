-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_second_datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the second RISC-V datapath.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_second_datapath is
  generic(
    N : Integer := 32;
    DATA_WIDTH : Natural := 32;
    ADDR_WIDTH : Natural := 10;
    BYTE_WIDTH : Natural := 8;
    gCLK_HPER : Time := 50 ns
  );
end tb_second_datapath;

architecture structural of tb_second_datapath is


  constant cCLK_PER  : time := gCLK_HPER * 2;
  
  
  component second_datapath is
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
end component;


      signal s_RS1 : std_logic_vector(4 downto 0);
      signal s_RS2 : std_logic_vector(4 downto 0);
      signal s_RD : std_logic_vector(4 downto 0);
      signal s_i_Imm12 : std_logic_vector(11 downto 0);
      signal s_i_Imm20 : std_logic_vector(19 downto 0);
      signal s_ALU_src   : std_logic;
      signal s_nAdd_Sub  : std_logic;
      signal s_imm_type  : std_logic;
      signal s_a_WE      : std_logic;
      signal s_a_BE      : std_logic_vector(3 downto 0);
      signal s_is_Mem    : std_logic;
      signal s_r_WE      : std_logic;
      signal s_i_CLK     : std_logic;
      signal s_i_RST     : std_logic;
      
      begin
      
      DUT : second_datapath
        generic map(
          N => N,
          DATA_WIDTH => DATA_WIDTH,
          ADDR_WIDTH => ADDR_WIDTH,
          BYTE_WIDTH => BYTE_WIDTH
        )
        port map(
          RS1 => s_RS1,
          RS2 => s_RS2,
          RD => s_RD,
          i_Imm12 => s_i_Imm12,
          i_Imm20 => s_i_Imm20,
          ALU_src => s_ALU_src,
          nAdd_Sub => s_nAdd_Sub,
          imm_type => s_imm_type,
          a_WE => s_a_WE,
          a_BE => s_a_BE,
          is_Mem => s_is_Mem,
          r_WE => s_r_WE,
          i_CLK => s_i_CLK,
          i_RST => s_i_RST
        );
        
      
  P_CLK: process
  begin
    s_i_CLK <= '0';
    wait for gCLK_HPER;
    s_i_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  P_TB: process
    begin

    s_RS1 <= "00000";
    s_RS2 <= "00000";
    s_RD <= "00000";
    s_i_Imm12 <= (others => '0');
    s_i_Imm20 <= (others => '0');
    s_ALU_src <= '0';
    s_nAdd_Sub <= '0';
    s_imm_type <= '0';
    s_a_WE <= '0';
    s_a_BE <= "1111";
    s_is_Mem <= '0';
    s_r_WE <= '0';
    s_i_RST <= '1';
    wait for cCLK_PER;

    s_i_RST <= '0';
    


    ----------------------------------------------------------------
    -- addi x25, x25, 0x3AC
    -- x25 = 0, corresponding to address 0x100103AC in the
    -- simulated word-addressable memory.
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "11001";
    s_i_Imm12 <= x"3AC";
    s_i_Imm20 <= (others => '0');
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;

    -- addi x1, zero, -40
    s_RS1 <= "00000";
    s_RD <= "00001";
    s_i_Imm12 <= x"FD8";
    s_i_Imm20 <= (others => '0');
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;
        
    --sw -40 in 0x940
    --sw x1, 0(x25)
    s_RS1 <= "11001";
    s_RS2 <= "00001";
    s_i_Imm12 <= x"000";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '1';
    s_is_Mem <= '0';
    s_r_WE <= '0';
    wait for cCLK_PER;

  -- load -40 into x23 from addi 0x940
  -- lw x23, 0(x25)
    s_RS1 <= "11001";
    s_RD <= "10111";
    s_i_Imm12 <= x"000";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '1';
    s_r_WE <= '1';
    wait for cCLK_PER;
    
    ----------------------------------------------------------------
    -- addi x26, x25, 256
    -- x26 = 256 = address of B[0]
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "11010";
    s_i_Imm12 <= x"100";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- lw x1, 0(x25)
    -- x1 = A[0] = -1
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "00001";
    s_i_Imm12 <= x"000";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '1';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- lw x2, 4(x25)
    -- x2 = A[1] = 2
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "00010";
    s_i_Imm12 <= x"004";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '1';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- add x1, x1, x2
    -- x1 = -1 + 2 = 1
    ----------------------------------------------------------------
    s_RS1 <= "00001";
    s_RS2 <= "00010";
    s_RD <= "00001";
    s_ALU_src <= '0';
    s_nAdd_Sub <= '0';
    s_imm_type <= '0';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- sw x1, 0(x26)
    -- B[0] = 1
    ----------------------------------------------------------------
    s_RS1 <= "11010";
    s_RS2 <= "00001";
    s_i_Imm12 <= x"000";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '1';
    s_is_Mem <= '0';
    s_r_WE <= '0';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- lw x2, 8(x25)
    -- x2 = A[2] = -3
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "00010";
    s_i_Imm12 <= x"008";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '1';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- add x1, x1, x2
    -- x1 = 1 + (-3) = -2
    ----------------------------------------------------------------
    s_RS1 <= "00001";
    s_RS2 <= "00010";
    s_RD <= "00001";
    s_ALU_src <= '0';
    s_nAdd_Sub <= '0';
    s_imm_type <= '0';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- sw x1, 4(x26)
    -- B[1] = -2
    ----------------------------------------------------------------
    s_RS1 <= "11010";
    s_RS2 <= "00001";
    s_i_Imm12 <= x"004";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '1';
    s_is_Mem <= '0';
    s_r_WE <= '0';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- lw x2, 12(x25)
    -- x2 = A[3] = 4
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "00010";
    s_i_Imm12 <= x"00C";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '1';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- add x1, x1, x2
    -- x1 = -2 + 4 = 2
    ----------------------------------------------------------------
    s_RS1 <= "00001";
    s_RS2 <= "00010";
    s_RD <= "00001";
    s_ALU_src <= '0';
    s_nAdd_Sub <= '0';
    s_imm_type <= '0';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- sw x1, 8(x26)
    -- B[2] = 2
    ----------------------------------------------------------------
    s_RS1 <= "11010";
    s_RS2 <= "00001";
    s_i_Imm12 <= x"008";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '1';
    s_is_Mem <= '0';
    s_r_WE <= '0';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- lw x2, 16(x25)
    -- x2 = A[4] = 5
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "00010";
    s_i_Imm12 <= x"010";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '1';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- add x1, x1, x2
    -- x1 = 2 + 5 = 7
    ----------------------------------------------------------------
    s_RS1 <= "00001";
    s_RS2 <= "00010";
    s_RD <= "00001";
    s_ALU_src <= '0';
    s_nAdd_Sub <= '0';
    s_imm_type <= '0';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- sw x1, 12(x26)
    -- B[3] = 7
    ----------------------------------------------------------------
    s_RS1 <= "11010";
    s_RS2 <= "00001";
    s_i_Imm12 <= x"00C";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '1';
    s_is_Mem <= '0';
    s_r_WE <= '0';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- lw x2, 20(x25)
    -- x2 = A[5] = 6
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "00010";
    s_i_Imm12 <= x"014";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '1';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- add x1, x1, x2
    -- x1 = 7 + 6 = 13
    ----------------------------------------------------------------
    s_RS1 <= "00001";
    s_RS2 <= "00010";
    s_RD <= "00001";
    s_ALU_src <= '0';
    s_nAdd_Sub <= '0';
    s_imm_type <= '0';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- sw x1, 16(x26)
    -- B[4] = 13
    ----------------------------------------------------------------
    s_RS1 <= "11010";
    s_RS2 <= "00001";
    s_i_Imm12 <= x"010";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '1';
    s_is_Mem <= '0';
    s_r_WE <= '0';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- lw x2, 24(x25)
    -- x2 = A[6] = -7
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "00010";
    s_i_Imm12 <= x"018";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '1';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- add x1, x1, x2
    -- x1 = 13 + (-7) = 6
    ----------------------------------------------------------------
    s_RS1 <= "00001";
    s_RS2 <= "00010";
    s_RD <= "00001";
    s_ALU_src <= '0';
    s_nAdd_Sub <= '0';
    s_imm_type <= '0';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- addi x27, x25, 512
    -- x27 = 512 = address corresponding to B[64]
    ----------------------------------------------------------------
    s_RS1 <= "11001";
    s_RD <= "11011";
    s_i_Imm12 <= x"200";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '0';
    s_is_Mem <= '0';
    s_r_WE <= '1';
    wait for cCLK_PER;

    ----------------------------------------------------------------
    -- sw x1, -4(x27)
    -- B[63] = 6
    -- -4 = 0xFFC in the 12-bit immediate.
    ----------------------------------------------------------------
    s_RS1 <= "11011";
    s_RS2 <= "00001";
    s_i_Imm12 <= x"FFC";
    s_ALU_src <= '1';
    s_nAdd_Sub <= '0';
    s_imm_type <= '1';
    s_a_WE <= '1';
    s_is_Mem <= '0';
    s_r_WE <= '0';
    wait for cCLK_PER;

    wait;

  end process;

end structural;
