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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_InvMixCols is
--  Port ( );
end tb_InvMixCols;

architecture tb of tb_InvMixCols is
component InvMixCols 
Port(
        c0 : in STD_LOGIC_VECTOR (7 downto 0);
        c1 : in STD_LOGIC_VECTOR (7 downto 0);
        c2 : in STD_LOGIC_VECTOR (7 downto 0);
        c3 : in STD_LOGIC_VECTOR (7 downto 0);
        index : in integer :=0;
        col : out STD_LOGIC_VECTOR (7 downto 0)
    );
end component ;
SIGNAL c0, c1, c2, c3 : std_logic_vector(7 downto 0) := (others => '0');
SIGNAL col : std_logic_vector(7 downto 0);
SIGNAL index: integer;

begin 
uut: InvMixCols PORT MAP (
    c0 => c0,
    c1 => c1,
    c2 => c2,
    c3 => c3,
    col => col,
    index => index
  );
simulating_proc: process
begin
c0 <= "10001011";
c1 <= "01000010";
c2 <= "01101101";
c3 <= "11010101";
wait for 20ns;
wait;
end process;
end tb;
