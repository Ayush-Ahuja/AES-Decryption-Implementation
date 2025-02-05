LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY tb_invSubBytes IS
END tb_invSubBytes;

ARCHITECTURE tb OF tb_invSubBytes IS
COMPONENT invSubBytes
    PORT(
    clk_in          : IN  STD_LOGIC;
    elem_vector     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    enab            : IN std_logic := '0';
    out_elem_vector : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END COMPONENT;--Inputs

signal clock : std_logic := '0';
signal takedata : std_logic_vector(7 downto 0) := (others => '0');--Outputs
signal givdata : std_logic_vector(7 downto 0) := (others => '0');-- Clock period definitions
constant clock_period : time := 10 ns;
signal enabling : std_logic := '1';
signal i: integer;

BEGIN-- Read image in VHDL
    uut: invSubBytes PORT MAP (
    clk_in => clock,
    elem_vector => givdata,
    enab => enabling,
    out_elem_vector => takedata
    );-- Clock process definitions


clock_process :process
begin
    clock <= '0';
    wait for clock_period/2;
    clock <= '1';
    wait for clock_period/2;
end process;-- Stimulus process

enabling <= not enabling after 100 ns; 

stim_proc: process
begin
    for i in 0 to 255 loop
        givdata <= std_logic_vector(to_unsigned(i, 8));
        wait for 20 ns;
    end loop;
wait;
end process;

END tb;
