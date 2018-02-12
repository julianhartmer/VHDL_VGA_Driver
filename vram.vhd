library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vram is 
	generic(
		H_RES		: integer := 640;
		V_RES		: integer := 480;
		LOG2_V_RES	: integer := 9;
		LOG2_H_RES	: integer := 10;
		PIXEL_SIZE	: integer := 3
	);
	port(	 
		--ctrl in
		clk		: in std_logic;
		change_frame	: in std_logic;		-- write wants frame switched
		frame_fin	: in std_logic;		-- read finished frame
		frame_switched	: out std_logic;	-- vram switched frames

		-- read port
		pix_out		: out std_logic_vector(PIXEL_SIZE-1 downto 0);
		pix_y_out	: in std_logic_vector(LOG2_V_RES-1 downto 0);
		pix_x_out	: in std_logic_vector(LOG2_H_RES-1 downto 0);

		-- write ports
		we		: in std_logic;
		pix_y_in	: in std_logic_vector(LOG2_V_RES-1 downto 0);
		pix_x_in	: in std_logic_vector(LOG2_H_RES-1 downto 0);
		pix_in		: in std_logic_vector(PIXEL_SIZE-1 downto 0)
	);
end vram;
architecture behav of vram is
	constant RES : integer := H_RES * V_RES;
	type frame is array ((V_RES*H_RES)-1 downto 0) of std_logic_vector((PIXEL_SIZE)-1 downto 0);
	signal current_write_frame : std_logic := '0';
	signal frame_0 		: frame := (others => (others => '0'));
	signal frame_0_we 	: std_logic := '0';
	signal frame_0_out 	: std_logic_vector(PIXEL_SIZE-1 downto 0);
	signal frame_1		: frame := (others => (others => '0'));
	signal frame_1_we	: std_logic := '0';
	signal frame_1_out	: std_logic_vector(PIXEL_SIZE-1 downto 0);
	signal pix_num_in, pix_num_out : std_logic_vector(LOG2_V_RES+LOG2_H_RES-1 downto 0) := (others => '0');

	-- use bram
	attribute ram_style : string;
	attribute ram_style of frame_0 : signal is "block";
	attribute ram_style of frame_1 : signal is "block";
begin
	pix_num_in <= std_logic_vector(to_unsigned(to_integer(unsigned(pix_y_in))*H_RES+to_integer(unsigned(pix_x_in)), pix_num_in'length));
	pix_num_out <= std_logic_vector(to_unsigned(to_integer(unsigned(pix_y_out))*H_RES+to_integer(unsigned(pix_x_out)), pix_num_in'length));
	frame_switched_driver : process (clk)
	begin
		if rising_edge(clk) then
			if change_frame = '1' and frame_fin = '1' then
				frame_switched <= '1';
				current_write_frame <= not current_write_frame;
			else
				frame_switched <= '0';
			end if;
		end if;
	end process;

	frame_0_driver : process (clk)
	begin
		if rising_edge(clk) then
			if frame_0_we = '1' then
				frame_0(to_integer(unsigned(pix_num_in))) <= pix_in;
			end if;
			frame_0_out <= frame_0(to_integer(unsigned(pix_num_out)));
		end if;
	end process;

	frame_1_driver: process (clk)
	begin
		if rising_edge(clk) then
			if frame_1_we = '1' then
				frame_1(to_integer(unsigned(pix_num_in))) <= pix_in;
			end if;
			frame_1_out <= frame_1(to_integer(unsigned(pix_num_out)));
		end if;
	end process;

	frame_0_we <= we when current_write_frame = '0' else
		      '0';
	frame_1_we <= we when current_write_frame = '1' else
		      '0';
	pix_out <= frame_0_out when current_write_frame = '1' else
		   frame_1_out;
end behav;
