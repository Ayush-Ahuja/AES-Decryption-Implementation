----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2024 15:49:08
-- Design Name: 
-- Module Name: XOR_part - Behavioral
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

entity XOR_part is
--  Port ( );
Port(
a_xor : in std_logic_vector(7 downto 0);
b_xor : in std_logic_vector(7 downto 0);
enab : in std_logic := '0';
output_xor : out std_logic_vector(7 downto 0)
);
end XOR_part;

architecture Behavioral of XOR_part is

begin
process(a_xor, b_xor)
    begin
        if enab = '1' then
            output_xor <= a_xor xor b_xor; 
        end if;
    end process;
end Behavioral;
