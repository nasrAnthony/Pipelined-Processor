library ieee;
use ieee.std_logic_1164.all;

entity mux3t1re is
	port 
		(
			ANDop, arith, ORop : in std_logic;
			ctrl : in std_logic_vector(1 downto 0);
			outp : out std_logic
		);
end entity;


architecture struct of mux3t1re is 

begin 
	-- SELECTION LOGIC
	outp <= ((not ctrl(1) and (not ctrl(0)) and ANDop) 
			or (not ctrl(1) and ctrl(0) and ORop) or
			(ctrl(1) and ctrl(0) and arith) or (ctrl(1) and ctrl(0)));
end struct;