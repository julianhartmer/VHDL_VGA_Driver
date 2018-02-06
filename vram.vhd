library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vram is 
	generic(
		H_RES		: integer := 640;
		V_RES		: integer := 480;
		LOG2_V_RES	: integer := 9;
		PIXEL_SIZE	: integer := 3;
		LINE_SIZE	: integer := 640*3
	);
	port(	 
		--ctrl
		clk		: in std_logic;

		-- read port
		line_num_out	: in std_logic_vector(LOG2_V_RES-1 downto 0);
		line_out	: out std_logic_vector(LINE_SIZE-1 downto 0);

		-- write ports
		we		: in std_logic;
		line_num_in	: in std_logic_vector(LOG2_V_RES-1 downto 0);
		line_in		: in std_logic_vector(LINE_SIZE-1 downto 0); 
		line_write_limit: out std_logic_vector(LOG2_V_RES-1 downto 0)
	);
end vram;
architecture behav of vram is
	constant RES : integer := H_RES * V_RES;
	type vram is array ((V_RES)-1 downto 0) of std_logic_vector((H_RES*PIXEL_SIZE)-1 downto 0);
	--signal vram0 : bram := (others => ("101"));
	signal frame : vram := (others => (others => '0'));
begin
	line_write_limit <= line_num_out;
	process(clk)
	begin
		if rising_edge(clk) then
			if we = '1' and to_integer(unsigned(line_in)) <= to_integer(unsigned(line_num_out)) then
				frame(to_integer(unsigned(line_num_in))) <= line_in;
			end if;
			line_out <= frame(to_integer(unsigned(line_num_out)));
		end if;
	end process;
end behav;
