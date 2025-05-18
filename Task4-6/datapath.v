`include "alu.v"
`include "sign_extend.v"
`include "controlunit.v"
`include "datamem.v"
`include "inmem.v"
`include "pc.v"
`include "regfile.v"
module datapath (
    input wire clk, rst,
    output wire RegWrite, MemWrite, MemRead,
    output wire [31:0] pc,
    output wire [31:0] instruction,
    output wire [31:0] ReadData2,
    output wire [31:0] ALU_Result
);

//Program counter
wire [31:0] pc_tmp;
wire [31:0] instruction_tmp;

assign pc = pc_tmp;
assign instruction = instruction_tmp;

pc pc_d(
    .clk(clk),
    .rst(rst),
    .pc_out(pc_tmp)
);

//Instruction Memory
inmem imem(
    .inmem_address(pc_tmp),
    .inmem_instruction(instruction_tmp)
);

//Instruction for datapath and control unit
wire [5:0] opcode       = instruction_tmp[31:26];
wire [4:0] rs           = instruction_tmp[25:21];
wire [4:0] rt           = instruction_tmp[20:16];
wire [4:0] rd           = instruction_tmp[15:11];
wire [5:0] funct        = instruction_tmp[5:0];
wire [15:0] immediate   = instruction_tmp[15:0];

//Control unit
wire RegDst, ALUSrc, MemToReg;
wire[3:0] ALU_Control;

controlunit cu(
    .controlunit_opcode(opcode),
    .controlunit_funct(funct),
    .controlunit_RegDst(RegDst),
    .controlunit_MemToReg(MemToReg),
    .controlunit_RegWrite(RegWrite),
    .controlunit_MemRead(MemRead),
    .controlunit_MemWrite(MemWrite),
    .controlunit_ALUSrc(ALUSrc),
    .controlunit_alu_control(ALU_Control)
);

//Reg File
wire [31:0] ReadData1;
wire [31:0] WriteData;
wire [4:0] WriteReg;
//Mux RegDst
assign WriteReg = (RegDst) ? rd : rt;
regfile rf(
    .regfile_clk(clk),
    .regfile_rst(rst),
    .regfile_ReadReg1(rs),
    .regfile_ReadReg2(rt),
    .regfile_WriteReg(WriteReg),
    .regfile_WriteData(WriteData),
    .regfile_RegWrite(RegWrite),
    .regfile_ReadData1(ReadData1),
    .regfile_ReadData2(ReadData2)
);

//Sign extend
wire [31:0] sign_extend_imme;
sign_extend se(
    .signextend_in(immediate),
    .signextend_out(sign_extend_imme)
);

//mux ALUSrc
wire [31:0] alu_op2;
assign alu_op2 = (ALUSrc) ? sign_extend_imme : ReadData2;
//ALU
alu al(
    .alu_op1(ReadData1),
    .alu_op2(alu_op2),
    .alu_control(ALU_Control),
    .alu_result(ALU_Result),
    .alu_zero()
);

wire [31:0] ReadData_Mem;
datamem dm(
    .datamem_clk(clk),
    .datamem_address(ALU_Result),
    .datamem_Write(ReadData2),
    .datamem_Read(ReadData_Mem),
    .datamem_MemRead(MemRead),
    .datamem_MemWrite(MemWrite)
);

assign WriteData = (MemToReg) ? ReadData_Mem : ALU_Result;

endmodule
