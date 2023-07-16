library ieee;
use ieee.std_logic_1164.all;

entity topMux is --32 by 1 (out is 8 bits)
	port 
		(
			in0 : in std_logic_vector(7 downto 0);
			in1 : in std_logic_vector(7 downto 0);
			in2 : in std_logic_vector(7 downto 0);
			in3 : in std_logic_vector(7 downto 0);
			in4 : in std_logic_vector(7 downto 0);
			in5 : in std_logic_vector(7 downto 0);
			in6 : in std_logic_vector(7 downto 0);
			in7 : in std_logic_vector(7 downto 0);
			inSel : in std_logic_vector(2 downto 0);
			outMux : out std_logic_vector(7 downto 0)
		);
end entity;

architecture RTL of topMux is 

component mux8t1re is 
	port 
		(
			i_in0, i_in1, i_in2, i_in3, i_in4, i_in5, i_in6, i_in7 : in std_logic;
			sel : in std_logic_vector (2 downto 0);
			o_out : out std_logic
		);
end component mux8t1re;

begin 
muxtop0 : mux8t1re 
	port 
		map 
			(	i_in0 => in0(0), 
				i_in1 => in1(0),
				i_in2 => in2(0),
				i_in3 => in3(0),
				i_in4 => in4(0),
				i_in5 => in5(0),
				i_in6 => in6(0),
				i_in7 => in7(0), 
				sel => inSel, 
				o_out => outMux(0)
			);
muxtop1 : mux8t1re 
	port 
		map 
			(	i_in0 => in0(1), 
				i_in1 => in1(1),
				i_in2 => in2(1),
				i_in3 => in3(1),
				i_in4 => in4(1),
				i_in5 => in5(1),
				i_in6 => in6(1),
				i_in7 => in7(1), 
				sel => inSel, 
				o_out => outMux(1)
			);
muxtop2 : mux8t1re 
	port 
		map 
			(	i_in0 => in0(2), 
				i_in1 => in1(2),
				i_in2 => in2(2),
				i_in3 => in3(2),
				i_in4 => in4(2),
				i_in5 => in5(2),
				i_in6 => in6(2),
				i_in7 => in7(2), 
				sel => inSel, 
				o_out => outMux(2)
			);
muxtop3 : mux8t1re 
	port 
		map 
			(	i_in0 => in0(3), 
				i_in1 => in1(3),
				i_in2 => in2(3),
				i_in3 => in3(3),
				i_in4 => in4(3),
				i_in5 => in5(3),
				i_in6 => in6(3),
				i_in7 => in7(3), 
				sel => inSel, 
				o_out => outMux(3)
			);
muxtop4 : mux8t1re 
	port 
		map 
			(	i_in0 => in0(4), 
				i_in1 => in1(4),
				i_in2 => in2(4),
				i_in3 => in3(4),
				i_in4 => in4(4),
				i_in5 => in5(4),
				i_in6 => in6(4),
				i_in7 => in7(4), 
				sel => inSel, 
				o_out => outMux(4)
			);
muxtop5 : mux8t1re 
	port 
		map 
			(	i_in0 => in0(5), 
				i_in1 => in1(5),
				i_in2 => in2(5),
				i_in3 => in3(5),
				i_in4 => in4(5),
				i_in5 => in5(5),
				i_in6 => in6(5),
				i_in7 => in7(5), 
				sel => inSel, 
				o_out => outMux(5)
			);
muxtop6 : mux8t1re 
	port 
		map 
			(	i_in0 => in0(6), 
				i_in1 => in1(6),
				i_in2 => in2(6),
				i_in3 => in3(6),
				i_in4 => in4(6),
				i_in5 => in5(6),
				i_in6 => in6(6),
				i_in7 => in7(6), 
				sel => inSel, 
				o_out => outMux(6)
			);
muxtop7 : mux8t1re 
	port 
		map 
			(	i_in0 => in0(7), 
				i_in1 => in1(7),
				i_in2 => in2(7),
				i_in3 => in3(7),
				i_in4 => in4(7),
				i_in5 => in5(7),
				i_in6 => in6(7),
				i_in7 => in7(7), 
				sel => inSel, 
				o_out => outMux(7)
			);
end RTL;