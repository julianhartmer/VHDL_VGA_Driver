use std.textio.all;
library ieee;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;


entity vga_tb is
end vga_tb;

architecture behav of vga_tb is

	component vga is
		generic(
			H_RES		: integer := 640;
			LOG2_H_RES	: integer := 10;
			V_RES		: integer := 480;
			LOG2_V_RES	: integer := 9;

			H_FP_PIXELS	: integer := 16;
			H_SP_PIXELS	: integer := 96;
			H_BP_PIXELS	: integer := 48;
			V_FP_LINES	: integer := 10;
			V_SP_LINES	: integer := 2;
			V_BP_LINES	: integer := 33;

			H_SP_POL	: std_logic := '0';
			V_SP_POL	: std_logic := '0'
		);
		port(
			pixel_clk	: in std_logic;
			reset		: in std_logic;
			h_sync		: out std_logic;
			v_sync		: out std_logic;
			r		: out std_logic;
			g		: out std_logic;
			b		: out std_logic
		);
	end component;

	signal reset, pixel_clk, r, g, b, h_sync, v_sync : std_logic;

	constant clk_period_half : time := 20 ns;	-- 25 Mhz

begin
	v : vga port map(
		pixel_clk	=> pixel_clk,
		reset		=> reset,
		h_sync		=> h_sync,
		v_sync		=> v_sync,
		r		=> r,
		g		=> g,
		b		=> b
	);

	CLK_process :process
	begin
		pixel_clk <= '0';
			wait for clk_period_half;
		pixel_clk <= '1';
			wait for clk_period_half;
	end process;

	change_colors: process
	begin
		report "Starting Simulation";
		report "frame 1 starting!";
		wait for 16.8 ms;
		report "frame 1 printed!";
		wait for 16.8 ms;
		report "frame 2 printed!";
		assert false report "simulation ended" severity failure;
		wait for 16.8 ms;
		report "frame 3 printed!";
		wait for 16.8 ms;
		report "frame 4 printed!";
		wait for 16.8 ms;
		report "frame 5 printed!";
		assert false report "simulation ended" severity failure;
		
	end process;


	process (pixel_clk)
	    file file_pointer: text is out "write.txt";
	    variable line_el: line;
	begin

	    if rising_edge(pixel_clk) then

		-- Write the time
		write(line_el, now); -- write the line.
		write(line_el, String'(":")); -- write the line.

		-- Write the hsync
		write(line_el, String'(" "));
		write(line_el, h_sync); -- write the line.

		-- Write the vsync
		write(line_el, String'(" "));
		write(line_el, v_sync); -- write the line.

		-- Write the red
		write(line_el, String'(" "));
		write(line_el, r); -- write the line.
		write(line_el, r); -- write the line.
		write(line_el, r); -- write the line.

		-- Write the green
		write(line_el, String'(" "));
		write(line_el, g); -- write the line.
		write(line_el, g); -- write the line.
		write(line_el, g); -- write the line.

		-- Write the blue
		write(line_el, String'(" "));
		write(line_el, b); -- write the line.
		write(line_el, b); -- write the line.
		write(line_el, b); -- write the line.

		writeline(file_pointer, line_el); -- write the contents into the file.

	    end if;
	end process;


end;
