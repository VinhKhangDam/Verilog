module datamem(
    input clk,
    input MemWrite, 
    input MemRead,
    input [31:0] Addr,
    input [31:0] WriteData,
    output reg [31:0] ReadData
  );
  reg [31:0] Mem [0:255];
  integer i;
  initial begin
    for (i = 0; i < 256; i = i + 1) 
      Mem[i] = 0;
  end
  
  // Asynchronous Read
  always @(*) begin
    if (MemRead)
      ReadData = Mem[Addr[9:2]];
    else
      ReadData = 32'b0;
  end
  
  // Synchronous Write
  always @(posedge clk) begin
    if (MemWrite)
      Mem[Addr[9:2]] <= WriteData;
  end
  endmodule