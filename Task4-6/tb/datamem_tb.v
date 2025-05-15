`timescale 1ns / 1ps
`include "../datamem.v"
module datamem_tb;
    // Inputs
    reg clk;
    reg MemWrite, MemRead;
    reg [31:0] Address;
    reg [31:0] WriteData_Mem;
    
    // Output
    wire [31:0] ReadData_Mem;
    
    // Instantiate the data memory module
    datamem datamem_inst (
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(Address),
        .WriteData_Mem(WriteData_Mem),
        .ReadData_Mem(ReadData_Mem)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Test procedure
    initial begin
        $dumpfile("../vcd/datamem.vcd");
        $dumpvars(0, datamem_tb);
        // Initialize inputs
        MemWrite = 0;
        MemRead = 0;
        Address = 32'h0;
        WriteData_Mem = 32'h0;
        
        // Monitor outputs
        $monitor("Time=%0t clk=%b MemWrite=%b MemRead=%b Address=%h WriteData_Mem=%h ReadData_Mem=%h", 
                 $time, clk, MemWrite, MemRead, Address, WriteData_Mem, ReadData_Mem);
        
        // Test 1: Write to address 0x0
        #10;
        MemWrite = 1;
        MemRead = 0;
        Address = 32'h00000000; // Maps to Mem[0]
        WriteData_Mem = 32'hDEADBEEF;
        #10; // Wait for posedge clk to write
        
        // Test 2: Read from address 0x0
        #10;
        MemWrite = 0;
        MemRead = 1;
        Address = 32'h00000000;
        #10; // Check ReadData_Mem = 0xDEADBEEF
        
        // Test 3: Write to address 0x4 (word-aligned, maps to Mem[1])
        #10;
        MemWrite = 1;
        MemRead = 0;
        Address = 32'h00000004; // Maps to Mem[1]
        WriteData_Mem = 32'h12345678;
        #10; // Wait for posedge clk to write
        
        // Test 4: Read from address 0x4
        #10;
        MemWrite = 0;
        MemRead = 1;
        Address = 32'h00000004;
        #10; // Check ReadData_Mem = 0x12345678
        
        // Test 5: Read with MemRead=0 (should output 0)
        #10;
        MemWrite = 0;
        MemRead = 0;
        Address = 32'h00000000;
        #10; // Check ReadData_Mem = 0x0
        
        // Test 6: Attempt write with MemWrite=0 (no change)
        #10;
        MemWrite = 0;
        MemRead = 1;
        Address = 32'h00000000;
        WriteData_Mem = 32'hFFFFFFFF;
        #10; // Check ReadData_Mem still 0xDEADBEEF
        
        // Test 7: Write and read at another address (e.g., 0x3FF0, maps to Mem[1020])
        #10;
        MemWrite = 1;
        MemRead = 0;
        Address = 32'h00003FF0; // Maps to Mem[1020]
        WriteData_Mem = 32'hA5A5A5A5;
        #10; // Wait for posedge clk to write
        MemWrite = 0;
        MemRead = 1;
        #10; // Check ReadData_Mem = 0xA5A5A5A5
        
        // Finish simulation
        #10;
        $finish;
    end
endmodule