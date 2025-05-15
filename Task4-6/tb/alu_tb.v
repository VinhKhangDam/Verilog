`timescale 1ns / 1ps
`include "../alu.v"
module alu_tb;
    // Inputs
    reg [31:0] op1, op2;
    reg [3:0] alu_control;
    
    // Outputs
    wire [31:0] result;
    wire zero;
    
    // Instantiate the ALU module
    alu alu_inst (
        .op1(op1),
        .op2(op2),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );
    
    // Test procedure
    initial begin
        $dumpfile("../vcd/alu_tb.vcd");
        $dumpvars(0, alu_tb);
        // Initialize inputs
        op1 = 32'h00000000;
        op2 = 32'h00000000;
        alu_control = 4'b0000;
        
        // Test COMPLEMENT (~op1)
        #10;
        op1 = 32'hFFFFFFFF;
        alu_control = 4'b0000; // COMPLEMENT
        
        // Test AND (op1 & op2)
        #10;
        op1 = 32'hAAAA5555;
        op2 = 32'hFFFF0000;
        alu_control = 4'b0001; // AND       
        
        // Test XOR (op1 ^ op2)
        #10;
        op1 = 32'hAAAA5555;
        op2 = 32'hFFFF0000;
        alu_control = 4'b0010; // XOR
        
        // Test OR (op1 | op2)
        #10;
        op1 = 32'hAAAA5555;
        op2 = 32'hFFFF0000;
        alu_control = 4'b0011; // OR
        
        // Test DECREMENT (op1 - 1)
        #10;
        op1 = 32'h00000001;
        alu_control = 4'b0100; // DECREMENT
        
        // Test ADD (op1 + op2)
        #10;
        op1 = 32'h000000FF;
        op2 = 32'h00000001;
        alu_control = 4'b0101; // ADD
        
        // Test SUB (op1 - op2)
        #10;
        op1 = 32'h000000FF;
        op2 = 32'h00000001;
        alu_control = 4'b0110; // SUB
        
        // Test INCREMENT (op1 + 1)
        #10;
        op1 = 32'h000000FF;
        alu_control = 4'b0111; // INCREMENT
        
        // Test default case
        #10;
        op1 = 32'hAAAAAAAA;
        op2 = 32'h55555555;
        alu_control = 4'b1000; // Invalid control
        
        // Test zero flag
        #10;
        op1 = 32'h00000000;
        op2 = 32'h00000000;
        alu_control = 4'b0101; // ADD (result should be 0)
        
        // Finish simulation
        #10;
        $finish;
    end
endmodule