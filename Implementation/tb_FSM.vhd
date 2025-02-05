library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_FSM is
end tb_FSM;

architecture tb of tb_FSM is
    component FSM
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            cathode_select : out STD_LOGIC_VECTOR(6 downto 0);
            anode_select : out STD_LOGIC_VECTOR(3 downto 0);
            reg : out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal cathode_select : STD_LOGIC_VECTOR(6 downto 0);
    signal anode_select : STD_LOGIC_VECTOR(3 downto 0);
    signal reg : STD_LOGIC_VECTOR(127 downto 0);

begin
    -- Instantiate the FSM component
    UUT : FSM 
        port map (
            clk => clk,
            reset => reset,
            cathode_select => cathode_select,
            anode_select => anode_select,
            reg => reg
        );

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process clk_process;

end tb;
