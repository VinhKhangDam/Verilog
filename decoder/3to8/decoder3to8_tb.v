`timescale 1ps/1ps

module decoder3to8_tb;
    reg a, b, c;
    wire [7:0] out;

    decoder3to8 d38(
        .a(a),
        .b(b),
        .c(c),
        .out(out)
    );

initial begin
    $dumpfile("decoder3to8_tb.vcd");
    $dumpvars(0, decoder3to8_tb);

    a = 0; b = 0; c = 0; #10;
    a = 0; b = 0; c = 1; #10;
    a = 0; b = 1; c = 0; #10;
    a = 0; b = 1; c = 1; #10;
    a = 1; b = 0; c = 0; #10;
    a = 1; b = 0; c = 1; #10;
    a = 1; b = 1; c = 0; #10;
    a = 1; b = 1; c = 1; #10;

    $finish;
end
endmodule