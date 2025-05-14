`include "alu.v"
`include "signextend.v"
`include "regfile.v"
`include "datamem.v"
module Datapath(
    input clk,
    input RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite,
    input [3:0] ALUControl_Signal,
    input [25:0] Instruction,
    output [31:0] ALU_Result,
    output zero, overflow
  );
  wire [4:0] WriteReg;
  wire [31:0]ALU_Op2, SignEx_out, WriteData, ReadData1, ReadData2, MemRead_Data;
  assign WriteReg = (RegDst) ? Instruction[15:11] : Instruction[20:16];
  
  regfile rf(
    .clk(clk),
    .RegWrite(RegWrite),
    .ReadReg1(Instruction[25:21]),
    .ReadReg2(Instruction[20:16]),
    .WriteReg(WriteReg),
    .WriteData(WriteData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
  );
  
  signextend se(
    .in(Instruction[15:0]),
    .out(SignEx_out)
    );
  
  assign ALU_Op2 = (ALUSrc) ? SignEx_out : ReadData2;
  
  //ALU
  alu alu_unit(
      .operand1(ReadData1),
      .operand2(ALU_Op2),
      .aluop(ALUControl_Signal),
      .alu_out(ALU_Result),
      .add_sub_overflow(overflow),
      .zero(zero)
    );
  
  //DataMem
  datamem dm(
    .clk(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .Addr(ALU_Result),
    .WriteData(ReadData2),
    .ReadData(MemRead_Data)
    );
  
  assign WriteData = (MemToReg) ? ALU_Result: MemRead_Data; 
  
endmodule
  
  
  
  
  
  
  
  
