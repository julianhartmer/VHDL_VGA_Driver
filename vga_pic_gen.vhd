library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_pic_gen is
	generic(
		H_RES		: integer := 640;
		LOG2_H_RES	: integer := 10;
		V_RES		: integer := 480;
		LOG2_V_RES	: integer := 9
	);
		
	port(	pic_en	 	: in std_logic;
		pic_x		: in std_logic_vector(LOG2_H_RES-1 downto 0);
		pic_y		: in std_logic_vector(LOG2_V_RES-1 downto 0);
		r_in		: in std_logic;
		g_in		: in std_logic;
		b_in		: in std_logic;
		r, g, b		: out std_logic
	);
end vga_pic_gen;

architecture behav of vga_pic_gen is
begin 
	r <= r_in when pic_en = '1' else '0';
	g <= g_in when pic_en = '1' else '0';
	b <= b_in when pic_en = '1' else '0';
	    
end behav;
