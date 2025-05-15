module regfile(
    input wire clk, rst,
    input wire RegWrite,
    input wire [4:0] ReadReg1, ReadReg2, WriteReg, 
    input wire [31:0] WriteData,
    output reg [31:0] ReadData1, ReadData2
);

reg [31:0] Regs [0:31];
initial begin
    Regs[0] = 32'b0;
end

always @(posedge clk) begin
    if (!rst) begin
        Regs[0] <= 32'b0;
    end
    else if (RegWrite) begin
        if (WriteReg != 5'b00000) begin
            Regs[WriteReg] <= WriteData;
        end
    end
end

always @(*) begin
    ReadData1 = (ReadReg1 == 5'b00000) ? 32'b0 : Regs[ReadReg1];
    ReadData2 = (ReadReg2 == 5'b00000) ? 32'b0 : Regs[ReadReg2];
end
endmodule