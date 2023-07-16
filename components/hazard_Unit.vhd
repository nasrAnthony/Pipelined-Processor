library ieee;
use ieee.std_logic_1164.all;
 
 
entity hazard_Unit is 
	port 
		(
			ID_EXrt : in std_logic_vector(4 downto 0);
			IF_IDrt : in std_logic_vector(4 downto 0);
			IF_IDrs : in std_logic_vector(4 downto 0);
			ID_EXmemRead : in std_logic;
			stallFlag : out std_logic
		);
end entity;

architecture RTL  of hazard_Unit is 
--signal declaration: 
signal c1 : std_logic; --check equality of ID_EXrt/IF_IDrt values. 
signal c2 : std_logic; --check equality of ID_EXrt/IF_IDrs values.
begin
c1 <= (ID_EXrt(0) xnor IF_IDrt(0)) and (ID_EXrt(1) xnor IF_IDrt(1))
		and (ID_EXrt(2) xnor IF_IDrt(2)) and (ID_EXrt(3) xnor IF_IDrt(3)) 
		and (ID_EXrt(4) xnor IF_IDrt(4));
c2 <= (ID_EXrt(0) xnor IF_IDrs(0)) and (ID_EXrt(1) xnor IF_IDrs(1))
		and (ID_EXrt(2) xnor IF_IDrs(2)) and (ID_EXrt(3) xnor IF_IDrs(3)) 
		and (ID_EXrt(4) xnor IF_IDrs(4));
--drive stall control output : 
stallFlag <= (c2 or c1) and ID_EXmemRead;--memread implies a lw, therefore generate a stall flag. 
end RTL;

