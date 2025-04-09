`timescale 1ps/1ps

module shift_left_4bit_tb;
    reg [3:0] in;
    reg [1:0] n;
    wire [3:0] out;

    shift_left_4bit sl4b(
        .in(in),
        .n(n),
        .out(out)
    );

initial begin
    $dumpfile("shift_left_4bit_tb.vcd");
    $dumpvars(0, shift_left_4bit_tb);

    in = 4'b1100; n = 2'b01; #10; // c = 110; <<1 = 1000 
    n = 2'b11; #10; // <<3 = 0000 = 0
    n = 2'b10; #10; // <<2 = 0000 = 0

    $finish;
end
endmodule