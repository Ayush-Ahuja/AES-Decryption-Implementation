library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_display is
end tb_top_display;

architecture sim of tb_top_display is
    -- Component declaration for the top-level display entity
    component top_display
        Port (
            clk_in : in std_logic;
            cathode_selection : out std_logic_vector (6 downto 0);
            anode_selection : out std_logic_vector (3 downto 0)
        );
    end component;

    -- Testbench signals
    signal clk_in : std_logic := '0';
    signal cathode_selection : std_logic_vector(6 downto 0);
    signal anode_selection : std_logic_vector(3 downto 0);

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz clock period

begin
    -- Instantiate the top_display component
    UUT : top_display
        port map (
            clk_in => clk_in,
            cathode_selection => cathode_selection,
            anode_selection => anode_selection
        );

    -- Generate a 100 MHz clock signal
    clk_process : process
    begin
        clk_in <= '0';
        wait for CLK_PERIOD / 2;
        clk_in <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Simulation process to observe outputs
    stimulus_process : process
    begin
        -- Run the simulation for a duration of 16 seconds to cover 4 full cycles of display
        wait for 16 sec;
        -- End the simulation
        assert false report "Simulation complete" severity note;
        wait;
    end process;

end sim;