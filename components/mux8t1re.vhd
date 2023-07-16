library ieee;
use ieee.std_logic_1164.all;


entity mux8t1re is 
	port 
		(
			i_in0, i_in1, i_in2, i_in3, i_in4, i_in5, i_in6, i_in7 : in std_logic;
			sel : in std_logic_vector (2 downto 0);
			o_out : out std_logic
		);
end mux8t1re;

architecture struct of mux8t1re is 
signal temp_in : std_logic_vector(7 downto 0);
signal temp_selNot : std_logic_vector(2 downto 0);

begin 
--generate the inverse of sel :
temp_selNot(2) <= not(sel(2));
temp_selNot(1) <= not(sel(1));
temp_selNot(0) <= not(sel(0));
--Generate the output:
temp_in(7) <= sel(2) and sel(1) and sel(0) and i_in7;
temp_in(6) <= sel(2) and sel(1) and temp_selNot(0) and i_in6;
temp_in(5) <= sel(2) and sel(0) and temp_selNot(1) and i_in5;
temp_in(4) <= sel(2) and temp_selNot(1) and temp_selNot(0) and i_in4;
temp_in(3) <= sel(1) and sel(0) and temp_selNot(2) and i_in3;
temp_in(2) <= sel(1) and temp_selNot(2) and temp_selNot(0) and i_in2;
temp_in(1) <= sel(0) and temp_selNot(1) and temp_selNot(2) and i_in1;
temp_in(0) <= temp_selNot(2) and temp_selNot(1)  and temp_selNot(0) and i_in0;
--Drive the output:
o_out <= temp_in(0) or temp_in(1) or temp_in(2) or temp_in(3) 
			or temp_in(4) or temp_in(5) or temp_in(6) or temp_in(7);
end struct;