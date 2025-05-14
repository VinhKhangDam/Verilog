`include "Datapath.v"
`include "ALUControl.v"
`include "ControlUnit.v"
module CPU(
    input clk,
    input [31:0] Instruction,
    output [31:0] ALU_Result,
    output  zero,
    output overflow
  );
  
  wire RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite;
  wire [1:0] ALU_Op;
  wire [3:0] ALUControl_Signal;
  wire [31:0] WriteData, ReadData1, ReadData2, MemRead_Data;
  
  Datapath dp(
    .clk(clk),
    .RegDst(RegDst),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemToReg(MemToReg),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUControl_Signal(ALUControl_Signal),
    .Instruction(Instruction[25:0]),
    .ALU_Result(ALU_Result),
    .zero(zero),
    .overflow(overflow)
  );
  
  ControlUnit cn(
    .Opcode(Instruction[31:26]),
    .RegDst(RegDst),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemToReg(MemToReg),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALU_Op(ALU_Op)
  );
  
  ALUControl actrl(
    .ALU_Op(ALU_Op),
    .Funct(Instruction[5:0]),
    .ALUControl_o(ALUControl_Signal)
  );
  endmodule
  
