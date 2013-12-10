library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.conv_integer;
use IEEE.STD_LOGIC_ARITH.conv_std_logic_vector;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.ceil;

Library UNISIM;
use UNISIM.vcomponents.all;

entity cpu_instructor_copy is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           porta : inout  STD_LOGIC_VECTOR (7 downto 0);
           portb : inout  STD_LOGIC_VECTOR (7 downto 0);
           portc : inout  STD_LOGIC_VECTOR (7 downto 0);
           portd : inout  STD_LOGIC_VECTOR (7 downto 0);
--           serial_out : out STD_LOGIC;
           serial_in : in STD_LOGIC;
           prog_clk : in STD_LOGIC;
           prog_data : in STD_LOGIC;
           sram_sck : out STD_LOGIC;
           sram_so : out STD_LOGIC;
           sram_si : in STD_LOGIC;
           sram_cs_n : out STD_LOGIC);
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
	
	COMPONENT rx_fifo
	  PORT (
	    rst : IN STD_LOGIC;
	    wr_clk : IN STD_LOGIC;
	    rd_clk : IN STD_LOGIC;
	    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    wr_en : IN STD_LOGIC;
	    rd_en : IN STD_LOGIC;
	    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	    full : OUT STD_LOGIC;
	    wr_ack : OUT STD_LOGIC;
	    empty : OUT STD_LOGIC;
	    rd_data_count : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT serial_rx
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		rx : IN std_logic;          
		new_data : OUT std_logic;
		data : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT sram
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		si : IN std_logic;
		data_in : IN std_logic_vector(7 downto 0);
		start : IN std_logic;
		we : IN std_logic;
		addr : IN std_logic_vector(23 downto 0);          
		data_out : OUT std_logic_vector(7 downto 0);
		so : OUT std_logic;
		done : OUT std_logic;
		sck : OUT std_logic;
		cs_n : OUT std_logic
		);
	END COMPONENT;
	
	signal cpu_clock : std_logic := '0';
	signal real_rst : std_logic;
	
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
	
	signal en : std_logic := '0';
	signal divisor_data : std_logic_vector(7 downto 0) := (others => '0');
	signal dividend_data : std_logic_vector(7 downto 0) := (others => '0');
	signal data_out : std_logic_vector(7 downto 0);
	
	signal sram_clk : std_logic := '0';
	signal sram_data_in : std_logic_vector(7 downto 0) :=  (others => '0');
	signal sram_start : std_logic := '0';
	signal sram_we : std_logic := '0';
	signal sram_addr : std_logic_vector(23 downto 0) := (others => '0');
	signal sram_data_out : std_logic_vector(7 downto 0) := (others => '0');
	signal sram_done : std_logic := '0';
	
	
	constant in_test_mode : std_logic := '0';
	constant base_clock_rate_hz : integer := 100000000;
	constant test_mode_divider : integer := base_clock_rate_hz;
	constant normal_mode_divider : integer := 65536;
	constant sram_test_mode_divider : integer := 2;
	constant sram_normal_mode_divider : integer := normal_mode_divider / 2;
--	constant sram_clock_target_hz : integer := 20000000;
--	constant sram_clock_divider : integer := integer(ceil(real(base_clock_rate_hz) / real(sram_clock_target_hz)));
	
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
		push : opcode;   -- push register_a to the stack (1 byte instr)
		pop  : opcode;   -- pop register_a from the stack (1 byte instr)
		diva  : opcode;   -- divide regiter_a by the next byte (2 byte instr)
		divaf : opcode;
		tris  : opcode;
		addcaf: opcode;
		rdser : opcode;
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
		jagtf => "00100011",
		push  => "00100100",
		pop   => "00100101",
		diva  => "00100110",
		divaf => "00100111",
		tris  => "00101000",
		addcaf=> "00101001",
		rdser => "00101010"
	);
	
	signal stack_origin : integer := conv_integer(x"8000");
	
--	type program_type is array(0 to 511) of opcode;
	type program_type is array(natural range <>) of opcode;
	
	constant program : program_type := (
		opcodes.mova, x"7e",
		opcodes.movaf, x"80", x"00",
		opcodes.mova, x"00",
		opcodes.movfa, x"80", x"00",
		opcodes.movaf, x"00", x"00"
	);

	signal programmed : std_logic := '1';
	
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
	
	signal rx_wr_clk : std_logic := '0';
	signal rx_wr_ack : std_logic := '0';
	signal rx_rd_clk : std_logic := '0';
	signal rx_din : std_logic_vector(7 downto 0);
	signal rx_wr_en : std_logic := '0';
	signal rx_rd_en : std_logic := '0';
	signal rx_dout : std_logic_vector(7 downto 0);
	signal rx_full : std_logic;
	signal rx_empty : std_logic;
	signal rx_data_count : std_logic_vector(5 downto 0);
	
	signal rx_data : std_logic_vector(7 downto 0);
	signal rx_new_data : std_logic;
	 
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
	
--	programmer : process(prog_clk)
--		constant start_flag : std_logic_vector(7 downto 0) := "01111110";
--		
--		type state_type is (wait_for_start, read_length, read_prog, done);
--		variable prog_pos : integer range 0 to program'high := 0;
--		variable data_length : integer range 0 to program'high := 0;
--		variable state : state_type := wait_for_start;
--		variable data : std_logic_vector(7 downto 0) := (others => '0');
--		variable data_pos : integer range 0 to 7 := 0;
--	begin
--		if(rising_edge(prog_clk)) then
--			data := data(6 downto 0) & prog_data;
--			if(data_pos = 7) then
--				data_pos := 0;
--				
--				if(state = wait_for_start) then
--					if(data = start_flag) then
--						state := read_length;
--					end if;
--				elsif(state = read_length) then
--					data_length := conv_integer(data);
--					state := read_prog;
--				elsif(state = read_prog) then
--					if(prog_pos = data_length - 1) then
--						programmed <= '1';
--						state := done;
--					else
--						program(prog_pos) <= data;
--						prog_pos := prog_pos + 1;
--					end if;
--				end if;
--			else
--				data_pos := data_pos + 1;
--			end if;
--		end if;
--	end process;
	
	brain : process(cpu_clock, real_rst)
		variable pc : integer := 0;
		variable current_opcode : opcode;
		variable current_opcode_int : integer range 0 to 255;
		variable delay : integer range 0 to 63 := 0;
		variable wide_buffer : std_logic_vector(15 downto 0);
		variable narrow_buffer : std_logic_vector(7 downto 0);
		variable stack_pointer : integer range 0 to (2**mem_addr'length) - 1 := stack_origin;
		
		
	begin
		
		if(real_rst = '1') then
			pc := 0;
			current_opcode := (others => '0');
			current_opcode_int := 0;
			delay := 0;
			wide_buffer := (others => '0');
			narrow_buffer := (others => '0');
			stack_pointer := stack_origin;
			
			dividend_data <= (others => '0');
			divisor_data <= (others => '0');
		elsif(programmed = '1' and rising_edge(cpu_clock)) then
			if(pc <= program'high) then
				if(delay = 0) then
					current_opcode := program(pc);
					current_opcode_int := conv_integer(current_opcode);
				end if;
				
				case current_opcode is
					
					when opcodes.noop =>
						null;
					when opcodes.jmp =>
						pc := conv_integer(program(pc + 1) & program(pc + 2)) - 1;
					when opcodes.mova =>
						pc := pc + 1;
						register_a <= program(pc);
					when opcodes.adda | opcodes.suba | opcodes.mula | opcodes.lrla | opcodes.lrra | opcodes.lsla | opcodes.lsra 
							| opcodes.ora | opcodes.xora | opcodes.anda | opcodes.nora | opcodes.xnora | opcodes.nanda =>
							
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
								register_a <= conv_std_logic_vector(conv_integer(register_a) * conv_integer(program(pc)), 8);
							when opcodes.lrla =>
								register_a <= std_logic_vector(unsigned(register_a) rol conv_integer(program(pc)));
							when opcodes.lrra => 
								register_a <= std_logic_vector(unsigned(register_a) ror conv_integer(program(pc)));
							when opcodes.lsla =>
								register_a <= std_logic_vector(unsigned(register_a) sll conv_integer(program(pc)));
							when opcodes.lsra =>
								register_a <= std_logic_vector(unsigned(register_a) srl conv_integer(program(pc)));
							when opcodes.ora =>
								register_a <= register_a or program(pc);
							when opcodes.xora =>
								register_a <= register_a xor program(pc);
							when opcodes.anda =>
								register_a <= register_a and program(pc);
							when opcodes.nora =>
								register_a <= register_a nor program(pc);
							when opcodes.xnora =>
								register_a <= register_a xnor program(pc);
							when opcodes.nanda =>
								register_a <= register_a nand program(pc);
							when others =>
								null;
						end case;
						
						
					when opcodes.movaf =>
						if(delay = 0) then
							sram_addr <= "00000000" & program(pc + 1) & program(pc + 2);
							sram_data_in <= register_a;
							sram_we <= '1';
							
							delay := 4;
						elsif(delay = 4) then
							sram_start <= '1';
							delay := 3;
						elsif(delay = 3) then
							if(sram_done = '0') then
								delay := 2;
								sram_start <= '0';
							end if;
						elsif(delay = 2) then
							if(sram_done = '1') then
								delay := 1;
							end if;			
						else
							sram_we <= '0';
							
							case conv_integer(program(pc + 1) & program(pc + 2)) is
								when 0 =>
									porta_input <= register_a;
								when 1 =>
									portb_input <= register_a;
								when 2 =>
									portc_input <= register_a;
								when 3 =>
									portd_input <= register_a;
								when 4 =>
									porta_direction <= not register_a;
								when 5 =>
									portb_direction <= not register_a;
								when 6 =>
									portc_direction <= not register_a;
								when 7 =>
									portd_direction <= not register_a;
								when others =>
									null;
							end case;
							pc := pc + 2;
							delay := 0;
						end if;				
						
						
--					when opcodes.movaf =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_data_in <= register_a;
--							
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "1";
--							delay := 1;
--						else
--							mem_we <= "0";
--							
--							case conv_integer(program(pc + 1) & program(pc + 2)) is
--								when 0 =>
--									porta_input <= register_a;
--								when 1 =>
--									portb_input <= register_a;
--								when 2 =>
--									portc_input <= register_a;
--								when 3 =>
--									portd_input <= register_a;
--								when 4 =>
--									porta_direction <= not register_a;
--								when 5 =>
--									portb_direction <= not register_a;
--								when 6 =>
--									portc_direction <= not register_a;
--								when 7 =>
--									portd_direction <= not register_a;
--								when others =>
--									null;
--							end case;
--							pc := pc + 2;
--							delay := 0;
--						end if;				
					
					
					when opcodes.movfa | opcodes.janef =>
						if(delay = 0) then
							sram_addr <= "00000000" & program(pc + 1) & program(pc + 2);
							sram_we <= '0';
							delay := 4;
						elsif(delay = 4) then
							sram_start <= '1';
							delay := 3;
						elsif(delay = 3) then
							if(sram_done <= '0') then
								sram_start <= '0';
								delay := 2;
							end if;
						elsif(delay = 2) then
							if(sram_done = '1') then
								delay := 1;
							end if;
						else
							
							delay := 0;
							
							case current_opcode is
								when opcodes.movfa =>
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
											register_a <= sram_data_out;
									end case;
									
									pc := pc + 2;
								when opcodes.janef =>
									if(register_a /= sram_data_out) then
										pc := conv_integer(program(pc + 1) & program(pc + 2)) - 1;
									else
										pc := pc + 2;
									end if;
								when others =>
									null;
							end case;
						end if;
					
					
--					when opcodes.movfa | opcodes.janef =>
--						if(delay = 0) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							mem_we <= "0";
--							delay := 2;
--						elsif(delay = 2) then
--							mem_addr <= program(pc + 1) & program(pc + 2);
--							delay := 1;
--						else
--							
--							delay := 0;
--							
--							case current_opcode is
--								when opcodes.movfa =>
--									case conv_integer(program(pc + 1) & program(pc + 2)) is
--										when 0 =>
--											register_a <= porta_output;
--										when 1 =>
--											register_a <= portb_output;
--										when 2 =>
--											register_a <= portc_output;
--										when 3 =>
--											register_a <= portd_output;
--										when 4 =>
--											register_a <= porta_direction;
--										when 5 =>
--											register_a <= portb_direction;
--										when 6 =>
--											register_a <= portc_direction;
--										when 7 =>
--											register_a <= portd_direction;
--										when others =>
--											register_a <= mem_data_out;
--									end case;
--									
--									pc := pc + 2;
--								when opcodes.janef =>
--									if(register_a /= mem_data_out) then
--										pc := conv_integer(program(pc + 1) & program(pc + 2)) - 1;
--									else
--										pc := pc + 2;
--									end if;
--								when others =>
--									null;
--							end case;
--						end if;
					when opcodes.janez | opcodes.jane =>
						wide_buffer := program(pc + 2) & program(pc + 3);
						
						
						case current_opcode is
							when opcodes.janez =>
								if(register_a /= "00000000") then
									pc := conv_integer(wide_buffer) - 1;
								end if;
							when opcodes.jane =>
								if(register_a /= program(pc + 1)) then
									pc := conv_integer(wide_buffer) - 1;
								end if;
							when others => 
								null;
						end case;
					
					when opcodes.addca =>
						pc := pc + 1;
						if(flags.carry = '1') then
							register_a <= conv_std_logic_vector(conv_integer(register_a) + conv_integer(program(pc)) + 1, 8);
						else
							register_a <= conv_std_logic_vector(conv_integer(register_a) + conv_integer(program(pc)), 8);
						end if;
					
					when opcodes.xoraf | opcodes.oraf | opcodes.andaf | opcodes.noraf | opcodes.xnoraf | opcodes.nandaf =>
						if(delay = 0) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							mem_we <= "0";
							delay := 2;
						elsif(delay = 2) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							delay := 1;
						else
							pc := pc + 2;
							delay := 0;
							case current_opcode is 
								when opcodes.xoraf =>
									register_a <= register_a xor mem_data_out;
								when opcodes.oraf => 
									register_a <= register_a or mem_data_out;
								when opcodes.andaf => 
									register_a <= register_a and mem_data_out;
								when opcodes.noraf => 
									register_a <= register_a nor mem_data_out;
								when opcodes.xnoraf => 
									register_a <= register_a xnor mem_data_out;
								when opcodes.nandaf => 
									register_a <= register_a nand mem_data_out;
								when others => 
									null;
							end case;
								
						end if;
					when opcodes.jagt =>
						if(conv_integer(register_a) > conv_integer(program(pc + 1))) then
							pc := conv_integer(program(pc + 2) & program(pc + 3)) - 1;
						else
							pc := pc + 3;
						end if;
					when opcodes.jagtf =>
						if(delay = 0) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							mem_we <= "0";
							delay := 2;
						elsif(delay = 2) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							delay := 1;
						else
							delay := 0;
							if(conv_integer(register_a) > conv_integer(mem_data_out)) then
								pc := conv_integer(program(pc + 3) & program(pc + 4)) - 1;
							else
								pc := pc + 4;
							end if;
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
					
					when opcodes.addaf | opcodes.subaf | opcodes.multaf | opcodes.addcaf =>
						if(delay = 0) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							mem_we <= "0";
							delay := 2;
						elsif(delay = 2) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							delay := 1;
						else
							pc := pc + 2;
							delay := 0;
							case current_opcode is
								when opcodes.addaf =>
									if(conv_integer(register_a) + conv_integer(mem_data_out) > 255) then
										flags.carry <= '1';
									else
										flags.carry <= '0';
									end if;
									register_a <= conv_std_logic_vector(conv_integer(register_a) + conv_integer(mem_data_out), 8);
								when opcodes.addcaf =>
									if(flags.carry = '1') then
										if(conv_integer(register_a) + 1 + conv_integer(mem_data_out) > 255) then
											flags.carry <= '1';
										else
											flags.carry <= '0';
										end if;
										register_a <= conv_std_logic_vector(conv_integer(register_a) + 1 + conv_integer(mem_data_out), 8);
									else
										if(conv_integer(register_a) + conv_integer(mem_data_out) > 255) then
											flags.carry <= '1';
										else
											flags.carry <= '0';
										end if;
										register_a <= conv_std_logic_vector(conv_integer(register_a) + conv_integer(mem_data_out), 8);
									end if;
								when opcodes.subaf =>
									register_a <= conv_std_logic_vector(conv_integer(register_a) - conv_integer(mem_data_out), 8);
								when opcodes.multaf =>
									register_a <= conv_std_logic_vector(conv_integer(register_a) * conv_integer(mem_data_out), 8);
								when others =>
									null;
							end case;
						end if;
					when opcodes.divaf =>
						if(delay = 0) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							mem_we <= "0";
							delay := 32;
						elsif(delay = 32) then
							mem_addr <= program(pc + 1) & program(pc + 2);
							delay := 31;
						elsif(delay = 31) then
							pc := pc + 2;
						
							dividend_data(7 downto 0) <= register_a;
							divisor_data(7 downto 0) <= mem_data_out;
							delay := 30;
						elsif(delay = 30) then
							en <= '1';
							delay := 29;
						elsif(delay < 30 and delay > 1) then
							delay := delay - 1;
						elsif(delay = 1) then
							register_a <= data_out(7 downto 0);
							delay := 0;
							en <= '0';
						end if;
					when opcodes.diva =>
						if(delay = 0) then
							dividend_data(7 downto 0) <= register_a;
							divisor_data(7 downto 0) <= program(pc + 1);
							delay := 30;
						elsif(delay = 30) then
							en <= '1';
							delay := 29;
						elsif(delay < 30 and delay > 1) then
							delay := delay - 1;
						elsif(delay = 1) then
								register_a <= data_out(7 downto 0);
								delay := 0;
								en <= '0';
								pc := pc + 1;
						end if;
					when opcodes.rdser =>
						if(delay = 0) then
--							porta_input <= "00001111";
							if(rx_empty = '1') then
								delay := 1;
							else
								rx_rd_en <= '1';
								delay := 2;
							end if;
						elsif(delay = 1) then
							if(rx_empty = '0') then
								delay := 2;
							end if;
--							porta_input <= "11110000";
						elsif(delay = 2) then
							rx_rd_en <= '0';
--							porta_input <= "11111111";
							register_a <= rx_dout;
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
	
	rx_serial_proc : process(clk, real_rst)
		variable last_new_data_value : std_logic := '0';
		variable state : std_logic_vector(1 downto 0) := "00";
	begin
		if(real_rst = '1') then
			state := "00";
		elsif(rising_edge(clk)) then
			case state is 
				when "00" =>
					if(last_new_data_value /= rx_new_data) then
						last_new_data_value := rx_new_data;
						
						if(rx_new_data = '1') then
							rx_din <= rx_data;
							state := "01";
						end if;
					end if;
				when "01" =>
					rx_wr_en <= '1';
					state := "10";
				when "10" =>
					rx_wr_en <= '0';
					state := "00";
				when others => 
					null;
			end case;
		end if;
	end process;

	clock_divider_proc : process(clk, real_rst)
		variable counter : integer := 0;
	begin
		if(real_rst = '1') then
			counter := 0;
			cpu_clock <= '0';
		elsif(rising_edge(clk)) then
			if(in_test_mode = '1') then
				if(counter = base_clock_rate_hz / test_mode_divider) then
					cpu_clock <= not cpu_clock;
					counter := 0;
				else
					counter := counter  + 1;
				end if;
			else
				if(counter = base_clock_rate_hz / normal_mode_divider) then
					cpu_clock <= not cpu_clock;
					counter := 0;
				else
					counter := counter  + 1;
				end if;
			end if;
		end if;
	end process;
	
	sram_clock_divider_proc : process(clk, real_rst)
		variable counter : integer := 0;
	begin
		if(real_rst = '1') then
			counter := 0;
			sram_clk <= '0';
		elsif(rising_edge(clk)) then
			if(in_test_mode = '1') then
				if(counter = base_clock_rate_hz / sram_test_mode_divider) then
					sram_clk <= not sram_clk;
					counter := 0;
				else
					counter := counter  + 1;
				end if;
			else
				if(counter = base_clock_rate_hz / sram_normal_mode_divider) then
					sram_clk <= not sram_clk;
					counter := 0;
				else
					counter := counter  + 1;
				end if;
			end if;
		end if;
	end process;

--	cpu_clock <= clk;
	cpu_memory : memory
	  PORT MAP (
		 clka => cpu_clock,
		 wea => mem_we,
		 addra => mem_addr,
		 dina => mem_data_in,
		 douta => mem_data_out
	  );
	  
	your_instance_name : cpu_divider
		port map (
			clk => cpu_clock,
			ce => en,
			rfd => open,
			dividend => dividend_data,
			divisor => divisor_data,
			quotient => data_out,
			fractional => open);
			
	serial_in_fifo : rx_fifo
	  PORT MAP (
	    rst => real_rst,
	    wr_clk => clk,
	    rd_clk => cpu_clock,
	    din => rx_din,
	    wr_en => rx_wr_en,
	    rd_en => rx_rd_en,
	    dout => rx_dout,
	    full => rx_full,
	    wr_ack => rx_wr_ack,
	    empty => rx_empty,
	    rd_data_count => rx_data_count
	  );
	  
	  serial_rx_comp : serial_rx PORT MAP(
		clk => clk,
		rst => real_rst,
		rx => serial_in,
		new_data => rx_new_data,
		data => rx_data
	);
	
	sram_instance : sram PORT MAP(
		clk => sram_clk,
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

