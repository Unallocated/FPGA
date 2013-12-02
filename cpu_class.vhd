library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.conv_integer;

entity cpu_class is
    Port ( clk : in  STD_LOGIC;
              rst : in  STD_LOGIC;
              porta : inout  STD_LOGIC_VECTOR (7 downto 0);
              portb : inout  STD_LOGIC_VECTOR (7 downto 0);
              portc : inout  STD_LOGIC_VECTOR (7 downto 0);
              portd : inout  STD_LOGIC_VECTOR (7 downto 0));
end cpu_class;
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
architecture Behavioral of cpu_class is

	COMPONENT memory
	  PORT (
		 clka    : IN STD_LOGIC;
		 wea    : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dina    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	signal cpu_clock : std_logic := '0';
	
	signal mem_we            : std_logic_vector(0 downto 0) := (others => '0');
	signal mem_addr         : std_logic_vector(15 downto 0) := (others => '0');
	signal mem_data_in    : std_logic_vector(7 downto 0) := (others => '0');
	signal mem_data_out : std_logic_vector(7 downto 0);
	
	signal register_a : std_logic_vector(15 downto 0) := (others => '0');
	signal register_b : std_logic_vector(15 downto 0) := (others => '0');
	
	signal porta_buf : std_logic_vector(7 downto 0);
	signal portb_buf : std_logic_vector(7 downto 0);
	signal portc_buf : std_logic_vector(7 downto 0);
	signal portd_buf : std_logic_vector(7 downto 0);
	
	type stack_type is array(0 to 255) of std_logic_vector(15 downto 0);
	signal stack : stack_type := (others => (others => '0'));
	
	--type opcode is (noop, add, sub, mult, divide);
	subtype opcode is std_logic_vector(7 downto 0);
	
	type opcodes_type is record
		noop : opcode;
		adda : opcode;
		suba : opcode;
		multa : opcode;
		diva : opcode;
		movla : opcode;
		jump : opcode;
		movaf : opcode;
		porta : opcode;
	end record;
	
	constant opcodes : opcodes_type := (
		-- Do nothing.  No extra args used.
		noop => "00000000",
		-- Add to register a.  Takes 2 more args that are the value to add
		adda => "00000001",
		-- Subtract from register a.  Takes 2 more args that are the value to subtract
		suba => "00000010", 
		-- Multiply register a.  Takes 2 more args that are the value to multiply by
		multa => "00000011",
		-- Divide register a.  Takes 2 more arguments that are the value to divide by
		diva => "00000100",
		-- Move a value into register a.  Takes 2 more arguments that are the value to move in
		movla => "00000101", 
		-- Move the program counter to a set location.  Takes 2 more args that are the location to move to
		jump=> "00000110",
		-- Move data from the a register to memory.  Takes 2 more args that are the memory location
		movaf => "00000111",
		-- Load a value into the porta register.  Takes 1 arg that is the value.
		porta => "00001000"
	);
	
	type program_type is array(natural range <>) of opcode;
	
	constant program : program_type := (
		opcodes.porta,
		"00001111",
		opcodes.noop,
		opcodes.noop,
		opcodes.porta,
		"10101010",
		opcodes.porta,
		"11110000",
		opcodes.jump,
		"00000000",
		"00000000"
	);
	
begin

	porta <= porta_buf;
	portb <= portb_buf;
	portc <= portc_buf;
	portd <= portd_buf;
	
	porta_buf <= register_a(7 downto 0);

	clock_divider : process(clk, rst)
		variable counter : integer range 0 to 100000000/8 := 0;
	begin
		if(rst = '1') then
			counter := 0;
			cpu_clock <= '0';
		elsif(rising_edge(clk)) then
			if(counter = 0) then
				cpu_clock <= not cpu_clock;
			end if;
			
			counter := counter + 1;
		end if;
	end process;
	
	cpu_process : process(cpu_clock, rst)
		variable program_counter : integer range 0 to 65535 := 0;
		variable current_opcode : opcode := (others => '0');
		variable current_opcode_int : integer range 0 to (2**opcode'length) - 1;
		variable temp_one : opcode;
		variable temp_two : opcode;
	begin
		if(rst = '1') then
			program_counter := 0;
		elsif(rising_edge(cpu_clock)) then
			if(program_counter < program'length) then
				current_opcode := program(program_counter);
				current_opcode_int := conv_integer(current_opcode);
				
				case current_opcode is
					when opcodes.noop =>
						null;
					when opcodes.porta => 
						program_counter := program_counter + 1;
						register_a(7 downto 0) <= program(program_counter);
					when opcodes.jump =>
						temp_one := program(program_counter + 1);
						temp_two := program(program_counter + 2);
						program_counter := conv_integer(temp_one & temp_two);
					when others =>
						null;
				end case;
				
				if(current_opcode /= opcodes.jump) then
					program_counter := program_counter + 1;
				end if;
			end if;
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

