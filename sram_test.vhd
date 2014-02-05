--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:09:34 01/28/2014
-- Design Name:   
-- Module Name:   /home/main/git/FPGA/sram_test.vhd
-- Project Name:  FPGA
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sram
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
 
ENTITY sram_test IS
END sram_test;
 
ARCHITECTURE behavior OF sram_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sram
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         si : IN  std_logic;
         data_in : IN  std_logic_vector(7 downto 0);
         start : IN  std_logic;
         we : IN  std_logic;
         addr : IN  std_logic_vector(23 downto 0);
         data_out : OUT  std_logic_vector(7 downto 0);
         so : OUT  std_logic;
         done : OUT  std_logic;
         sck : OUT  std_logic;
         cs_n : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal si : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal start : std_logic := '0';
   signal we : std_logic := '0';
   signal addr : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal data_out : std_logic_vector(7 downto 0);
   signal so : std_logic;
   signal done : std_logic;
   signal sck : std_logic;
   signal cs_n : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sram PORT MAP (
          clk => clk,
          rst => rst,
          si => si,
          data_in => data_in,
          start => start,
          we => we,
          addr => addr,
          data_out => data_out,
          so => so,
          done => done,
          sck => sck,
          cs_n => cs_n
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		addr <= x"800005";
      wait for clk_period*10;
		start <= '1';
		wait for clk_period;
		wait until done = '1';
		start <= '0';
		wait for clk_period * 2;
		start <= '1';
      -- insert stimulus here 

      wait;
   end process;

END;
