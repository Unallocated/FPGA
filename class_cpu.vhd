library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.conv_integer;
use IEEE.STD_LOGIC_ARITH.conv_std_logic_vector;
use IEEE.NUMERIC_STD.all;

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
-- push and pop for reg_a
-- push and pop for flags

architecture Behavioral of class_cpu is

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
	
	signal porta_buf : std_logic_vector(7 downto 0);
	signal portb_buf : std_logic_vector(7 downto 0);
	signal portc_buf : std_logic_vector(7 downto 0);
	signal portd_buf : std_logic_vector(7 downto 0);
	
	signal register_a : std_logic_vector(7 downto 0) := (others => '0');
	
	signal mem_we : std_logic_vector(0 downto 0) := (others => '0');
	signal mem_addr : std_logic_vector(15 downto 0) := (others => '0');
	signal mem_data_in : std_logic_vector(7 downto 0) := (others => '0');
	signal mem_data_out : std_logic_vector(7 downto 0);
	
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
		call  => "00010001"
	);
	
	constant stack_origin : integer := conv_integer(x"8000");
	
	type program_type is array(natural range <>) of opcode;
	
	constant program : program_type := (
		--opcodes.jmp,x"00",x"03", --  0 -> 2
		opcodes.mova,x"ff", --  3 -> 4
		opcodes.movaf,x"00",x"00"
	);
		
	
begin

	real_rst <= rst;
	
	porta <= porta_buf;
	portb <= portb_buf;
	portc <= portc_buf;
	portd <= portd_buf;
	
	brain : process(cpu_clock, real_rst)
		variable pc : integer := 0;
		variable current_opcode : opcode;
		variable current_opcode_int : integer range 0 to 255;
		variable wide_buffer : std_logic_vector(15 downto 0);
		variable wide_buffer_int : integer range 0 to (2**16) - 1 := 0;
		variable narrow_buffer : std_logic_vector(7 downto 0);
		variable narrow_buffer_int : integer range 0 to (2**8) - 1 := 0;
		variable delay : integer range 0 to 15 := 0;
		variable stack_pointer : integer := stack_origin;
	begin
		porta_buf <= conv_std_logic_vector(pc, 8);
		
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
					when opcodes.porta =>
						pc := pc + 1;
						porta_buf <= program(pc);
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
--								when 0 =>
--									porta_buf <= register_a;
								when 1 =>
									portb_buf <= register_a;
								when 2 =>
									portc_buf <= register_a;
								when 3 =>
									portd_buf <= register_a;
								when others =>
									null;
							end case;
							
							delay := 0;
						end if;
					when opcodes.adda =>
						pc := pc + 1;
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
							
							pc := pc + 2;
							delay := 2;
						elsif(delay = 2) then
							delay := 1;
						else
							register_a <= mem_data_out;
							
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
							wide_buffer := conv_std_logic_vector(pc, 16);
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
		variable counter : integer range 0 to 100000000/64 := 0;
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

	cpu_memory : memory
	  PORT MAP (
		 clka => cpu_clock,
		 wea => mem_we,
		 addra => mem_addr,
		 dina => mem_data_in,
		 douta => mem_data_out
	  );

end Behavioral;

