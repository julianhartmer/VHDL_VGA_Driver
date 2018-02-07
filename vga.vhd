library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity vga is
	generic(
		H_RES		: integer := 640;
		LOG2_H_RES	: integer := 10;
		V_RES		: integer := 480;
		LOG2_V_RES	: integer := 9;
		PIXEL_SIZE	: integer := 3;
		LINE_SIZE	: integer := 640*3;
		LOG2_LINE_SIZE	: integer := 11;

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
		pixel_line	: in std_logic_vector((PIXEL_SIZE*H_RES)-1 downto 0);
		line_num	: out std_logic_vector(LOG2_V_RES-1 downto 0);
		h_sync		: out std_logic;
		v_sync		: out std_logic;
		r		: out std_logic;
		g		: out std_logic;
		b		: out std_logic
	);
end vga;

architecture behav of vga is

	component vga_controller is
		generic(
			H_RES		: integer := H_RES;
			LOG2_H_RES	: integer := LOG2_H_RES;
			V_RES		: integer := V_RES;
			LOG2_V_RES	: integer := LOG2_V_RES;

			H_FP_PIXELS	: integer := H_FP_PIXELS;
			H_SP_PIXELS	: integer := H_SP_PIXELS;
			H_BP_PIXELS	: integer := H_BP_PIXELS;
			V_FP_LINES	: integer := V_FP_LINES;
			V_SP_LINES	: integer := V_SP_LINES;
			V_BP_LINES	: integer := V_BP_LINES;


			H_SP_POL	: std_logic := H_SP_POL;
			V_SP_POL	: std_logic := V_SP_POL
		);
		port(	pixel_clk	: in std_logic;
			h_sync, v_sync	: out std_logic;
			pic_en		: out std_logic;
			pic_x		: out std_logic_vector(LOG2_H_RES-1 downto 0);
			pic_y		: out std_logic_vector(LOG2_V_RES-1 downto 0)
		);
	end component;

	component vga_pic_gen is
		generic(
			H_RES		: integer := H_RES;
			LOG2_H_RES	: integer := LOG2_H_RES;
			V_RES		: integer := V_RES;
			LOG2_V_RES	: integer := LOG2_V_RES
		);
			
		port(	pic_en	 	: in std_logic;
			pic_x		: in std_logic_vector(LOG2_H_RES-1 downto 0);
			pic_y		: in std_logic_vector(LOG2_V_RES-1 downto 0);
			r_in		: in std_logic;
			g_in		: in std_logic;
			b_in		: in std_logic;
			r, g, b		: out std_logic
		);
	end component;

	signal pic_en : std_logic := '0';
	signal pic_x : std_logic_vector(LOG2_H_RES-1 downto 0) := (others => '0');
	signal pic_y : std_logic_vector(LOG2_V_RES-1 downto 0) := (others => '0');
	signal r_in,g_in,b_in : std_logic;

	signal pixel_line_pos	: integer := 0;

begin -- behavioral
	ctrl : vga_controller port map(
		pixel_clk	=> pixel_clk,
		h_sync		=> h_sync,
		v_sync		=> v_sync,
		pic_x		=> pic_x,
		pic_y		=> pic_y,
		pic_en		=> pic_en
	);

	pic : vga_pic_gen port map(
		pic_en	 	=> pic_en,
		pic_x		=> pic_x,
		pic_y		=> pic_y,
		r_in		=> r_in,
		g_in		=> g_in,
		b_in		=> b_in,
		r		=> r,
		g		=> g,
		b		=> b
	);

	line_num <= pic_y;
	pixel_line_pos <= to_integer(unsigned(pic_x))*PIXEL_SIZE;

	r_in <= pixel_line(pixel_line_pos);
	     
	g_in <= pixel_line(pixel_line_pos+1);
	    
	b_in <= pixel_line(pixel_line_pos+2);

end behav;
