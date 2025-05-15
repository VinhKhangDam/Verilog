module regfile(
    input wire regfile_clk, regfile_rst,
    input wire regfile_RegWrite,
    input wire [4:0] regfile_ReadReg1, regfile_ReadReg2, regfile_WriteReg, 
    input wire [31:0] regfile_WriteData,
    output reg [31:0] regfile_ReadData1, regfile_ReadData2
);

reg [31:0] Regs [0:31];
initial begin
    Regs[0] = 32'b0;
end

always @(posedge regfile_clk) begin
    if (!regfile_rst) begin
        Regs[0] <= 32'b0;
    end
    else if (regfile_RegWrite) begin
        if (regfile_WriteReg != 5'b00000) begin
            Regs[regfile_WriteReg] <= regfile_WriteData;
        end
    end
end

always @(*) begin
    regfile_ReadData1 = (regfile_ReadReg1 == 5'b00000) ? 32'b0 : Regs[regfile_ReadReg1];
    regfile_ReadData2 = (regfile_ReadReg2 == 5'b00000) ? 32'b0 : Regs[regfile_ReadReg2];
end
endmodule