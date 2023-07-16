library ieee;
use ieee.std_logic_1164.all;
entity forwarding_Unit is 
	port 
		(
			MEM_WB_regWrite : in std_logic;
			EX_MEMrd : in std_logic_vector( 4 downto 0);
			ID_EXrs : in std_logic_vector( 4 downto 0);
			ID_EXrt : in std_logic_vector( 4 downto 0);
			MEM_WBrd : in std_logic_vector( 4 downto 0);
			EX_MEM_regWrite : in std_logic;
			forAFlag : out std_logic_vector(1 downto 0):="00";
			forBFlag : out std_logic_vector(1 downto 0):="00"
			
		);
end entity;


architecture RTL of forwarding_Unit is 
--signal declarations:
signal c1, c2, c3, c4 : std_logic;
--equality flags:
signal EX_MEMrsEQU,MEM_WBrtEQU, EX_MEMrtEQU, MEM_WBrsEQU : std_logic;
begin
EX_MEMrsEQU <= (EX_MEMrd(4) xnor ID_EXrs(4)) and (EX_MEMrd(3) xnor ID_EXrs(3)) and (EX_MEMrd(2) xnor ID_EXrs(2)) and (EX_MEMrd(1) xnor ID_EXrs(1)) and (EX_MEMrd(0) xnor ID_EXrs(0));--g
EX_MEMrtEQU <= (EX_MEMrd(4) xnor ID_EXrt(4)) and (EX_MEMrd(3) xnor ID_EXrt(3)) and (EX_MEMrd(2) xnor ID_EXrt(2)) and (EX_MEMrd(1) xnor ID_EXrt(1)) and (EX_MEMrd(0) xnor ID_EXrt(0));--g
MEM_WBrsEQU <= (MEM_WBrd(4) xnor ID_EXrs(4)) and (MEM_WBrd(3) xnor ID_EXrs(3)) and (MEM_WBrd(2) xnor ID_EXrs(2)) and (MEM_WBrd(1) xnor ID_EXrs(1)) and (MEM_WBrd(0) xnor ID_EXrs(0));--g
MEM_WBrtEQU <= (MEM_WBrd(4) xnor ID_EXrt(4)) and (MEM_WBrd(3) xnor ID_EXrt(3)) and (MEM_WBrd(2) xnor ID_EXrt(2)) and (MEM_WBrd(1) xnor ID_EXrt(1)) and (MEM_WBrd(0) xnor ID_EXrt(0));--g
c1 <= EX_MEM_regWrite and EX_MEMrsEQU and (EX_MEMrd(4) or EX_MEMrd(3) or EX_MEMrd(2) or EX_MEMrd(1) or EX_MEMrd(0));
c2 <= EX_MEM_regWrite and EX_MEMrtEQU and (EX_MEMrd(4) or EX_MEMrd(3) or EX_MEMrd(2) or EX_MEMrd(1) or EX_MEMrd(0));
c3 <= MEM_WB_regWrite and MEM_WBrsEQU and (MEM_WBrd(4) or MEM_WBrd(3) or MEM_WBrd(2) or MEM_WBrd(1) or MEM_WBrd(0)); --Cannot write into the 0 register. 
c4 <= MEM_WB_regWrite and MEM_WBrtEQU and (MEM_WBrd(4) or MEM_WBrd(3) or MEM_WBrd(2) or MEM_WBrd(1) or MEM_WBrd(0));
--drive outputs: 
forAFlag <= c1  & (c3 and (not c1));
forBFlag <= c2  & (c4 and (not c2));
end RTL;
