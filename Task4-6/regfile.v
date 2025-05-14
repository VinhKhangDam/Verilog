module regfile(
    input clk,
    input RegWrite,
    input [4:0] ReadReg1, ReadReg2, WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1, ReadData2
  );
  
  reg [31:0] Regs [31:0];
  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) 
      Regs[i] = 0;
  end
  
  // always @(negedge clk) begin
  assign ReadData1 = Regs[ReadReg1];
  assign ReadData2 = Regs[ReadReg2];
  // end
  
  always @(posedge clk) begin
    if (RegWrite) 
      Regs[WriteReg] <= WriteData;
    end
  endmodule