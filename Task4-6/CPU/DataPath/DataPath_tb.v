`timescale 1ns / 1ps

module DataPath_tb;

    // Inputs
    reg clk;
    reg RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite;
    reg [3:0] ALUControl_Signal;
    reg [25:0] Instruction;
    
    // Outputs
    wire [31:0] AlU_Result;
    wire zero;
    
    // Instantiate the DataPath module
    DataPath uut (
        .clk(clk),
        .RegDst(RegDst),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUControl_Signal(ALUControl_Signal),
        .Instruction(Instruction),
        .ALU_Result(AlU_Result),
        .zero(zero)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin

        $dumpfile("DataPath_tb.vcd");
        $dumpvars(0, DataPath_tb);
        // Initialize inputs
        clk = 0;
        RegDst = 0;
        MemRead = 0;
        MemWrite = 0;
        MemToReg = 0;
        ALUSrc = 0;
        RegWrite = 0;
        ALUControl_Signal = 0;
        Instruction = 0;
        
        // Wait for global reset
        #10;
        
        // Test 1: R-type instruction (ADD)
        Instruction = 26'b00010_00011_00001_00000_100000; // add $1, $2, $3        
        RegDst = 1;
        ALUSrc = 0;
        MemToReg = 0;
        RegWrite = 1;
        ALUControl_Signal = 4'b0101; // ADD
        #10;
        
        // Test 2: LW instruction
         Instruction = 26'b00001_00010_0000000000000100; // lw $1, 4($2)
        RegDst = 0;
        ALUSrc = 1;
        MemToReg = 1;
        RegWrite = 1;
        MemRead = 1;
        ALUControl_Signal = 4'b0101; // ADD for address calculation
        #10;
          
        // Test 3: SW instruction
        Instruction = 26'b00001_00010_0000000000001000; // sw $1, 8($2)
        RegDst = 0;
        ALUSrc = 1;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 1;
        ALUControl_Signal = 4'b0101; // ADD for address calculation
        #10;
         
        // Finish simulation
        #10 $finish;
    end
    
endmodule
