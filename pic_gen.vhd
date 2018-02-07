library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pic_gen is 
	generic(
		H_RES		: integer := 640;
		V_RES		: integer := 480;
		LOG2_V_RES	: integer := 9;
		LOG2_H_RES	: integer := 10;
		PIXEL_SIZE	: integer := 8
	);
	port(	 
		--ctrl
		frame_fin	: in std_logic;	-- vram frame finished
		frame_switched	: in std_logic;	-- vram switched frames
		change_frame	: out std_logic;
		pixel		: out std_logic_vector(PIXEL_SIZE-1 downto 0);
		pixel_num	: out std_logic_vector(LOG2_H_RES+LOG2_V_RES-1 downto 0);
		we		: out std_logic
	);
end pic_gen;
architecture behav of pic_gen is
	signal counter : integer range H_RES*V_RES-1 downto 0 := 0;
begin
	process(frame_fin)
		variable frame_counter : integer := 59;
	begin
		if rising_edge(frame_fin) then
			change_frame <= '0';
			counter <= counter-1;
			if counter = 0 then
				change_frame <= '1';
				if frame_switched = '1' then
					change_frame <= '0';
					counter <= 59;
				end if;
			end if;
		end if;
	end process;

	pixel <= std_logic_vector(to_unsigned(counter, pixel'length));
	pixel_num <= std_logic_vector(to_unsigned(counter, pixel_num'length));
	we <= '1';
end behav;
