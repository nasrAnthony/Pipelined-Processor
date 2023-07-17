library ieee;
use ieee.std_logic_1164.all;


entity topMIPS is 
	port 
		(
			ValueSelect : in std_logic_vector( 2 downto 0);
			InstrSelect : in std_logic_vector(2 downto 0);
			GClock : in std_logic;
			GReset : in std_logic;
			MuxOut : out std_logic_vector(7 downto 0);
			InstructionOut : out std_logic_vector(31 downto 0);
			--CNTRL sigs
			BranchOut : out std_logic;
			ZeroOut : out std_logic;
			MemWriteOut : out std_logic;
			RegWriteOut : out std_logic
			--ts_muxBuff : out std_logic
			--ts_PCout : out std_logic_vector(7 downto 0);
			--ts_PCinc : out std_logic_vector(7 downto 0);
			--ts_Muxop2: out std_logic_vector(7 downto 0);
			--tsINSTIFID : out std_logic_vector(31 downto 0);
			--tsZero_flag : out std_logic;
			--tsBEQ :out std_logic;
			--tsFlush : out std_logic;
			--tsMUXOUT : out std_logic_vector(7 downto 0)
		);
	
end topMIPS;

architecture RTL of topMIPS is 


component reg32bit is --fore INSTR reg
	port 
		(
			inBits : in std_logic_vector(31 downto 0);
			i_clk : in std_logic;
			i_resetNot : in std_logic;
			i_en : in std_logic; -- will act as stall input from hazard detect unit
			outBits : out std_logic_vector(31 downto 0)
		);
end component;

component cla8bitALU is -- Used as a standard 8 bit adder to increment PC by 4...
	port 
		(
			inA : in std_logic_vector(7 downto 0);
			inB : in std_logic_vector(7 downto 0);
			iCarry : in std_logic;
			oCarry : out std_logic;
			overflowFlag : out std_logic;
			oRes : out std_logic_vector(7 downto 0)
		);
end component;

component mux8by4 is 
	port 
		(
			i_sel : in std_logic_vector(1 downto 0);
			ANDop : in std_logic_vector(7 downto 0);
			ORop : in std_logic_vector(7 downto 0);
			arith : in std_logic_vector(7 downto 0);
			res : out std_logic_vector(7 downto 0)
		);
end component;

component topMux is --8x8 by 8(out is 8 bits)
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
end component;

component IFIDpipeReg is 
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
end component;

component IDEXpipeReg is 
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
end component;

component EXMEMpipeReg is 
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
end component;

component mux2t1x8b is
	port 
		(
			inp1 : in std_logic_vector(7 downto 0);
			inp2 : in std_logic_vector(7 downto 0);
			cntr : in std_logic;
			outp2 : out std_logic_vector(7 downto 0)
		);
end component;

component MEMWBpipeReg is 
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
end component;

component ALUir is 
	port 
		(
			ReadData1 : in std_logic_vector(7 downto 0);
			ReadData2 : in std_logic_vector(7 downto 0);
			i_function : in std_logic_vector(5 downto 0);
			i_aluOP : in std_logic_vector( 1 downto 0);
			i_aluSRC : in std_logic;
			i_outRes : out std_logic_vector(7 downto 0);
			zeroFlag : out std_logic
		);
end component;

component dataMemoryRam is
	port
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

component instrMemoryROM is
	port
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

component ALUcontrolUNIT is 
	port 
		(
			i_oper : in std_logic_vector(5 downto 0);
			alu_OP : in std_logic_vector(1 downto 0);
			o_oper : out std_logic_vector(2 downto 0)
		);
end component;

component ALU8bit_U is 
	port 
	(
		inA : in std_logic_vector(7 downto 0);
		inB : in std_logic_vector(7 downto 0);
		opCode : in std_logic_vector(2 downto 0);
		zeroFlag, overFlowFlag : out std_logic;
		oRes : out std_logic_vector(7 downto 0)
	);
	
end component;

component forwarding_Unit is 
	port 
		(
			MEM_WB_regWrite : in std_logic;
			EX_MEMrd : in std_logic_vector( 4 downto 0);
			ID_EXrs : in std_logic_vector( 4 downto 0);
			ID_EXrt : in std_logic_vector( 4 downto 0);
			MEM_WBrd : in std_logic_vector( 4 downto 0);
			EX_MEM_regWrite : in std_logic;
			forAFlag : out std_logic_vector(1 downto 0);
			forBFlag : out std_logic_vector(1 downto 0)
			
		);
end component;

component hazard_Unit is 
	port 
		(
			ID_EXrt : in std_logic_vector(4 downto 0);
			IF_IDrt : in std_logic_vector(4 downto 0);
			IF_IDrs : in std_logic_vector(4 downto 0);
			ID_EXmemRead : in std_logic;
			o_pcWRITE : out std_logic;
			stallFlag : out std_logic
		);
end component;

component fileRegister is 
	port 
		(
			i_clk : in std_logic;
			i_resetNot : in std_logic;
			i_regWrite : in std_logic; -- Write en
			i_readReg1, i_readReg2 : in std_logic_vector(2 downto 0);
			i_writeDATA :  in std_logic_vector(7 downto 0);
			i_writeSel : in std_logic_vector(4 downto 0);
			o_readData1, o_readData2 : out std_logic_vector(7 downto 0)
		);
end component;

component comparator8bit is 
	port 
		(
			inA, inB : in std_logic_vector(7 downto 0);
			flagLE : out std_logic;
			flagEQ : out std_logic;
			flagGR : out std_logic
		);
end component;

component mux2t1x9b is
	port 
		(
			inp1 : in std_logic_vector(8 downto 0);
			inp2 : in std_logic_vector(8 downto 0);
			cntr : in std_logic;
			outp2 : out std_logic_vector(8 downto 0)
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

component RISCcontrol is 
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
end component;
signal midMemWBout, midEXmemALUres, midEXMemALUout, midEXMemdata2, midMEMWBdataOut, midMEMWBAluOut  : std_logic_vector(7 downto 0);
signal midForwardAFlag, midForwardBFlag : std_logic_vector(1 downto 0);
signal midIDEXdata1, midIDEXdata2 : std_logic_vector(7 downto 0);
signal midMemWBStallFlag : std_logic_vector(1 downto 0);
signal midMEMWBMuxOut, midRegDstOut, midExMEMStallOut : std_logic_vector(4 downto 0);
signal midEXMemMuxOut : std_logic_vector(4 downto 0);
signal midALUopCode : std_logic_vector(1 downto 0);
signal midALUpartialO : std_logic_vector(2 downto 0);
signal midRSregOut, midRDregOut, midRTregOut1, midRTregOut2 : std_logic_vector(4 downto 0);
signal midIDexStallMUX : std_logic_vector(8 downto 0);
signal midIDEXdata1Out : std_logic_vector(7 downto 0);
signal midIDEXdata2Out : std_logic_vector(7 downto 0);
signal midIDexRTreg : std_logic_vector(4 downto 0);
signal writeReg : std_logic_vector(4 downto 0);
signal midSTALLFlagIDEX  : std_logic;
signal midMemReadIDEX : std_logic;
signal midStallIDEX : std_logic;
signal midWriteAssrt : std_logic;
signal midStallMUXo : std_logic_vector(8 downto 0);
signal midControlBits : std_logic_vector(8 downto 0);
signal midCntrlMux : std_logic;
signal midBranchALUAdd : std_logic_vector(7 downto 0);
signal midIDEXmemRead : std_logic;
--control sigs : 
signal midZeroFlag, midRegWrite, midRegWriteCOPY, midALUsrc, midMemWrite, midMemRead, midMem2Reg, midBNE, midBEQ, midBranch, midJump, midRegDst : std_logic;
--data sigs : 
signal midData1, midData2, midDataMemOut, midDataMuxOut, midAluAin, midAluBin, midAluOut, midMisc : std_logic_vector(7 downto 0);
signal midWB : std_logic_vector(1 downto 0);
signal midEx : std_logic_vector(3 downto 0);
signal midM  : std_logic_vector(2 downto 0);
signal midBranchMuchSelOut : std_logic;
signal midAddRom, midAddRam : std_logic_vector(7 downto 0);
signal midOutMux : std_logic_vector(7 downto 0);
signal midCarryPc, midBranchCarry, midCarryOut, midZero, midOverFlow : std_logic;
signal midStall, midIFIDwrite, midFlush, midPCwrite : std_logic;
signal midMuxOutBranch, midPCout, midPCpointFut, midPCinc : std_logic_vector(7 downto 0);
signal midIDInstrOutMem, midInstOutMem : std_logic_vector(31 downto 0);
signal notReset : std_logic;
signal midbuff : std_logic;
begin --NEWVER
	notReset <= not(GReset);
	midRegWrite <= midMEMWBstallFlag(1);
	midbuff <= not(midZeroFlag and midBEQ);
	midStallIDEX <= not midCntrlMux;
--IF (instruction Fetch)
reg_PC  : reg8bit
	port 
		map 
			(
				inBits => midMuxOutBranch,
				i_clk => GClock, 
				i_resetNot => notReset, 
				--i_en => '1', --midPCwrite, 
				i_en => midPCwrite, -- will act as stall input from hazard detect unit
				outBits => midPCout
			);
mux_PC  : mux2t1x8b
	port 
		map 
			(
				inp1 => midBranchALUAdd, 
				inp2 => midPCinc, 
				cntr => midbuff, 
				outp2 => midMuxOutBranch
			);
adder_PC : cla8bitALU
	port 
		map 
			(
				inA =>  midPCout, 
				inB => "00000100",
				iCarry => '0',
				oRes => midPCpointFut
			);
instrMEM : instrMemoryROM
	port
		map
			(
				address => midPCout, 
				clock	 => GClock, 
				q		=> midInstOutMem
			);	
IFID : IFIDpipeReg
	port 
		map 
			(
				i_resetGlobal => notReset,
				i_gclk => GClock, 
				i_en => '1', 
				i_flushFlag => midFlush, 
				i_IFIDwrite => midIFIDwrite, 
				i_instr => midInstOutMem, 
				i_pc => midPCpointFut,
				o_pc => midPCinc,
				o_instr => midIDInstrOutMem
			);

--ID (instruction decode stage):
CONTROL_UNIT : RISCcontrol
	port 
		map 
			(
				iOp => midIDInstrOutMem(31 downto 26), 
				iBEQassert => midBranchMuchSelOut,
				oALUop => midALUopCode, 
				oRegDst => midRegDst, 
				oRegWrite => midRegWriteCOPY, 
				oJump => midJump, 
				oMemRead => midMemRead, 
				oMemToReg => midMem2Reg, 
				oMemWrite => midMemWrite, 
				oAluSrc => midAluSrc, 
				oBranch => midBranch, 
				oBNE => midBNE, 
				oFlushAssert => midFlush, 
				oEX => midEx, 
				oM  => midM, 
				oWB => midWB
			);
BranchCONDITION : comparator8bit 
	port 
		map 
			(
				inA => midData1, 
				inB => midData2, 
				flagLE =>  open, 
				flagEQ => midZeroFlag, 
				flagGR =>  open 
			);
branchADDER  : cla8bitALU 
	port 
		map 
			(
				inA => midIDinstrOutMem(7 downto 0), 
				inB => midPCinc, 
				iCarry => '0', 
				oCarry => midBranchCarry, 
				overflowFlag => open, 
				oRes => midBranchALUAdd
			);
stallMUX_unit : mux2t1x9b
	port 
		map 
			(
				inp1 => midControlBits, 
				inp2 => "000000000", 
				cntr => midCntrlMux, 
				outp2 => midStallMUXo
			);

midControlBits(3 downto 0) <= midEx;
midControlBits(6 downto 4) <= midM;
midControlBits(8 downto 7) <= midWB;

HAZARDUNIT : hazard_Unit 
	port 
		map 
			(
				ID_EXrt => midRtregOut2, 
				IF_IDrt => midIDinstrOutMem (25 downto 21), 
				IF_IDrs => midIDinstrOutMem (20 downto 16),
				ID_EXmemRead => midIDEXmemRead, 
				o_pcWRITE  => midPCwrite, 
				stallFlag => midCntrlMux
			);
regFile_unit : fileRegister 
		port 
			map 
				(
					i_clk => GClock,
					i_resetNot => notReset, 
					i_regWrite => midWriteAssrt, 
					i_readReg1 => midIDInstrOutMem(25 downto 23), 
					i_readReg2 => midIDInstrOutMem(22 downto 20), 
					i_writeDATA => midDataMuxOut, 
					i_writeSel => midEXMemMuxOut,
					o_readData1 => midData1, 
					o_readData2 => midData2
				);
midWriteAssrt <= not(midRegWrite);			
			
--IDEX : 
IDEX : IDEXpipeReg 
	port 
		map 
			(
				i_resetGlobal => notReset, 
				i_gclk => GClock, 
				i_en => midStallIDEX, 
				i_readData_1 => midData1, 
				i_readData_2 => midData2, 
				i_vectWB => midStallMUXo(8 downto 7),
				i_vectMEM => midStallmUXo(6 downto 4), 
				i_vectEX => midStallMUXo(3 downto 0), 
				i_rs => midInstOutMem(25 downto 21), 
				i_rt1 =>  midInstOutMem(20 downto 16),
				i_rt2 =>  midInstOutMem(20 downto 16),
				i_rd =>  midInstOutMem(15 downto 11),
				o_readData_1 => midIDEXdata1Out, 
				o_readData_2 => midIDEXdata2Out, 
				o_vectWB => midIDEXstallMUX(8 downto 7), 
				o_vectMEM => midIDEXstallMUX(6 downto 4),
				o_vectEX => midIDEXstallMUX(3 downto 0), 
				o_rs => midRSregOut, 
				o_rt1 => midRtregOut1, 
				o_rt2 => midRtregOut2, 
				o_rd => midRDregOut
			);

ALU_UNIT  : ALUir -- abstracts the control unit ALU away, it is contained within...
	port 
		map 
			(
				ReadData1 => midAluAin, 
				ReadData2 => midAluBin,
				i_function => midIDinstrOutMem(5 downto 0), 
				i_aluOP => midALUopCode, 
				i_aluSRC => midAluSrc, 
				i_outRes => midAluOut, 
				zeroFlag => midZero
			); 

forward_UNIT : forwarding_Unit 
	port 
		map 
			(
				MEM_WB_regWrite => midMEMWBstallFlag(1), 
				EX_MEMrd => midEXMemMuxOut,
				ID_EXrs => midRSregOut, 
				ID_EXrt => midRtregOut1, 
				MEM_WBrd => midMEMWBmuxOut, 
				EX_MEM_regWrite => midExMEMStallOut(4), 
				forAFlag => midForwardAFlag, 
				forBFlag => midFOrwardBFlag
			);
forwardMUXA : mux8by4 
	port 
		map 
			(
				i_sel => midForwardAFlag, 
				ANDop => midIDEXdata1,
				ORop => midDataMuxOut, 
				arith => midEXMemALUout, 
				res => midAluAin
			);
forwardMUXB: mux8by4 
	port 
		map 
			(
				i_sel => midForwardBFlag, 
				ANDop => midIDEXdata2,
				ORop => midDataMuxOut, 
				arith => midEXMemALUout, 
				res => midAluBin
			);
EXMEM_pipeREG : EXMEMpipeReg
		port 
			map 
				(
					i_resetGlobal => notReset, 
					i_gclk => GClock, 
					i_en => midSTALLFlagIDEX, 
					i_vectWB => midIDEXStallMux(8 downto 7), 
					i_vectMEM =>  midIDEXStallMux(6 downto 4),
					i_vectIDEXregRD => midRegDstOut, 
					i_vectALUres => midAluOut, 
					o_vectALUres => midEXMemALUout,
					o_vectWB => midExMEMStallOut(4 downto 3),
					o_vectMEM  => midExMEMStallOut(2 downto 0),
					o_vectIDEXregRD => midEXmemMuxOut
				);

RAMinstance : dataMemoryRam 
	port
		map
			(	
				address	=> midEXMemALUout, 
				clock		=> GClock, 
				data		=> midIDEXdata2, 
				wren		=> midExMEMStallOut(0), 
				q			=> midDataMemOut
			);
MEMWB_pipeReg : MEMWBpipeReg
	port 
		map 
			(
				i_resetGlobal => notReset, 
				i_gclk => GClock, 
				i_en => midStallIDEX,
				i_memData => midDataMemOut, 
				i_resALU => midEXMemALUout, 
				i_vectEXMEMregRD => midEXMemMuxOut, 
				i_vectWB => midExMEMStallOut(4 downto 3), 
				o_vectWB => midMemWBStallFlag(1 downto 0), 
				o_resALU => midMEMWBAluOut, 
				o_memData => midMEMWBdataOut, 
				o_vectWBMEMregRD => midMEMWBmuxOut
			);
muxMEM : mux2t1x8b 
	port 
		map 
			(
				inp1 => midMEMWBdataOut, 
				inp2 => midMEMWBAluOut, 
				cntr => midMemWBStallFlag(0),
				outp2 => midDataMuxOut
			);
topMUXFINAL : topMux 
	port 
		map 
			(
				in0 => midPCinc, 
				in1 => midAluAin, 
				in2 => midIDEXdata1, 
				in3 => midIDEXdata2, 
				in4 => midDataMuxOut, 
				in5 => midMisc, 
				in6 => midMisc, 
				in7 => midMisc, 
			   inSel => ValueSelect, 
				outMux => midOutMux
			);
--DRive outputs :
midMisc(0) <= midZero;
midMisc(1) <= midRegDst;
midMisc(2) <= midJump;
midMisc(3) <= midMemRead;
midMisc(4) <= midMem2Reg;
midMisc(6 downto 5) <= midAlUopCode;
midMisc(7) <= midAluSrc;
MuxOut <= midOutMux;
InstructionOut <= midInstOutMem;
RegWriteOut <= midRegWrite;
MemWriteOut <= midWriteAssrt;
ZeroOut <= midZero;
BranchOut <= midBranchMuchSelOut;	
--ts_PCout <= midPCout;
--ts_PCinc <= midPCinc;
--ts_Muxop2 <= midBranchALUAdd;
--tsINSTIFID <= midIDInstrOutMem;
--tsZero_flag <= midZeroFlag;
--tsMUXOUT <= midMuxOutBranch;
--tsBEQ <= midBEQ;
--tsFlush <= midFlush;
--ts_muxBuff <= midbuff;

end RTL;