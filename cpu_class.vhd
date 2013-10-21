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
	
	signal register_a : std_logic_vector(7 downto 0) := (others => '0');
	signal register_b : std_logic_vector(7 downto 0) := (others => '0');
	
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
		loada : opcode;
		jump : opcode;
	end record;
	
	constant opcodes : opcodes_type := (
		noop => "00000000",  -- no extra registers used
		adda => "00000001",    -- one extra byte that is the 8 bit value to add to register_a
		suba => "00000010",    -- one extra byte that is the 8 bit value to subtract from register_a
		multa => "00000011",   -- one extra byte that is the 8 bit value to multiply register_a by
		diva => "00000100",      -- one extra byte that is the 8 bit value to divide register_a by
		loada => "00000101",   -- one extra byte that is the 8 bit value to load into register_a
		jump => "00000110"
	);
	
	type program_type is array(natural range <>) of opcode;
	
	constant program : program_type := (
		opcodes.loada,
		"00001111",
		opcodes.noop,
		opcodes.noop,
		opcodes.loada,
		"10101010",
		opcodes.loada,
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
	
	porta_buf <= register_a;

	clock_divider : process(clk, rst)
		variable counter : integer range 0 to 100000000/2 := 0;
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
					when opcodes.loada => 
						program_counter := program_counter + 1;
						register_a <= program(program_counter);
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

