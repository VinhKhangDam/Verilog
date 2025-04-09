`timescale 1ps/1ps

module dff_tb;
    reg d, clk, rst;
    wire q;

    dff d0(
        .d(d),
        .clk(clk),
        .rst(rst),
        .q(q)
    );

always #5 clk = ~clk;

initial begin
    $dumpfile("dff_tb.vcd");
    $dumpvars(0, dff_tb);

    clk = 0; rst = 1; #10;
    rst = 0; d = 1; #10;
    d = 0; #10;
    d = 1; #10;
    d = 0; #10
    #20;

    $finish;
end
endmodule