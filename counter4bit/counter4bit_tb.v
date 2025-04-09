`timescale 1ps/1ps

module counter4bit_tb;
    reg clk, rst, up_down;
    wire [3:0] result;

    counter4bit ct4(
        .clk(clk),
        .rst(rst),
        .up_down(up_down),
        .result(result)
    );

always #5 clk = ~clk;

initial begin
    $dumpfile("counter4bit_tb.vcd");
    $dumpvars(0, counter4bit_tb);

    clk = 0; #10;
    rst = 1; #10;
    rst = 0; up_down = 0; #200;
    up_down = 1; #200;

    $finish;
end
endmodule