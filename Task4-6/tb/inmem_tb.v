`timescale 1ns/1ps
`include "../inmem.v"
module inmem_tb;

    reg [31:0] Address;
    wire [31:0] instruction;

    inmem im(
        .Address(Address),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("../vcd/inmem.vcd");
        $dumpvars(0, inmem_tb);
        $display("Starting Instruction Memory testbench...");

        Address = 32'h0;

        #10;

        $display("Time | Address | Instruction");
        $display("=============================");

        repeat(30) begin 
            $display("%4d| %h   | %h", $time, Address, instruction);
            Address = Address + 32'd4;
            #10;
        end

        Address = 32'h20;
        #10;
        $display("%4d| %h   | %h", $time, Address, instruction);

        Address = 32'h100;
        #10;
        $display("%4d| %h   | %h", $time, Address, instruction);

        $finish;
    end
endmodule