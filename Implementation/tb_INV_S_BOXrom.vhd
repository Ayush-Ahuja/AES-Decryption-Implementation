----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2024 22:10:16
-- Design Name: 
-- Module Name: tb_INV_S_BOXrom - Behavioral
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_INV_S_BOXrom is
--  Port ( );
end tb_INV_S_BOXrom;

architecture tb of tb_INV_S_BOXrom is

COMPONENT S_InvBoxROM is
    Port ( clk      : in  std_logic;
           enable : in std_logic := '1';   
           addr     : in  std_logic_vector(7 downto 0); -- Address for accessing BRAM
           dout     : out std_logic_vector(7 downto 0)  -- Data read from BRAM
         );
end COMPONENT;

SIGNAL clk      :  std_logic := '0';
SIGNAL enable : std_logic := '1';   
SIGNAL addr     :  std_logic_vector(7 downto 0); -- Address for accessing BRAM
SIGNAL dout     :  std_logic_vector(7 downto 0);  -- Data read from BRAM

begin
UUT : S_InvBoxROM 
    PORT MAP(
        clk => clk,
        enable => enable,
        addr => addr,
        dout => dout
    );
 clk <= not clk after 10 ns;
 enable <= not enable after 100 ns;
 
stim_proc: process
begin
    for i in 0 to 255 loop
        addr <= std_logic_vector(to_unsigned(i, 8));
        wait for 20 ns;
    end loop;
wait;
end process;  

end tb;
