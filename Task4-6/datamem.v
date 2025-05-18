module datamem(
    input wire datamem_clk, 
    input wire datamem_MemWrite, datamem_MemRead,
    input wire [31:0] datamem_address,
    input wire [31:0] datamem_Write,
    output reg [31:0] datamem_Read
);
reg [31:0] Mem [0:1023];
always @(posedge datamem_clk) begin
    if (datamem_MemWrite) begin
        Mem[datamem_address[31:2]] <= datamem_Write;
    end
    else begin
        Mem[datamem_address[31:2]] <= Mem[datamem_address[31:2]];
    end
end
always @(*) begin
    if (datamem_MemRead) begin
        datamem_Read = Mem[datamem_address[31:2]];
    end
    else begin
        datamem_Read = 32'b0;
    end
end
endmodule