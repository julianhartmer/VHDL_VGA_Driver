library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pic_gen is 
	generic(
		H_RES		: integer := 640;
		V_RES		: integer := 480;
		LOG2_V_RES	: integer := 9;
		LOG2_H_RES	: integer := 10;
		PIXEL_SIZE	: integer := 3;
		FRAME_TIME	: integer := 1
	);
	port(	 
		--ctrl
		pixel_clk	: in std_logic;
		frame_fin	: in std_logic;	-- vram frame finished
		frame_switched	: in std_logic;	-- vram switched frames
		change_frame	: out std_logic;
		pixel		: out std_logic_vector(PIXEL_SIZE-1 downto 0);
		pixel_x		: out std_logic_vector(LOG2_H_RES-1 downto 0);
		pixel_y		: out std_logic_vector(LOG2_V_RES-1 downto 0);
		we		: out std_logic
	);
end pic_gen;
architecture behav of pic_gen is
	signal counter : std_logic_vector (LOG2_V_RES+LOG2_H_RES-1 downto 0) := (others => '0');
	signal x_counter : unsigned (LOG2_H_RES-1 downto 0) := (others => '0');
	signal y_counter : unsigned (LOG2_V_RES-1 downto 0) := (others => '0');
	signal pix_out : std_logic_vector(PIXEL_SIZE-1 downto 0) := (others => '0');
begin

	counter_driver: process(pixel_clk)
	begin
		if rising_edge(pixel_clk) then
			if x_counter = H_RES then
				x_counter <= (others => '0');
				if y_counter = V_RES then
					y_counter <= (others => '0');
				else 
					y_counter <= y_counter + 1;
				end if;
			else
				x_counter <= x_counter+1;
			end if;
		end if;
	end process;

	frame_counter_driver: process(pixel_clk)
		variable frame_counter : integer range FRAME_TIME downto 0 := FRAME_TIME;
	begin
		if rising_edge(pixel_clk) then
			if frame_counter = 0 then
				if frame_switched = '1' then
					pix_out <= std_logic_vector(unsigned(pix_out) + to_unsigned(1, pix_out'length));

					frame_counter := FRAME_TIME;
					change_frame <= '0';
				else
					change_frame <= '1';
				end if;
			elsif frame_fin = '1' then
				frame_counter := frame_counter - 1;
				if frame_counter = FRAME_TIME then
					frame_counter := FRAME_TIME;
					change_frame <= '1';
				end if;
			end if;
		end if;
	end process;

	pixel <= pix_out;
	pixel_x <= std_logic_vector(x_counter);
	pixel_y <= std_logic_vector(y_counter);
	we <= '1';
end behav;
