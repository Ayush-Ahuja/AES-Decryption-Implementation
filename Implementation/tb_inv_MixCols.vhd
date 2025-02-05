----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2024 11:51:07
-- Design Name: 
-- Module Name: tb_InvMixCols - Behavioral
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

entity tb_inv_MixCols is
--  Port ( );
end tb_inv_MixCols;

architecture tb of tb_inv_MixCols is
component inv_MixCols 
Port(
        c0 : in STD_LOGIC_VECTOR (7 downto 0);
        c1 : in STD_LOGIC_VECTOR (7 downto 0);
        c2 : in STD_LOGIC_VECTOR (7 downto 0);
        c3 : in STD_LOGIC_VECTOR (7 downto 0);
        col0 : out STD_LOGIC_VECTOR (7 downto 0);
        col1 : out STD_LOGIC_VECTOR (7 downto 0);
        col2 : out STD_LOGIC_VECTOR (7 downto 0);
        col3 : out STD_LOGIC_VECTOR (7 downto 0)
    );
end component ;
SIGNAL c0, c1, c2, c3 : std_logic_vector(7 downto 0) := (others => '0');
SIGNAL col0, col1, col2, col3 : std_logic_vector(7 downto 0);
begin 
uut: inv_MixCols PORT MAP (
    c0 => c0,
    c1 => c1,
    c2 => c2,
    c3 => c3,
    col0 => col0,
    col1 => col1,
    col2 => col2,
    col3 => col3
  );
simulating_proc: process
begin
c0 <= x"8b",
      x"0c" after 100 ns,
      x"68" after 200 ns,
      x"da" after 300 ns;
c1 <= x"42",
      x"70" after 100 ns,
      x"43" after 200 ns,
      x"4e" after 300 ns;
c2 <= x"6d",
      x"30" after 100 ns,
      x"00" after 200 ns,
      x"d7" after 300 ns;
c3 <= x"d5",
      x"1f" after 100 ns,
      x"8a" after 200 ns,
      x"ee" after 300 ns;
--    for i in 0 to 255 loop
--        c0 <= std_logic_vector(to_unsigned(i, 8));
--        c1 <= std_logic_vector(to_unsigned((i+31) mod 256, 8));
--        c2 <= std_logic_vector(to_unsigned((i+61) mod 256, 8));
--        c3 <= std_logic_vector(to_unsigned((i+97) mod 256, 8));
--        wait for 20 ns;
--    end loop;
wait;
end process;
end tb;
