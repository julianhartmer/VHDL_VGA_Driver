use std.textio.all;
library ieee;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;


entity vga_tb is
end vga_tb;

architecture behav of vga_tb is

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
	component vga_pic_gen is
		generic(
			H_RES		: integer := 640;
			LOG2_H_RES	: integer := 10;
			V_RES		: integer := 480;
			LOG2_V_RES	: integer := 9
		);
			
		port(	pic_en	 	: in std_logic;
			pic_x		: in std_logic_vector(LOG2_H_RES-1 downto 0);
			pic_y		: in std_logic_vector(LOG2_V_RES-1 downto 0);
			r_in		: in std_logic_vector((H_RES*V_RES)-1 downto 0);
			g_in		: in std_logic_vector((H_RES*V_RES)-1 downto 0);
			b_in		: in std_logic_vector((H_RES*V_RES)-1 downto 0);
			r, g, b		: out std_logic
		);
	end component;
	constant H_RES		: integer := 640;
	constant LOG2_H_RES	: integer := 10;
	constant V_RES		: integer := 480;
	constant LOG2_V_RES	: integer := 9;

	signal reset, pixel_clk, h_sync, v_sync, pic_en, r, g, b : std_logic;
	signal pic_x : std_logic_vector(LOG2_H_RES-1 downto 0);
	signal pic_y : std_logic_vector(LOG2_V_RES-1 downto 0);
	signal r_in, g_in, b_in : std_logic_vector((H_RES*V_RES)-1 downto 0);

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
	x : vga_pic_gen port map(
		pic_en	=> pic_en,
		pic_x	=> pic_x,
		pic_y	=> pic_y,
		r_in	=> r_in,
		g_in	=> g_in,
		b_in	=> b_in,
		r	=> r,
		g	=> g,
		b	=> b
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
		reset <= '0';
		wait for 1.1 ms;
		report "Printing first frame";
		r_in <= (others => '0');
		g_in <= (others => '0');
		b_in <= (others => '0');
		wait for 16.65 ms;
		report "First Frame printed!";
		assert false report "simulation ended" severity failure;

		r_in <= (others => '0');
		g_in <= (others => '0');
		b_in <= (others => '1');
		wait for 16.65 ms;

		r_in <= (others => '0');
		g_in <= (others => '1');
		b_in <= (others => '0');
		wait for 16.65 ms;

		r_in <= (others => '0');
		g_in <= (others => '1');
		b_in <= (others => '1');
		wait for 16.65 ms;

		r_in <= (others => '1');
		g_in <= (others => '0');
		b_in <= (others => '0');
		wait for 16.65 ms;

		r_in <= (others => '1');
		g_in <= (others => '0');
		b_in <= (others => '1');
		wait for 16.65 ms;

		r_in <= (others => '1');
		g_in <= (others => '1');
		b_in <= (others => '0');
		wait for 16.65 ms;

		r_in <= (others => '1');
		g_in <= (others => '1');
		b_in <= (others => '1');
		wait for 16.65 ms;
		assert false report "simulation ended" severity failure;
		
	end process;



--	process (pixel_clk)
--	    file file_pointer: text is out "write.txt";
--	    variable line_el: line;
--	begin
--
--	    if rising_edge(pixel_clk) then
--
--		-- Write the time
--		write(line_el, now); -- write the line.
--		write(line_el, String'(":")); -- write the line.
--
--		-- Write the hsync
--		write(line_el, String'(" "));
--		write(line_el, h_sync); -- write the line.
--
--		-- Write the vsync
--		write(line_el, String'(" "));
--		write(line_el, v_sync); -- write the line.
--
--		-- Write the red
--		write(line_el, String'(" "));
--		write(line_el, r); -- write the line.
--		write(line_el, r); -- write the line.
--		write(line_el, r); -- write the line.
--
--		-- Write the green
--		write(line_el, String'(" "));
--		write(line_el, g); -- write the line.
--		write(line_el, g); -- write the line.
--		write(line_el, g); -- write the line.
--
--		-- Write the blue
--		write(line_el, String'(" "));
--		write(line_el, b); -- write the line.
--		write(line_el, b); -- write the line.
--		write(line_el, b); -- write the line.
--
--		writeline(file_pointer, line_el); -- write the contents into the file.
--
--	    end if;
--	end process;
end;
