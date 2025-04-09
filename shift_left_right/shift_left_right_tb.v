`timescale 1ps/1ps

module shift_left_right_tb;
    reg [3:0] in;
    reg dir;
    reg [1:0] num;
    wire [3:0] out;

    shift_left_right shift_left_right_0 (
        .in(in),
        .dir(dir),
        .num(num),
        .out(out)
    );

initial begin
    $dumpfile("shift_left_right_tb.vcd");
    $dumpvars(0, shift_left_right_tb);

    in = 4'b1011; dir = 1'b0; num = 2'b11; #10;
    in = 4'b1011; dir = 1'b1; num = 2'b11; #10;

    $finish;
end

endmodule