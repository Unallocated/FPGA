library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.conv_std_logic_vector;
use IEEE.NUMERIC_STD.unsigned;
use WORK.uas.ALL;

--
-- This is a VGA entity designed to drive a VGA monitor.  It allows the parent entity to control color and provides
-- the parent entity with x and y position information for rendering.
--
-- Resolution is defined by the 'config' generic parameter.  By default the resolution is 640x480 using a 25MHz pixel clock.
-- Custom resolutions can be defined by creating a value of type 'vga_timing' defined in the included lib.vhd.
--
-- This entity will start with the horizontal sync pulse, followed by the back porch, video, and finally the front porch.

entity vga_configurable is
	 
	 Generic ( 
			  config      : vga_timing := vga_25mhz_640x480; -- Allow the user to specify custom VGA timings.  Default to 25MHz at 640x480
			  red_width   : positive    := 3;                 -- Let the user change the number of red color bits
			  green_width : positive    := 3;                 -- Let the user change the number of green color bits
			  blue_width  : positive    := 2                  -- Let the user change the number of blue color bits
			);
    Port ( 
	        clk      : in STD_LOGIC;                                        -- VGA clock (needs to be correct for the specified resolution!!)
           rst      : in STD_LOGIC;                                        -- Resets the horizontal and vertical counters (active high)
           hs       : out STD_LOGIC;                                       -- Horizontal sync output to the monitor
           vs       : out STD_LOGIC;                                       -- Vertical sync output to the monitor
           green    : out STD_LOGIC_VECTOR(green_width-1 downto 0);        -- Green color output to the monitor
           red      : out STD_LOGIC_VECTOR(red_width-1 downto 0);          -- Red color output to the monitor
           blue     : out STD_LOGIC_VECTOR(blue_width-1 downto 0);         -- Blue color output to the monitor
			  x_pos    : out INTEGER range -1 to config.horizontal_video - 1; -- Output to get the current X position being rendered
			  y_pos    : out INTEGER range -1 to config.vertical_video - 1;   -- Output to get the current Y position being rendered
			  blue_in  : in STD_LOGIC_VECTOR(blue_width-1 downto 0);          -- What blue color to output to the 'blue' signel
			  red_in   : in STD_LOGIC_VECTOR(red_width-1 downto 0);           -- What red color to output to the 'red' signal
			  green_in : in STD_LOGIC_VECTOR(green_width-1 downto 0)          -- What green color to output to the 'green' signal
			);
end vga_configurable;

architecture Behavioral of vga_configurable is
	
	-- 0 when no color is allowed to be displayed.  1 otherwise.
	signal color_valid : std_logic := '0';  

begin
	
	-- Send out color information if allowed
	green <= (others => '0') when color_valid = '0' else green_in;
	red   <= (others => '0') when color_valid = '0' else red_in;
	blue  <= (others => '0') when color_valid = '0' else blue_in;


	-- Main process that syncs and draws on the monitor
	process(clk, rst)
		-- h_counter is used to keep track of the 'gun' position in the horizontal (x) axis.  It's max value is the sum of all of the sync
		variable h_counter : integer range 0 to config.horizontal_sync + config.horizontal_front_porch + config.horizontal_back_porch + config.horizontal_video := 0;
		-- v_counter is used to keep track of the 'gun' position in the vertical (y) axis.  It's max value is the sum of all of the syncs
		variable v_counter : integer range 0 to config.vertical_sync + config.vertical_front_porch + config.vertical_back_porch + config.vertical_video := 0;
	begin
		if(rst = '1') then
			-- Reset the horizontal and vertical counters
			h_counter := 0;
			v_counter := 0;
		elsif(rising_edge(clk)) then
			-- Check to see if the horizontal sync pulse needs to be set
			if(h_counter < config.horizontal_sync) then
				hs <= config.horizontal_polarity;
			else
				hs <= not config.horizontal_polarity;
			end if;
			
			-- Check to see if the vertical sync pulse needs to be set
			if(v_counter < config.vertical_sync) then
				vs <= config.vertical_polarity;
			else
				vs <= not config.vertical_polarity;
			end if;
			
			-- Check to see if video is currently allowed
			if(h_counter > config.horizontal_sync + config.horizontal_back_porch 
					and h_counter < config.horizontal_sync + config.horizontal_back_porch + config.horizontal_video
					and v_counter > config.vertical_sync + config.vertical_back_porch
					and v_counter < config.vertical_sync + config.vertical_back_porch + config.vertical_video) then
					
				-- Set the color to be valid	
				color_valid <= '1';
				-- Get the current x and y pixel position
				x_pos <= h_counter - config.horizontal_sync - config.horizontal_back_porch;
				y_pos <= v_counter - config.vertical_sync - config.vertical_back_porch;
			else
				-- No color is allowed right now
				color_valid <= '0';
				-- Set both x and y to -1 since pixel positions are currently not valid
				x_pos <= -1;
				y_pos <= -1;
			end if;
			
			-- Check to see if the max value for the horizontal sync has been reached (it's the end of the line)
			if(h_counter = config.horizontal_front_porch + config.horizontal_back_porch + config.horizontal_sync + config.horizontal_video - 1) then
				-- Check to see if the max value for the vertical sync has been reached (it's the last line on the screen)
				if(v_counter = config.vertical_front_porch + config.vertical_back_porch + config.vertical_sync + config.vertical_video - 1) then
					-- Zero out the v_counter since it's the end of the frame (all lines have been drawn)
					v_counter := 0;
				else
					-- Increment v_counter since it's time to move to a new line
					v_counter := v_counter + 1;
				end if;
				
				-- Zero out the h_counter since a new line has been reached
				h_counter := 0;
			else
				-- Increment h_counter since the end of the line has not been reached
				h_counter := h_counter + 1;
			end if;
		end if;
	end process;
end Behavioral;

