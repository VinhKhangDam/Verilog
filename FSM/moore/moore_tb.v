//000

`timescale 1ps/1ps

module moore_tb;
    reg i, clk, rst;
    wire y;

    moore mrr(
        .i(i),
        .clk(clk),
        .rst(rst),
        .y(y)
    );

always #5 clk = ~clk;

initial begin
    $dumpfile("moore_tb.vcd");
    $dumpvars(0, moore_tb);

    clk = 0; rst = 1; #10;
    rst = 0;
    i = 1; #25;
    i = 0; #45;
    i = 1; #75;
    i = 0; #100;

    $finish;
end
endmodule