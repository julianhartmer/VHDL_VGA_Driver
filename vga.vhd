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
		pixel_read_x	: out std_logic_vector(LOG2_H_RES-1 downto 0);
		pixel_read_y	: out std_logic_vector(LOG2_V_RES-1 downto 0);
		frame_fin	: out std_logic;

		h_sync		: out std_logic;
		v_sync		: out std_logic;
		r_0		: out std_logic;
		g_0		: out std_logic;
		b_0		: out std_logic

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
			next_pix_y_pos	: out std_logic_vector(LOG2_V_RES-1 downto 0);
			next_pix_x_pos	: out std_logic_vector(LOG2_H_RES-1 downto 0);
			frame_fin	: out std_logic
		);
	end component;

	signal pic_en : std_logic := '0';
	signal pic_x : std_logic_vector(LOG2_H_RES-1 downto 0) := (others => '0');
	signal pic_y : std_logic_vector(LOG2_V_RES-1 downto 0) := (others => '0');

begin -- behavioral
	ctrl : vga_controller port map(
		pixel_clk	=> pixel_clk,
		h_sync		=> h_sync,
		v_sync		=> v_sync,
		next_pix_y_pos	=> pixel_read_y,
		next_pix_x_pos	=> pixel_read_x,
		pic_en		=> pic_en,
		frame_fin	=> frame_fin
	);

	r_0 <= pixel(0) when pic_en='1' else '0';
	g_0 <= pixel(1) when pic_en='1' else '0';
	b_0 <= pixel(2) when pic_en='1' else '0';

end behav;
