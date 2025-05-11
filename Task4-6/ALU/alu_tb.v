`timescale 1ps/1ps

module alu_tb;
  reg signed [31:0] operand1, operand2;
  reg [2:0] alu_op;
  wire signed [31:0] alu_out;
  wire add_sub_overflow;

  alu uut(
    .operand1(operand1),
    .operand2(operand2),
    .aluop(alu_op),
    .alu_out(alu_out),
    .add_sub_overflow(add_sub_overflow)
  );
  initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);
    //operand1 = 0000_0000_0000_0000_0000_0000_0010_0000
    //operand2 = 0000_0000_0000_0000_0000_0000_0010_0010
    operand1 = 32'd32;
    operand2 = 32'd34;
    alu_op = 3'b000; #10; //FFFFFFE0
    alu_op = 3'b001; #10; //00000020
    alu_op = 3'b010; #10; //00000002
    alu_op = 3'b011; #10; //00000022
    alu_op = 3'b100; #10; //0000001F
    alu_op = 3'b101; #10; //00000042
    alu_op = 3'b110; #10; //FFFFFFFE
    alu_op = 3'b111; #10; //00000021
    //check overflow
    //ADD
    // ✅ ADD overflow: 0x7FFFFFFF + 0x00000001 = overflow (2147483647 + 1)
    operand1 = 32'h7FFFFFFF;  // +2147483647
    operand2 = 32'h00000001;  // +1
    alu_op = 3'b101;           // ADD
    #10;

    // ✅ SUB overflow: 0x80000000 - 0xFFFFFFFF = overflow (-2147483648 - (-1))
    operand1 = 32'h7FFFFFFF;  // 2147483647
    operand2 = 32'hFFFFFFFF;  // -1    alu_op = 3'b110;           // SUB
    alu_op = 3'b110;
    #10;    
    $finish;
 end
endmodule
