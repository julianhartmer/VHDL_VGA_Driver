use std.textio.all;
library ieee;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_tb is
end vga_tb;

architecture behav of vga_tb is

	component vga is
		generic(
			H_RES		: integer := 640;
			LOG2_H_RES	: integer := 10;
			V_RES		: integer := 480;
			LOG2_V_RES	: integer := 9;
			PIXEL_SIZE	: integer := 3;
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
			pixel		: in std_logic_vector(PIXEL_SIZE-1 downto 0);
			pixel_read_num	: out std_logic_vector(LOG2_V_RES+LOG2_H_RES-1 downto 0);
			h_sync		: out std_logic;
			v_sync		: out std_logic;
			r_0		: out std_logic;
			g_0		: out std_logic;
			b_0		: out std_logic;
			frame_fin	: out std_logic
		);
	end component;

	component pic_gen is
		generic(
			H_RES		: integer := 640;
			V_RES		: integer := 480;
			LOG2_V_RES	: integer := 9;
			LOG2_H_RES	: integer := 10;
			PIXEL_SIZE	: integer := 3
		);
		port(	 
			--ctrl
			pixel_clk	: in std_logic;
			frame_fin	: in std_logic;	-- vram frame finished
			frame_switched	: in std_logic;	-- vram switched frames
			change_frame	: out std_logic;
			pixel		: out std_logic_vector(PIXEL_SIZE-1 downto 0);
			pixel_num	: out std_logic_vector(LOG2_H_RES+LOG2_V_RES-1 downto 0);
			we		: out std_logic
		);
	end component;

	signal pixel_clk, r_0, g_0, b_0, h_sync, v_sync, frame_fin, frame_switched, change_frame, we : std_logic := '0';
	signal pixel : std_logic_vector(3-1 downto 0);
	signal pixel_read_num : std_logic_vector(19-1 downto 0);
	signal pixel_num : std_logic_vector(19-1 downto 0);
			

	constant clk_period_half : time := 20 ns;	-- 25 Mhz

begin
	v : vga port map(
		pixel_clk	=> pixel_clk,
		pixel		=> pixel,
		pixel_read_num	=> pixel_read_num,
		h_sync		=> h_sync,
		v_sync		=> v_sync,
		r_0		=> r_0,
		g_0		=> g_0,
		b_0		=> b_0,
		frame_fin	=> frame_fin
	);
	pic : pic_gen port map(
		pixel_clk	=> pixel_clk,
		frame_fin	=> frame_fin,
		frame_switched	=> frame_switched,
		change_frame	=> change_frame,
		pixel		=> pixel,
		pixel_num	=> pixel_num,
		we		=> we
	);

	frame_switched_driver : process (pixel_clk)
	begin
		if rising_edge(pixel_clk) then
			if change_frame = '1' and frame_fin = '1' then
				frame_switched <= '1';
			else
				frame_switched <= '0';
			end if;
		end if;
	end process;

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
		wait for 16.8 ms;
		report "frame 3 printed!";
		wait for 16.8 ms;
		report "frame 4 printed!";
		wait for 16.8 ms;
		report "frame 5 printed!";
		wait for 168 ms;
		report "10 frames printed!";
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
		write(line_el, r_0); -- write the line.
		write(line_el, r_0); -- write the line.
		write(line_el, r_0); -- write the line.

		-- Write the green
		write(line_el, String'(" "));
		write(line_el, g_0); -- write the line.
		write(line_el, g_0); -- write the line.
		write(line_el, g_0); -- write the line.

		-- Write the blue
		write(line_el, String'(" "));
		write(line_el, b_0); -- write the line.
		write(line_el, b_0); -- write the line.
		write(line_el, b_0); -- write the line.

		writeline(file_pointer, line_el); -- write the contents into the file.

	    end if;
	end process;


end;
