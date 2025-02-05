library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity FSM IS
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           cathode_select : out STD_LOGIC_VECTOR(6 downto 0);
           anode_select : out STD_LOGIC_VECTOR(3 downto 0);
           reg : out STD_LOGIC_VECTOR(127 downto 0)
         );
end FSM;

architecture machine of FSM IS
    component bram_access
    Port ( clk      : in  std_logic;
           rst      : in  std_logic;
           ena      : in  std_logic;  -- enable signal that basically enables memory for read/write
           we       : in  std_logic_vector(0 downto 0);   
           addr     : in  std_logic_vector(10 downto 0); -- Address for accessing BRAM
           din      : in  std_logic_vector(7 downto 0); -- Data to write into BRAM
           dout     : out std_logic_vector(7 downto 0)  -- Data read from BRAM
         );
    end component;
    
    component round_keys_ROM 
    Port ( clk      : in  std_logic;
           enable   : in std_logic ;   
           addr     : in  std_logic_vector(7 downto 0); 
           dout     : out std_logic_vector(7 downto 0)  
         );
    end component;
    
    component invSubBytes IS
    PORT(
    clk_in          : IN  STD_LOGIC;
    elem_vector     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    enab : IN  std_logic ;
    out_elem_vector : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END component;
    
    component XOR_part is
--  Port ( );
    Port(
    a_xor : in std_logic_vector(7 downto 0);
    b_xor : in std_logic_vector(7 downto 0);
    output_xor : out std_logic_vector(7 downto 0);
    enab : in std_logic 
    );
    end component ;
    
    component invShiftRows is
    Port (
        first_element : in std_logic_vector(7 downto 0);
        second_element : in std_logic_vector(7 downto 0);
        third_element : in std_logic_vector(7 downto 0);
        fourth_element : in std_logic_vector(7 downto 0);
        row_index : in integer;
        enab : in std_logic;
        out_first_element : out std_logic_vector(7 downto 0);
        out_second_element : out std_logic_vector(7 downto 0);
        out_third_element : out std_logic_vector(7 downto 0);
        out_fourth_element : out std_logic_vector(7 downto 0)
    );
    end component;
    
    component inv_MixCols is
    Port(
        c0 : in STD_LOGIC_VECTOR (7 downto 0);
        c1 : in STD_LOGIC_VECTOR (7 downto 0);
        c2 : in STD_LOGIC_VECTOR (7 downto 0);
        c3 : in STD_LOGIC_VECTOR (7 downto 0);
        enab : in std_logic ;
        col0 : out STD_LOGIC_VECTOR (7 downto 0);
        col1 : out STD_LOGIC_VECTOR (7 downto 0);
        col2 : out STD_LOGIC_VECTOR (7 downto 0);
        col3 : out STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;
    
    component displaytext is
    Port ( 
        clk_in : in std_logic;
        digit1 : in std_logic_vector (7 downto 0);
        digit2 : in std_logic_vector (7 downto 0);
        digit3 : in std_logic_vector (7 downto 0);
        digit4 : in std_logic_vector (7 downto 0);
        cathode_selection : out std_logic_vector (6 downto 0);
        anode_selection : out std_logic_vector (3 downto 0)
    );
    end component;

    type state_type is (xor_op, subbyte_op, shiftrow_op, mixcol_op, counting, plain_text, reading, writing, reading_key);
    constant XOR_CYCLES      : integer := 10;  -- Example cycle count for XOR_part
    constant SUBBYTE_CYCLES  : integer := 5;  -- Example cycle count for invSubBytes
    constant SHIFTROW_CYCLES : integer := 5;  -- Example cycle count for invShiftRows
    constant MIXCOL_CYCLES   : integer := 5;  -- Example cycle count for inv_MixCols
    constant BRAM_CYCLES     : integer := 5;  -- Example cycle count for inv_MixCols
    constant ROM_CYCLES      : integer := 5;  -- Example cycle count for inv_MixCols
    constant DISPLAY_CYCLES  : integer := 300000000;
    signal xor_counter       : integer := XOR_CYCLES;
    signal subbyte_counter   : integer := SUBBYTE_CYCLES;
    signal shiftrow_counter  : integer := SHIFTROW_CYCLES;
    signal mixcol_counter    : integer := MIXCOL_CYCLES;
    signal display_counter   : integer := DISPLAY_CYCLES;
    signal bram_counter      : integer := BRAM_CYCLES;
    signal rom_counter       : integer := ROM_CYCLES;
    
    
    signal cur_state : state_type := counting;
    signal next_state : state_type := counting;
    signal round_count : integer := 0;
    signal count_xor : integer := 0;
    signal count_subbyte : integer := 0;
    signal count_shiftrow : integer := 0;
    signal count_mixcol : integer := 0;
    signal multiple : integer := 1;
    signal multiple_count : integer := 0;
    signal multiple_counter : integer := 0;
--    signal indicate : integer := 0;
    signal xor_done : std_logic := '0';
    signal shiftrow_done : std_logic := '0';
    signal subbyte_done : std_logic := '0';
    signal read_ram_done : std_logic := '0';
    signal read_rom_done : std_logic := '0';
    signal write_done : std_logic := '0';
    signal mixcol_done : std_logic := '0';
    signal plaintext_done : std_logic := '0';   
--    signal counting_done : std_logic := '0';
--    signal oper_done : std_logic := '0';
    signal oper_type : integer := 0;
    signal reg1 : std_logic_vector(7 downto 0) := "00000000";
    signal reg3 : std_logic_vector(7 downto 0) := "00000000";
    signal reg5 : std_logic_vector(7 downto 0) := "00000000";
    signal reg51 : std_logic_vector(7 downto 0) := "00000000";
    signal addr_reg_ram1 : std_logic_vector(10 downto 0) := "00000000000";
    signal addr_reg_ram2 : std_logic_vector(10 downto 0) := "00000000000";
    signal addr_reg_rom : std_logic_vector(7 downto 0) := "00000000";
    signal reg2 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal reg441 : std_logic_vector(7 downto 0) := "00000000";
    signal reg442 : std_logic_vector(7 downto 0) := "00000000";
    signal reg443 : std_logic_vector(7 downto 0) := "00000000";
    signal reg444 : std_logic_vector(7 downto 0) := "00000000";
    signal reg7 : std_logic_vector(7 downto 0) := "00000000";
    signal reg41 : std_logic_vector(7 downto 0) := "00000000";
    signal reg42 : std_logic_vector(7 downto 0) := "00000000";
    signal reg43 : std_logic_vector(7 downto 0) := "00000000";
    signal reg44 : std_logic_vector(7 downto 0) := "00000000";
    signal reg8 : std_logic_vector(7 downto 0) := "00000000";
    signal row_index : integer := 4;
    signal tot_reg_key : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    signal tot_reg : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    signal byte_count : integer range 0 to 15 := 0;     -- Counter to track byte position
    signal digit1: std_logic_vector(7 downto 0) := "00000000";
    signal digit2: std_logic_vector(7 downto 0) := "00000000";
    signal digit3: std_logic_vector(7 downto 0) := "00000000";
    signal digit4: std_logic_vector(7 downto 0) := "00000000";
    signal mix_col_number : integer :=0;

--    signal resolve_integer :0;
    signal xor_enab : std_logic := '0';
    signal shiftrow_enab : std_logic := '0';
    signal subbyte_enab : std_logic := '0';
    signal readkey_enab : std_logic := '0';
    signal write_enab : std_logic_vector(0 downto 0) := "0";
    signal mixcol_enab : std_logic := '0';
    signal plaintext_enab : std_logic := '0'; 
    signal bram_enab : std_logic := '0';
    signal bram_enab1 : std_logic := '0';
    
    
begin
    
    DUT1 : invShiftRows PORT MAP(
        first_element => reg2(31 downto 24),
        second_element => reg2(23 downto 16),
        third_element => reg2(15 downto 8),
        fourth_element => reg2(7 downto 0),
        row_index => row_index,
        out_first_element => reg41(7 downto 0),
        out_second_element => reg42(7 downto 0),
        out_third_element => reg43(7 downto 0),
        out_fourth_element => reg44(7 downto 0),
        enab => shiftrow_enab
     );
     
    DUT2 : inv_MixCols PORT MAP(
        c0 => reg2(31 downto 24),
        c1 => reg2(23 downto 16),
        c2 => reg2(15 downto 8),
        c3 => reg2(7 downto 0),
        enab => mixcol_enab,
        col0 => reg441,
        col1 => reg442,
        col2 => reg443,
        col3 => reg444
     );
     
    DUT3 : XOR_part PORT MAP(
         a_xor => reg1(7 downto 0),
         b_xor => reg3(7 downto 0),
         output_xor => reg5(7 downto 0),
         enab => xor_enab
     );
     
    DUT4 : invSubBytes PORT MAP(
        clk_in  => clk,
        elem_vector => reg1(7 downto 0),   
        enab => subbyte_enab,
        out_elem_vector => reg51
     );
    
--    DUT5 : bram_access PORT MAP(
--       clk => clk,     
--       rst  => '0',    
--       ena  => bram_enab,      -- enable signal that basically enables memory for read/write
--       we   => "1",       
--       addr => addr_reg_ram2,    
--       din  => reg1(7 downto 0),    
--       dout => reg5(7 downto 0)   
--     );
     
     DUT6 : bram_access PORT MAP(
       clk => clk,     
       rst  => '0',    
       ena  => bram_enab1,      -- enable signal that basically enables memory for read/write
       we   => write_enab,       
       addr => addr_reg_ram1,    
       din  => reg1(7 downto 0),    
       dout => reg8(7 downto 0)   
     );
    
    DUT7 : round_keys_ROM PORT MAP(
       clk  => clk,
       enable => readkey_enab,  
       addr  => addr_reg_rom, 
       dout => reg7(7 downto 0)      
     );
     
     DUT8 : displaytext PORT MAP(
        clk_in => clk,
        digit1 => digit1,
        digit2 => digit2,
        digit3 => digit3,
        digit4 => digit4,
        cathode_selection => cathode_select,
        anode_selection => anode_select 
     );
    
     
    -- Sequential block
    reg <= tot_reg;
    process (clk, reset)
    begin
        if (reset = '1') then
            cur_state <= counting;
--            round_count <= 0;
        elsif (clk'EVENT AND clk = '1') then
            cur_state <= next_state;
            -- Decrement counters if components are enabled
            if xor_enab = '1' then
                if xor_counter > 0 then
                    xor_counter <= xor_counter - 1;
                else
                    xor_counter <= XOR_CYCLES;
                end if;
            end if;
            
            if subbyte_enab = '1' then
                if subbyte_counter > 0 then
                    subbyte_counter <= subbyte_counter - 1;
                else
                    subbyte_counter <= SUBBYTE_CYCLES;
                end if;
            end if;
            
            if shiftrow_enab = '1' then
                if shiftrow_counter > 0 then
                    shiftrow_counter <= shiftrow_counter - 1;
                else
                    shiftrow_counter <= SHIFTROW_CYCLES;
                end if;
            end if;
            
            if mixcol_enab = '1' then
                if mixcol_counter > 0 then
                    mixcol_counter <= mixcol_counter - 1;
                else
                    mixcol_counter <= MIXCOL_CYCLES;
                end if;
            end if;
            
            if bram_enab = '1' then
                if bram_counter > 0 then
                    bram_counter <= bram_counter - 1;
                else
                    bram_counter <= BRAM_CYCLES;
                end if;
            end if;
            
            if bram_enab1 = '1' then
                if bram_counter > 0 then
                    bram_counter <= bram_counter - 1;
                else
                    bram_counter <= BRAM_CYCLES;
                end if;
            end if;
            
            if readkey_enab = '1' then
                if rom_counter > 0 then
                    rom_counter <= rom_counter - 1;
                else
                    rom_counter <= ROM_CYCLES;
                end if;
            end if;
            
            if plaintext_enab = '1' then
                if display_counter > 0 then
                    display_counter <= display_counter - 1;
                else
                    display_counter <= DISPLAY_CYCLES;
                end if;
            end if;

        end if;
    end process;

    -- Combinational block
    process (cur_state, subbyte_done, shiftrow_done, xor_done, mixcol_done, round_count, plaintext_done, read_ram_done, read_rom_done, write_done, xor_counter, subbyte_counter,
                shiftrow_counter, mixcol_counter, display_counter, bram_counter, rom_counter)
    begin
        next_state <= cur_state;

        case cur_state is
            when xor_op =>
                if xor_done = '1' then
                    next_state <= counting;
                elsif read_rom_done = '1' then
                    tot_reg <= tot_reg xor tot_reg_key;
--                    xor_enab <= '1';
--                    if xor_counter = 0 then
                        read_rom_done <= '0';
                        xor_done <= '1';
--                        xor_enab <= '0';
--                    end if;
                else
                    next_state <= reading_key; 
                    
                end if;

            when shiftrow_op =>
                if shiftrow_done = '1' then
                    next_state <= counting;
                elsif row_index > 0 then
                    shiftrow_enab <= '1';
                    reg2(31 downto 24) <= tot_reg((32*row_index-1) downto (32*row_index-8));
                    reg2(23 downto 16) <= tot_reg((32*row_index-9) downto (32*row_index-16));
                    reg2(15 downto 8) <= tot_reg((32*row_index-17) downto (32*row_index-24));
                    reg2(7 downto 0) <= tot_reg((32*row_index-25) downto (32*row_index-32));
                    if shiftrow_counter = 0 then
                        tot_reg((32*row_index-1) downto (32*row_index-8)) <= reg41;
                        tot_reg((32*row_index-9) downto (32*row_index-16)) <= reg42;
                        tot_reg((32*row_index-17) downto (32*row_index-24)) <= reg43;
                        tot_reg((32*row_index-25) downto (32*row_index-32)) <= reg44;
--                        shiftrow_counter <= SHIFTROW_CYCLES;
--                        if row_index = 1 then 
--                            row_index <= 4;  
--                            shiftrow_done <= '1';                     
--                            shiftrow_enab <= '0';
----                            shiftrow_counter <= SHIFTROW_CYCLES;
--                        else
                        row_index <= row_index -1;   
                    end if;
                 else
                    row_index <= 4;  
                    shiftrow_done <= '1';                     
                    shiftrow_enab <= '0';               
                end if;
                 
            when mixcol_op =>
                if mixcol_done = '1' then
                    next_state <= counting;
                
                   elsif mix_col_number < 4 then
                        reg2(31 downto 24) <= tot_reg(127-8*mix_col_number downto 120-8*mix_col_number);
                        reg2(23 downto 16) <= tot_reg(95-8*mix_col_number downto 88-8*mix_col_number);
                        reg2(15 downto 8) <= tot_reg(63-8*mix_col_number downto 56-8*mix_col_number);
                        reg2(7 downto 0) <= tot_reg(31-8*mix_col_number downto 24-8*mix_col_number);
                        mixcol_enab <= '1';
                        if mixcol_counter=0 then
--                            mixcol_enab <='0';
--                            mixcol_counter <= MIXCOL_CYCLES;
                            tot_reg(127-8*mix_col_number downto 120-8*mix_col_number) <= reg441;
                            tot_reg(95-8*mix_col_number downto 88-8*mix_col_number) <= reg442;
                            tot_reg(63-8*mix_col_number downto 56-8*mix_col_number) <= reg443;
                            tot_reg(31-8*mix_col_number downto 24-8*mix_col_number) <= reg444;
                            
                            mix_col_number <= mix_col_number + 1;
                            
                        end if;
                    else
                        mix_col_number <= 0;
                        mixcol_enab <='0';
--                                mixcol_counter <= MIXCOL_CYCLES;
                        mixcol_done <= '1';
                end if;

            
            when subbyte_op =>
                if subbyte_done = '1' then
                    next_state <= counting;
                else
                     if byte_count < 16 then
                         subbyte_enab <= '1';
                         reg1 <= tot_reg((15 - byte_count) * 8 + 7 downto (15 - byte_count) * 8);
                         if subbyte_counter = 0 then
                            tot_reg((15 - byte_count) * 8 + 7 downto (15 - byte_count) * 8) <= reg51;
                            byte_count <= byte_count + 1;
--                            subbyte_counter <= SUBBYTE_CYCLES;
                         end if;
                     else
                         subbyte_done <= '1';
                         subbyte_enab <= '0';
--                         subbyte_counter <= SUBBYTE_CYCLES;
                         byte_count <= 0;
                     end if; 
                end if;
              
            when plain_text =>
                oper_type <= 2;
                if read_ram_done = '1' then
                    plaintext_enab <= '1';
                    digit1 <= tot_reg((32*row_index-1) downto (32*row_index-8));
                    digit2 <= tot_reg((32*row_index-9) downto (32*row_index-16));
                    digit3 <= tot_reg((32*row_index-17) downto (32*row_index-24));
                    digit4 <= tot_reg((32*row_index-25) downto (32*row_index-32));
                    if display_counter = 0 then
--                        display_counter <= DISPLAY_CYCLES;
                        if row_index = 1 then 
                            multiple_counter <= multiple_counter + 1;
                            read_ram_done <= '0';
                            plaintext_enab <= '0';
--                            display_counter <= DISPLAY_CYCLES;
                        else
                            row_index <= row_index -1;
                        end if;   
                    end if;
                else
                    multiple_count <= (multiple_counter mod 2);
                    oper_type <= 2;
                    row_index <= 4;
                    next_state <= reading;
                end if;
                              
            when reading =>
                if read_ram_done = '1' then
                    if oper_type = 1 then
                        next_state <= counting;
                    elsif oper_type = 2 then
                        next_state <= plain_text;
                    end if;
                elsif byte_count < 16 then
                     bram_enab1 <= '1';
                     addr_reg_ram1 <= std_logic_vector(to_unsigned(16*multiple_count + byte_count, 11));
                     if bram_counter = 0 then
                        tot_reg((15 - byte_count) * 8 + 7 downto (15 - byte_count) * 8) <= reg8;
                        byte_count <= byte_count + 1;
--                        bram_counter <= BRAM_CYCLES;
                     end if;
                else                   
                   byte_count <= 0 ;  -- Reset counter after reading all 16 bytes
                   read_ram_done <= '1';
                   bram_enab1 <= '0';
--                   bram_counter <= BRAM_CYCLES;
                end if;
                
            when reading_key =>
                if read_rom_done = '1' then
                    next_state <= xor_op;
                elsif byte_count < 16 then
                     readkey_enab <= '1';
                     addr_reg_rom <= std_logic_vector(to_unsigned(144 - 16 * round_count + byte_count, 8));
                     if rom_counter = 0 then
                        tot_reg_key((15 - byte_count) * 8 + 7 downto (15 - byte_count) * 8) <= reg7;
                        byte_count <= byte_count + 1;
--                        bram_counter <= BRAM_CYCLES;
                     end if;
                else                   
                   byte_count <= 0 ;  -- Reset counter after reading all 16 bytes
                   read_rom_done <= '1';
                   readkey_enab <= '0';
--                   bram_counter <= BRAM_CYCLES;
                end if;
                
            when writing =>
                if write_done = '1' then
                    next_state <= counting;
                elsif byte_count < 16 then
                     bram_enab1 <= '1';
                     write_enab <= "1";
                     addr_reg_ram1 <= std_logic_vector(to_unsigned(16*multiple_count + byte_count, 11));
                     reg1 <= tot_reg((15 - byte_count) * 8 + 7 downto (15 - byte_count) * 8);
                     if bram_counter = 0 then
                        byte_count <= byte_count + 1;
--                        bram_counter <= BRAM_CYCLES;
                     end if;
                else                   
                   byte_count <= 0 ;  -- Reset counter after reading all 16 bytes
                   write_done <= '1';
                   bram_enab1 <= '0';
                   write_enab <= "0";
--                   bram_counter <= BRAM_CYCLES;
                end if;
            
            when counting =>
                if round_count = 0 then
                    next_state <= reading;
                    oper_type <= 1;
                    if read_ram_done = '1' then
                        next_state <= xor_op;
                            if xor_done = '1' then
                                next_state <= shiftrow_op;
                                if shiftrow_done = '1' then
                                    next_state <= subbyte_op;
                                    if subbyte_done = '1' then
                                        round_count <= round_count + 1;
                                        xor_done <= '0';
                                        subbyte_done <= '0';
                                        shiftrow_done <= '0';
                                        mixcol_done <= '0';
                                        read_ram_done <= '0';
                                        oper_type <= 0;
                                        next_state <= counting;
                                    end if;
                                end if;
                            end if;
                        end if;
                 elsif round_count = 9 then
                    next_state <= xor_op;
                        if xor_done = '1' then
                            next_state <= writing;
                            if write_done = '1' then
                                next_state <= counting;                              
                                if multiple_count >= multiple then
                                    next_state <= plain_text;
--                                    xor_done <= '0';
--                                    write_done <= '0';
                                else
                                    round_count <= 0;
                                    multiple_count <= multiple_count + 1;
                                    xor_done <= '0';
                                    write_done <= '0';
                                end if;
                            end if;
                        end if;
                  else
                    next_state <= xor_op;
                    if xor_done = '1' then
                        next_state <= mixcol_op;
                        if mixcol_done = '1' then
                            next_state <= shiftrow_op;
                            if shiftrow_done = '1' then
                                next_state <= subbyte_op;
                                if subbyte_done = '1' then
                                    round_count <= round_count + 1;
                                    xor_done <= '0';
                                    subbyte_done <= '0';
                                    shiftrow_done <= '0';
                                    mixcol_done <= '0';
                                    next_state <= counting;
                                end if;
                            end if;
                        end if;
                    end if;     
                 end if;
            when others =>
                 next_state <= counting;           
        end case;
    end process;
end machine;

