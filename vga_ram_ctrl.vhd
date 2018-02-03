library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_ram_ctrl is 
	generic(
		BLOCKSIZE	: integer := 3;
		BLOCKAMOUNT	: integer := 640;
		LOG2_BLOCKAMOUNT: integer := 10
	);
	port(	 
		clk		: in std_logic;
		buf_num		: in std_logic;

		addr_out 	: in std_logic_vector(LOG2_BLOCKAMOUNT-1 downto 0);
		pixel_out	: out std_logic_vector(BLOCKSIZE-1 downto 0);

		we		: in std_logic;
		addr_in		: in std_logic_vector(LOG2_BLOCKAMOUNT-1 downto 0);
		pixel_in	: in std_logic_vector(BLOCKSIZE-1 downto 0)
	);
end vga_ram_ctrl;
architecture behav of vga_ram_ctrl is
	type bram is array (BLOCKAMOUNT-1 downto 0) of std_logic_vector(BLOCKSIZE-1 downto 0);
	--signal vram0 : bram := (others => ("101"));
	signal vram0 : bram := (79 downto 0 => ("000"),
				159 downto 80 => ("001"),
				239 downto 160 => ("010"),
				319 downto 240 => ("011"),
				399 downto 320 => ("100"),
				479 downto 400 => ("101"),
				559 downto 480 => ("110"),
				639 downto 560 => ("111"));
	signal vram1 : bram := (others => ("010"));
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if buf_num = '0' then
				if we = '1' then
					vram1(to_integer(unsigned(addr_in))) <= pixel_in;
				end if;
				pixel_out <= vram0(to_integer(unsigned(addr_in)));
			elsif buf_num = '1' then
				if we = '1' then
					vram0(to_integer(unsigned(addr_in))) <= pixel_in;
				end if;
				pixel_out <= vram1(to_integer(unsigned(addr_in)));
			end if;
		end if;
	end process;
end behav;
