LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY tb_invShiftRows IS
END tb_invShiftRows;

ARCHITECTURE tb OF tb_invShiftRows IS
COMPONENT invShiftRows
    Port (
        first_element : in std_logic_vector(7 downto 0);
        second_element : in std_logic_vector(7 downto 0);
        third_element : in std_logic_vector(7 downto 0);
        fourth_element : in std_logic_vector(7 downto 0);
        row_index : in integer;
        out_first_element : out std_logic_vector(7 downto 0);
        out_second_element : out std_logic_vector(7 downto 0);
        out_third_element : out std_logic_vector(7 downto 0);
        out_fourth_element : out std_logic_vector(7 downto 0)
    );
END COMPONENT;


signal first_element : std_logic_vector(7 downto 0) := x"72";
signal second_element : std_logic_vector(7 downto 0) := x"9f";
signal third_element : std_logic_vector(7 downto 0) := x"ff";
signal fourth_element : std_logic_vector(7 downto 0) := x"a0";
signal row_index : integer := 0;
signal out_first_element :  std_logic_vector(7 downto 0);
signal out_second_element :  std_logic_vector(7 downto 0);
signal out_third_element :  std_logic_vector(7 downto 0);
signal out_fourth_element :  std_logic_vector(7 downto 0);
signal i: integer;

BEGIN
    uut: invShiftRows PORT MAP (
    first_element => first_element,
    second_element => second_element,
    third_element => third_element,
    fourth_element => fourth_element,
    row_index => row_index,
    out_first_element => out_first_element,
    out_second_element => out_second_element,
    out_third_element => out_third_element,
    out_fourth_element => out_fourth_element
    );

simulating_proc: process
begin
    for i in 0 to 255 loop
        row_index <= i mod 4;
        wait for 20 ns;
    end loop;
wait;
end process;

END tb;
