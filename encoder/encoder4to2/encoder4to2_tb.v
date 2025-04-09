`timescale 1ps/1ps

module encoder4to2_tb;
    reg a, b, c, d;
    wire [1:0] out;

    encoder4to2 e42(
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out(out)
    );

initial begin
    $dumpfile("encoder4to2_tb.vcd");
    $dumpvars(0, encoder4to2_tb);

    a = 0; b = 0; c = 0; d = 1; #10;
    a = 0; b = 0; c = 1; d = 0; #10;
    a = 0; b = 1; c = 0; d = 0; #10;
    a = 1; b = 0; c = 0; d = 0; #10;

    $finish;
end
endmodule