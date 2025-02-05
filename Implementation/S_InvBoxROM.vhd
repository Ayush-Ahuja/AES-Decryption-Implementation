----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2024 03:11:37 PM
-- Design Name: 
-- Module Name: bram - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity S_InvBoxROM is
    Port ( clk      : in  std_logic;
           enable : in std_logic := '1';   
           addr     : in  std_logic_vector(7 downto 0); -- Address for accessing BRAM
           dout     : out std_logic_vector(7 downto 0)  -- Data read from BRAM
         );
end S_InvBoxROM;

architecture behavioral of S_InvBoxROM is
   
    component blk_mem_gen_1
        Port (
            clka  : in  std_logic;  
            ena : in std_logic := '1';                 
            addra : in  std_logic_vector(7 downto 0);   
            douta : out std_logic_vector(7 downto 0)   
        );
    end component;

begin

    
    S_InvBoxROM_inst : blk_mem_gen_1
        port map (
            clka  => clk, 
            ena => enable,                
            addra => addr,                              
            douta => dout               
        );

end behavioral;
