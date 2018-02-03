library ieee;
use ieee.std_logic_1164.all;

entity vga_ram_ctrl is 
	generic(
		BLOCKSIZE	: integer := 3;
		BLOCKAMOUNT	: integer := 640;
		LOG2_BLOCKAMOUNT: integer := 10;
	);
	port(	 
		clk		: in std_logic;
		switch_buf	: in std_logic;

		addr_out 	: in std_logic_vector(LOG2_BLOCKAMOUNT-1 downto 0);
		pixel_out	: out std_logic_vector(BLOCKSIZE-1 downto 0);

		we		: in std_logic;
		addr_in		: in std_logic_vector(LOG2_BLOCKAMOUNT-1 downto 0);
		pixel_in	: out std_logic_vector(BLOCKSIZE-1 downto 0);
	);
end vga_ram_ctrl;
architecture behav of vga_ram_ctrl is
	type bram is array (0 to BLOCKAMOUNT) of std_logic_vector(BLOCKSIZE-1 downto 0);
	signal read_01 : std_logic := '0';
	signal vram0 : bram := (others => (others => '0'));
	signal vram1 : bram := (others => (others => '1'));
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if switch = '1' then
				read_01 <= not read_01;
			end if;
			if switch = '0' then
				if we = '1' then
					vram1(to_integer(unsigned(addr_in))) <= data_in;
				end if;
				data_out <= vram0(to_integer(unsigned(add_in)));
			elsif switch = '1' then
				if we = '1' then
					vram0(to_integer(unsigned(add_in))) <= data_in;
				data_out <= vram1(to_integer(unsigned(add_in)));
				end if;
			end if;
		end if;
	end process;
end behav;
