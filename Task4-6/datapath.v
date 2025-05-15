`include "../regfile.v"
`include "../alu.v"
`include "../sign_extend.v"
`include "../datamem.v"
`include "../inmem.v"
`include "../pc.v"
`include "../controlunit.v"
module datapath (
    input wire clk, rst,
    output RegWrite, MemWrite, MemRead,
    output [31:0] pc,
    output [31:0] instruction,
    output [31:0] ReadData2,
    output [31:0] MemWrite_Data,
    output [31:0] MemAddr,
    output [31:0] ALU_Result
);
wire [31:0] pc_tmp;
wire [31:0] instruction_tmp;

assign pc = pc_tmp;
assign instruction = instruction_tmp;

pc pc_d(
    .clk(clk),
    .rst(rst),
    .pc_out(pc_tmp)
);
inmem imem(
    .Address(pc_tmp),
    .instruction(instruction_tmp)
);

wire [5:0] opcode = instruction_tmp[31:26];
wire [4:0] rs      = instruction_tmp[25:21];
wire [4:0] rt      = instruction_tmp[20:16];
wire [4:0] rd      = instruction_tmp[15:11];
wire [5:0] funct   = instruction_tmp[5:0];
wire [15:0] immediate = instruction_tmp[15:0];

wire RegDst, ALUSrc, MemToReg;
wire[3:0] ALU_Control;

controlunit cu(
    .opcode(opcode),
    .funct(funct),
    .RegDst(RegDst),
    .MemToReg(MemToReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALU_Control(ALU_Control)
);

wire [31:0]ReadData1;
wire [31:0]sign_extend_imme;
wire [31:0] alu_op2;
wire [31:0] ReadData_Mem;
wire [31:0] WriteData;
wire [31:0] WriteReg;

regfile rf(
    .clk(clk),
    .rst(rst),
    .ReadReg1(rs),
    .ReadReg2(rt),
    .WriteReg(WriteReg),
    .WriteData(WriteData),
    .RegWrite(RegWrite),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

assign WriteReg = (RegDst) ? rd : rt;

sign_extend se(
    .in(immediate),
    .out(sign_extend_imme)
);

assign alu_op2 = (ALUSrc) ? sign_extend_imme : ReadData2;

alu al(
    .op1(ReadData1),
    .op2(alu_op2),
    .alu_control(ALU_Control),
    .result(ALU_Result)
);

assign MemAddr = ALU_Result;

assign WriteData_Mem = ReadData2;

datamem dm(
    .clk(clk),
    .Address(MemAddr),
    .WriteData_Mem(WriteData_Mem),
    .ReadData_Mem(ReadData_Mem),
    .MemRead(MemRead),
    .MemWrite(MemWrite)
);
endmodule