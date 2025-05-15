module datamem(
    input wire clk, 
    input wire MemWrite, MemRead,
    input wire [31:0] Address,
    input wire [31:0] WriteData_Mem,
    output reg [31:0] ReadData_Mem
);
reg [31:0] Mem [0:1023];
always @(posedge clk) begin
    if (MemWrite) begin
        Mem[Address[31:2]] <= WriteData_Mem;
    end
    else begin
        Mem[Address[31:2]] <= Mem[Address[31:2]];
    end
end
always @(*) begin
    if (MemRead) begin
        ReadData_Mem = Mem[Address[31:2]];
    end
    else begin
        ReadData_Mem = 32'b0;
    end
end
endmodule