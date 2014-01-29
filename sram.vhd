library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sram is
    Port ( clk      : in   STD_LOGIC;
           rst      : in   STD_LOGIC;
           si       : in   STD_LOGIC;
           data_in  : in   STD_LOGIC_VECTOR (7 downto 0);
           start    : in   STD_LOGIC;
           we       : in   STD_LOGIC;
           addr     : in   STD_LOGIC_VECTOR (23 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0);
           so       : out  STD_LOGIC;
           done     : out  STD_LOGIC;
           sck      : out  STD_LOGIC;
           cs_n     : out  STD_LOGIC);
end sram;

architecture Behavioral of sram is

	type state_t is (IDLE, INSTR, ADDRESS, DATA);
	signal state : state_t := IDLE;

	signal data_in_buffer : std_logic_vector(data_in'range);
	signal addr_buffer : std_logic_vector(addr'range);
	signal we_buffer : std_logic;
	signal start_buffer : std_logic := '0';
begin

	process(clk, rst)
	begin
		if(rst = '1') then
			state <= IDLE;
		elsif(rising_edge(clk)) then
			
			case state is
				when IDLE =>
					cs_n <= '1';
					done <= '1';
					
					if(start = '1' and start_buffer = '0') then
						state <= INSTR;
						done <= '0';
						cs_n <= '0';
						data_in_buffer <= data_in;
						addr_buffer <= addr;
						we_buffer <= we;
					end if;
					
					start_buffer <= start;
					
				when INSTR =>
					state <= ADDRESS;
				when ADDRESS =>
					state <= DATA;
				when DATA =>
					state <= IDLE;
			end case;
		end if;
	end process;


end Behavioral;











