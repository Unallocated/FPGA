library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.conv_integer;

entity cpu is
    Port ( clk : in  STD_LOGIC;
              rst : in  STD_LOGIC;
              led : out  STD_LOGIC_VECTOR (7 downto 0));
end cpu;

architecture Behavioral of cpu is

	COMPONENT adder
	  PORT (
		 a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 clk : IN STD_LOGIC;
		 ce : IN STD_LOGIC;
		 s : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT mult
	  PORT (
		 clk : IN STD_LOGIC;
		 a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ce : IN STD_LOGIC;
		 p : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	-- Create a type that will contain 256 8-bit values
	type ram_type is array(0 to 255) of std_logic_vector(7 downto 0);
	-- Create the CPU's addressable memory
	signal ram : ram_type := (others => (others => '0'));
	
	-- Acts as the data regiser (sometimes called the 'w' register)
	signal data_buffer : std_logic_vector(7 downto 0) := (others => '0');
	
	-- Keeps track of location in the program
	signal program_counter : integer := 0;

	-- Define what opcodes are available
	type opcodes_type is record
		noop : std_logic_vector(11 downto 0);
		movlw : std_logic_vector(11 downto 0);
		add : std_logic_vector(11 downto 0);
		sub : std_logic_vector(11 downto 0);
		clr : std_logic_vector(11 downto 0);
		mult : std_logic_vector(11 downto 0);
		org : std_logic_vector(11 downto 0);
		movwf : std_logic_vector(11 downto 0);
		decw : std_logic_vector(11 downto 0);
		decf : std_logic_vector(11 downto 0);
		movfw : std_logic_vector(11 downto 0);
		btwc : std_logic_vector(11 downto 0);
	end record;
	
	-- Define the addresses for each opcode (first 4 bits only)
	constant opcodes : opcodes_type := (
		noop => "000000000000",
		movlw => "000100000000",
		add => "001000000000",
		sub => "001100000000",
		clr => "010000000000",
		mult => "010100000000",
		org => "011000000000",
		movwf => "011100000000",
		decw => "100000000000",
		decf => "100100000000",
		movfw => "101000000000",
		btwc => "101100000000");
		
	-- Slow this thing down a bit
	signal slow_clk : std_logic;
	
	-- Define a type that will hold instructions (not the same as memory!)
	type program_type is array (natural range <>) of std_logic_vector(11 downto 0);
	
	-- A program that will start at 11111111 and go to 00000000 before restarting the program
	constant decrement_program : program_type := (
		opcodes.movlw xor "000011111111",  -- load 11111111 into data_buffer
		opcodes.decw xor "000000000000",    -- decriment data_buffer
		opcodes.btwc xor "000000000000",     -- check to see if data_buffer is zero.  if so, move on, otherwise go back one instruction
		opcodes.org xor "000000000000"         -- go back to the start of the program
	);
	
	-- A program that will load in two values to memory, then read them back out and finall start over
	constant storage_program : program_type := (
		opcodes.movlw xor "000010101010", -- load 01010101 into the data_buffer
		opcodes.movwf xor "000000000001", -- load the contents of data_buffer into memory address 1
		opcodes.movlw xor "000011110011", -- load 11110011 into the data_buffer
		opcodes.movwf xor "000000000010", -- load the contents of data_buffer into memory address 2
		opcodes.clr xor "000000000000",        -- clear data_buffer
		opcodes.movfw xor "000000000001", -- load the contents of memory address 1 to data_buffer
		opcodes.noop xor "000000000000",    -- do nothing for one cycle
		opcodes.clr xor "000000000000",        -- clear data_buffer
		opcodes.movfw xor "000000000010", -- load the contents of memory address 2 to data_buffer
		opcodes.noop xor "000000000000",    -- do nothing for one cycle
		opcodes.org xor "000000000000"        -- go back to the start of the program
	);
	
	-- The program to be run
	constant program : program_type := decrement_program;
		
--		opcodes.movwf xor "000001111110",
--		opcodes.movlw xor "000000011000",
--		opcodes.movfw xor "000001111110",
--		opcodes.add xor "000000000011",
--		opcodes.sub xor "000000000001",
--		opcodes.clr,
--		opcodes.movlw xor "000000001111",
--		opcodes.clr,
--		opcodes.movlw xor "000000000010",
--		opcodes.mult xor "000000000010",
--		opcodes.org xor "000000000000"
--	);
	
	
	-- There is an adder instantiated.  These are the signals for that adder
	-- An adder is not really needed, but if the design gets too big, then things
	-- could get out of hand with a simple flip flop adder that is created when 
	-- the '+' sign is used.  This adder should be a lookup table or DSP block
	signal adder_in_one : std_logic_vector(7 downto 0);
	signal adder_in_two : std_logic_vector(7 downto 0);
	signal adder_out : std_logic_vector(7 downto 0);
	signal adder_en : std_logic;
	
	-- There is a multiplier IP core being used.  These are the signals for that
	-- muliplier.  It is not strictly needed, but will help if the CPU is run at high
	-- speeds later on.
	signal multiplier_one : std_logic_vector(7 downto 0);
	signal multiplier_two : std_logic_vector(7 downto 0);
	signal multiplier_out : std_logic_vector(7 downto 0);
	signal multiplier_en : std_logic;
	
begin

	-- Create an instance of the adder
	my_adder : adder
	PORT MAP (
		a => adder_in_one,
		b => adder_in_two,
		clk => slow_clk,
		ce => adder_en,
		s => adder_out
	);
	
	-- Create an instance of the multiplier
	your_instance_name : mult
	  PORT MAP (
		 clk => slow_clk,
		 a => multiplier_one,
		 b => multiplier_two,
		 ce => multiplier_en,
		 p => multiplier_out
	  );
	  
	-- Show the contents of data_buffer on the LEDs for feedback  
	led <= data_buffer;
	
	-- Process used to slow the clock down
	process(clk, rst)
		-- Change the upper limit of 'counter' to slow down or speed up the CPU clock
		variable counter : integer range 0 to 25000000*2 := 0;
	begin
		if(rst = '1') then
			counter := 0;
			slow_clk <= '0';
		elsif(rising_edge(clk)) then
			if(counter = 0) then
				slow_clk <= not slow_clk;
			end if;
			
			counter := counter + 1;
		end if;
	end process;
	
	-- This is the CPU.  All functions are handled in this one process.  Not really the best
	-- idea, but it works for something simple like this.
	process(slow_clk, rst)
		-- Will hold the current opcode being pointed at by the program counter
		variable opcode : std_logic_vector(11 downto 0);
		-- Will hold the value of the current opcode
		variable value : std_logic_vector(7 downto 0);
		-- Same as 'value', just converted to an integer for ease of handling
		variable value_int : integer range 0 to 255;
		-- The adder and multiplier blocks need a couple of clock cycles to finish.  This
		-- variable will allow the CPU to 'pause' processing until the adder/multiplier is done.
		-- 10 was an arbitrarily chosen number.  Currently only needs to be 0 to 2.
		variable delay : integer range 0 to 10 := 0;
		-- Things like the btwc and org opcodes need to be able to move the program
		-- counter around.  Setting this to '1' means that the program counter should
		-- not automatically increment as it has been overridden somewhere else.
		variable skip_program_counter_increment : std_logic := '0';
	begin
		-- Add in some default values for reset condition.
		if(rst = '1') then
			program_counter <= 0;
			data_buffer <= (others => '0');
			delay := 0;
			skip_program_counter_increment := '0';
		-- Only do things on the rising edge of the slow_clk signal
		elsif(rising_edge(slow_clk)) then
			-- Make sure the program counter is in bounds
			if(program_counter < program'high + 1) then
				-- Grab the current opcode ignoring all but the first 4 bits
				opcode := program(program_counter) and "111100000000";
				-- Get the current value ignoring the first 4 bits
				value := program(program_counter)(7 downto 0);
				-- Convert the value to an integer for ease of use
				value_int := conv_integer(value);
				
				-- This is where all the logic happens.  Check each possibility and handle it 
				-- in a certain way.
				case opcode is
					-- Moving data from the value of the command to the 'w' register (data_buffer)
					when opcodes.movlw =>
						data_buffer <= program(program_counter)(7 downto 0);
					-- Add the current value to whatever is in the 'w' register, and then store it in the 'w' regiser (data_buffer)
					-- This command needs 3 clock cycles to finish.  Could probably be done in two, but meh.
					when opcodes.add =>
						case delay is
							-- 0 is the defalt value for the delay variable.  Getting here means that the 
							-- addition need to be started.
							when 0 =>
								delay := 2;
								adder_in_one <= data_buffer;
								adder_in_two <= value;
								adder_en <= '1';
							-- Stall for one cycle for the addition to complete
							when 2 =>
								delay := 1;
							-- Addition is done.  Grab the value and disable the adder
							when 1 =>
								adder_en <= '0';
								data_buffer <= adder_out;
								-- Reset delay
								delay := 0;
							-- Others is needed here since the delay variable has other possibilities
							when others =>
								delay := 0;
						end case;
					-- Subtraction is currently done the simple way.  Will be changed later
					when opcodes.sub =>
						data_buffer <= conv_std_logic_vector(conv_integer(data_buffer) - value_int, 8);
					-- Noop does nothing for one cycle
					when opcodes.noop =>
						null;
					-- Clr clears the 'w' register (data_buffer)
					when opcodes.clr =>
						data_buffer <= (others => '0');
					-- Mult is the multiply instruction.  Needs 3 cycles to complete.
					when opcodes.mult =>
						case delay is
							when 0 =>
								delay := 2;
								multiplier_one <= data_buffer;
								multiplier_two <= value;
								multiplier_en <= '1';
							when 2 =>
								delay := 1;
							when 1 =>
								multiplier_en <= '0';
								data_buffer <= multiplier_out;
								delay := 0;
							when others =>
								delay := 0;
						end case;
					-- Org moves the program counter to the point indicated by 'value_int'
					when opcodes.org =>
						program_counter <= value_int;
					-- Movwf moves data from the 'w' register (data_buffer) to the ram address in 'value_int'
					when opcodes.movwf =>
						ram(value_int) <= data_buffer;
					-- Decw subtracts one from the 'w' register (data_buffer)
					when opcodes.decw =>
						data_buffer <= conv_std_logic_vector(conv_integer(data_buffer) - 1, 8);
					-- Decf subtracts one from the ram address at 'value_int'
					when opcodes.decf =>
						ram(value_int) <= conv_std_logic_vector(conv_integer(ram(value_int)) - 1, 8);
					-- Movfw moves data from the ram address at 'value_int' to the 'w' register (data_buffer)
					when opcodes.movfw =>
						data_buffer <= ram(value_int);
					-- Btwc tests the 'w' register (data_buffer) to see if it is zero.  If not then it will subtract one
					-- from the program counter to move it to the previous operation.  Notice that the skip program
					-- counter increment is set here so that the position is not changed at the end.
					when opcodes.btwc =>
						if(data_buffer /= "00000000") then
							program_counter <= program_counter - 1;
							skip_program_counter_increment := '1';
						end if;
					-- Catch all in case there are opcodes that do not have definitions
					when others =>
						null;
				end case;
				
				-- If the delay is non-zero, then the program counter needs to stay where
				-- it currently is.
				if(delay /= 0 or opcode = opcodes.org) then
					skip_program_counter_increment := '1';
				end if;
				
				-- Only increment the program counter if the skip program counter increment is '0'
				if(skip_program_counter_increment = '0') then
					program_counter <= program_counter + 1;
				end if;
				
				-- Reset the skip program counter increment for the next clock
				skip_program_counter_increment := '0';
			end if;
		end if;
	end process;
end Behavioral;

