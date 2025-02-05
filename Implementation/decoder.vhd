----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/30/2024 02:30:06 PM
-- Design Name: 
-- Module Name: decoder - Behavioral
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

entity decoder is
--  Port ( );
Port ( p : in STD_LOGIC;
q : in STD_LOGIC;
r : in STD_LOGIC;
s : in STD_LOGIC;
enabl : in STD_Logic;
a : out STD_LOGIC;
b : out STD_LOGIC;
c : out STD_LOGIC;
d : out STD_LOGIC;
e : out STD_LOGIC;
f : out STD_LOGIC;
g : out STD_LOGIC);
end decoder;

architecture Behavioral of decoder is

begin
process (p,q,r,s,enabl)
begin
if enabl = '1' then
    a<= '1';
    b<= '1';
    c<= '1';
    d<= '1';
    e<= '1';
    f<= '1';
    g<= '0';
 else
a<=not ((p or q or r or not s) and (p or not q or r or s) and (not p or not q or r or not s) and (not p or q or not r or not s));
b<=not((p or not q or r or not s) and (not q or not r or s) and (not p or not q or s) and (not p or not r or not s));
c<=not (( p or  q or  not r or  s) and (not p or not q or  not r) and (not p or not q or s));
d<=not( (not q or  not r or not s) and ( p or  q or  r or not s) and ( p or not q or r or  s) and (not p or q or  not r or s));
e<=not( (p or not s) and (p or not q or r) and (q or r or not s));
f<=not((p or q or not s) and (p or q or not r) and (p or not r or not s) and (not p or not q or r or not s));
g<=not((p or q or r) and (p or not q or not r or not s) and (not p or not q or r or s));
end if;
end process;
end Behavioral;
