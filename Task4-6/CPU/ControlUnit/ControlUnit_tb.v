`timescale 1ns / 1ps

module ControlUnit_tb;

    // Inputs
    reg [5:0] Opcode;
    
    // Outputs
    wire RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite;
    wire [1:0] ALU_Op;
    
    // Instantiate the ControlUnit module
    ControlUnit uut (
        .Opcode(Opcode),
        .RegDst(RegDst),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALU_Op(ALU_Op)
    );
    
    initial begin
        $dumpfile("ControlUnit_tb.vcd");
        $dumpvars(0, ControlUnit_tb);
        // Test 1: R-type instruction
        Opcode = 6'b000000;
        #10;
               
        // Test 2: LW instruction
        Opcode = 6'b100011;
        #10;
               
        // Test 3: SW instruction
        Opcode = 6'b101011;
        #10;
               
        // Test 4: Unknown instruction
        Opcode = 6'b111111;
        #10;
        // Finish simulation

       $finish;
    end
    
endmodule
