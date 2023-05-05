library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.common.all;
use work.wishbone_types.all;

entity core_tb is
end core_tb;

architecture behave of core_tb is
        signal clk, rst: std_logic;
	signal clk_count: integer := 0;
	signal start_count : std_ulogic := '0';
	signal stop_count : std_ulogic;
	signal final_clk_count: integer;

        -- testbench signals
        constant clk_period : time := 10 ns;
begin

    soc0: entity work.soc
        generic map(
            SIM => true,
            MEMORY_SIZE => (384*1024),
            RAM_INIT_FILE => "main_ram.bin",
            CLK_FREQ => 100000000
            )
        port map(
            rst => rst,
            system_clk => clk,
	    stop_count_out => stop_count,
	    start_count_out => start_count
            );

    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
	if (start_count = '1' or clk_count /= 0) then
	    clk_count <= clk_count + 1;
	    --report "clk_count: " & integer'image(clk_count);
	end if;
    end process;

    rst_process: process
    begin
        rst <= '1';
        wait for 10*clk_period;
        rst <= '0';
        wait;
    end process;

    stop_clk_count: process
    begin
	if (stop_count = '1') then
	   final_clk_count <= clk_count;
	   report "stop_count ticked, final_clk_count: " & integer'image(clk_count);
	   wait;
	end if;
	wait on stop_count;
    end process;

    jtag: entity work.sim_jtag;

end;
