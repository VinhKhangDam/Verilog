`timescale 1ps/1ps

module mul4bit_tb;
    reg [3:0] a, b;
    wire [7:0] mul;

    mul4bit m4(
        .a(a),
        .b(b),
        .mul(mul)
    );

initial begin
    $dumpfile("mul4bit_tb.vcd");
    $dumpvars(0, mul4bit_tb);

    $monitor ("Time = %0t | a = %b b = %b => mul = %b", $time, a, b, mul);

    a = 4'b1000; b = 4'b0100; #10; //8 * 4 = 32 = 00100000

    a = 4'b0010; b = 4'b1010; #10; //2 * 10 = 20 = 00010100

    a = 4'b111; b = 4'b1111; #10; //11 * 11 = 121 = 01101001

    $finish;
end
endmodule