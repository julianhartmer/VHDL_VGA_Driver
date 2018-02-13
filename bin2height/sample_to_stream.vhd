library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sample_to_stream is
    generic(
        SAMPLE_WIDTH 	: integer := 24;
        BLOCK_WIDTH     : integer := 1024
    );
	port(
        clk             : in std_logic;
        rst             : in std_logic;
        sample_good	    : in std_logic;
        sample          : in std_logic_vector(SAMPLE_WIDTH - 1 downto 0);
        m_axis_tvalid   : out std_logic;
        m_axis_tready   : in std_logic;
        m_axis_tdata    : out std_logic_vector(2*SAMPLE_WIDTH - 1 downto 0);
        m_axis_tlast    : out std_logic
    );
end entity;

architecture behavioral of sample_to_stream is
	signal sample_good_last : std_logic := '0';
    signal sample_count 	: integer range 0 to BLOCK_WIDTH - 1 := 0;
    signal sample_reg   	: std_logic_vector(sample'range);
	signal valid			: std_logic := '0';
begin

	sample_good_reg: process(clk, rst, sample_good) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				sample_good_last <= '0';
			else
				sample_good_last <= sample_good;
				
                if sample_good = '1' and sample_good_last = '0' then
                    valid <= '1';
                end if;
                
                if m_axis_tready = '1' and valid = '1' then
                    valid <= '0';
					m_axis_tlast <= '0';
                    if sample_count < BLOCK_WIDTH - 1 then
                        sample_count <= sample_count + 1;
                        if sample_count = BLOCK_WIDTH - 2 then
                            m_axis_tlast <= '1';
                        end if;
                    else
                        sample_count <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;
	
	m_axis_tvalid <= valid;
    
    process(clk, rst, sample_good, sample_good_last) is
    begin
        if rising_edge(clk) then
            if rst = '0' then
                sample_reg <= (others => '0');
            else
                if sample_good <= '1' and sample_good_last = '0' then
                    sample_reg <= sample;
                end if;
            end if;
        end if;
    end process;
    
   
    m_axis_tdata(SAMPLE_WIDTH - 1 downto 0) <= sample_reg;
    m_axis_tdata(2*SAMPLE_WIDTH - 1 downto SAMPLE_WIDTH) <= (2*SAMPLE_WIDTH - 1 downto SAMPLE_WIDTH => '0');
	
end behavioral;
