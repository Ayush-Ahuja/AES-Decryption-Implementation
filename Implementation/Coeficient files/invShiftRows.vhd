----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2024 15:58:38
-- Design Name: 
-- Module Name: invShiftRows - Behavioral
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity invShiftRows is
    Port (
        first_element : in std_logic_vector(7 downto 0);
        second_element : in std_logic_vector(7 downto 0);
        third_element : in std_logic_vector(7 downto 0);
        fourth_element : in std_logic_vector(7 downto 0);
        row_index : in integer;
        enab : in STD_LOGIC := '0';
        out_first_element : out std_logic_vector(7 downto 0);
        out_second_element : out std_logic_vector(7 downto 0);
        out_third_element : out std_logic_vector(7 downto 0);
        out_fourth_element : out std_logic_vector(7 downto 0)
    );
end invShiftRows;

architecture Behavioral of invShiftRows is
begin
    process(first_element, second_element, third_element, fourth_element, row_index)
    begin
        if enab = '1' then
            case row_index is
                when 4 =>
                    out_first_element <= first_element;
                    out_second_element <= second_element;
                    out_third_element <= third_element;
                    out_fourth_element <= fourth_element;
        
                when 3 =>
                    out_first_element <= fourth_element;
                    out_second_element <= first_element;
                    out_third_element <= second_element;
                    out_fourth_element <= third_element;
        
                when 2 =>
                    out_first_element <= third_element;
                    out_second_element <= fourth_element;
                    out_third_element <= first_element;
                    out_fourth_element <= second_element;
        
                when others=>
                    out_first_element <= second_element;
                    out_second_element <= third_element;
                    out_third_element <= fourth_element;
                    out_fourth_element <= first_element;
            end case;
         end if;
    end process;
end Behavioral;

