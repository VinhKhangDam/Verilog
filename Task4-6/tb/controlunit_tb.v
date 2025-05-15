`timescale 1ns / 1ps
`include "../controlunit.v"
module controlunit_tb;
    // Inputs
    reg [5:0] opcode;
    reg [5:0] funct;
    
    // Outputs
    wire RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite;
    wire [3:0] ALU_Control;
    
    // Instantiate the control unit module
    controlunit controlunit_inst (
        .opcode(opcode),
        .funct(funct),
        .RegDst(RegDst),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALU_Control(ALU_Control)
    );
    
    // Test procedure
    initial begin
        $dumpfile("../vcd/controlunit_tb.vcd");
        $dumpvars(0, controlunit_tb);
        // Initialize inputs
        opcode = 6'b000000;
        funct = 6'b000000;
        
        // Test opcode 6'b000001, funct 6'b100000 (R-type, ADD)
        #10;
        opcode = 6'b000001;
        funct = 6'b100000; // funct for ADD (ALU_Control = 4'b0101)
        
        // Test opcode 6'b000001, invalid funct (default case for funct)
        #10;
        opcode = 6'b000001;
        funct = 6'b000000; // Invalid funct (ALU_Control = 4'b0000)
        
        // Test opcode 6'b000100 (likely Load Word)
        #10;
        opcode = 6'b000100;
        funct = 6'bxxxxxx; // funct ignored for this opcode
        
        // Test opcode 6'b000010 (likely Store Word)
        #10;
        opcode = 6'b000010;
        funct = 6'bxxxxxx; // funct ignored for this opcode
        
        // Test invalid opcode (default case)
        #10;
        opcode = 6'b111111; // Invalid opcode
        funct = 6'bxxxxxx;
        
        // Finish simulation
        #10;
        $finish;
    end
endmodule