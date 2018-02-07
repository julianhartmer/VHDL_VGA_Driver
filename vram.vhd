library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vram is 
	generic(
		H_RES		: integer := 640;
		V_RES		: integer := 480;
		LOG2_V_RES	: integer := 9;
		LOG2_H_RES	: integer := 10;
		PIXEL_SIZE	: integer := 8
	);
	port(	 
		--ctrl in
		clk		: in std_logic;
		change_frame	: in std_logic;		-- write wants frame switched
		frame_fin	: in std_logic;		-- read finished frame
		frame_switched	: out std_logic;	-- vram switched frames

		-- read port
		pix_num_out	: in std_logic_vector(LOG2_V_RES+LOG2_H_RES-1 downto 0);
		pix_out		: out std_logic_vector(PIXEL_SIZE-1 downto 0);

		-- write ports
		we		: in std_logic;
		pix_num_in	: in std_logic_vector(LOG2_V_RES+LOG2_H_RES-1 downto 0);
		pix_in		: in std_logic_vector(PIXEL_SIZE-1 downto 0)
	);
end vram;
architecture behav of vram is
	constant RES : integer := H_RES * V_RES;
	type frame is array ((V_RES*V_RES)-1 downto 0) of std_logic_vector((PIXEL_SIZE)-1 downto 0);
	--signal vram0 : bram := (others => ("101"));
	type vram is array (1 downto 0) of frame;
	signal frames : vram := (0 => (others => (others => '0')),
				 1 => (others => (others => '1'))
				 );
	signal current_write_frame : integer range 1 downto 0 := 0;
	signal current_read_frame : integer range 1 downto 0:= 1;
begin
	current_read_frame <= 0 when current_write_frame = 1 else
			      1;
	process(clk)
	begin
		if rising_edge(clk) then
			if change_frame = '1' and frame_fin = '1' then
				current_write_frame <= current_read_frame;
				frame_switched <= '1';
			else
				if we = '1' then
					frames(current_write_frame)(to_integer(unsigned(pix_num_in))) <= pix_in;
				end if;
				pix_out <= frames(current_read_frame)(to_integer(unsigned(pix_num_out)));
			end if;
		end if;
	end process;
end behav;
