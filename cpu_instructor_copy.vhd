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

	-- Component declaration for the CPU's memory
	COMPONENT memory
	  PORT (
		 clka  : IN STD_LOGIC;
		 wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dina  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	-- Scaled down clock for the CPU
	signal cpu_clock : std_logic := '0';
	
	-- Signals to interface with the memory
	signal mem_we       : std_logic_vector(0 downto 0) := (others => '0');
	signal mem_addr     : std_logic_vector(15 downto 0) := (others => '0');
	signal mem_data_in  : std_logic_vector(7 downto 0) := (others => '0');
	signal mem_data_out : std_logic_vector(7 downto 0);
	
	-- Two temp storage registers to modify data in
	signal register_a : std_logic_vector(7 downto 0) := (others => '0');
	signal register_b : std_logic_vector(7 downto 0) := (others => '0');
	
	-- All of the IO ports are 8 bit
	signal porta_buf : std_logic_vector(7 downto 0);
	signal portb_buf : std_logic_vector(7 downto 0);
	signal portc_buf : std_logic_vector(7 downto 0);
	signal portd_buf : std_logic_vector(7 downto 0);
	
	signal real_rst : std_logic;
	
	-- Map to various flags to identify things like overflow, negative, etc
	type flag_type is record
		a_overflow : std_logic;
		delay_count : integer range 0 to 31;
	end record;
	
	signal flags : flag_type;
	
	-- Each stack element needs to be 8 bits wide to match the opcode width
	type stack_type is array(0 to 255) of std_logic_vector(7 downto 0);
	
	-- The stack will store pointers to locations in the main program
	signal stack : stack_type := (others => (others => '0'));
	
	-- All opcodes are 8 bits wide
	subtype opcode is std_logic_vector(7 downto 0);
	
	-- All of the available opcodes must be defined here
	type opcodes_type is record
		noop  : opcode;
		movla : opcode;
		movaf : opcode;
		jump  : opcode;
	end record;
	
	-- All of the opcodes are given an 8-bit value here
	constant opcodes : opcodes_type := (
		-- Do nothing.  No extra args used.
		noop => "00000000",
		-- Move a value into register a.  Takes 2 more arguments that are the value to move in
		movla => "00000001", 
		-- Move data from the a register to memory.  Takes 2 more args that are the memory location
		movaf => "00000010",
		-- Move the program counter to a set location.  Takes 2 more args that are the location to move to
		jump=> "00000011"
	);
	
	-- Unbounded array of opcodes that will store the program
	type program_type is array(natural range <>) of opcode;
	
	-- The actual program
	constant program : program_type := (
		opcodes.movla,
		"10101010",
		opcodes.movaf,
		"00000000",
		"00000000",
		opcodes.noop,
		opcodes.movla,
		"01010101",
		opcodes.movaf,
		"00000000",
		"00000000",
		opcodes.noop,
		opcodes.movla,
		"11110000",
		opcodes.movaf,
		"00000000",
		"00000100",
		opcodes.noop,
		opcodes.jump,
		"00000000",
		"00000000"
	);
	
begin

	real_rst <= not rst;  -- For Mojo
--	real_rst <= rst;      -- For Nexys3

	porta <= porta_buf;
	portb <= portb_buf;
	portc <= portc_buf;
	portd <= portd_buf;
	

	clock_divider : process(clk, real_rst)
		variable counter : integer range 0 to 100000000/8 := 0;
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
	
	cpu_process : process(cpu_clock, real_rst)
		variable program_counter : integer range 0 to 65535 := 0;
		variable current_opcode : opcode := (others => '0');
		variable current_opcode_int : integer range 0 to (2**opcode'length) - 1;
		variable temp_one : opcode;
		variable temp_two : opcode;
		variable wide_buffer : std_logic_vector(15 downto 0);
	begin
		if(real_rst = '1') then
			program_counter := 0;
		elsif(rising_edge(cpu_clock)) then
			if(program_counter < program'length) then
				current_opcode := program(program_counter);
				current_opcode_int := conv_integer(current_opcode);
				
				if(mem_we = "1") then
					mem_we <= "0";
				end if;
				
				case current_opcode is
					when opcodes.noop =>
						-- Delay one cycle
						null;
					when opcodes.movla =>
						-- Move data from the next element in the program counter to register a
						program_counter := program_counter + 1;
						register_a <= program(program_counter);
					when opcodes.movaf =>
						program_counter := program_counter + 1;
						wide_buffer(15 downto 8) := program(program_counter);
						program_counter := program_counter + 1;
						wide_buffer(7 downto 0) := program(program_counter);
						
						if(conv_integer(wide_buffer) < 4) then
							case wide_buffer is
								when "0000000000000000" =>
									porta_buf <= register_a;
								when "0000000000000001" =>
									portb_buf <= register_a;
								when "0000000000000010" =>
									portc_buf <= register_a;
								when "0000000000000011" =>
									portd_buf <= register_a;
								when others =>
									-- This can't happen, but ISE still bitches about it
									null;
							end case;
						end if;
						
						mem_addr <= wide_buffer;
						mem_data_in <= register_a;
						mem_we <= "1";
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

