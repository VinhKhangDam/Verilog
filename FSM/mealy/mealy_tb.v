//0110

`timescale 1ps/1ps

module mealy_tb;
    reg i, clk, rst;
    wire y;

    mealy ml(
        .i(i),
        .clk(clk),
        .rst(rst),
        .y(y)
    );

always #5 clk = ~clk;

initial begin
    $dumpfile("mealy_tb.vcd");
    $dumpvars(0, mealy_tb);

    clk = 0; rst = 1; i = 0; #10;
    rst = 0;
    i = 1; #20;
    i = 0; #20;
    i = 1; #20;
    i = 0; #20;
    i = 1; #20;
    i = 0; #20;
    i = 1; #20;
    i = 0; #20;
    i = 1; #20;
    i = 0; #20;
    i = 1; #20;
    i = 0; #20;
    i = 1; #20;
    i = 0; #20;
    i = 1; #20;
    i = 0; #20;
    i = 1; #20;
    $finish;
end
endmodule