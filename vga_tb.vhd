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
			PIXEL_SIZE	: integer := 8;
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
			r_1		: out std_logic;
			r_2		: out std_logic;
			g_0		: out std_logic;
			g_1		: out std_logic;
			g_2		: out std_logic;
			b_0		: out std_logic;
			b_1		: out std_logic
		);
	end component;

	signal pixel_clk, r_0, r_1, r_2, g_0, g_1, g_2, b_0, b_1, h_sync, v_sync : std_logic;
	signal pixel : std_logic_vector(8-1 downto 0);
	signal pixel_read_num : std_logic_vector(19-1 downto 0);
			

	constant clk_period_half : time := 20 ns;	-- 25 Mhz

begin
	v : vga port map(
		pixel_clk	=> pixel_clk,
		pixel		=> pixel,
		pixel_read_num	=> pixel_read_num,
		h_sync		=> h_sync,
		v_sync		=> v_sync,
		r_0		=> r_0,
		r_1		=> r_1,
		r_2		=> r_2,
		g_0		=> g_0,
		g_1		=> g_1,
		g_2		=> g_2,
		b_0		=> b_0,
		b_1		=> b_1
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
		wait for 0.8 ms;
		report "frame 1 :0.8!";
		wait for 1.0 ms;
		report "frame 1 :1.8!";
		wait for 1.0 ms;
		report "frame 1 :2.8!";
		wait for 1.0 ms;
		report "frame 1 :3.8!";
		wait for 1.0 ms;
		report "frame 1 :4.8!";
		wait for 1.0 ms;
		report "frame 1 :5.8!";
		wait for 1.0 ms;
		report "frame 1 :6.8!";
		wait for 1.0 ms;
		report "frame 1 :7.8!";
		wait for 1.0 ms;
		report "frame 1 :8.8!";
		wait for 1.0 ms;
		report "frame 1 :9.8!";
		wait for 1.0 ms;
		report "frame 1 :10.8!";
		wait for 1.0 ms;
		report "frame 1 :11.8!";
		wait for 1.0 ms;
		report "frame 1 :12.8!";
		wait for 1.0 ms;
		report "frame 1 :13.8!";
		wait for 1.0 ms;
		report "frame 1 :14.8!";
		wait for 1.0 ms;
		report "frame 1 :15.8!";
		wait for 1.0 ms;
		report "frame 1 :16.8!";
		report "frame 1 printed!";
		wait for 16.8 ms;
		report "frame 2 printed!";
		wait for 16.8 ms;
		report "frame 3 printed!";
		wait for 16.8 ms;
		report "frame 4 printed!";
		wait for 16.8 ms;
		report "frame 5 printed!";
		assert false report "simulation ended" severity failure;
		
	end process;


	pixel <= pixel_read_num(pixel'length-1+10 downto 10);
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
		write(line_el, r_1); -- write the line.
		write(line_el, r_2); -- write the line.

		-- Write the green
		write(line_el, String'(" "));
		write(line_el, g_0); -- write the line.
		write(line_el, g_1); -- write the line.
		write(line_el, g_2); -- write the line.

		-- Write the blue
		write(line_el, String'(" "));
		write(line_el, b_0); -- write the line.
		write(line_el, b_1); -- write the line.
		write(line_el, b_1); -- write the line.

		writeline(file_pointer, line_el); -- write the contents into the file.

	    end if;
	end process;


end;
