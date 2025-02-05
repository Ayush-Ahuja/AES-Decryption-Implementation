library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_4x1 is
Port ( A1 : in STD_LOGIC_VECTOR (4 downto 0);
B1 : in STD_LOGIC_VECTOR (4 downto 0);
C1 : in STD_LOGIC_VECTOR (4 downto 0);
D1 : in STD_LOGIC_VECTOR (4 downto 0);
S1 : in STD_LOGIC_VECTOR (1 downto 0) := "00";
Output4 : out STD_LOGIC_VECTOR (4 downto 0));
end mux_4x1;

architecture Behavioral of mux_4x1 is
begin
    selector : process(S1)
    begin 
--    if S1 ="00" then
--        Output4 <= A1;
--    elsif S1="01" then
--        Output4 <= B1;
--    elsif S1="10" then
--        Output4 <= C1;
--    elsif S1="11" then
--        Output4 <= D1;
--    end if;
    case S1 is 
        when "00" =>
            Output4 <= A1;
        when "01" =>
            Output4 <= B1;
        when "10" =>
            Output4 <= C1;
        when others =>
            Output4 <= D1;
    END CASE;
    end process;
end Behavioral;
