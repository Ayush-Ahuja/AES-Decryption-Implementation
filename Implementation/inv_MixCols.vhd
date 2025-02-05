library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity inv_MixCols is
    Port(
        c0 : in STD_LOGIC_VECTOR (7 downto 0);
        c1 : in STD_LOGIC_VECTOR (7 downto 0);
        c2 : in STD_LOGIC_VECTOR (7 downto 0);
        c3 : in STD_LOGIC_VECTOR (7 downto 0);
        enab : in STD_LOGIC := '0';
        col0 : out STD_LOGIC_VECTOR (7 downto 0);
        col1 : out STD_LOGIC_VECTOR (7 downto 0);
        col2 : out STD_LOGIC_VECTOR (7 downto 0);
        col3 : out STD_LOGIC_VECTOR (7 downto 0)
    );
end inv_MixCols;

architecture Behavioral of inv_MixCols is

    function xtimes(d : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(7 downto 0);
    begin
        if d(7) = '0' then
            result := d(6 downto 0) & '0';
        else
            result := (d(6 downto 0) & '0') xor "00011011"; -- AES polynomial for field reduction
        end if;
        return result;
    end function xtimes;

begin
    process(c0, c1, c2, c3)
        variable temp_col, a_temp_col : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        variable a01, a02, a04, a08   : STD_LOGIC_VECTOR(7 downto 0);
    begin
        if enab = '1' then
            for index in 0 to 3 loop
                a_temp_col := (others => '0'); -- Reset a_temp_col for each column computation
    
                for i in 0 to 3 loop
                    -- Assign input columns to a01 based on loop variable i
                    if i = 0 then
                        a01 := c0;
                    elsif i = 1 then
                        a01 := c1;
                    elsif i = 2 then
                        a01 := c2;
                    else
                        a01 := c3;
                    end if;
    
                    -- Calculate intermediate values using xtimes
                    a02 := xtimes(a01); 
                    a04 := xtimes(a02); 
                    a08 := xtimes(a04); 
    
                    -- Perform the InvMixColumns matrix multiplication for AES
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
    
                    -- Accumulate the result in a_temp_col
                    a_temp_col := a_temp_col xor temp_col;
                end loop;
    
                -- Assign the computed column value to the appropriate output
                if index = 0 then
                    col0 <= a_temp_col; 
                elsif index = 1 then
                    col1 <= a_temp_col; 
                elsif index = 2 then
                    col2 <= a_temp_col; 
                else
                    col3 <= a_temp_col; 
                end if;
            end loop;
         end if;
    end process;

end Behavioral;
