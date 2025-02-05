LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY invSubBytes IS
PORT(
clk_in          : IN  STD_LOGIC;
elem_vector     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
enab : IN  std_logic := '0';
out_elem_vector : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END invSubBytes;

ARCHITECTURE behavioral OF invSubBytes IS

COMPONENT S_InvBoxROM
PORT(
clk  : IN  STD_LOGIC;
enable : std_logic := '1';
addr : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;

SIGNAL x1   : STD_LOGIC_VECTOR(7 DOWNTO 0); 
SIGNAL idx1 : INTEGER RANGE 0 TO 15; 
SIGNAL idx2 : INTEGER RANGE 0 TO 15; 
SIGNAL mult : INTEGER RANGE 0 TO 255; 

BEGIN
idx1 <= to_integer(unsigned(elem_vector(7 DOWNTO 4)));
idx2 <= to_integer(unsigned(elem_vector(3 DOWNTO 0)));
mult <= (16 * idx1) + idx2;
x1 <= std_logic_vector(to_unsigned(mult, 8));

DUT1 : S_InvBoxROM PORT MAP(
clk  => clk_in,
enable => enab,
addr => x1,
dout => out_elem_vector
 );
END behavioral;

