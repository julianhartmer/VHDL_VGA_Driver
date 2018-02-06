library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pic_gen is 
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
		line_limit	: in std_logic_vector(LOG2_V_RES-1 downto 0);
		pic_line	: out std_logic_vector(H_RES*PIXEL_SIZE-1 downto 0);
		line_num	: out std_logic_vector(LOG2_V_RES-1 downto 0);
		we		: out std_logic
	);
end pic_gen;
architecture behav of pic_gen is
	constant RES : integer := H_RES * V_RES;
	signal pic_line0 : std_logic_vector((H_RES*PIXEL_SIZE)-1 downto 0) := (
		100*3-1 downto 0 => '1',
		200*3-1 downto 100*3 => '0',
		300*3-1 downto 200*3 => '1',
		400*3-1 downto 300*3 => '0',
		500*3-1 downto 400*3 => '1',
		600*3-1 downto 500*3 => '0',
		640*3-1 downto 600*3 => '1'
	);
	signal pic_line1 : std_logic_vector((H_RES*PIXEL_SIZE)-1 downto 0) := (
		100*3-1 downto 0 => '0',
		200*3-1 downto 100*3 => '1',
		300*3-1 downto 200*3 => '0',
		400*3-1 downto 300*3 => '1',
		500*3-1 downto 400*3 => '0',
		600*3-1 downto 500*3 => '1',
		640*3-1 downto 600*3 => '0'
	);
	signal last_line_limit : std_logic_vector(LOG2_V_RES-1 downto 0);

begin
	line_num <= line_limit;
	process(clk)
	begin
		if rising_edge(clk) then
			if last_line_limit /= line_limit then
				we <= '1';
				if line_limit(3) = '1' then
					pic_line <= pic_line0;
				else
					pic_line1 <= pic_line1;
				end if;
			else
				we <= '0';
			end if;
		end if;
	end process;
end behav;
