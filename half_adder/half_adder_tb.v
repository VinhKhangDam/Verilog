`timescale 1ps/1ps

module half_adder_tb;
    reg a, b;
    wire sum ,cout;

    half_adder hd(
        .a(a),
        .b(b),
        .sum(sum),
        .cout(cout)
    );

initial begin
    $dumpfile("half_adder_tb.vcd");
    $dumpvars(0, half_adder_tb);

    a = 1'b0; b = 1'b0; #10;
    a = 1'b0; b = 1'b1; #10;
    a = 1'b1; b = 1'b0; #10;
    a = 1'b1; b = 1'b1; #10;

    $finish;
end

endmodule