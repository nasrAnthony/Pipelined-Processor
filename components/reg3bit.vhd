library ieee;
use ieee.std_logic_1164.all;

entity reg3bit is 
	port 
		(
			i_clk : in std_logic;
			i_in : in std_logic_vector(2 downto 0);
			i_resetNot : in std_logic;
			i_enable : in std_logic;
			o_out : out std_logic_vector(2 downto 0)
		);
end entity;


architecture structural of reg3bit is 
signal bufferValue : std_logic_vector(2 downto 0);
component enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
end component enARdFF_2;


begin 
bit_2 : enARdFF_2 
	port 
		map 
			(
				i_resetBar	=> i_resetNot, 
				i_d  => i_in(2), 
				i_enable	=> i_enable, 
				i_clock	=> i_clk, 
				o_q =>  bufferValue(2)
			);
			
bit_1 : enARdFF_2 
	port 
		map 
			(
				i_resetBar	=> i_resetNot, 
				i_d  => i_in(1), 
				i_enable	=> i_enable, 
				i_clock	=> i_clk, 
				o_q =>  bufferValue(1)
			);
bit_0 : enARdFF_2 
	port 
		map 
			(
				i_resetBar	=> i_resetNot, 
				i_d  => i_in(0), 
				i_enable	=> i_enable, 
				i_clock	=> i_clk, 
				o_q =>  bufferValue(0)
			);
o_out <= bufferValue;

end structural;
