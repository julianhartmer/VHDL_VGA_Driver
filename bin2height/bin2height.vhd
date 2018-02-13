library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin2height is
	generic(
		SAMPLE_WIDTH	: integer := 24;
		BLOCK_WIDTH	: integer := 1024;
		LOG2_BLOCK_WIDTH: integer := 10;
		MAX_BAR_HEIGHT	: integer := 450;
		LOG2_BAR_HEIGHT	: integer := 9
	);
	port(
		clk			 : in std_logic;
		rst			 : in std_logic;

		m_axis_tvalid   : out std_logic;
		m_axis_tready   : in std_logic;
		m_axis_tdata	: out std_logic_vector(LOG2_BAR_HEIGHT- 1 downto 0);
		m_axis_tlast	: out std_logic;

		s_axis_tvalid   : in std_logic;
		s_axis_tready   : out std_logic;
		s_axis_tdata	: in unsigned(SAMPLE_WIDTH - 1 downto 0);
		s_axis_tlast	: in std_logic
	);
end entity;

architecture behavioral of bin2height is
	signal idx_pass_thru	: std_logic_vector(BLOCK_WIDTH-1 downto 0) := (
		1  => '1',
		2  => '1',
		3  => '1',
		4  => '1',
		5  => '1',
		6  => '1',
		7  => '1',
		8  => '1',
		9  => '1',
		10 => '1',
		11 => '1',
		12 => '1',
		13 => '1',
		14 => '1',
		15 => '1',
		16 => '1',
		17 => '1',
		18 => '1',
		19 => '1',
		20 => '1',
		21 => '1',
		22 => '1',
		23 => '1',
		24 => '1',
		25 => '1',
		26 => '1',
		27 => '1',
		29 => '1',
		30 => '1',
		31 => '1',
		33 => '1',
		34 => '1',
		36 => '1',
		37 => '1',
		39 => '1',
		41 => '1',
		43 => '1',
		45 => '1',
		47 => '1',
		49 => '1',
		51 => '1',
		54 => '1',
		56 => '1',
		59 => '1',
		61 => '1',
		64 => '1',
		67 => '1',
		70 => '1',
		73 => '1',
		77 => '1',
		80 => '1',
		84 => '1',
		88 => '1',
		92 => '1',
		96 => '1',
		101=> '1',
		105=> '1',
		110=> '1',
		115=> '1',
		120=> '1',
		126=> '1',
		132=> '1',
		137=> '1',
		144=> '1',
		151=> '1',
		158=> '1',
		165=> '1',
		173=> '1',
		181=> '1',
		189=> '1',
		198=> '1',
		207=> '1',
		216=> '1',
		226=> '1',
		237=> '1',
		248=> '1',
		259=> '1',
		271=> '1',
		283=> '1',
		296=> '1',
		310=> '1', 324=> '1',
		339=> '1',
		355=> '1',
		371=> '1',
		388=> '1',
		406=> '1',
		425=> '1',
		others => '0'
	);


	signal valid_out	: std_logic := '0';
	signal counter		: unsigned(LOG2_BLOCK_WIDTH-1 downto 0) := (others => '0');
	signal data_reg		: std_logic_vector(LOG2_BAR_HEIGHT-1 downto 0);
	signal s_ready		: std_logic := '0';
	signal multiplied	: unsigned(LOG2_BAR_HEIGHT+SAMPLE_WIDTH-1 downto 0);
	signal valid_to_ready_reg: std_logic := '0';
	signal incoming		: std_logic := '0';
begin

	multiplied <= s_axis_tdata * to_unsigned(MAX_BAR_HEIGHT, LOG2_BAR_HEIGHT);
	m_axis_tdata <= data_reg;

	counter_inc_driv: process(clk) is
	begin
		if rising_edge(clk) then
			if rst = '1' then
				counter <= (others => '1');
				s_axis_tready <= '0';
			else
				s_axis_tready <= m_axis_tready;
				if s_axis_tvalid = '1' and m_axis_tready = '1' then
					if s_axis_tlast = '1' then
						m_axis_tlast <= '1';
						counter <= (others => '0');
					else
						if idx_pass_thru(to_integer(counter)) = '1' then
							data_reg <= std_logic_vector(multiplied(multiplied'high downto multiplied'high-data_reg'high));
							m_axis_tvalid <= '1';
						else
							m_axis_tvalid <= '0';
						end if;
						m_axis_tlast <= '0';
						counter <= counter + to_unsigned(1,1);
					end if;
				end if;
			end if;
		end if;
	end process;
end behavioral;
