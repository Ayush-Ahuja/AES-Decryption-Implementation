----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/06/2024 04:15:51 PM
-- Design Name: 
-- Module Name: PORTmap - Behavioral
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

entity PORTmap is
--  Port ( );
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
end PORTmap;

architecture Behavioral of PORTmap is
component timing_block
Port (
clk_in : in STD_LOGIC; -- 100 MHz input clock
mux_select : inout STD_LOGIC_VECTOR (1 downto 0); -- Signal for the mux
anodes : out STD_LOGIC_VECTOR (3 downto 0) -- Anodes signal for display
);
end component;
component mux_4x1
Port ( A1 : in STD_LOGIC_VECTOR (4 downto 0);
B1 : in STD_LOGIC_VECTOR (4 downto 0);
C1 : in STD_LOGIC_VECTOR (4 downto 0);
D1 : in STD_LOGIC_VECTOR (4 downto 0);
S1 : in STD_LOGIC_VECTOR (1 downto 0);
Output4 : out STD_LOGIC_VECTOR (4 downto 0));
end component;
component decoder
Port ( p : in STD_LOGIC;
q : in STD_LOGIC;
r : in STD_LOGIC;
s : in STD_LOGIC;
enabl : in std_logic;
a : out STD_LOGIC;
b : out STD_LOGIC;
c : out STD_LOGIC;
d : out STD_LOGIC;
e : out STD_LOGIC;
f : out STD_LOGIC;
g : out STD_LOGIC);

end component;
signal x1: std_logic_vector(1 downto 0); -- inputs
signal z1 : std_logic_vector (4 downto 0); -- outputs
--signal anode_select1 : STD_LOGIC_VECTOR (3 downto 0);
begin
DUT1 : timing_block port map (clk_in,x1,anode_select);
DUT2 : mux_4x1 port map (first_digit,sec_digit,third_digit,fourth_digit,x1,z1);
DUT3 : decoder port map (z1(3),z1(2),z1(1),z1(0),z1(4),cathode_select0 ,cathode_select1 ,cathode_select2 ,cathode_select3 ,cathode_select4 ,cathode_select5 ,cathode_select6);
--anode_select <= anode_select1;
end Behavioral;
