`timescale 1ns / 1ps

module CPU_tb;

    // Inputs
    reg clk;
    reg [31:0] Instruction;
    
    // Outputs
    wire [31:0] ALU_Result;
    wire zero;
    
    // Instantiate the Unit Under Test (UUT)
    CPU uut (
        .clk(clk), 
        .Instruction(Instruction), 
        .ALU_Result(ALU_Result), 
        .zero(zero)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        // Initialize Inputs
        Instruction = 0;
        
        // Wait for global reset
        #10;
        
        // Test R-type ADD instruction (add $1, $2, $3)
        // opcode=000000, rs=2, rt=3, rd=1, shamt=0, funct=100000
        Instruction = 32'b000000_00010_00011_00001_00000_100000;
        #10;
        $display("R-type ADD: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Test R-type SUB instruction (sub $4, $5, $6)
        // opcode=000000, rs=5, rt=6, rd=4, shamt=0, funct=100010
        Instruction = 32'b000000_00101_00110_00100_00000_100010;
        #10;
        $display("R-type SUB: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Test R-type AND instruction (and $7, $8, $9)
        // opcode=000000, rs=8, rt=9, rd=7, shamt=0, funct=100100
        Instruction = 32'b000000_01000_01001_00111_00000_100100;
        #10;
        $display("R-type AND: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Test LW instruction (lw $10, 100($11))
        // opcode=100011, rs=11, rt=10, imm=100
        Instruction = 32'b100011_01011_01010_0000000001100100;
        #10;
        $display("LW: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Test SW instruction (sw $12, 200($13))
        // opcode=101011, rs=13, rt=12, imm=200
        Instruction = 32'b101011_01101_01100_0000000011001000;
        #10;
        $display("SW: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Test R-type OR instruction (or $14, $15, $16)
        // opcode=000000, rs=15, rt=16, rd=14, shamt=0, funct=100101
        Instruction = 32'b000000_01111_10000_01110_00000_100101;
        #10;
        $display("R-type OR: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Test R-type XOR instruction (xor $17, $18, $19)
        // opcode=000000, rs=18, rt=19, rd=17, shamt=0, funct=100110
        Instruction = 32'b000000_10010_10011_10001_00000_100110;
        #10;
        $display("R-type XOR: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Test R-type COMPLEMENT instruction (comp $20, $21)
        // opcode=000000, rs=21, rt=0, rd=20, shamt=0, funct=100111
        Instruction = 32'b000000_10101_00000_10100_00000_100111;
        #10;
        $display("R-type COMPLEMENT: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Test R-type INCREMENT instruction (inc $22, $23)
        // opcode=000000, rs=23, rt=0, rd=22, shamt=0, funct=001000
        Instruction = 32'b000000_10111_00000_10110_00000_001000;
        #10;
        $display("R-type INCREMENT: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Test R-type DECREMENT instruction (dec $24, $25)
        // opcode=000000, rs=25, rt=0, rd=24, shamt=0, funct=001001
        Instruction = 32'b000000_11001_00000_11000_00000_001001;
        #10;
        $display("R-type DECREMENT: ALU_Result=%h, zero=%b", ALU_Result, zero);
        
        // Finish simulation
        #10;
        $finish;
    end
    
endmodule
