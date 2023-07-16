library ieee;
use ieee.std_logic_1164.all;


entity IDEXpipeReg is 
	port 
			(
				i_resetGlobal : in std_logic;
				i_gclk : in std_logic;
				i_en : in std_logic;
				i_readData_1 : in std_logic_vector(7 downto 0);
				i_readData_2 : in std_logic_vector(7 downto 0);
				i_vectWB : in std_logic_vector(1 downto 0);
				i_vectMEM : in std_logic_vector(2 downto 0);
				i_vectEX : in std_logic_vector(3 downto 0);
				i_rs : in std_logic_vector(4 downto 0);
				i_rt1 : in std_logic_vector(4 downto 0);
				i_rt2 : in std_logic_Vector(4 downto 0);
				i_rd : in std_logic_vector(4 downto 0);
				o_readData_1 : out std_logic_vector(7 downto 0);
				o_readData_2 : out std_logic_vector(7 downto 0);
				o_vectWB : out std_logic_vector(1 downto 0);
				o_vectMEM : out std_logic_vector(2 downto 0);
				o_vectEX : out std_logic_vector(3 downto 0);
				o_rs : out std_logic_vector(4 downto 0);
				o_rt1 : out std_logic_vector(4 downto 0);
				o_rt2 : out std_logic_vector(4 downto 0);
				o_rd : out std_logic_vector(4 downto 0)
			);
end entity;

architecture struct of IDEXpipeReg is 
signal midEXbits : std_logic_vector(3 downto 0);
signal midReadData1, midReadData2 : std_logic_vector(7 downto 0);
signal midMEMbits : std_logic_vector(2 downto 0);
signal midWBbits : std_logic_vector(1 downto 0);
signal midrs, midrt1, midrt2, midrd : std_logic_vector(4 downto 0);

component reg4bit is
	port 
		(
			inBits : in std_logic_vector(3 downto 0);
			i_clk : in std_logic;
			i_resetNot : in std_logic;
			i_en : in std_logic;
			outBits : out std_logic_vector(3 downto 0)
		);
end component;

component reg5bit is
	port 
		(
			inBits : in std_logic_vector(4 downto 0);
			i_clk : in std_logic;
			i_resetNot : in std_logic;
			i_en : in std_logic;
			outBits : out std_logic_vector(4 downto 0)
		);
end component;

component reg2bit is 
	port 
		(
			i_clk : in std_logic;
			i_in : in std_logic_vector(1 downto 0);
			i_resetNot : in std_logic;
			i_enable : in std_logic;
			o_out : out std_logic_vector(1 downto 0)
		);
end component;

component reg8bit is
	port 
		(
			inBits : in std_logic_vector(7 downto 0);
			i_clk : in std_logic;
			i_resetNot : in std_logic;
			i_en : in std_logic;
			outBits : out std_logic_vector(7 downto 0)
		);
end component;

component reg3bit is 
	port 
		(
			i_clk : in std_logic;
			i_in : in std_logic_vector(2 downto 0);
			i_resetNot : in std_logic;
			i_enable : in std_logic;
			o_out : out std_logic_vector(2 downto 0)
		);
end component;


begin 

readData1_bufferReg : reg8bit 
	port 
		map 
			(
				inBits => i_readData_1, 
				i_clk => i_gclk, 
				i_resetNot => i_resetGlobal, 
				i_en => i_en, 
				outBits => midReadData1
			);
		
readData2_bufferReg : reg8bit 
	port 
		map 
			(
				inBits => i_readData_2, 
				i_clk => i_gclk, 
				i_resetNot => i_resetGlobal, 
				i_en => i_en, 
				outBits => midReadData2
			);

WBbitsBuffer : reg2bit 
	port 
		map 
			(
				i_clk => i_gclk, 
				i_in => i_vectWB, 
				i_resetNot => i_resetGlobal, 
				i_enable => i_en, 
				o_out => midWBbits
			);
MEMbitsBuffer : reg3bit 
	port 
		map 
			(
				i_clk => i_gclk, 
				i_in => i_vectMEM, 
				i_resetNot => i_resetGlobal, 
				i_enable => i_en, 
				o_out => midMEMbits
			);
			
EXbitsBuffer : reg4bit
	port 
		map 
			(
				inBits => i_vectEX, 
				i_clk => i_gclk, 
				i_resetNot => i_resetGlobal,
				i_en => i_en, 
				outBits => midEXbits
			);
		
rsReg:  reg5bit
	port 
		map
		(
			inBits => i_rs, 
			i_clk => i_gclk, 
			i_resetNot => i_resetGlobal, 
			i_en => i_en, 
			outBits => midrs
		);
rt1Reg:  reg5bit
	port 
		map
		(
			inBits => i_rt1, 
			i_clk => i_gclk, 
			i_resetNot => i_resetGlobal, 
			i_en => i_en, 
			outBits => midrt1
		);
rt2Reg:  reg5bit
	port 
		map
		(
			inBits => i_rt2, 
			i_clk => i_gclk, 
			i_resetNot => i_resetGlobal, 
			i_en => i_en, 
			outBits => midrt2
		);
rdReg:  reg5bit
	port 
		map
		(
			inBits => i_rd, 
			i_clk => i_gclk, 
			i_resetNot => i_resetGlobal, 
			i_en => i_en, 
			outBits => midrd
		);
o_readData_1 <= midReadData1;
o_readData_2 <= midReadData2;
o_vectEX <= midEXbits;
o_vectWB <= midWBbits;
o_vectMEM <= midMEMbits;
o_rs <= midrs;
o_rt1 <= midrt1;
o_rt2 <= midrt2;
o_rd <= midrd;

end struct;
