library ieee;
use ieee.std_logic_1164.all;


entity EXMEMpipeReg is 
	port 
			(
				i_resetGlobal : in std_logic;
				i_gclk : in std_logic;
				i_en : in std_logic;
				i_vectWB : in std_logic_vector(1 downto 0);
				i_vectMEM : in std_logic_vector(2 downto 0);
				i_vectIDEXregRD : in std_logic_vector(4 downto 0);
				i_vectALUres : in std_logic_vector(7 downto 0);
				o_vectALUres: out std_logic_vector(7 downto 0);
				o_vectWB : out std_logic_vector(1 downto 0);
				o_vectMEM : out std_logic_vector(2 downto 0);
				o_vectIDEXregRD : out std_logic_vector(4 downto 0)	
			);
end entity;

architecture struct of EXMEMpipeReg is 
signal midIDEXregRDbits : std_logic_vector(4 downto 0);
signal midALUres : std_logic_vector(7 downto 0);
signal midMEMbits : std_logic_vector(2 downto 0);
signal midWBbits : std_logic_vector(1 downto 0);


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

component reg3bit is 
	port 
		(
			i_clk : in std_logic;
			i_in : in std_logic_vector(2downto 0);
			i_resetNot : in std_logic;
			i_enable : in std_logic;
			o_out : out std_logic_vector(2 downto 0)
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

aluRes_bufferReg : reg8bit 
	port 
		map 
			(
				inBits => i_vectALUres, 
				i_clk => i_gclk, 
				i_resetNot => i_resetGlobal, 
				i_en => i_en, 
				outBits => midALUres
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
			
regRD_buffer : reg5bit
	port 
		map 
			(
				inBits => i_vectIDEXregRD, 
				i_clk => i_gclk, 
				i_resetNot => i_resetGlobal,
				i_en => i_en, 
				outBits => midIDEXregRDbits
			);
			
o_vectALUres <= midALUres;
o_vectIDEXregRD <= midIDEXregRDbits;
o_vectWB <= midWBbits;
o_vectMEM <= midMEMbits;

end struct;
