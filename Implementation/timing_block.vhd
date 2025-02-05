library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timing_block is
Port (
clk_in : in STD_LOGIC; -- 100 MHz input clock
mux_select : inout STD_LOGIC_VECTOR (1 downto 0) := "11"; -- Signal for the mux
anodes : out STD_LOGIC_VECTOR (3 downto 0) -- Anodes signal for display
);
end timing_block;


architecture Behavioral of timing_block is
constant N : integer := 50000;-- <need to select correct value>
signal counter: integer := 0;
signal clock : STD_LOGIC := '0';
--constant newnum : integer := 2;
--signal counterr: integer := 0;
--signal init_vector : std_logic_vector(1 downto 0) := "11";
begin
--Process 1 for dividing the clock from 100 Mhz to 1Khz - 60hz
    newCLK: process(clk_in)
    begin 
    if rising_edge(clk_in) then
        
        if counter = N then
            counter <= 0;
            clock <= not clock;
        else
        counter <= counter + 1;
        end if;
        
    end if;
    end process;
    --Process 2 for mux select signal
    MUXselect: process(clock)
    begin
--    mux_select <= 0
    case mux_select is 
        when "00" => 
        mux_select <= "01";
        when "01" => 
        mux_select <= "10";
        when "10" => 
        mux_select <= "11";
        when others => 
        mux_select <= "00";
        end case;
    end process;
    --Process 3 for anode signal
    ANODEselect: process(mux_select)
        begin
--        if init_vector = "00" then
--        anodes <= "1110";
--        elsif init_vector = "01" then
--        anodes <= "1101";
--        elsif init_vector = "10" then
--        anodes <= "1011";
--        elsif init_vector = "11" then
--        anodes <= "0111";
--        end if;
        case mux_select is
        when "00" =>
        anodes <= "0111";
        when "01" =>
        anodes <= "1011";
        when "10" =>
        anodes <= "1101";
        when others =>
        anodes <= "1110";
        end case;
    end process;
end Behavioral;