library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.uas.ALL;

entity draw_solid_color is
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
			);
end draw_solid_color;

architecture Behavioral of draw_solid_color is

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
--	COMPONENT nexys3_clock
--	PORT(
--	  CLK_IN1  : in  std_logic;
--	  CLK_OUT1 : out std_logic
--	    );
--	END COMPONENT;
	
	-- Mojo
	COMPONENT mojo_clock
	PORT(
	  CLK_IN1  : in  std_logic;
	  CLK_OUT1 : out std_logic
	    );
	END COMPONENT;
	
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
	
begin

	-- Nexys3
--	Inst_clock : nexys3_clock PORT MAP(
--		CLK_IN1 => clk,
--		CLK_OUT1 => vga_clk
--	);
	
	-- Mojo
	Inst_clock : mojo_clock PORT MAP(
		CLK_IN1 => clk,
		CLK_OUT1 => vga_clk
	);
	
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
		x_pos    => open,
		y_pos    => open,
		blue_in  => blue_buf,
		red_in   => red_buf,
		green_in => green_buf
	);

end Behavioral;

