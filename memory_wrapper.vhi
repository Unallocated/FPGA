
-- VHDL Instantiation Created from source file memory_wrapper.vhd -- 11:18:49 11/11/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT memory_wrapper
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		start : IN std_logic;
		data_in : IN std_logic_vector(7 downto 0);
		addr : IN std_logic_vector(15 downto 0);
		we : IN std_logic;          
		data_out : OUT std_logic_vector(7 downto 0);
		done : OUT std_logic
		);
	END COMPONENT;

	Inst_memory_wrapper: memory_wrapper PORT MAP(
		clk => ,
		rst => ,
		start => ,
		data_in => ,
		data_out => ,
		addr => ,
		we => ,
		done => 
	);


