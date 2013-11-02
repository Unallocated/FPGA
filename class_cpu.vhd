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
--
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
		lrra  => "00001011"
	);
	
	type program_type is array(natural range <>) of opcode;
	
	constant program : program_type := (
		opcodes.mova,
		"01111110",
		opcodes.lrra,
		"00000001",
		opcodes.movaf,
		"00000000",
		"00000000",
		opcodes.jmp,
		"00000000",
		"00000010"
	);
	
begin

	real_rst <= not rst;
	
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
	begin
		if(real_rst = '1') then
			pc := 0;
		elsif(rising_edge(cpu_clock)) then
			if(pc < program'high) then
				current_opcode := program(pc);
				current_opcode_int := conv_integer(current_opcode);
				
				if(mem_we = "1") then
					mem_we <= "0";
				end if;
				
				case current_opcode is
					when opcodes.noop =>
						null;
					when opcodes.jmp =>
						pc := pc + 1;
						wide_buffer(15 downto 8) := program(pc);
						pc := pc + 1;
						wide_buffer(7 downto 0) := program(pc);
						pc := conv_integer(wide_buffer);
					when opcodes.porta =>
						pc := pc + 1;
						porta_buf <= program(pc);
					when opcodes.mova =>
						pc := pc + 1;
						register_a <= program(pc);
					when opcodes.movaf =>
						pc := pc + 1;
						wide_buffer(15 downto 8) := program(pc);
						pc := pc + 1;
						wide_buffer(7 downto 0) := program(pc);
						
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
					when opcodes.adda =>
						pc := pc + 1;
						register_a <= conv_std_logic_vector(conv_integer(program(pc)) + conv_integer(register_a), 8);
					when opcodes.suba =>
						pc := pc + 1;
						register_a <= conv_std_logic_vector(conv_integer(register_a) - conv_integer(program(pc)), 8);
						
						
--					when opcodes.lsla =>
--						pc := pc + 1;
--						register_a <= conv_std_logic_vector(conv_integer(register_a) * (2**conv_integer(program(pc))),8);
					when opcodes.lsla =>
						pc := pc + 1;
						register_a <= std_logic_vector(unsigned(register_a) sll conv_integer(program(pc)));
						
						
--					when opcodes.lsra =>
--						pc := pc + 1;
--						register_a <= conv_std_logic_vector(conv_integer(register_a) / (2**conv_integer(program(pc))),8);
					when opcodes.lsra =>
						pc := pc + 1;
						register_a <= std_logic_vector(unsigned(register_a) srl conv_integer(program(pc)));
					
					
					when opcodes.mula =>
						pc := pc + 1;
						register_a <= conv_std_logic_vector(conv_integer(register_a) * conv_integer(program(pc)),8);
					when opcodes.lrla =>
						pc := pc + 1;
						narrow_buffer_int := conv_integer(program(pc)) mod 8;
						
						if(narrow_buffer_int /= 0) then
							register_a <= register_a(7 - narrow_buffer_int downto 0) & 
										register_a(7 downto 8 - narrow_buffer_int);
						end if;
					when opcodes.lrra =>
						pc := pc + 1;
						narrow_buffer_int := conv_integer(program(pc)) mod 8;
						
						if(narrow_buffer_int /= 0) then
							register_a <= register_a(narrow_buffer_int - 1 downto 0) &
										register_a(7 downto narrow_buffer_int);
						end if;
					
					when others =>
						null;
				end case;
				
				if(current_opcode /= opcodes.jmp) then
					pc := pc + 1;
				end if;
			end if;
		end if;
	end process;

	clock_divider : process(clk, real_rst)
		variable counter : integer range 0 to 100000000/30 := 0;
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

