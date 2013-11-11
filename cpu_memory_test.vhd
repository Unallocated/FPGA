library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.conv_integer;
use IEEE.STD_LOGIC_ARITH.conv_std_logic_vector;
use IEEE.NUMERIC_STD.all;

entity cpu_memory_test is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           porta : inout  STD_LOGIC_VECTOR (7 downto 0);
           portb : inout  STD_LOGIC_VECTOR (7 downto 0);
           portc : inout  STD_LOGIC_VECTOR (7 downto 0);
           portd : inout  STD_LOGIC_VECTOR (7 downto 0));
end cpu_memory_test;

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
-- Always increment program counter (allow negative)  DONE
-- Always set mem_we to zero on the rising edge  DONE
--
-- overflow/underflow flag
-- reg_a, reg_b is zero flag
-- adda (2 byte)  DONE
-- suba (2 byte)  DONE
-- mula (2 byte)  DONE
-- lshifta (2 byte) DONE
-- rshifta (2 byte) DONE
-- lror (2 bytes)
-- rror (2 bytes)   
-- flags record
-- jump if ne to (value to be ne to), (program_loc)

-- testing zero not zero flag (daniel and tony)

-- stack does not get zeroed out as things are popped off.  
-- instead, just update the stack pointer (decriment)

-- put zero at the top of the stack or have an instruction that
-- defines where the program actually starts

-- program positions added to the stack should be one greater than
-- the location of the program counter at time of branch. 

-- push stack into memory
-- memory address pointers for 16,32, etc bits - tony
-- locations in memory that are for 16, 32, etc bit math - martin

architecture Behavioral of cpu_memory_test is

	COMPONENT memory_wrapper
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		start : IN std_logic;
		data_in : IN std_logic_vector(7 downto 0);
		addr : IN std_logic_vector(15 downto 0);
		we : IN std_logic;          
		data_out : OUT std_logic_vector(7 downto 0);
		done : OUT std_logic
		);
	END COMPONENT;
	
	signal cpu_clock : std_logic := '0';
	signal real_rst : std_logic;
	
	signal porta_buf : std_logic_vector(7 downto 0);
	signal portb_buf : std_logic_vector(7 downto 0);
	signal portc_buf : std_logic_vector(7 downto 0);
	signal portd_buf : std_logic_vector(7 downto 0);
	
	type flags_type is record
		carry : std_logic;
	end record;
	
	signal flags : flags_type := (
		carry => '0'
	);
	
	signal register_a : std_logic_vector(7 downto 0) := (others => '0');
	
	signal mem_we : std_logic_vector(0 downto 0) := (others => '0');
	signal mem_addr : std_logic_vector(15 downto 0) := (others => '0');
	signal mem_data_in : std_logic_vector(7 downto 0) := (others => '0');
	signal mem_data_out : std_logic_vector(7 downto 0);
	signal mem_start : std_logic := '0';
	signal mem_done : std_logic := '0';
	
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
		movfa : opcode;   -- move a value from memory into register_a (3 byte instr)
		janez : opcode;   -- jump if register_a is not zero (3 byte instr)
		jane  : opcode;   -- jump if register_a is not equal to the next byte (4 byte instr)
		janef : opcode;   -- jump if register_a is not equal to the value in memory location f (4 byte instr)
		addca : opcode;   -- add the carry bit and next byte to register_a (1 byte instr)
		call  : opcode;   -- call a function (3 byte instr)
		ret   : opcode;   -- return from a function (1 bye instr)
		addaf : opcode;   -- add the value in memory address to register_a (3 byte instr)
		subaf : opcode;   -- subtract the value in memory address from register_a (3 byte instr)
		multaf: opcode;   -- multiply register_a by the value in memory adddress (3 byte instr)
		xora  : opcode;   -- xor register_a with the next byte (2 byte instr)
		ora   : opcode;   -- or register_a with the next byte (2 byte instr)
		anda  : opcode;   -- and register_a with the next byte (2 byte instr)
		nora  : opcode;   -- nor register_a with the next byte (2 byte instr)
		xnora : opcode;   -- xnor register_a with the next byte (2 byte instr)
		nanda : opcode;   -- nand register_a with the next byte (2 byte instr)
		xoraf : opcode;   -- xor register_a with the value in memory address (3 byte instr)
		oraf  : opcode;   -- or register_a with the value in memory address (3 byte instr)
		andaf : opcode;   -- and register a with the value in memory address (3 byte instr)
		noraf : opcode;   -- nor register_a with the value in memory address (3 byte instr)
		xnoraf: opcode;   -- xnor register_a with the value in memory address (3 byte instr)
		nandaf: opcode;   -- nand register_a with the value in memory address (3 byte instr)
		jagt  : opcode;   -- jump if register_a is greater than the next byte (4 btye instr)
		jagtf : opcode;   -- jump if register_a is greater than the value in memory location (5 byte instr)
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
		addaf => "00010011",
		subaf => "00010100",
		multaf=> "00010101",
		xora  => "00010110",
		ora   => "00010111",
		anda  => "00011000",
		nora  => "00011001",
		xnora => "00011010",
		nanda => "00011011",
		xoraf => "00011100",
		oraf  => "00011101",
		andaf => "00011110",
		noraf => "00011111",
		xnoraf=> "00100000",
		nandaf=> "00100001",
		jagt  => "00100010",
		jagtf => "00100011"
	);
	
	constant stack_origin : integer := conv_integer(x"8000");
	
	type program_type is array(natural range <>) of opcode;
	
	constant program : program_type := (
		opcodes.jmp,x"00",x"03", --  0 -> 2
		opcodes.mova,x"ff", --  3 -> 4
		opcodes.movaf,x"40",x"00", --  5 -> 7
		opcodes.mova,x"0f", --  8 -> 9
		opcodes.movaf,x"00",x"00", --  10 -> 12
		opcodes.movfa,x"40",x"00", --  13 -> 15
		opcodes.movaf,x"00",x"00"
	);

--   1 + 2 + 16 +32
-- 00110011
	
begin

	real_rst <= rst;
	
	porta <= porta_buf;
	portb <= portb_buf;
	portc <= portc_buf;
	portd <= portd_buf;
	
	porta_buf(7) <= mem_done;
	portb_buf <= mem_addr(15 downto 8);
	portc_buf <= mem_addr(7 downto 0);
	portd_buf <= mem_data_in;
--	porta_buf <= (others => flags.carry);
	
	brain : process(cpu_clock, real_rst)
		variable pc : integer range 0 to program'length + 1:= 0;
		variable current_opcode : opcode;
		variable current_opcode_int : integer range 0 to 255;
		variable delay : integer range 0 to 15 := 0;
		variable wide_buffer : std_logic_vector(15 downto 0);
		variable wide_buffer_int : integer range 0 to (2**16) - 1 := 0;
		variable narrow_buffer : std_logic_vector(7 downto 0);
		variable narrow_buffer_int : integer range 0 to (2**8) - 1 := 0;
		variable stack_pointer : integer range 0 to (2**mem_addr'length) - 1 := stack_origin;
	begin
--		porta_buf <= conv_std_logic_vector(stack_pointer, 8);
		if(real_rst = '1') then
			pc := 0;
			stack_pointer := stack_origin;
		elsif(rising_edge(cpu_clock)) then
			if(delay = 0) then
				current_opcode := program(pc);
				current_opcode_int := conv_integer(current_opcode);
			end if;
			
			if(pc < program'high) then
				
				case current_opcode is
					when opcodes.noop =>
						null;
					when opcodes.jmp =>
						pc := conv_integer(program(pc + 1) & program(pc + 2)) - 1;
					when opcodes.mova =>
						pc := pc + 1;
						register_a <= program(pc);
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
					when opcodes.movaf =>
						if(delay = 0) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							mem_data_in <= register_a;
							mem_we <= "1";
							mem_start <= '1';
							wide_buffer_int := conv_integer(program(pc + 1) & program(pc + 2));
							
							delay := 2;
						elsif(delay = 2) then
							delay := 1;
						elsif(delay = 1) then
							mem_start <= '0';
							if(mem_done = '1') then
								mem_we <= "0";
								pc := pc + 2;
								case wide_buffer_int is
									when 0 =>
										porta_buf(6 downto 0) <= register_a(6 downto 0);
--									when 1 =>
--										portb_buf <= register_a;
--									when 2 =>
--										portc_buf <= register_a;
	--								when 3 =>
	--									portd_buf <= register_a;
									when others =>
										null;
								end case;
								
								delay := 0;
							end if;
						end if;
					when opcodes.movfa =>
						if(delay = 0) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							mem_we <= "0";
							mem_start <= '1';
							delay := 2;
						elsif(delay = 2) then
							delay := 1;
						else
							mem_start <= '0';
							if(mem_done = '1') then
								pc := pc + 2;
								register_a <= mem_data_out;
								delay := 0;
							end if;
						end if;
						
--					when opcodes.movaf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_data_in <= register_a;
--							wide_buffer_int := conv_integer(program(pc + 1) & program(pc + 2));
--							
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "1";
--							delay := 1;
--						else
--							mem_we <= "0";
--							pc := pc + 2;
--							case wide_buffer_int is
--								when 0 =>
--									porta_buf <= register_a;
--								when 1 =>
--									portb_buf <= register_a;
--								when 2 =>
--									portc_buf <= register_a;
----								when 3 =>
----									portd_buf <= register_a;
--								when others =>
--									null;
--							end case;
--							
--							delay := 0;
--						end if;				
--					when opcodes.movfa =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--							
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--						else
--							pc := pc + 2;
--							delay := 0;
--							register_a <= mem_data_out;
--						end if;
					when opcodes.janez =>
						pc := pc + 1;
						wide_buffer(15 downto 8) := program(pc);
						pc := pc + 1;
						wide_buffer(7 downto 0) := program(pc);
						if(register_a /= "00000000") then
							pc := conv_integer(wide_buffer) - 1;
						end if;
					when opcodes.jane =>
						pc := pc + 1;
						if(register_a /= program(pc)) then
							pc := pc + 1;
							wide_buffer(15 downto 8) := program(pc);
							pc := pc + 1;
							wide_buffer(7 downto 0) := program(pc);
							pc := conv_integer(wide_buffer) - 1;
						else
							pc := pc + 2;
						end if;
--					when opcodes.janef =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--							
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--						else
--							pc := pc + 2;
--							delay := 0;
--							if(register_a /= mem_data_out) then
--								pc := pc + 1;
--								wide_buffer(15 downto 8) := program(pc);
--								pc := pc + 1;
--								wide_buffer(7 downto 0) := program(pc);
--								pc := conv_integer(wide_buffer) - 1;
--							else
--								pc := pc + 2;
--							end if;
--						end if;
					when opcodes.addca =>
						pc := pc + 1;
						if(flags.carry = '1') then
							register_a <= conv_std_logic_vector(conv_integer(register_a) + conv_integer(program(pc)) + 1, 8);
						else
							register_a <= conv_std_logic_vector(conv_integer(register_a) + conv_integer(program(pc)), 8);
						end if;
--					when opcodes.call =>
--						if(delay = 0) then
--							mem_addr <= conv_std_logic_vector(stack_pointer, 16);
--							mem_data_in <= register_a;
--							delay := 8;
--						elsif(delay = 8) then
--							mem_addr <= conv_std_logic_vector(stack_pointer, 16);
--							mem_we <= "1";
--							delay := 7;
--							wide_buffer := conv_std_logic_vector(pc+3, 16);
--						elsif(delay = 7) then
--							mem_we <= "0";
--							delay := 6;
--						elsif(delay = 6) then
--							mem_addr <= conv_std_logic_vector(stack_pointer + 1, 16);
--							mem_data_in <= wide_buffer(15 downto 8);
--							delay := 5;
--						elsif(delay = 5) then
--							mem_addr <= conv_std_logic_vector(stack_pointer + 1, 16);
--							mem_we <= "1";
--							delay := 4;
--						elsif(delay = 4) then
--							mem_we <= "0";
--							delay := 3;
--						elsif(delay = 3) then
--							mem_addr <= conv_std_logic_vector(stack_pointer + 2, 16);
--							mem_data_in <= wide_buffer(7 downto 0);
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= conv_std_logic_vector(stack_pointer + 2, 16);
--							mem_we <= "1";
--							delay := 1;
--						elsif(delay = 1) then
--							mem_we <= "0";
--							delay := 0;
--							stack_pointer := stack_pointer + 3;
--							pc := conv_integer(program(pc + 1) & program(pc + 2)) - 1;
--						end if;
--					when opcodes.ret =>
--						if(delay = 0) then
--							if(stack_pointer = stack_origin) then
--								pc := program'high;
--								delay := 0;
--							else
--								mem_addr <= conv_std_logic_vector(stack_pointer - 3, 16);
--								mem_we <= "0";
--								delay := 8;
--							end if;
--						elsif(delay = 8) then
--							mem_addr <= conv_std_logic_vector(stack_pointer - 3, 16);
--							delay := 7;
--						elsif(delay = 7) then
--							register_a <= mem_data_out;
--							delay := 6;
--						elsif(delay = 6) then
--							mem_addr <= conv_std_logic_vector(stack_pointer - 2, 16);
--							mem_we <= "0";
--							delay := 5;
--						elsif(delay = 5) then
--							mem_addr <= conv_std_logic_vector(stack_pointer - 2, 16);
--							delay := 4;
--						elsif(delay = 4) then
--							wide_buffer(15 downto 8) := mem_data_out;
--							delay := 3;
--						elsif(delay = 3) then
--							mem_addr <= conv_std_logic_vector(stack_pointer - 1, 16);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= conv_std_logic_vector(stack_pointer - 1, 16);
--							delay := 1;
--						elsif(delay = 1) then
--							wide_buffer(7 downto 0) := mem_data_out;
--							pc := conv_integer(wide_buffer) - 1;
--							stack_pointer := stack_pointer - 3;
--							delay := 0;
--						end if;
--					when opcodes.addaf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--							
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							pc := pc + 2;
--							delay := 0;
--							narrow_buffer := conv_std_logic_vector(conv_integer(register_a) + conv_integer(mem_data_out), 8);
--							if(conv_integer(narrow_buffer) < narrow_buffer_int) then
--								flags.carry <= '1';
--							else
--								flags.carry <= '0';
--							end if;
--							
--							register_a <= narrow_buffer;
--							
--						end if;
--					when opcodes.subaf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							pc := pc + 2;
--							delay := 0;
--							register_a <= conv_std_logic_vector(conv_integer(register_a) - conv_integer(mem_data_out), 8);
--						end if;
--					when opcodes.multaf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							pc := pc + 2;
--							delay := 0;
--							register_a <= conv_std_logic_vector(conv_integer(register_a) * conv_integer(mem_data_out), 8);
--						end if;
					when opcodes.xora =>
						register_a <= register_a xor program(pc + 1);
						pc := pc + 1;
					when opcodes.ora =>
						register_a <= register_a or program(pc + 1);
						pc := pc + 1;
					when opcodes.anda =>
						register_a <= register_a and program(pc + 1);
						pc := pc + 1;
					when opcodes.nora =>
						register_a <= register_a nor program(pc + 1);
						pc := pc + 1;
					when opcodes.xnora =>
						register_a <= register_a xnor program(pc + 1);
						pc := pc + 1;
					when opcodes.nanda =>
						register_a <= register_a nand program(pc + 1);
						pc := pc + 1;
--					when opcodes.xoraf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							pc := pc + 2;
--							delay := 0;
--							register_a <= register_a xor mem_data_out;
--						end if;
--					when opcodes.oraf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							pc := pc + 2;
--							delay := 0;
--							register_a <= register_a or mem_data_out;
--						end if;
--					when opcodes.andaf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							pc := pc + 2;
--							delay := 0;
--							register_a <= register_a and mem_data_out;
--						end if;
--					when opcodes.noraf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							pc := pc + 2;
--							delay := 0;
--							register_a <= register_a nor mem_data_out;
--						end if;
--					when opcodes.xnoraf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							pc := pc + 2;
--							delay := 0;
--							register_a <= register_a xnor mem_data_out;
--						end if;
--					when opcodes.nandaf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							pc := pc + 2;
--							delay := 0;
--							register_a <= register_a nand mem_data_out;
--						end if;
--					when opcodes.jagt =>
--						if(conv_integer(register_a) > conv_integer(program(pc + 1))) then
--							pc := conv_integer(program(pc + 2) & program(pc + 3)) - 1;
--						else
--							pc := pc + 3;
--						end if;
--					when opcodes.jagtf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--							narrow_buffer_int := conv_integer(register_a);
--						else
--							delay := 0;
--							if(conv_integer(register_a) > conv_integer(mem_data_out)) then
--								pc := conv_integer(program(pc + 3) & program(pc + 4)) - 1;
--							else
--								pc := pc + 4;
--							end if;
--						end if;
					when others =>
						null;
				end case;
				
				if(delay = 0) then 
					pc := pc + 1;
				end if;
				
			end if;
		end if;
	end process;

--	clock_divider : process(clk, real_rst)
--		variable counter : integer range 0 to 100000000/4 := 0;
--	begin
--		if(real_rst = '1') then
--			counter := 0;
--			cpu_clock <= '0';
--		elsif(rising_edge(clk)) then
--			if(counter = 0) then
--				cpu_clock <= not cpu_clock;
--			end if;
--			
--			counter := counter + 1;
--		end if;
--	end process;

	cpu_clock <= clk;

	Inst_memory_wrapper: memory_wrapper PORT MAP(
		clk => cpu_clock,
		rst => real_rst,
		start => mem_start,
		data_in => mem_data_in,
		data_out => mem_data_out,
		addr => mem_addr,
		we => mem_we(0),
		done => mem_done
	);

end Behavioral;

