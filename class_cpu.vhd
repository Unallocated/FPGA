library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
	
	signal mem_we : std_logic_vector(0 downto 0) := (others => '0');
	signal mem_addr : std_logic_vector(15 downto 0) := (others => '0');
	signal mem_data_in : std_logic_vector(7 downto 0) := (others => '0');
	signal mem_data_out : std_logic_vector(7 downto 0);
	
	type opcode is (noop, add, sub, mult, divide);
	
	type program_type is array(natural range <>) of std_logic_vector(7 downto 0);
	
	constant program : program_type := (
		-- program goes here
		"00000000",
		"00000001"
	);
	
begin

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

	cpu_memory : memory
	  PORT MAP (
		 clka => cpu_clock,
		 wea => mem_we,
		 addra => mem_addr,
		 dina => mem_data_in,
		 douta => mem_data_out
	  );

end Behavioral;

