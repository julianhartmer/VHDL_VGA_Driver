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
	port(	reset, pixel_clk: in std_logic;
		h_sync, v_sync	: out std_logic;
		pic_en		: out std_logic;
		pic_x		: out std_logic_vector(LOG2_H_RES-1 downto 0);
		pic_y		: out std_logic_vector(LOG2_V_RES-1 downto 0)
	);
end vga_controller;
architecture behav of vga_controller is
	constant H_PIXEL_AMOUNT : integer := H_RES + H_FP_PIXELS + H_SP_PIXELS + H_BP_PIXELS;

	constant V_PIC_PIXELS	: integer := V_RES*H_PIXEL_AMOUNT;
	constant V_FP_PIXELS	: integer := V_FP_LINES*H_PIXEL_AMOUNT;
	constant V_SP_PIXELS	: integer := V_SP_LINES*H_PIXEL_AMOUNT;
	constant V_BP_PIXELS	: integer := V_BP_LINES*H_PIXEL_AMOUNT;

	type state_type is (H_DIS, H_FP, H_SP, H_BP, V_FP, V_SP, V_BP, OFF);

	signal state : state_type := V_FP;

	signal h_counter : integer := 0;
	signal v_counter : integer := 0;

begin -- behavioral
	process (pixel_clk, reset) 
	begin
		if (rising_edge(pixel_clk)) then
			if (reset = '1') then
				pic_en <= '0';
				pic_y <= (others => '0');
				pic_x <= (others => '0');
				h_sync <= not H_SP_POL;
				v_sync <= not V_SP_POL;
				state <= H_DIS;
				h_counter <= 0;
				v_counter <= 0;
			else
				case state is

				when H_DIS =>
					h_counter <= h_counter+1;

					pic_en <= '1';
					pic_y <= std_logic_vector(to_unsigned(v_counter, pic_y'length));
					pic_x <= std_logic_vector(to_unsigned(h_counter, pic_x'length));

					h_sync <= not H_SP_POL;
					v_sync <= not V_SP_POL;
					if h_counter >= H_RES-1 then
						state <= H_FP;
						h_counter <= 0;
					end if;
				when H_FP =>
					h_counter <= h_counter+1;

					pic_en <= '0';
					pic_y <= (others => '0');
					pic_x <= (others => '0');

					h_sync <= not H_SP_POL;
					v_sync <= not V_SP_POL;
					if h_counter >= H_FP_PIXELS-1 then
						state <= H_SP;
						h_counter <= 0;
					end if;
				when H_SP =>
					h_counter <= h_counter+1;

					pic_en <= '0';
					pic_y <= (others => '0');
					pic_x <= (others => '0');

					h_sync <= H_SP_POL;
					v_sync <= not V_SP_POL;
					if h_counter >= H_SP_PIXELS-1 then
						state <= H_BP;
						h_counter <= 0;
					end if;
				when H_BP =>
					h_counter <= h_counter+1;

					pic_en <= '0';
					pic_y <= (others => '0');
					pic_x <= (others => '0');

					h_sync <= not H_SP_POL;
					v_sync <= not V_SP_POL;

					if h_counter >= H_BP_PIXELS-1 then
						state <= H_DIS;
						h_counter <= 0;
						v_counter <= v_counter+1;
						if v_counter >= V_RES-1 then
							state <= V_FP;
							v_counter <= 0;
						end if;
					end if;
				when V_FP =>
					h_counter <= h_counter + 1;

					pic_en <= '0';
					pic_y <= (others => '0');
					pic_x <= (others => '0');
					
					h_sync <= not H_SP_POL;
					v_sync <= not V_SP_POL;

					if h_counter >= H_PIXEL_AMOUNT then
						v_counter <= v_counter + 1;
						h_counter <= 0;
						if v_counter >= V_FP_LINES-1 then
							state <= V_SP;
							v_counter <= 0;
							h_counter <= 0;
						end if;
					end if;
				when V_SP =>
					h_counter <= h_counter + 1;

					pic_en <= '0';
					pic_y <= (others => '0');
					pic_x <= (others => '0');

					h_sync <= not H_SP_POL;
					v_sync <= V_SP_POL;

					if h_counter >= H_PIXEL_AMOUNT then
						v_counter <= v_counter + 1;
						h_counter <= 0;
						if v_counter >= V_SP_LINES-1 then
							state <= V_BP;
							v_counter <= 0;
							h_counter <= 0;
						end if;
					end if;
				when V_BP =>
					h_counter <= h_counter + 1;

					pic_en <= '0';
					pic_y <= (others => '0');
					pic_x <= (others => '0');

					h_sync <= not H_SP_POL;
					v_sync <= not V_SP_POL;

					if h_counter >= H_PIXEL_AMOUNT then
						v_counter <= v_counter + 1;
						h_counter <= 0;
						if v_counter >= V_BP_LINES-1 then
							state <= H_DIS;
							v_counter <= 0;
							h_counter <= 0;
						end if;
					end if;
				when OFF =>
					v_counter <= 0;
					h_counter <= 0;

					pic_en <= '0';
					pic_y <= (others => '0');
					pic_x <= (others => '0');

					h_sync <= not H_SP_POL;
					v_sync <= not V_SP_POL;

					state <= H_DIS;
				end case;
			end if;
		end if;
	end process;

end behav;
