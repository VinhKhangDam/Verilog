`timescale 1ps/1ps

module fullsub_tb;
    reg [3:0] sub1, sub2;
    wire [3:0] sub;
    wire cout_sub;

    fullsub fs(
        .sub1(sub1),
        .sub2(sub2),
        .sub(sub),
        .cout_sub(cout_sub)
    );

initial begin
    $dumpfile("fullsub_tb.vcd");
    $dumpvars(0, fullsub_tb);

    sub1 = 4'b1111; sub2 = 4'b1000; #10;
    sub1 = 4'b1000; sub2 = 4'b1000; #10;
    sub1 = 4'b0010; sub2 = 4'b1010; #10;
    $finish;
end
endmodule