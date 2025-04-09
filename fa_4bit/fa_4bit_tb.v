module fa_4bit_tb;
    reg [3:0] s1, s2;
    reg cin4;
    wire [3:0] sum4;
    wire cout4;

    fa_4bit fa4(
        .s1(s1),
        .s2(s2),
        .cin4(cin4),
        .sum4(sum4),
        .cout4(cout4)
    );

initial begin
    $dumpfile("fa_4bit_tb.vcd");
    $dumpvars(0, fa_4bit_tb);

    s1 = 4'b1111; s2 = 4'b1000; cin4 = 1'b0; #10;
    cin4 = 1'b1; #10;

    s1 = 4'b1000; s2 = 4'b0111; cin4= 1'b0; #10;
    cin4 = 1'b1; #10

    $finish;
end

endmodule