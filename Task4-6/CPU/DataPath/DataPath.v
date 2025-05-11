//Task 5
module DataPath(
  input clk,
  input RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite,
  input [3:0] ALUControl_Signal,
  input [25:0] Instruction,
  output [31:0] ALU_Result,
  output zero
);
wire [4:0] WriteReg;
wire [31:0] ReadData1, ReadData2, WriteData, ALU_Op2, SignEx_out, MemRead_Data;
assign WriteReg = (RegDst) ? Instruction[15:11] : Instruction[20:16];

RegFile rf(
  .clk(clk),
  .RegWrite(RegWrite),
  .ReadReg1(Instruction[25:21]),
  .ReadReg2(Instruction[20:16]),
  .WriteReg(WriteReg),
  .WriteData(WriteData),
  .ReadData1(ReadData1),
  .ReadData2(ReadData2)
);

SignExtend se(
  .in(Instruction[15:0]),
  .out(SignEx_out)
  );

assign ALU_Op2 = (ALUSrc) ? SignEx_out : ReadData2;

//ALU
ALU alu_unit(
    .Operand1(ReadData1),
    .Operand2(ALU_Op2),
    .ALUControl(ALUControl_Signal),
    .ALU_Result(ALU_Result),
    .zero(zero)
  );

//DataMem
DataMem dm(
  .clk(clk),
  .MemRead(MemRead),
  .MemWrite(MemWrite),
  .Addr(ALU_Result),
  .WriteData(ReadData2),
  .ReadData(MemRead_Data)
  );

assign WriteData = (MemToReg) ? MemRead_Data : ALU_Result; 

endmodule

module RegFile(
  input clk,
  input RegWrite,
  input [4:0] ReadReg1, ReadReg2, WriteReg,
  input [31:0] WriteData,
  output reg [31:0] ReadData1, ReadData2
);

reg [31:0] Regs [31:0];

always @(posedge clk) begin
  ReadData1 <= Regs[ReadReg1];
  ReadData2 <= Regs[ReadReg2];
  if (RegWrite) 
    Regs[WriteReg] <= WriteData;
  end
endmodule

module SignExtend(
  input [15:0] in,
  output [31:0] out
);

assign out = {{16{in[15]}}, in};

endmodule

module ALU(
  input [31:0] Operand1, Operand2,
  input [3:0] ALUControl,
  output reg [31:0] ALU_Result,
  output zero
);

parameter COMPLEMENT = 4'b0000;
parameter AND        = 4'b0001;
parameter XOR        = 4'b0010;
parameter OR         = 4'b0011;
parameter DECREMENT  = 4'b0100;
parameter ADD        = 4'b0101;
parameter SUB        = 4'b0110;
parameter INCREMENT  = 4'b0111;

always @(*) begin
  case(ALUControl)
    COMPLEMENT : ALU_Result = ~(Operand1) + 1;
    AND         : ALU_Result = Operand1 & Operand2;
    XOR         : ALU_Result = Operand1 ^ Operand2;
    OR          : ALU_Result = Operand1 | Operand2;
    DECREMENT   : ALU_Result = Operand1 - 1;
    ADD         : ALU_Result = Operand1 + Operand2;
    SUB         : ALU_Result = Operand1 - Operand2;
    INCREMENT   : ALU_Result = Operand1 + 1;
    default     : ALU_Result = 0;
  endcase
end
assign zero = (ALU_Result == 0);
endmodule

module DataMem(
  input clk,
  input MemWrite, input MemRead,
  input [31:0] Addr,
  input [31:0] WriteData,
  output reg [31:0] ReadData
);
reg [31:0] Mem [0:255];

always @(*) begin
  if (MemRead)
    ReadData = Mem[Addr[9:2]];
  else
    ReadData = 32'b0;
end

always @(posedge clk) begin
  if (MemWrite) begin
    Mem[Addr[9:2]] <= WriteData;
  end
end
endmodule

