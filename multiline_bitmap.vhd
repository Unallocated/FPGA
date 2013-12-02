library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.conv_std_logic_vector;
use WORK.uas.ALL;

entity multiline_bitmap is
	 Generic ( 
				red_width   : positive := 3;
				green_width : positive := 3;
				blue_width  : positive := 2
				);
    Port ( 
	      clk   : in  STD_LOGIC;
         rst   : in  STD_LOGIC;
         hs    : out  STD_LOGIC;
         vs    : out  STD_LOGIC;
         red   : out  STD_LOGIC_VECTOR (red_width-1 downto 0);
         green : out  STD_LOGIC_VECTOR (green_width-1 downto 0);
         blue  : out  STD_LOGIC_VECTOR (blue_width-1 downto 0)
--			led : out std_logic_vector(7 downto 0)
			);
end multiline_bitmap;

architecture Behavioral of multiline_bitmap is

	COMPONENT vga_configurable
	Generic ( 
			  config      : vga_timing;
			  red_width   : positive;
			  green_width : positive;
			  blue_width  : positive
			  );
	PORT(
		clk      : IN std_logic;
		rst      : IN std_logic;
		blue_in  : IN std_logic_vector;
		red_in   : IN std_logic_vector;
		green_in : IN std_logic_vector;          
		hs       : OUT std_logic;
		vs       : OUT std_logic;
		green    : OUT std_logic_vector;
		red      : OUT std_logic_vector;
		blue     : OUT std_logic_vector;
		x_pos    : OUT integer range -1 to config.horizontal_video - 1;
		y_pos    : OUT integer range -1 to config.vertical_video - 1
		);
	END COMPONENT;
	
	-- Nexys3
	COMPONENT nexys3_clock
	PORT(
	  CLK_IN1  : in  std_logic;
	  CLK_OUT1 : out std_logic
	    );
	END COMPONENT;
	
	-- Mojo
--	COMPONENT mojo_clock
--	PORT(
--	  CLK_IN1  : in  std_logic;
--	  CLK_OUT1 : out std_logic
--	    );
--	END COMPONENT;
	
	-- Basys2
--	COMPONENT clock
--	PORT(
--		CLKIN_IN        : IN std_logic;          
--		CLKFX_OUT       : OUT std_logic;
--		CLKIN_IBUFG_OUT : OUT std_logic;
--		CLK0_OUT        : OUT std_logic
--		 );
--	END COMPONENT;
	
	constant vga_config : vga_timing := vga_25mhz_640x480;
	
	signal vga_clk : std_logic;
	
	signal red_buf   : std_logic_vector(red_width - 1 downto 0)   := (others => '1');
	signal green_buf : std_logic_vector(green_width - 1 downto 0) := (others => '0');
	signal blue_buf  : std_logic_vector(blue_width - 1 downto 0)  := (others => '0');
	
	signal x_pos : integer range -1 to vga_config.horizontal_video - 1;
	signal y_pos : integer range -1 to vga_config.vertical_video - 1;
	
	
	type my_map is array (0 to 12) of std_logic_vector(0 to 6);
	type chars is array(natural range <>) of my_map;
	
	constant charset : chars := 
		(
			("1111111","1000001","1000001","1000001",
			 "1000001","1000001","1000001","1000001",
			 "1000001","1000001","1000001","1000001","1111111"),
			("0000001","0000001","0000001","0000001",
			 "0000001","0000001","0000001","0000001",
			 "0000001","0000001","0000001","0000001","0000001")
		);
		
	type my_char_buffer is array (0 to 5) of my_map;
	constant chars_per_line : integer := 2;
	
	signal my_buffer : my_char_buffer := (
		charset(0), charset(1), charset(1), charset(1),charset(0),charset(0)
	);
	
	constant char_width : integer := 8;
	constant char_height : integer := 16;
	
begin

	process(vga_clk)
		variable x : integer := 0;
		variable y : integer := 0;
		variable char_pos : integer range 0 to my_buffer'high := 0;
		variable x_index : integer := 0;
		variable y_index : integer := 0;
		constant max_width : integer := chars_per_line * char_width;
		constant max_height : integer := (my_buffer'length / chars_per_line) * char_height;
		constant offset : integer := 100;
	begin
		if(rising_edge(vga_clk)) then
			if(x_pos > offset - 1 and y_pos > offset - 1) then
				x := x_pos - offset;
				y := y_pos - offset;
				if(x < max_width and y < max_height) then
					
--					red_buf <= (others => '1');
					x_index := x mod char_width;
					y_index := y mod char_height;
					
--					led <= conv_std_logic_vector(char_pos,8);
					if(x_index < 7 and y_index < 13) then
--						red_buf <= (others => '1');
						if(my_buffer(char_pos)(y_index)(x_index) = '1') then
							red_buf <= (others => '1');
						else
							red_buf <= (others => '0');
						end if;
					else
						if(x_index = 7) then
							char_pos := char_pos + 1;
						end if;
						red_buf <= (others => '0');
					end if;
				else
					red_buf <= (others => '0');
				end if;
			else
				red_buf <= (others => '0');
			end if;
		end if;
	end process;

--	process(vga_clk)
--		variable char_pos : integer := 0;
--		variable line_pos : integer := 0;
--		variable x_index : integer := 0;
--		variable offset : integer := 100;
--	begin
--		if(rising_edge(vga_clk)) then
--			if(x_pos - offset > -1 and y_pos - offset > -1 and 
--					x_pos - offset < ((charset(0)(0)'length) * (my_buffer'length)) + my_buffer'high and 
--					y_pos - offset < 13) then
--					
--				char_pos := (x_pos - offset) / 8;
--				x_index := (x_pos - offset) mod 8;
--				if(x_index < 7 and my_buffer(char_pos)(y_pos - offset)(x_index) = '1') then
--					red_buf <= (others => '1');
--				else
--					red_buf <= (others => '0');
--				end if;
--			else
--				red_buf <= (others => '0');
--			end if;
--		end if;
--	end process;

	-- Nexys3
	Inst_clock : nexys3_clock PORT MAP(
		CLK_IN1 => clk,
		CLK_OUT1 => vga_clk
	);
	
	-- Mojo
--	Inst_clock : mojo_clock PORT MAP(
--		CLK_IN1 => clk,
--		CLK_OUT1 => vga_clk
--	);
	
	-- Basys2
--	Inst_clock: clock PORT MAP(
--		CLKIN_IN        => clk,
--		CLKFX_OUT       => vga_clk,
--		CLKIN_IBUFG_OUT => open,
--		CLK0_OUT        => open
--	);

	Inst_vga_configurable: vga_configurable 
	GENERIC MAP(
		config      => vga_25mhz_640x480,
		red_width   => red_width,
		green_width => green_width,
		blue_width  => blue_width
	)
	PORT MAP(
		clk      => vga_clk,
		rst      => rst,
		hs       => hs,
		vs       => vs,
		green    => green,
		red      => red,
		blue     => blue,
		x_pos    => x_pos,
		y_pos    => y_pos,
		blue_in  => blue_buf,
		red_in   => red_buf,
		green_in => green_buf
	);

end Behavioral;

