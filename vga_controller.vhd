library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller is
	-- CLK must be 25,175 MHz
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
	port(	pixel_clk	: in std_logic;
		h_sync, v_sync	: out std_logic;
		pic_en		: out std_logic;
		pic_x		: out std_logic_vector(LOG2_H_RES-1 downto 0);
		pic_y		: out std_logic_vector(LOG2_V_RES-1 downto 0)
	);
end vga_controller;
architecture behav of vga_controller is
	constant H_PIXEL_AMOUNT : integer := H_RES + H_FP_PIXELS + H_SP_PIXELS + H_BP_PIXELS;
	constant V_LINES_AMOUNT : integer := V_RES + V_FP_LINES + V_SP_LINES + V_BP_LINES;


	constant H_DIS_START : integer := 0;
	constant H_FP_START : integer := H_DIS_START + H_RES;
	constant H_SP_START : integer := H_FP_START + H_FP_PIXELS;
	constant H_BP_START : integer := H_SP_START + H_SP_PIXELS;

	constant V_PIC_START : integer := 0;
	constant V_FP_START : integer := V_PIC_START + V_RES;
	constant v_SP_START : integer := V_FP_START + V_FP_LINES;
	constant v_BP_START : integer := V_SP_START + V_SP_LINES;

	signal h_counter : integer := 0;
	signal v_counter : integer := 0;
	signal	pic_x_reg : std_logic_vector(LOG2_H_RES-1 downto 0) := (others => '0');
	signal 	pic_y_reg : std_logic_vector(LOG2_V_RES-1 downto 0) := (others => '0');

begin -- behavioral
	pic_x <= pic_x_reg;
	pic_y <= pic_y_reg;

	counters: process (pixel_clk)
	begin
		if rising_edge(pixel_clk) then
			h_counter <= h_counter + 1;
			if h_counter >= H_PIXEL_AMOUNT - 1 then
				v_counter <= v_counter + 1;
				h_counter <= 0;
				if v_counter >= V_LINES_AMOUNT + 1 then
					v_counter <= 0;
				end if;
			end if;
		end if;
	end process;

	h_sync_d: process (pixel_clk)
	begin
		if rising_edge(pixel_clk) then
			h_sync <= not H_SP_POL;
			if (h_counter >= H_SP_START) and (h_counter < H_BP_START) then
				h_sync <= H_SP_POL;
			end if;
		end if;
	end process;

	v_sync_d: process (pixel_clk)
	begin
		if rising_edge(pixel_clk) then
			v_sync <= not V_SP_POL;
			if (v_counter >= V_SP_START) and (v_counter < V_BP_START) then
				v_sync <= V_SP_POL;
			end if;
		end if;
	end process;

	pic_gen_d: process (pixel_clk)
	begin
		if rising_edge(pixel_clk) then
			pic_y_reg <= (others => '0');
			pic_x_reg <= (others => '0');
			pic_en <= '0';
			if (h_counter >= H_DIS_START) and (h_counter < H_FP_START) and (v_counter < V_FP_START) then
				pic_y_reg <= std_logic_vector(to_unsigned(v_counter, pic_y'length));
				pic_x_reg <= std_logic_vector(to_unsigned(h_counter, pic_x'length));
				pic_en <= '1';
			end if;
		end if;
	end process;

end behav;
