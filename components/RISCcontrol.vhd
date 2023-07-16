library ieee;
use ieee.std_logic_1164.all;

entity RISCcontrol is 
	port 
		(
			iOp : in std_logic_vector(5 downto 0);
			iBEQassert : in std_logic;
			oALUop : buffer std_logic_vector(1 downto 0);
			oRegDst : buffer std_logic;
			oRegWrite : buffer std_logic;	
			oJump : buffer std_logic;
			oMemRead :  buffer std_logic;
			oMemToReg : buffer std_logic;
			oMemWrite : buffer std_logic;
			oAluSrc : buffer std_logic;
			oBranch : buffer std_logic;
			oBNE : buffer std_logic;
			oFlushAssert : out std_logic;
			oEX : out std_logic_vector(3 downto 0);
			oM : out std_logic_vector(2 downto 0);
			oWB : out std_logic_vector(1 downto 0)
		);
end entity;

architecture struct of RISCcontrol is 
--Define signals for each type of instruction : 
--load word (lw):
signal midLW : std_logic;
--store word (sw):
signal midSW : std_logic;
--R type (RT):
signal midRT : std_logic;
--Jump : (JUMP):
signal midJUMP : std_logic;
--Branch if equal (BEQ):
signal midBEQ : std_logic;
--Branch if not equal ( BNE):
signal midBNE : std_logic;

begin  
 -- Control logic assigned to each of the instruction inter signal. 
 --ADD BNE
 -- 000000 : (0  : decimal) -> Rtype
midRT <= not(iOP(5)) and not(iOP(4)) and not(iOP(3)) and not(iOP(2)) and not(iOP(1)) and not(iOP(0));
 -- 100011 : (35 : decimal) -> Load 
midLW <= iOP(5) and not(iOP(4)) and not(iOP(3)) and not(iOP(2)) and iOP(1) and iOP(0);
 -- 101011 : (43 : decimal) -> Store
midSW <= iOP(5) and not(iOP(4)) and iOP(3) and not(iOP(2)) and iOP(1) and iOP(0);
 -- 000010 : (2  : decimal) -> Jump 
midJUMP <= not(iOP(5)) and not(iOP(4)) and not(iOP(3)) and not(iOP(2)) and iOP(1) and not(iOP(0));
 -- 000100 : (4  : decimal) -> BEQ 
midBEQ <= not(iOP(5)) and not(iOP(4)) and not(iOP(3)) and iOP(2) and not(iOP(1)) and not(iOP(0));
 -- 000101 : (5  : decimal) -> BNE
midBNE <= not(iOP(5)) and not(iOP(4)) and not(iOP(3)) and iOP(2) and not(iOP(1)) and iOP(0);

--Driving the correct sets and resets to the control signals output by the control unit. 
oALUop(1) <= midRT;
oALUop(0) <= midBEQ or midBNE;
oRegDst <= midRT;
oRegWrite <= midLW or midRT;
oJump <= midJUMP;
oMemRead <= midLW;
oMemToReg <= midLW;
oMemWrite <= midSW;
oAluSrc <= midSW or midLW;
oBranch <= midBEQ;
oBNE <= midBNE;
oEX(2 downto 1) <= oALUop(1 downto 0);
oEX(0) <= oALuSrc;
oEX(3) <= oRegDst;
oM(0) <= oMemWrite;
oM(1) <= oMemRead;
oM(2) <= oBranch;
oWB(1) <= oRegWrite;
oWB(0) <= oMemToReg;
oFlushAssert <= iBEQassert;
end struct;
 