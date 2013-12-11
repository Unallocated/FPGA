library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.conv_integer;
use IEEE.STD_LOGIC_ARITH.conv_std_logic_vector;
use IEEE.NUMERIC_STD.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity class_cpu is
    Port ( clk : in  STD_LOGIC;
              rst : in  STD_LOGIC;
              porta : inout  STD_LOGIC_VECTOR (7 downto 0);
              portb : inout  STD_LOGIC_VECTOR (7 downto 0);
              portc : inout  STD_LOGIC_VECTOR (7 downto 0);
              portd : inout  STD_LOGIC_VECTOR (7 downto 0));
end class_cpu;
--
-- add, sub, mult, divide
-- 8 bit ram (64k addresses)
-- 8 bit opcode
-- 
-- 2 - 8 bit registers
-- flags vector (8 bit)
-- serial output via FIFO
-- 256 element stack register (16 bit wide)
-- 5 8-bit io registers

-- shift with carry instruction
-- 26th -> addca, flags, division (ipcore)
-- functions/procedure (lumping like logic)
-- serial at some point

architecture Behavioral of class_cpu is

	component cpu_divider
		port (
		clk: in std_logic;
		ce: in std_logic;
		rfd: out std_logic;
		dividend: in std_logic_vector(7 downto 0);
		divisor: in std_logic_vector(7 downto 0);
		quotient: out std_logic_vector(7 downto 0);
		fractional: out std_logic_vector(7 downto 0));
	end component;

	COMPONENT memory
	  PORT (
		 clka : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	signal cpu_clock : std_logic := '0';
	signal real_rst : std_logic;
	
--	signal porta_buf : std_logic_vector(7 downto 0);
--	signal portb_buf : std_logic_vector(7 downto 0);
--	signal portc_buf : std_logic_vector(7 downto 0);
--	signal portd_buf : std_logic_vector(7 downto 0);
	
	signal register_a : std_logic_vector(7 downto 0) := (others => '0');
	
	signal mem_we : std_logic_vector(0 downto 0) := (others => '0');
	signal mem_addr : std_logic_vector(15 downto 0) := (others => '0');
	signal mem_data_in : std_logic_vector(7 downto 0) := (others => '0');
	signal mem_data_out : std_logic_vector(7 downto 0);
	
	signal divider_ce : std_logic := '0';
	signal divider_divisor : std_logic_vector(7 downto 0);
	signal divider_dividend : std_logic_vector(7 downto 0);
	signal divider_quotient : std_logic_vector(7 downto 0);
	signal divider_fractional : std_logic_vector(7 downto 0);
	
	type flags_type is record
		carry : std_logic;
	end record;
	
	signal flags : flags_type := (
		carry => '0'
	);
	
	subtype opcode is std_logic_vector(7 downto 0);
	
	type opcodes_type is record
		noop  : opcode;   -- do nothing
		mova  : opcode;   -- move next opcode to register a (2 byte instr)
		movaf : opcode;   -- move register a to some memory address (3 byte instr)
		jmp   : opcode;   -- sets value of program counter (3 byte instr)
		porta : opcode;   -- sets value of the porta output (2 byte instr)
		adda  : opcode;   -- adds value of next byte to register_a (2 byte instr)
		suba  : opcode;   -- subtract value of next byte from register_a (2 byte instr)
		lsla  : opcode;   -- left shift register_a by number of bits defined by next byte (2 byte instr)
		lsra  : opcode;   -- right shift register_a by number of bits defined by next byte (2 byte instr)
		mula  : opcode;   -- multiply register_a by value in next byte (2 byte instr)
		lrla  : opcode;   -- left rotate register_a by number of bits in next byte (2 byte instr)
		lrra  : opcode;   -- right rotate register_a by number of bits in next byte (2 byte instr)
		movfa : opcode;   -- moves value from memory into register a (3 byte instr)
		janez : opcode;   -- jump if register a is not zero (3 byte instr)
		jane  : opcode;   -- jump if register a does not equal the next byte (4 byte instr)
		janef : opcode;   -- jump if register a does not equal the value in memory address (5 byte instr)
		call  : opcode;   -- call function in location x (3 byte instr)
		ret   : opcode;   -- return from function call (1 byte instr)
		push  : opcode;   -- pushes register_a onto the stack (1 byte instr)
		pop   : opcode;   -- pops register_a from the stack (1 byte instr)
		diva  : opcode;   -- divide register_a by the next byte (2 byte instr)
		addca : opcode;   -- add next byte to register_a including the carry bit (2 byte instr)
		moda  : opcode;   -- register_a mod the next byte (2 byte instr) 
	end record;
	
	constant opcodes : opcodes_type := (
		noop  => "00000000",
		mova  => "00000001",
		movaf => "00000010",
		jmp   => "00000011",
		porta => "00000100",
		adda  => "00000101",
		suba  => "00000110",
		lsla  => "00000111",
		lsra  => "00001000",
		mula  => "00001001",
		lrla  => "00001010",
		lrra  => "00001011",
		movfa => "00001100",
		janez => "00001101",
		jane  => "00001110",
		janef => "00001111",
		addca => "00010000",
		call  => "00010001",
		ret   => "00010010",
		push  => "00100100",
		pop   => "00100101",
		diva  => "00100110",
		moda  => "00100111"
	);
	
	constant stack_origin : integer := conv_integer(x"8000");
	
	type program_type is array(natural range <>) of opcode;
	
	constant program : program_type := (
		opcodes.mova, x"ff",
		opcodes.movaf,x"00",x"05",
		opcodes.movfa,x"00",x"01",
		opcodes.movaf,x"00",x"00",
		opcodes.jmp,  x"00",x"05"
	);
		
	signal porta_output : std_logic_vector(portb'range) := (others => '0');
	signal porta_input : std_logic_vector(portb'range) := (others => '0');
	signal porta_direction : std_logic_vector(porta'range) := (others => '0');
	
	signal portb_output : std_logic_vector(portb'range) := (others => '0');
	signal portb_input : std_logic_vector(portb'range) := (others => '0');
	signal portb_direction : std_logic_vector(porta'range) := (others => '0');
	
	signal portc_output : std_logic_vector(portc'range) := (others => '0');
	signal portc_input : std_logic_vector(portc'range) := (others => '0');
	signal portc_direction : std_logic_vector(portc'range) := (others => '0');
	
	signal portd_output : std_logic_vector(portd'range) := (others => '0');
	signal portd_input : std_logic_vector(portd'range) := (others => '0');
	signal portd_direction : std_logic_vector(portd'range) := (others => '0');
	
begin

	BUF_GEN_PORTA:
	for i in porta'range generate
		IOBUF_inst : IOBUF
			generic map (
			   DRIVE => 12,
			   IOSTANDARD => "LVCMOS33",
			   SLEW => "SLOW")
			port map (
			   O => porta_output(i),     -- Buffer output
			   IO => porta(i),   -- Buffer inout port (connect directly to top-level port)
			   I => porta_input(i),     -- Buffer input
			   T => porta_direction(i)      -- 3-state enable input, high=input, low=output 
			);
	end generate BUF_GEN_PORTA;
	
	BUF_GEN_PORTB:
	for i in portb'range generate
		IOBUF_inst : IOBUF
			generic map (
			   DRIVE => 12,
			   IOSTANDARD => "LVCMOS33",
			   SLEW => "SLOW")
			port map (
			   O => portb_output(i),     -- Buffer output
			   IO => portb(i),   -- Buffer inout port (connect directly to top-level port)
			   I => portb_input(i),     -- Buffer input
			   T => portb_direction(i)      -- 3-state enable input, high=input, low=output 
			);
	end generate BUF_GEN_PORTB;
	
	BUF_GEN_PORTC:
	for i in portc'range generate
		IOBUF_inst : IOBUF
			generic map (
			   DRIVE => 12,
			   IOSTANDARD => "LVCMOS33",
			   SLEW => "SLOW")
			port map (
			   O => portc_output(i),     -- Buffer output
			   IO => portc(i),   -- Buffer inout port (connect directly to top-level port)
			   I => portc_input(i),     -- Buffer input
			   T => portc_direction(i)      -- 3-state enable input, high=input, low=output 
			);
	end generate BUF_GEN_PORTC;
	
	BUF_GEN_PORTD:
	for i in portd'range generate
		IOBUF_inst : IOBUF
			generic map (
			   DRIVE => 12,
			   IOSTANDARD => "LVCMOS33",
			   SLEW => "SLOW")
			port map (
			   O => portd_output(i),     -- Buffer output
			   IO => portd(i),   -- Buffer inout port (connect directly to top-level port)
			   I => portd_input(i),     -- Buffer input
			   T => portd_direction(i)      -- 3-state enable input, high=input, low=output 
			);
	end generate BUF_GEN_PORTD;

	real_rst <= rst;
	
--	porta <= porta_buf;
--	portb <= portb_buf;
--	portc <= portc_buf;
--	portd <= portd_buf;
	
	brain : process(cpu_clock, real_rst)
		variable pc : integer := 0;
		variable current_opcode : opcode;
		variable current_opcode_int : integer range 0 to 255;
		variable wide_buffer : std_logic_vector(15 downto 0);
		variable wide_buffer_int : integer range 0 to (2**16) - 1 := 0;
		variable narrow_buffer : std_logic_vector(7 downto 0);
		variable narrow_buffer_int : integer range 0 to (2**8) - 1 := 0;
		variable delay : integer range 0 to 31 := 0;
		variable stack_pointer : integer := stack_origin;
	begin
--		porta_buf <= conv_std_logic_vector(pc, 8);
		if(real_rst = '1') then
			pc := 0;
			stack_pointer := stack_origin;
		elsif(rising_edge(cpu_clock)) then
			if(pc <= program'high) then
				if(delay = 0) then
					current_opcode := program(pc);
					current_opcode_int := conv_integer(current_opcode);
				end if;
				
--				mem_we <= "0";
				
				case current_opcode is
					when opcodes.noop =>
						null;
					when opcodes.jmp =>
						pc := pc + 1;
						wide_buffer(15 downto 8) := program(pc);
						pc := pc + 1;
						wide_buffer(7 downto 0) := program(pc);
						pc := conv_integer(wide_buffer) - 1;
					when opcodes.mova =>
						pc := pc + 1;
						register_a <= program(pc);
					when opcodes.movaf =>
						if(delay = 0) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							mem_data_in <= register_a;
							
							wide_buffer_int := conv_integer(program(pc + 1) & program(pc + 2));
							pc := pc + 2;
							delay := 2;
						elsif(delay = 2) then
							mem_we <= "1";
							delay := 1;
						else
							mem_we <= "0";
							
							case wide_buffer_int is
								when 0 =>
									porta_input <= register_a;
								when 1 =>
									portb_input <= register_a;
								when 2 =>
									portc_input <= register_a;
								when 3 =>
									portd_input <= register_a;
								when 4 =>
									porta_direction <= register_a;
								when 5 =>
									portb_direction <= register_a;
								when 6 =>
									portc_direction <= register_a;
								when 7 =>
									portd_direction <= register_a;
								when others =>
									null;
							end case;
							
							delay := 0;
						end if;
					when opcodes.adda =>
						pc := pc + 1;
						if(conv_integer(program(pc)) + conv_integer(register_a) > 255) then
							flags.carry <= '1';
						else
							flags.carry <= '0';
						end if;
						register_a <= conv_std_logic_vector(conv_integer(program(pc)) + conv_integer(register_a), 8);
					when opcodes.suba =>
						pc := pc + 1;
						register_a <= conv_std_logic_vector(conv_integer(register_a) - conv_integer(program(pc)), 8);
						
						
					when opcodes.lsla =>
						pc := pc + 1;
						register_a <= std_logic_vector(unsigned(register_a) sll conv_integer(program(pc)));
					when opcodes.lsra =>
						pc := pc + 1;
						register_a <= std_logic_vector(unsigned(register_a) srl conv_integer(program(pc)));
					when opcodes.mula =>
						pc := pc + 1;
						register_a <= conv_std_logic_vector(conv_integer(register_a) * conv_integer(program(pc)),8);
					
					when opcodes.lrla =>
						pc := pc + 1;
						register_a <= std_logic_vector(unsigned(register_a) rol conv_integer(program(pc)));
					
					when opcodes.lrra =>
						pc := pc + 1;
						register_a <= std_logic_vector(unsigned(register_a) ror conv_integer(program(pc)));
					
					when opcodes.movfa =>
						if(delay = 0) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							mem_we <= "0";
							
							delay := 2;
						elsif(delay = 2) then
							delay := 1;
						else
							case conv_integer(program(pc + 1) & program(pc + 2)) is
								when 0 =>
									register_a <= porta_output;
								when 1 =>
									register_a <= portb_output;
								when 2 =>
									register_a <= portc_output;
								when 3 =>
									register_a <= portd_output;
								when 4 =>
									register_a <= porta_direction;
								when 5 =>
									register_a <= portb_direction;
								when 6 =>
									register_a <= portc_direction;
								when 7 =>
									register_a <= portd_direction;
								when others =>
									register_a <= mem_data_out;
							end case;
							
							pc := pc + 2;
							delay := 0;
						end if;
					
					when opcodes.janez =>
						if(register_a = "00000000") then
							pc := pc + 2;
						else
							pc := conv_integer(program(pc + 1) & program(pc + 2)) - 1;
						end if;
					
					when opcodes.jane =>
						if(register_a = program(pc + 1)) then
							pc := pc + 3;
						else
							pc := conv_integer(program(pc + 2) & program(pc + 3)) - 1;
						end if;
					
					when opcodes.janef =>
						if(delay = 0) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							mem_we <= "0";
							
							pc := pc + 2;
							delay := 2;
						elsif(delay = 2) then
							delay := 1;
						else
							if(register_a /= mem_data_out) then
								wide_buffer := program(pc + 1) & program(pc + 2);
								pc := conv_integer(wide_buffer) - 1;
							else
								pc := pc + 2;
							end if;
							
							delay := 0;
						end if;
							
					when opcodes.call =>
						if(delay = 0) then
							wide_buffer := conv_std_logic_vector(pc + 3, 16);
							mem_addr <= conv_std_logic_vector(stack_pointer, 16);
							mem_data_in <= wide_buffer(15 downto 8);
							delay := 5;
						elsif(delay = 5) then
							mem_addr <= conv_std_logic_vector(stack_pointer, 16);
							mem_we <= "1";
							delay := 4;
						elsif(delay = 4) then
							mem_we <= "0";
							delay := 3;
						elsif(delay = 3) then
							mem_addr <= conv_std_logic_vector(stack_pointer + 1, 16);
							mem_data_in <= wide_buffer(7 downto 0);
							delay := 2;
						elsif(delay = 2) then
							mem_addr <= conv_std_logic_vector(stack_pointer + 1, 16);
							mem_we <= "1";
							delay := 1;
						elsif(delay = 1) then
							mem_we <= "0";
							stack_pointer := stack_pointer + 2;
							pc := conv_integer(program(pc + 1) & program(pc + 2)) - 1;
							delay := 0;
						end if;
					when opcodes.ret =>
						if(delay = 0) then
							mem_addr <= conv_std_logic_vector(stack_pointer - 1, 16);
							mem_we <= "0";
							delay := 5;
						elsif(delay = 5) then
							mem_addr <= conv_std_logic_vector(stack_pointer - 1, 16);
							delay := 4;
						elsif(delay = 4) then
							wide_buffer(7 downto 0) := mem_data_out;
							delay := 3;
						elsif(delay = 3) then
							mem_addr <= conv_std_logic_vector(stack_pointer - 2, 16);
							delay := 2;
						elsif(delay = 2) then
							mem_addr <= conv_std_logic_vector(stack_pointer - 2, 16);
							delay := 1;
						elsif(delay = 1) then
							wide_buffer(15 downto 8) := mem_data_out;
							pc := conv_integer(wide_buffer) - 1;
							stack_pointer := stack_pointer - 2;
							delay := 0;
						end if;
					
					when opcodes.push =>
						if(delay = 0) then
							mem_addr <= conv_std_logic_vector(stack_pointer, 16);
							mem_data_in <= register_a;
							delay := 2;
						elsif(delay = 2) then
							mem_addr <= conv_std_logic_vector(stack_pointer, 16);
							mem_we <= "1";
							delay := 1;
						elsif(delay = 1) then
							mem_addr <= conv_std_logic_vector(stack_pointer, 16);
							mem_we <= "0";
							stack_pointer := stack_pointer + 1;
							delay := 0;
						end if;
					when opcodes.pop =>
						if(delay = 0) then
							mem_addr <= conv_std_logic_vector(stack_pointer - 1, 16);
							mem_we <= "0";
							delay := 2;
						elsif(delay = 2) then
							mem_addr <= conv_std_logic_vector(stack_pointer - 1, 16);
							delay := 1;
						elsif(delay = 1) then
							register_a <= mem_data_out;
							stack_pointer := stack_pointer - 1;
							delay := 0;
						end if;
					when opcodes.diva =>
						if(delay = 0) then
							divider_dividend <= register_a;
							divider_divisor <= program(pc + 1);
							delay := 21;
						elsif(delay = 21) then
							divider_ce <= '1';
							delay := 20;
						elsif(delay > 1) then
							delay := delay - 1;
						elsif(delay = 1) then
							register_a <= divider_quotient;
							divider_ce <= '0';
							pc := pc + 1;
							delay := 0;
						end if;
					when opcodes.addca =>
						pc := pc + 1;
						if(flags.carry = '1') then
							if(conv_integer(program(pc)) + 1 + conv_integer(register_a) > 255) then
								flags.carry <= '1';
							else
								flags.carry <= '0';
							end if;
							register_a <= conv_std_logic_vector(conv_integer(program(pc)) + 1 + conv_integer(register_a), 8);
						else
							if(conv_integer(program(pc)) + conv_integer(register_a) > 255) then
								flags.carry <= '1';
							else
								flags.carry <= '0';
							end if;
							register_a <= conv_std_logic_vector(conv_integer(program(pc)) + conv_integer(register_a), 8);
						end if;
					when opcodes.moda =>
						if(delay = 0) then
							divider_dividend <= register_a;
							divider_divisor <= program(pc + 1);
							delay := 21;
						elsif(delay = 21) then
							divider_ce <= '1';
							delay := 20	;
						elsif(delay > 1) then
							delay := delay - 1;
						elsif(delay = 1) then
							register_a <= divider_fractional;
							divider_ce <= '0';
							pc := pc + 1;
							delay := 0;
						end if;
					when others =>
						null;
				end case;
				
				if(delay = 0) then
					pc := pc + 1;
				end if;
			end if;
		end if;
	end process;

	clock_divider : process(clk, real_rst)
		variable counter : integer range 0 to 100000000/16 := 0;
	begin
		if(real_rst = '1') then
			counter := 0;
			cpu_clock <= '0';
		elsif(rising_edge(clk)) then
			if(counter = 0) then
				cpu_clock <= not cpu_clock;
			end if;
			
			counter := counter + 1;
		end if;
	end process;
	
	my_divider : cpu_divider
		port map (
			clk => cpu_clock,
			ce => divider_ce,
			rfd => open,
			dividend => divider_dividend,
			divisor => divider_divisor,
			quotient => divider_quotient,
			fractional => divider_fractional);

	cpu_memory : memory
	  PORT MAP (
		 clka => cpu_clock,
		 wea => mem_we,
		 addra => mem_addr,
		 dina => mem_data_in,
		 douta => mem_data_out
	  );

end Behavioral;

