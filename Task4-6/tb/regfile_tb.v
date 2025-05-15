`timescale 1ns / 1ps
`include "../regfile.v"
module regfile_tb;
    // Inputs
    reg clk;
    reg rst;
    reg RegWrite;
    reg [4:0] ReadReg1, ReadReg2, WriteReg;
    reg [31:0] WriteData;
    
    // Outputs
    wire [31:0] ReadData1, ReadData2;
    
    // Instantiate the register file module
    regfile regfile_inst (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Test procedure
    initial begin
        $dumpfile("../vcd/regfile.vcd");
        $dumpvars(0, regfile_tb);
        // Initialize inputs
        rst = 1;
        RegWrite = 0;
        ReadReg1 = 5'b0;
        ReadReg2 = 5'b0;
        WriteReg = 5'b0;
        WriteData = 32'h0;
        
        // Monitor outputs
        $monitor("Time=%0t clk=%b rst=%b RegWrite=%b WriteReg=%d WriteData=%h ReadReg1=%d ReadData1=%h ReadReg2=%d ReadData2=%h", 
                 $time, clk, rst, RegWrite, WriteReg, WriteData, ReadReg1, ReadData1, ReadReg2, ReadData2);
        
        // Test 1: Write to register 1 (before reset)
        #10;
        RegWrite = 1;
        WriteReg = 5'd1;
        WriteData = 32'hDEADBEEF;
        #10; // Wait for posedge clk to write
        
        // Test 2: Reset (only Regs[0] should be 0)
        #10;
        rst = 0; // Assert reset
        #10;
        rst = 1; // Deassert reset
        ReadReg1 = 5'd0;
        ReadReg2 = 5'd1;
        #10; // Check ReadData1=0, ReadData2=0xDEADBEEF (unchanged)
        
        // Test 3: Read from register 0 and 1
        #10;
        RegWrite = 0;
        ReadReg1 = 5'd0;
        ReadReg2 = 5'd1;
        #10; // Check ReadData1=0, ReadData2=0xDEADBEEF
        
        // Test 4: Write to register 31
        #10;
        RegWrite = 1;
        WriteReg = 5'd31;
        WriteData = 32'h12345678;
        #10; // Wait for posedge clk to write
        
        // Test 5: Read from register 31 and uninitialized register 2
        #10;
        RegWrite = 0;
        ReadReg1 = 5'd31;
        ReadReg2 = 5'd2;
        #10; // Check ReadData1=0x12345678, ReadData2=x (uninitialized)
        
        // Test 6: Attempt to write to register 0 (should not change)
        #10;
        RegWrite = 1;
        WriteReg = 5'd0;
        WriteData = 32'hFFFFFFFF;
        #10;
        ReadReg1 = 5'd0;
        ReadReg2 = 5'd31;
        #10; // Check ReadData1=0, ReadData2=0x12345678
        
        // Test 7: Attempt write with RegWrite=0 (no change)
        #10;
        RegWrite = 0;
        WriteReg = 5'd3;
        WriteData = 32'hA5A5A5A5;
        #10;
        ReadReg1 = 5'd3;
        ReadReg2 = 5'd1;
        #10; // Check ReadData1=x (unwritten), ReadData2=0xDEADBEEF
        
        // Test 8: Write and read same register in same cycle
        #10;
        RegWrite = 1;
        WriteReg = 5'd4;
        WriteData = 32'h5555AAAA;
        ReadReg1 = 5'd4;
        ReadReg2 = 5'd4;
        #10; // Check ReadData1/2=x (old value, since write is synchronous)
        #10;
        RegWrite = 0;
        #10; // Check ReadData1/2=0x5555AAAA after write
        
        // Finish simulation
        #10;
        $finish;
    end
endmodule