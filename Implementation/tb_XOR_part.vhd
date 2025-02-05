----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2024 10:42:23
-- Design Name: 
-- Module Name: tb_XOR_part - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_XOR_part is
--  Port ( );
end tb_XOR_part;

architecture tb of tb_XOR_part is
COMPONENT XOR_part
    Port (
        a_xor : in std_logic_vector(7 downto 0);
        b_xor : in std_logic_vector(7 downto 0);
        output_xor : out std_logic_vector(7 downto 0) 
    );
END COMPONENT;

SIGNAL a_xor : std_logic_vector(7 downto 0) := (others => '0');
SIGNAL b_xor : std_logic_vector(7 downto 0) := (others => '0');
SIGNAL output_xor : std_logic_vector(7 downto 0);
SIGNAL i: integer;

begin
uut: XOR_part PORT MAP (
    a_xor => a_xor,
    b_xor => b_xor,
    output_xor => output_xor
  );

simulating_proc: process
begin
    for i in 0 to 255 loop
        a_xor <= std_logic_vector(to_unsigned(i, 8));
        b_xor <= std_logic_vector(to_unsigned((i+31) mod 256, 8));
        wait for 20 ns;
    end loop;
wait;

end process;
 

end tb;
