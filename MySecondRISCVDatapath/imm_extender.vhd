-------------------------------------------------------------------------
-- Parker Petsche
-- Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- imm_extender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a generic immediate extender for our datapath.
--            

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity imm_extender is
    port (
        i_Imm12 : in  std_logic_vector(11 downto 0);
        i_Imm20 : in  std_logic_vector(19 downto 0);
        i_Con   : in  std_logic;
        o_O     : out std_logic_vector(31 downto 0)
    );
end imm_extender;

architecture behavioral of imm_extender is
begin

    process(i_Imm12, i_Imm20, i_Con)
    begin
        if i_Con = '1' then
            -- Sign extend 12-bit immediate
            o_O(11 downto 0)  <= i_Imm12;
            o_O(31 downto 12) <= (others => i_Imm12(11));

        else
            -- Append 12 zeros to 20-bit immediate
            o_O(11 downto 0)  <= (others => '0');
            o_O(31 downto 12) <= i_Imm20;
        end if;
    end process;

end behavioral;
