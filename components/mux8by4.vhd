library ieee;
use ieee.std_logic_1164.all;

entity mux8by4 is 
	port 
		(
			i_sel : in std_logic_vector(1 downto 0);
			ANDop : in std_logic_vector(7 downto 0);
			ORop : in std_logic_vector(7 downto 0);
			arith : in std_logic_vector(7 downto 0);
			res : out std_logic_vector(7 downto 0)
		);
		
end entity;

architecture RTL of mux8by4 is 

component mux3t1re is
	port 
		(
			ANDop, arith, ORop : in std_logic;
			ctrl : in std_logic_vector(1 downto 0);
			outp : out std_logic
		);
end component;

begin 
	generateMux : for i in 0 to 7 generate 
	instMux : mux3t1re 	port map (ctrl => i_sel, ANDop => ANDop(i), ORop => ORop(i), arith => arith(i), outp => res(i));
	end generate;
end RTL;
