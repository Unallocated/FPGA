library IEEE;
use IEEE.STD_LOGIC_1164.all;

package uas is

	type vga_timing is
	record
		horizontal_sync : positive;
		horizontal_front_porch : positive;
		horizontal_back_porch : positive;
		horizontal_video : positive;
		horizontal_polarity : std_logic;
		
		vertical_sync : positive;
		vertical_front_porch : positive;
		vertical_back_porch : positive;
		vertical_video : positive;
		vertical_polarity : std_logic;
		
	end record;
	
	constant vga_25mhz_640x480 : vga_timing := (
		horizontal_sync => 96,
		horizontal_front_porch => 16,
		horizontal_back_porch => 48,
		horizontal_video => 640,
		horizontal_polarity => '0',
		vertical_sync => 2,
		vertical_front_porch => 10,
		vertical_back_porch => 33,
		vertical_video => 480,
	   vertical_polarity => '0');
	
	constant vga_50mhz_800x600 : vga_timing := (
		horizontal_sync => 120,
		horizontal_front_porch => 56,
		horizontal_back_porch => 64,
		horizontal_video => 800,
		horizontal_polarity => '1',
		vertical_sync => 6,
		vertical_front_porch => 37,
		vertical_back_porch => 23,
		vertical_video => 600,
      vertical_polarity => '1');
		
	constant vga_135mhz_1280x1024 : vga_timing := (
		horizontal_sync => 144,
		horizontal_front_porch => 16,
		horizontal_back_porch => 248,
		horizontal_video => 1280,
		horizontal_polarity => '1',
		vertical_sync => 3,
		vertical_front_porch => 1,
		vertical_back_porch => 38,
		vertical_video => 1024,
      vertical_polarity => '1');

end uas;

package body uas is

end uas;
