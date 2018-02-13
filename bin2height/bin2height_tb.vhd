library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin2height_tb is
end entity;

architecture behavioral of bin2height_tb is
	component bin2height is
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
			m_axis_tdata	: out std_logic_vector(LOG2_BAR_HEIGHT - 1 downto 0);
			m_axis_tlast	: out std_logic;

			s_axis_tvalid   : in std_logic;
			s_axis_tready   : out std_logic;
			s_axis_tdata	: in unsigned(SAMPLE_WIDTH - 1 downto 0);
			s_axis_tlast	: in std_logic
		);
	end component;
	signal clk, m_valid, m_ready, m_last, s_valid, s_ready, s_last: std_logic := '0';
	signal rst: std_logic := '1';
	signal m_data : std_logic_vector(9-1 downto 0) := (others => '0');
	signal s_data : unsigned(24-1 downto 0) := (others => '0');
	signal counter : integer range 0 to 1023 := 0;
begin
	b2h_a : bin2height port map(
		clk		=> clk,
		rst		=> rst,
		m_axis_tvalid	=> m_valid,
		m_axis_tready   => m_ready,
		m_axis_tdata	=> m_data,
		m_axis_tlast	=> m_last,

		s_axis_tvalid   => s_valid,
		s_axis_tready   => s_ready,
		s_axis_tdata	=> s_data,
		s_axis_tlast	=> s_last
	);

	clk_driver: process
	begin
		clk <= not clk;
		wait for 1 ns;
	end process;

	counter_driv: process(clk)
	begin
		if rising_edge(clk) then
			s_data <= s_data + to_unsigned(1024,11);
			counter <= counter + 1;
			s_last <= '0';
			if counter = 1022 then
				s_data <= (others => '0');
				s_last <= '1';
				counter <= 0;
			end if;
		end if;
	end process;

	simu: process
	begin
		report "Starting bin2height tb";
		rst <= '1';
		wait for 30 ns;
		rst <= '0';
		wait for 20 ns;
		s_valid <= '1';
		wait for 20 ns;
		m_ready <= '1';
		wait for 8000 ns;
		assert false report "simulation ended" severity failure;
	end process;
end;
