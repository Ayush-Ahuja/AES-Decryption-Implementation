library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity round_keys_ROM is
    Port ( clk      : in  std_logic;
           enable : in std_logic := '1';   
           addr     : in  std_logic_vector(7 downto 0); 
           dout     : out std_logic_vector(7 downto 0)  
         );
end round_keys_ROM;

architecture behavioral of round_keys_ROM is
   
    component blk_mem_gen_2
        Port (
            clka  : in  std_logic;  
            ena : in std_logic := '1';                 
            addra : in  std_logic_vector(7 downto 0);   
            douta : out std_logic_vector(7 downto 0)   
        );
    end component;

begin

    
    round_keys_ROM_inst : blk_mem_gen_2
        port map (
            clka  => clk, 
            ena => enable,                
            addra => addr,                              
            douta => dout               
        );

end behavioral;