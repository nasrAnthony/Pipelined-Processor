library ieee;
use ieee.std_logic_1164.all;


entity IFIDpipeReg is 
	port 
			(
				i_resetGlobal : in std_logic;
				i_gclk : in std_logic;
				i_en : in std_logic;
				i_flushFlag : in std_logic;
				i_IFIDwrite : in std_logic;
				i_instr : in std_logic_vector(31 downto 0);
				i_pc : in std_logic_vector(7 downto 0);
				o_pc : out std_logic_vector(7 downto 0);
				o_instr : out std_logic_vector(31 downto 0)
			);
end entity;

architecture struct of IFIDpipeReg is 
signal midInstr : std_logic_vector(31 downto 0);
signal midPC : std_logic_vector(7 downto 0);

component reg32bit is
	port 
		(
			inBits : in std_logic_vector(31 downto 0);
			i_clk : in std_logic;
			i_resetNot : in std_logic;
			i_en : in std_logic;
			outBits : out std_logic_vector(31 downto 0)
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
begin 

instruction_Buffer : reg32bit 
	port 
		map 
			(
				inBits => i_instr, 
				i_clk => i_gclk, 
				i_resetNot => i_resetGlobal, 
				i_en => i_en, 
				outBits => midInstr
			);
PC_Buffer : reg8bit 
	port 
		map 
			(
				inBits => i_pc, 
				i_clk => i_gclk, 
				i_resetNot => i_resetGlobal, 
				i_en => i_en, 
				outBits => midPC
			);
			
o_instr <= midInstr;
o_pc <= midPC;

end struct;
