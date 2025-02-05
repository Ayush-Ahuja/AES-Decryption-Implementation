library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity displaytext is
    Port ( 
        clk_in : in std_logic;
        digit1 : in std_logic_vector (7 downto 0);
        digit2 : in std_logic_vector (7 downto 0);
        digit3 : in std_logic_vector (7 downto 0);
        digit4 : in std_logic_vector (7 downto 0);
        cathode_selection : out std_logic_vector (6 downto 0);
        anode_selection : out std_logic_vector (3 downto 0)
    );
end displaytext;

architecture Behavioral of displaytext is
component PORTmap
Port(clk_in : in STD_LOGIC; -- 100 MHz input clock
first_digit : in STD_LOGIC_VECTOR (4 downto 0);
sec_digit : in STD_LOGIC_VECTOR (4 downto 0);
third_digit : in STD_LOGIC_VECTOR (4 downto 0);
fourth_digit : in STD_LOGIC_VECTOR (4 downto 0);
--cathode_select : out STD_LOGIC_VECTOR (6 downto 0); -- Signal for the mux
cathode_select0 : out STD_LOGIC;
cathode_select1 : out STD_LOGIC;
cathode_select2 : out STD_LOGIC;
cathode_select3 : out STD_LOGIC;
cathode_select4 : out STD_LOGIC;
cathode_select5 : out STD_LOGIC;
cathode_select6 : out STD_LOGIC;
anode_select : out STD_LOGIC_VECTOR (3 downto 0) -- Anodes signal for display
--selec_vec : out STD_LOGIC_VECTOR (3 downto 0)
);
end component;

SIGNAL first_eval : std_logic_vector(4 downto 0);
SIGNAL second_eval : std_logic_vector(4 downto 0);
SIGNAL third_eval : std_logic_vector(4 downto 0);
SIGNAL fourth_eval : std_logic_vector(4 downto 0);
SIGNAL enabs : std_logic;

function convertToChar (data : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable hex_value : std_logic_vector(4 downto 0);
begin
    case data is
        -- ASCII '0' to '9' -> hex 0x0 to 0x9
        when x"30" => hex_value := "00000";  -- ASCII '0' to hex 0x0
        when x"31" => hex_value := "00001";  -- ASCII '1' to hex 0x1
        when x"32" => hex_value := "00010";  -- ASCII '2' to hex 0x2
        when x"33" => hex_value := "00011";  -- ASCII '3' to hex 0x3
        when x"34" => hex_value := "00100";  -- ASCII '4' to hex 0x4
        when x"35" => hex_value := "00101";  -- ASCII '5' to hex 0x5
        when x"36" => hex_value := "00110";  -- ASCII '6' to hex 0x6
        when x"37" => hex_value := "00111";  -- ASCII '7' to hex 0x7
        when x"38" => hex_value := "01000";  -- ASCII '8' to hex 0x8
        when x"39" => hex_value := "01001";  -- ASCII '9' to hex 0x9

        -- ASCII 'A' to 'F' -> hex 0xA to 0xF
        when x"41" => hex_value := "01010";  -- ASCII 'A' to hex 0xA
        when x"42" => hex_value := "01011";  -- ASCII 'B' to hex 0xB
        when x"43" => hex_value := "01100";  -- ASCII 'C' to hex 0xC
        when x"44" => hex_value := "01101";  -- ASCII 'D' to hex 0xD
        when x"45" => hex_value := "01110";  -- ASCII 'E' to hex 0xE
        when x"46" => hex_value := "01111";  -- ASCII 'F' to hex 0xF

        -- ASCII 'a' to 'f' -> hex 0xA to 0xF (lowercase)
        when x"61" => hex_value := "01010";  -- ASCII 'a' to hex 0xA
        when x"62" => hex_value := "01011";  -- ASCII 'b' to hex 0xB
        when x"63" => hex_value := "01100";  -- ASCII 'c' to hex 0xC
        when x"64" => hex_value := "01101";  -- ASCII 'd' to hex 0xD
        when x"65" => hex_value := "01110";  -- ASCII 'e' to hex 0xE
        when x"66" => hex_value := "01111";  -- ASCII 'f' to hex 0xF

        -- Default case for invalid input
        when others => hex_value := "10000";
    end case;
    return hex_value;
end function convertToChar;
begin 
    first_eval <= convertToChar(digit1);
    second_eval <= convertToChar(digit2);
    third_eval <= convertToChar(digit3);
    fourth_eval <= convertToChar(digit4);
    
    
DUT1 : PORTmap
    PORT MAP (
        clk_in         => clk_in,
        first_digit    => first_eval,
        sec_digit      => second_eval,
        third_digit    => third_eval,
        fourth_digit   => fourth_eval,
        cathode_select0 => cathode_selection(0),
        cathode_select1 => cathode_selection(1),
        cathode_select2 => cathode_selection(2),
        cathode_select3 => cathode_selection(3),
        cathode_select4 => cathode_selection(4),
        cathode_select5 => cathode_selection(5),
        cathode_select6 => cathode_selection(6),
        anode_select   => anode_selection
    );  
end Behavioral;
