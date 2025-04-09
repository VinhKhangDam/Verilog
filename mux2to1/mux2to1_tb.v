module mux2to1_tb;
    reg a, b, sel;
    wire s;

    mux2to1 m21(
        .a(a),
        .b(b),
        .sel(sel),
        .s(s)
    );

initial begin
    $dumpfile("mux2to1_tb.vcd");
    $dumpvars(0, mux2to1_tb);

    $monitor ("Time = %0t | a = %b |  b = %b select = %b | result = %b", $time, a, b, sel, s);
    a = 1'b1; b = 1'b0; sel = 1'b0; #10; 
    sel = 1'b1; #10;

    $finish;

end

endmodule
