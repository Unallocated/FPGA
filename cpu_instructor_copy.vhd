library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.conv_integer;

entity cpu_instructor_copy is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           porta : inout  STD_LOGIC_VECTOR (7 downto 0);
           portb : inout  STD_LOGIC_VECTOR (7 downto 0);
           portc : inout  STD_LOGIC_VECTOR (7 downto 0);
           portd : inout  STD_LOGIC_VECTOR (7 downto 0));
end cpu_instructor_copy;

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
--
--
-- tristate logic on the ports ?
-- map the ports to memory?
-- Always increment program counter (allow negative)
-- Always set mem_we to zero on the rising edge
--
-- overflow/underflow flag
-- reg_a, reg_b is zero flag
-- adda (2 byte)
-- suba (2 byte)
-- mula (2 byte)
-- lshifta (2 byte)
-- rshifta (2 byte)
-- lror (2 bytes)
-- rror (2 bytes)
-- flags record


architecture Behavioral of cpu_instructor_copy is

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
	end record;
	
	constant opcodes : opcodes_type := (
		noop  => "00000000",
		mova  => "00000001",
		movaf => "00000010",
		jmp   => "00000011",
		porta => "00000100"
	);
	
	type program_type is array(natural range <>) of opcode;
	
	constant program : program_type := (
		opcodes.mova,
		"10101010",
		opcodes.movaf,
		"00000000",
		"00000000",
		opcodes.noop,
		opcodes.mova,
		"11110000",
		opcodes.movaf,
		"00000000",
		"00000000",
		opcodes.jmp,
		"00000000",
		"00000000"
	);
	
--	constant program : program_type := (
--		opcodes.noop,
--		opcodes.porta,
--		"10101010",
--		opcodes.noop,
--		opcodes.porta,
--		"00001111",
--		opcodes.jmp,
--		"00000000",
--		"00000000"
--	);
	
begin

	real_rst <= rst;
	
	porta <= porta_buf;
	portb <= portb_buf;
	portc <= portc_buf;
	portd <= portd_buf;
	
	brain : process(cpu_clock, real_rst)
		variable program_counter : integer range -1 to program'length + 1 := 0;
		variable current_opcode : opcode;
		variable current_opcode_int : integer range 0 to 255;
		variable wide_buffer : std_logic_vector(15 downto 0);
		variable wide_buffer_int : integer range 0 to (2**mem_addr'length) - 1 := 0;
	begin
		if(real_rst = '1') then
			program_counter := 0;
		elsif(rising_edge(cpu_clock)) then
			if(program_counter < program'high) then
				current_opcode := program(program_counter);
				current_opcode_int := conv_integer(current_opcode);
				
				mem_we <= "0";
				
				case current_opcode is
					when opcodes.noop =>
						null;
					when opcodes.jmp =>
						program_counter := program_counter + 1;
						wide_buffer(15 downto 8) := program(program_counter);
						program_counter := program_counter + 1;
						wide_buffer(7 downto 0) := program(program_counter);
						program_counter := conv_integer(wide_buffer) - 1;
					when opcodes.porta =>
						program_counter := program_counter + 1;
						porta_buf <= program(program_counter);
					when opcodes.mova =>
						program_counter := program_counter + 1;
						register_a <= program(program_counter);
					when opcodes.movaf =>
						program_counter := program_counter + 1;
						wide_buffer(15 downto 8) := program(program_counter);
						program_counter := program_counter + 1;
						wide_buffer(7 downto 0) := program(program_counter);
						
						wide_buffer_int := conv_integer(wide_buffer);
						case wide_buffer_int is
							when 0 =>
								porta_buf <= register_a;
							when 1 =>
								portb_buf <= register_a;
							when 2 =>
								portc_buf <= register_a;
							when 3 =>
								portd_buf <= register_a;
							when others =>
								null;
						end case;
						
						mem_addr <= wide_buffer;
						mem_data_in <= register_a;
						mem_we <= "1";
					when others =>
						null;
				end case;
				
				program_counter := program_counter + 1;
			end if;
		end if;
	end process;

	clock_divider : process(clk, real_rst)
		variable counter : integer range 0 to 100000000/2 := 0;
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


