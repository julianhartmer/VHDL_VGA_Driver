use std.textio.all;
library ieee;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;


entity vga_controller_tb is
end vga_controller_tb;

architecture behav of vga_controller_tb is

	component vga_controller is
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
		port(	reset, pixel_clk: in std_logic;
			h_sync, v_sync	: out std_logic;
			pic_en		: out std_logic;
			pic_x		: out std_logic_vector(LOG2_H_RES-1 downto 0);
			pic_y		: out std_logic_vector(LOG2_V_RES-1 downto 0)
		);
	end component;
	constant H_RES		: integer := 640;
	constant LOG2_H_RES	: integer := 10;
	constant V_RES		: integer := 480;
	constant LOG2_V_RES	: integer := 9;

	signal reset, pixel_clk, h_sync, v_sync, pic_en : std_logic;
	signal pic_x : std_logic_vector(LOG2_H_RES-1 downto 0);
	signal pic_y : std_logic_vector(LOG2_V_RES-1 downto 0);
	signal r,g,b : std_logic;
	signal r_out,g_out,b_out : std_logic;

	constant clk_period_half : time := 20 ns;	-- 25 Mhz

begin
	y : vga_controller port map(
		reset		=> reset,
		pixel_clk	=> pixel_clk,
		h_sync		=> h_sync,
		v_sync		=> v_sync,
		pic_x		=> pic_x,
		pic_y		=> pic_y,
		pic_en		=> pic_en
	);

	CLK_process :process
	begin
		pixel_clk <= '0';
			wait for clk_period_half;
		pixel_clk <= '1';
			wait for clk_period_half;
	end process;

	r <= pic_y(LOG2_V_RES - 2) when pic_en = '1' else '0';
	     
	g <= pic_y(LOG2_V_RES - 2) when pic_en = '1' else '0';
	    
	b <= pic_y(LOG2_V_RES - 2) when pic_en = '1' else '0';

	change_colors: process
	begin
		reset <= '0';
		report "starting simulation";
		--r <= '0';
		--g <= '0';
		--b <= '0';
		wait for 1.1 ms;

		wait for 1.9 ms;
		--r <= '0';
		--g <= '0';
		--b <= '1';
		wait for 1.9 ms;
		--r <= '0';
		--g <= '1';
		--b <= '0';
		wait for 1.9 ms;
		--r <= '0';
		--g <= '1';
		--b <= '1';
		wait for 1.9 ms;
		--r <= '1';
		--g <= '0';
		--b <= '0';
		wait for 1.9 ms;
		--r <= '1';
		--g <= '0';
		--b <= '1';
		wait for 1.9 ms;
		--r <= '1';
		--g <= '1';
		--b <= '0';
		wait for 1.9 ms;
		--r <= '1';
		--g <= '1';
		--b <= '1';
		wait for 1.9 ms;
		wait for 1.4 ms;

		--r <= '0';
		--g <= '0';
		--b <= '1';
		wait for 16.65 ms;
		report "first frame printed!";
		assert false report "simulation ended" severity failure;

	end process;
	r_out <= r when pic_en = '1' else '0';
	g_out <= g when pic_en = '1' else '0';
	b_out <= b when pic_en = '1' else '0';

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
		write(line_el, r_out); -- write the line.
		write(line_el, r_out); -- write the line.
		write(line_el, r_out); -- write the line.

		-- Write the green
		write(line_el, String'(" "));
		write(line_el, g_out); -- write the line.
		write(line_el, g_out); -- write the line.
		write(line_el, g_out); -- write the line.

		-- Write the blue
		write(line_el, String'(" "));
		write(line_el, b_out); -- write the line.
		write(line_el, b_out); -- write the line.
		write(line_el, b_out); -- write the line.

		writeline(file_pointer, line_el); -- write the contents into the file.

	    end if;
	end process;
end;
