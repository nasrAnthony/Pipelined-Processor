library ieee;
use ieee.std_logic_1164.all;


entity MEMWBpipeReg is 
	port 
			(
				i_resetGlobal : in std_logic;
				i_gclk : in std_logic;
				i_en : in std_logic;
				i_memData : in std_logic_vector(7 downto 0);
				i_resALU : in std_logic_vector(7 downto 0);
				i_vectEXMEMregRD : in std_logic_vector(4 downto 0);
				i_vectWB : in std_logic_vector(1 downto 0);
				o_vectWB : out std_logic_vector(1 downto 0);
				o_resALU : out std_logic_vector(7 downto 0);
				o_memData : out std_logic_vector(7 downto 0);
				o_vectWBMEMregRD: out std_logic_vector(4 downto 0)
			);
end entity;

architecture struct of MEMWBpipeReg is 
signal midWBbits : std_logic_vector(1 downto 0);
signal midMemData : std_logic_vector(7 downto 0);
signal midResALU : std_logic_vector(7 downto 0);
signal midWBMEMregRD : std_logic_vector(4 downto 0);

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
begin 

regRD_Buffer : reg5bit 
	port 
		map 
			(
				inBits => i_vectEXMEMregRD, 
				i_clk => i_gclk, 
				i_resetNot => i_resetGlobal, 
				i_en => i_en, 
				outBits => midWBMEMregRD
			);
ALUres_Buffer : reg8bit 
	port 
		map 
			(
				inBits => i_resALU, 
				i_clk => i_gclk, 
				i_resetNot => i_resetGlobal, 
				i_en => i_en, 
				outBits => midResALU
			);
WBbits_Buffer : reg2bit 
	port 
		map 
			(
				i_clk => i_gclk, 
				i_in => i_vectWB, 
				i_resetNot => i_resetGlobal, 
				i_enable => i_en, 
				o_out => midWBbits
			);

o_vectWBMEMregRD <= midWBMEMregRD;
o_vectWB <= midWBbits;
o_memData <= midMemData;
o_resALU <= midResALU;

end struct;
