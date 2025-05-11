`timescale 1ns / 1ps

module ALUControl_tb;

    // Inputs
    reg [1:0] ALU_Op;
    reg [5:0] Funct;
    
    // Outputs
    wire [3:0] ALUControl_o;
    
    // Instantiate the ALUControl module
    ALUControl uut (
        .ALU_Op(ALU_Op),
        .Funct(Funct),
        .ALUControl_o(ALUControl_o)
    );
    
    initial begin
        $dumpfile("ALUControl_tb.vcd");
        $dumpvars(0, ALUControl_tb);
        // Test 1: ALU_Op = 2'b00 (add immediate)
        ALU_Op = 2'b00;
        Funct = 6'bxxxxxx;
        #10;       
        // Test 2: ALU_Op = 2'b01 (subtract for beq)
        ALU_Op = 2'b01;
        Funct = 6'bxxxxxx;
        #10;       
        // Test 3: ALU_Op = 2'b10 (R-type)
        ALU_Op = 2'b10;
        // Test 3.1: ADD
        Funct = 6'b100000;
        #10;   
        // Test 3.2: SUB
        Funct = 6'b100010;
        #10;   
        // Test 3.3: AND
        Funct = 6'b100100;
        #10;      
        // Test 3.4: OR
        Funct = 6'b100101;
        #10;
        // Test 3.5: XOR
        Funct = 6'b100110;
        #10;       
        // Finish simulation
        $finish;
    end
    
endmodule
