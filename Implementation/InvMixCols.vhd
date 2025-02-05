library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Use only one of the following two libraries for arithmetic operations
-- use IEEE.STD_LOGIC_ARITH.ALL;  -- Not recommended in new designs
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- For unsigned arithmetic operations

entity InvMixColumns is
    Port(
        c0 : in STD_LOGIC_VECTOR (7 downto 0);
        c1 : in STD_LOGIC_VECTOR (7 downto 0);
        c2 : in STD_LOGIC_VECTOR (7 downto 0);
        c3 : in STD_LOGIC_VECTOR (7 downto 0);
        index : in integer ;
        col : out STD_LOGIC_VECTOR (7 downto 0)
    );
end InvMixColumns;

architecture Behavioral of InvMixColumns is
    function xtimes(d : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(7 downto 0);
    begin
        if d(7) = '0' then
            result := d(6 downto 0) & '0';
        else
            result := (d(6 downto 0) & '0') xor "00011011";
        end if;
        return result;
    end function xtimes;
    type std_logic_vector_array is array(0 to 3) of STD_LOGIC_VECTOR(7 downto 0);

begin
    process(c0, c1, c2, c3, index)
        variable temp_col, a_temp_col : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        variable a01, a02, a04, a08   : STD_LOGIC_VECTOR(7 downto 0);
    begin
        a_temp_col := (others => '0'); 

        for i in 0 to 3 loop
            if i =0 then
                a01 := c0;
            elsif i=1 then
                a01 := c1;
            elsif i=2 then
                a01 := c2;
            else
                a01 := c3;
            end if;
            a02 := xtimes(a01); 
            a04 := xtimes(a02); 
            a08 := xtimes(a04); 
            case (i - index) mod 4 is 
                when 0 => 
                    temp_col := a02 xor a04 xor a08; -- multiplication with 0e
                when 1 =>
                    temp_col := a01 xor a02 xor a08; -- multiplication with 0b
                when 2 =>
                    temp_col := a01 xor a04 xor a08; -- multiplication with 0d
                when others => 
                    temp_col := a01 xor a08;         -- multiplication with 09
            end case;

            a_temp_col := a_temp_col xor temp_col;
        end loop;
        
        col <= a_temp_col;  
    end process;

end Behavioral;
