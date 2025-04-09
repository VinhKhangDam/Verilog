`timescale 1ps/1ps

module add_sub_4bit_tb;
    reg [3:0] a, b;
    reg select;
    wire [3:0] result;

    add_sub_4bit as4(
        .a(a),
        .b(b),
        .select(select),
        .result(result)
    );

initial begin
    $dumpfile("add_sub_4bit_tb.vcd");
    $dumpvars(0, add_sub_4bit_tb);

    a = 4'b1101; b = 4'b001; select = 1'b0; #10
    select = 1'b1; #10;

    $finish;
end
endmodule