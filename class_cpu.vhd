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
           portd : inout  STD_LOGIC_VECTOR (7 downto 0);
			  sram_cs_n : out STD_LOGIC;
			  sram_si : in STD_LOGIC;
			  sram_sck : out STD_LOGIC;
			  sram_so : out STD_LOGIC);
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

	-- Xilinx divider IP core.  Divides 8-bit unsigned numbers
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

	-- The CPU currently uses on die RAM.  8 bit data across 65535 addresses (64KB)
	COMPONENT memory
	  PORT (
		 clka : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT sram
	Generic(
			avail_addr_width : integer
	);
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		si : IN std_logic;
		data_in : IN std_logic_vector(7 downto 0);
		start : IN std_logic;
		we : IN std_logic;
		addr : IN std_logic_vector;          
		data_out : OUT std_logic_vector(7 downto 0);
		so : OUT std_logic;
		done : OUT std_logic;
		sck : OUT std_logic;
		cs_n : OUT std_logic
		);
	END COMPONENT;
	
	-- We do not run the cpu at the FPGA base clock since 100/50Mhz is wayyy to fast for 
	-- troubleshooting.  Check the clock_divider process at the bottom for info.
	signal cpu_clock : std_logic := '0';
	
	-- Needed since the Mojo has an active low reset while the Nexys3 has an active
	-- high reset.  This signal is what all components will use for reset.
	-- For the Mojo, it will be set to ' not rst'.  
	-- For the Nexys3 it will be set to ' rst' (no inversion is required.)
	signal real_rst : std_logic;
	
	-- Currently the only general purpose register.
	signal register_a : std_logic_vector(7 downto 0) := (others => '0');
	
	-- Signals for accessing the memory
	signal mem_we : std_logic_vector(0 downto 0) := (others => '0');
	signal mem_addr : std_logic_vector(15 downto 0) := (others => '0');
	signal mem_data_in : std_logic_vector(7 downto 0) := (others => '0');
	signal mem_data_out : std_logic_vector(7 downto 0);
	
	-- Signals for interacting with the divider
	signal divider_ce : std_logic := '0';
	signal divider_divisor : std_logic_vector(7 downto 0);
	signal divider_dividend : std_logic_vector(7 downto 0);
	signal divider_quotient : std_logic_vector(7 downto 0);
	signal divider_fractional : std_logic_vector(7 downto 0);
	
	-- Signals for SPI memory
	signal sram_data_in : std_logic_vector(7 downto 0) := (others => '0');
	signal sram_start : std_logic := '0';
	signal sram_we : std_logic := '0';
	signal sram_data_out : std_logic_vector(7 downto 0) := (others => '0');
	signal sram_done : std_logic := '0';
	signal sram_addr : std_logic_vector(15 downto 0) := (others => '0');
	signal sram_clock : std_logic := '0';
	
	-- Flags type (currently just a carry bit)
	-- It is a record for ease of extension later on
	type flags_type is record
		carry : std_logic;
	end record;
	
	-- Actual register that will hold the carry bit
	signal flags : flags_type := (
		carry => '0'
	);
	
	type registers_t is record
		r0 : std_logic_vector(15 downto 0);
		r1 : std_logic_vector(15 downto 0);
	end record;
	
	signal registers : registers_t := (others => (others => '0'));
	
	-- All opcodes are just 8 bit vectors.  This makes it easier
	-- to define a signal as an opcode.  Much faster than having to
	-- write out std_logic_vector(7 downto 0) for each opcode!
	subtype opcode is std_logic_vector(7 downto 0);
	
	-- Holds all of the opcodes for the CPU.  This is just the
	-- skeleton.  The definitions are below.
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
		xora  : opcode;   -- xor register_a with the next byte (2 byte instr)
		ora   : opcode;   -- or register_a with the next byte (2 byte instr)
		anda  : opcode;   -- and register_a with the next byte (2 byte instr)
		nora  : opcode;   -- nora register_a with the next byte (2 byte instr)
		xnora : opcode;   -- xnora register_a with the next byte (2 byte instr)
		movrl : opcode;   -- move a value directly into register X's low byte (3 byte instr)
		movrh : opcode;   -- move a value directly into register X's high byte (3 byte instr)
		movrla: opcode;   -- move register X's low byte to register_a (2 byte instr)
		movrha: opcode;   -- move register X's high byte to register_a (2 byte instr)
		movarl: opcode;   -- move register_a to the low byte of register X (2 byte instr)
		movarh: opcode;   -- move register_a to the high byte of register X (2 byte instr)
		movpaf: opcode;   -- move register_a to the memory location pointed to by register X (2 byte instr)
		movpfa: opcode;   -- move value from memory location pointed to by register X to register_a (2 byte instr)
	end record;
	
	-- Available opcodes.  Each opcode needs a unique value
	-- assigned to it.  For the most part it's just a one-up number.
	-- Numbers out of order are because the assembler script was 
	-- written before some of the opcodes.
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
		xora  => "00010111",
		ora   => "00011000",
		anda  => "00011001",
		nora  => "00011010",
		xnora => "00011011",
		push  => "00100100",
		pop   => "00100101",
		diva  => "00100110",
		moda  => "00100111",
		movrl => "00101000",
		movrh => "00101001",
		movrla=> "00101010",
		movrha=> "00101011",
		movarl=> "00101100",
		movarh=> "00101101",
		movpaf=> "00101110",
		movpfa=> "00101111"
	);
	
	-- Defines where the stack starts at in memory.
	constant stack_origin : integer := conv_integer(x"8000");
	
	-- The program is just an array of opcodes.  Set the type to
	-- be an unbounded array of opcodes.  The bound will be defined
	-- once the program is defined.
	type program_type is array(natural range <>) of opcode;
	
	-- The actual program that will be run by the CPU
	constant program : program_type := (
		opcodes.mova, x"7e",
		opcodes.movaf, x"00", x"00"
	);
	
	-- Each port on the CPU is bi-directional.  This means that a tri-state
	-- buffer is required to set the pins of each port to input or output.
	-- The portx_output signal is for sending data from the FPGA to the pins
	-- The portx_input signal is for reading data from the pins to the FPGA
	-- The portx_direction is for setting the pins to be outputs or inputs.  (0 = output, 1 = input)
	-- All ports default to outputs and all pins are set to output a zero.
	
	-- Tri-state buffer signals for port a
	signal porta_output : std_logic_vector(portb'range) := (others => '0');
	signal porta_input : std_logic_vector(portb'range) := (others => '0');
	signal porta_direction : std_logic_vector(porta'range) := (others => '0');
	
	-- Tri-state buffer signals for port b
	signal portb_output : std_logic_vector(portb'range) := (others => '0');
	signal portb_input : std_logic_vector(portb'range) := (others => '0');
	signal portb_direction : std_logic_vector(porta'range) := (others => '0');
	
	-- Tri-state buffer signals for port c
	signal portc_output : std_logic_vector(portc'range) := (others => '0');
	signal portc_input : std_logic_vector(portc'range) := (others => '0');
	signal portc_direction : std_logic_vector(portc'range) := (others => '0');
	
	-- Tri-state buffer signals for port d
	signal portd_output : std_logic_vector(portd'range) := (others => '0');
	signal portd_input : std_logic_vector(portd'range) := (others => '0');
	signal portd_direction : std_logic_vector(portd'range) := (others => '0');
	
begin
	-- The next 4 generate statements set up each pin of each port to connect to
	-- a tri-state buffer.  This allows each pin to be controlled independantly.
	-- Only the first generate statement will be commented.  The rest work the same way!

	-- Generate statements need a name
	BUF_GEN_PORTA:
	-- This is the same as a for loop in C 'for(int i = 0; i <= 7; i++)'
	for i in porta'range generate
		-- Create an instance of IOBUF for each pin in the port
		-- IOBUF comes from 'Library UNISIM; use UNISIM.vcomponents.all;'
		IOBUF_inst : IOBUF
			-- IOBUF allows for some generic definitions.  These are just defaults.
			generic map (
			   DRIVE => 12,
			   IOSTANDARD => "LVCMOS33",
			   SLEW => "SLOW")
			port map (
			   -- Buffer that will hold the value the FPGA wants to output to the pin
			   O => porta_output(i),     -- Buffer output
			   -- The actual inout port in the component (pins on the FPGA)
			   IO => porta(i),   -- Buffer inout port (connect directly to top-level port)
			   -- Buffer that will hold the value coming in from outside of the FPGA.
			   -- In the event that the pin is in output mode, this will be the value 
			   -- in the porta_output(i) buffer.
			   I => porta_input(i),     -- Buffer input
			   -- Buffer that determines the direction of this pin
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
			   O => portb_output(i),
			   IO => portb(i),
			   I => portb_input(i),
			   T => portb_direction(i)
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
			   O => portc_output(i),
			   IO => portc(i),
			   I => portc_input(i),
			   T => portc_direction(i)
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
			   O => portd_output(i),
			   IO => portd(i),
			   I => portd_input(i),
			   T => portd_direction(i)
			);
	end generate BUF_GEN_PORTD;

	-- Sets the actual reset value.  Needed since the Mojo uses an active low
	-- and the Nexys3 uses an active high.  Mojo would use 'real_rst <= not rst'.
	-- All components in this project assume active high resets!
	real_rst <= rst;
	
	brain : process(cpu_clock, real_rst)
		variable pc : integer range 0 to program'high + 1 := 0;
		variable current_opcode : opcode;
		variable wide_buffer : std_logic_vector(15 downto 0);
		variable wide_buffer_int : integer range 0 to (2**16) - 1 := 0;
		variable narrow_buffer : std_logic_vector(7 downto 0);
		variable narrow_buffer_int : integer range 0 to (2**8) - 1 := 0;
		variable delay : integer range 0 to 31 := 0;
		variable stack_pointer : integer := stack_origin;
	begin
	
		if(real_rst = '1') then
			pc := 0;
			stack_pointer := stack_origin;
		elsif(rising_edge(cpu_clock)) then
			if(pc <= program'high) then
				if(delay = 0) then
					current_opcode := program(pc);
				end if;
				
				case current_opcode is
					when opcodes.noop =>
						null;
					when opcodes.jmp =>
						pc := conv_integer(program(pc + 1) & program(pc + 2)) - 1;
					when opcodes.mova =>
						pc := pc + 1;
						register_a <= program(pc);
						
					when opcodes.movaf | opcodes.movpaf =>
						if(delay = 0) then
							if(current_opcode = opcodes.movaf) then
								wide_buffer := program(pc + 1) & program(pc + 2);
							elsif(current_opcode = opcodes.movpaf) then
								case conv_integer(program(pc + 1)) is
									when 0 =>
										wide_buffer := registers.r0;
									when 1 =>
										wide_buffer := registers.r1;
									when others => 
										null;
								end case;
							end if;
							
							sram_addr <= wide_buffer;
							sram_data_in <= register_a;
							sram_we <= '1';
							
							delay := 2;
						elsif(delay = 2) then
							sram_start <= '1';
							if(sram_done = '0') then
								delay := 1;
								sram_start <= '0';
							end if;
						else
							if(sram_done = '1') then
								case conv_integer(wide_buffer) is
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
								
								if(current_opcode = opcodes.movaf) then
									pc := pc + 2;
								elsif(current_opcode = opcodes.movpaf) then
									pc := pc + 1;
								end if;
							
								delay := 0;
							end if;
						end if;
--					when opcodes.movaf | opcodes.movpaf =>
--						if(delay = 0) then
--							if(current_opcode = opcodes.movaf) then
--								wide_buffer := program(pc + 1) & program(pc + 2);
--							elsif(current_opcode = opcodes.movpaf) then
--								case conv_integer(program(pc + 1)) is
--									when 0 =>
--										wide_buffer := registers.r0;
--									when 1 =>
--										wide_buffer := registers.r1;
--									when others => 
--										null;
--								end case;
--							end if;
--							
--							mem_addr <= wide_buffer;
--							mem_data_in <= register_a;
--							
--							delay := 2;
--						elsif(delay = 2) then
--							mem_we <= "1";
--							delay := 1;
--						else
--							mem_we <= "0";
--							
--							case conv_integer(wide_buffer) is
--								when 0 =>
--									porta_input <= register_a;
--								when 1 =>
--									portb_input <= register_a;
--								when 2 =>
--									portc_input <= register_a;
--								when 3 =>
--									portd_input <= register_a;
--								when 4 =>
--									porta_direction <= register_a;
--								when 5 =>
--									portb_direction <= register_a;
--								when 6 =>
--									portc_direction <= register_a;
--								when 7 =>
--									portd_direction <= register_a;
--								when others =>
--									null;
--							end case;
--							
--							if(current_opcode = opcodes.movaf) then
--								pc := pc + 2;
--							elsif(current_opcode = opcodes.movpaf) then
--								pc := pc + 1;
--							end if;
--							
--							delay := 0;
--						end if;
						
					-- adda, suba, mula
					when opcodes.adda | opcodes.suba | opcodes.mula | opcodes.addca =>
						pc := pc + 1;
						case current_opcode is
							when opcodes.adda =>
								if(conv_integer(program(pc)) + conv_integer(register_a) > 255) then
									flags.carry <= '1';
								else
									flags.carry <= '0';
								end if;
								register_a <= conv_std_logic_vector(conv_integer(program(pc)) + conv_integer(register_a), 8);
							when opcodes.suba =>
								register_a <= conv_std_logic_vector(conv_integer(register_a) - conv_integer(program(pc)), 8);
							when opcodes.mula =>
								register_a <= conv_std_logic_vector(conv_integer(register_a) * conv_integer(program(pc)),8);
							when opcodes.addca =>
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
							when others => 
								null;
						end case;
					
					-- lsla, lsra, lrla, lrra
					when opcodes.lsla | opcodes.lsra | opcodes.lrla | opcodes.lrra =>
						pc := pc + 1;
						case current_opcode is
							when opcodes.lsla =>
								register_a <= std_logic_vector(unsigned(register_a) sll conv_integer(program(pc)));
							when opcodes.lsra =>
								register_a <= std_logic_vector(unsigned(register_a) srl conv_integer(program(pc)));
							when opcodes.lrla =>
								register_a <= std_logic_vector(unsigned(register_a) rol conv_integer(program(pc)));
							when opcodes.lrra =>
								register_a <= std_logic_vector(unsigned(register_a) ror conv_integer(program(pc)));
							when others =>
								null;
						end case;
					
					when opcodes.movfa | opcodes.movpfa =>
						if(delay = 0) then
							if(current_opcode = opcodes.movfa) then
								wide_buffer := program(pc + 1) & program(pc + 2);
							else
								case conv_integer(program(pc + 1)) is
									when 0 =>
										wide_buffer := registers.r0;
									when 1 =>
										wide_buffer := registers.r1;
									when others => 
										null;
								end case;
							end if;
								
								
							sram_addr <= wide_buffer;
							sram_we <= '0';
							
							delay := 2;
						elsif(delay = 2) then
							sram_start <= '1';
							if(sram_done = '0') then
								sram_start <= '0';
								delay := 1;
							end if;
						else
							if(sram_done = '1') then
								case conv_integer(wide_buffer) is
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
								
								if(current_opcode = opcodes.movfa) then
									pc := pc + 2;
								else
									pc := pc + 1;
								end if;
								
								delay := 0;
							end if;
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
						
					-- diva, moda
					when opcodes.diva | opcodes.moda =>
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
							case current_opcode is
								when opcodes.diva =>
									register_a <= divider_quotient;
								when opcodes.moda =>
									register_a <= divider_fractional;
								when others =>
									null;
							end case;
							divider_ce <= '0';
							pc := pc + 1;
							delay := 0;
						end if;
					
					-- xora, ora, anda, nora, xnora
					when opcodes.xora | opcodes.ora | opcodes.anda | opcodes.nora | opcodes.xnora =>
						pc := pc + 1;
						case current_opcode is 
							when opcodes.xora =>
								register_a <= program(pc) xor register_a;
							when opcodes.ora =>
								register_a <= program(pc) or register_a;
							when opcodes.anda =>
								register_a <= program(pc) and register_a;
							when opcodes.nora =>
								register_a <= program(pc) nor register_a;
							when opcodes.xnora =>
								register_a <= program(pc) xnor register_a;
							when others =>
								null;
						end case;
					
					when opcodes.movrl =>
						case conv_integer(program(pc + 1)) is
							when 0 =>
								registers.r0(7 downto 0) <= program(pc + 2);
							when 1 =>
								registers.r1(7 downto 0) <= program(pc + 2);
							when others =>
								null;
						end case;
						
						pc := pc + 2;
					
					when opcodes.movrh =>
						case conv_integer(program(pc + 1)) is
							when 0 =>
								registers.r0(15 downto 8) <= program(pc + 2);
							when 1 =>
								registers.r1(15 downto 8) <= program(pc + 2);
							when others =>
								null;
						end case;
						
						pc := pc + 2;
					
					when opcodes.movrla =>
						case conv_integer(program(pc + 1)) is
							when 0 =>
								register_a <= registers.r0(7 downto 0);
							when 1 =>
								register_a <= registers.r1(7 downto 0);
							when others =>
								null;
						end case;
						
						pc := pc + 1;
						
					when opcodes.movrha =>
						case conv_integer(program(pc + 1)) is
							when 0 =>
								register_a <= registers.r0(15 downto 8);
							when 1 =>
								register_a <= registers.r1(15 downto 8);
							when others =>
								null;
						end case;
						
						pc := pc + 1;
						
					when opcodes.movarl =>
						case conv_integer(program(pc + 1)) is
							when 0 =>
								registers.r0(7 downto 0) <= register_a;
							when 1 =>
								registers.r1(7 downto 0) <= register_a;
							when others =>
								null;
						end case;
						
						pc := pc + 1;
						
					when opcodes.movarh =>
						case conv_integer(program(pc + 1)) is
							when 0 =>
								registers.r0(15 downto 8) <= register_a;
							when 1 =>
								registers.r1(15 downto 8) <= register_a;
							when others =>
								null;
						end case;
						
						pc := pc + 1;
					
					when others =>
						null;
				end case;
				
				if(delay = 0) then
					pc := pc + 1;
				end if;
			end if;
		end if;
	end process;

	cpu_clock_divider : process(clk, real_rst)
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
	
	sram_clock_divider : process(clk, real_rst)
		variable counter : integer range 0 to 100000000/32 := 0;
	begin
		if(real_rst = '1') then
			counter := 0;
			sram_clock <= '0';
		elsif(rising_edge(clk)) then
			if(counter = 0) then
				sram_clock <= not sram_clock;
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
	  
	 spi_memory : sram 
	 Generic map (
		avail_addr_width => 16
	 )
	 PORT MAP(
		clk => sram_clock,
		rst => real_rst,
		si => sram_si,
		data_in => sram_data_in,
		start => sram_start,
		we => sram_we,
		addr => sram_addr,
		data_out => sram_data_out,
		so => sram_so,
		done => sram_done,
		sck => sram_sck,
		cs_n => sram_cs_n
	);

end Behavioral;

