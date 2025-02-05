----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2024 20:16:34
-- Design Name: 
-- Module Name: tb_displaytext - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_displaytext is
--  Port ( );
end tb_displaytext;

architecture tb of tb_displaytext is
component displaytext 
Port(
       clk_in : in std_logic;
       digit1 : in std_logic_vector (7 downto 0);
       digit2 : in std_logic_vector (7 downto 0);
       digit3 : in std_logic_vector (7 downto 0);
       digit4 : in std_logic_vector (7 downto 0);
       cathode_selection : out std_logic_vector (6 downto 0);
       anode_selection : out std_logic_vector (3 downto 0)
    );
end component ;

SIGNAL clk_in :  std_logic := '0';
SIGNAL digit1 :  std_logic_vector (7 downto 0);
SIGNAL digit2 :  std_logic_vector (7 downto 0);
SIGNAL digit3 :  std_logic_vector (7 downto 0);
SIGNAL digit4 :  std_logic_vector (7 downto 0);
SIGNAL cathode_selection : std_logic_vector (6 downto 0);
SIGNAL anode_selection : std_logic_vector (3 downto 0);

begin

uut: displaytext PORT MAP (
    clk_in => clk_in,
    digit1 => digit1,
    digit2 => digit2,
    digit3 => digit3,
    digit4 => digit4,
    cathode_selection => cathode_selection,
    anode_selection => anode_selection
  );

clk_in <= not clk_in after 10 ns;
digit1 <= "01110010";
digit2 <= x"39";
digit3 <= x"5a";
digit4 <= x"42";

end tb;
