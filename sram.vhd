library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sram is
	 Generic ( avail_addr_width : integer := 17;
	           actual_addr_width : integer := 24;
				  data_width : integer := 8
	 );
    Port ( clk      : in   STD_LOGIC;
           rst      : in   STD_LOGIC;
           si       : in   STD_LOGIC;
           data_in  : in   STD_LOGIC_VECTOR (data_width-1 downto 0);
           start    : in   STD_LOGIC;
           we       : in   STD_LOGIC;
           addr     : in   STD_LOGIC_VECTOR (avail_addr_width-1 downto 0);
           data_out : out  STD_LOGIC_VECTOR (data_width-1 downto 0);
           so       : out  STD_LOGIC;
           done     : out  STD_LOGIC;
           sck      : out  STD_LOGIC;
           cs_n     : out  STD_LOGIC);
end sram;

architecture Behavioral of sram is
	constant WRITE_INSTR : std_logic_vector(data_width-1 downto 0) := x"02";
	constant READ_INSTR : std_logic_vector(data_width-1 downto 0) := x"03";

	type state_t is (IDLE, INSTR, ADDRESS, DATA);
	signal state : state_t := IDLE;

	signal data_in_buffer : std_logic_vector(data_in'range);
	signal addr_buffer : std_logic_vector(actual_addr_width-1 downto 0);
	signal we_buffer : std_logic;
	signal start_buffer : std_logic := '0';
	
	signal bit_pos : integer range 0 to 23 := 0;
	signal sck_flag : std_logic_vector(1 downto 0) := "00";
begin

	process(clk, rst)
	begin
		if(rst = '1') then
			state <= IDLE;
		elsif(rising_edge(clk)) then
			if(sck_flag = "01") then
				sck <= '1';
				sck_flag <= "10";
			elsif(sck_flag = "10") then
				sck <= '0';
				sck_flag <= "00";
			else
				case state is
					when IDLE =>
						cs_n <= '1';
						done <= '1';
						bit_pos <= data_width-1;
						so <= '0';
						sck_flag <= "00";
						
						if(start = '1' and start_buffer = '0') then
							state <= INSTR;
							done <= '0';
							cs_n <= '0';
							data_in_buffer <= data_in;
							if(actual_addr_width > avail_addr_width) then
								addr_buffer(actual_addr_width - 1 downto avail_addr_width) <= (others => '0');
							end if;
							addr_buffer(avail_addr_width-1 downto 0) <= addr;
							we_buffer <= we;
						end if;
						
						start_buffer <= start;
						
					when INSTR =>
						if(we_buffer = '1') then
							so <= WRITE_INSTR(bit_pos);
						else
							so <= READ_INSTR(bit_pos);
						end if;
						
						if(bit_pos = 0) then
							state <= ADDRESS;
							bit_pos <= actual_addr_width-1;
						else
							bit_pos <= bit_pos - 1;
						end if;
						
						sck_flag <= "01";
					when ADDRESS =>
						so <= addr_buffer(bit_pos);
						
						if(bit_pos = 0) then
							state <= DATA;
							bit_pos <= data_width-1;
						else
							bit_pos <= bit_pos - 1;
						end if;
						
						sck_flag <= "01";
					when DATA =>
						if(we_buffer = '1') then
							so <= data_in_buffer(bit_pos);
						else
							data_out(bit_pos) <= si;
						end if;
						
						if(bit_pos = 0) then
							state <= IDLE;
							bit_pos <= data_width-1;
						else
							bit_pos <= bit_pos - 1;
						end if;
						
						sck_flag <= "01";
				end case;
			end if;
		end if;
	end process;


end Behavioral;











