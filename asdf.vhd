--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:38:07 12/05/2013
-- Design Name:   
-- Module Name:   /root/FPGA/asdf.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: class_cpu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY asdf IS
END asdf;
 
ARCHITECTURE behavior OF asdf IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT class_cpu
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         porta : INOUT  std_logic_vector(7 downto 0);
         portb : INOUT  std_logic_vector(7 downto 0);
         portc : INOUT  std_logic_vector(7 downto 0);
         portd : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

	--BiDirs
   signal porta : std_logic_vector(7 downto 0);
   signal portb : std_logic_vector(7 downto 0);
   signal portc : std_logic_vector(7 downto 0);
   signal portd : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: class_cpu PORT MAP (
          clk => clk,
          rst => rst,
          porta => porta,
          portb => portb,
          portc => portc,
          portd => portd
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
   		porta <= "11111101";
      -- hold reset state for 100 ns.
      wait for 16 ns;
--      portb <= "11110000";
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
