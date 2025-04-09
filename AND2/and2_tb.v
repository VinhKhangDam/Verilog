module and2_tb;
    reg a, b;
    wire result;


    and_2 a2(
        .a(a),
        .b(b),
        .result(result)
    );

initial begin
    $dumpfile("and2_tb.vcd");
    $dumpvars(0, and2_tb);

    $monitor("Time = %0t | a = %b , b = %b | result = %b", $time, a, b, result);

    a = 1'b0; b = 1'b0; #10;
    a = 1'b0; b = 1'b1; #10;
    a = 1'b1; b = 1'b0; #10;
    a = 1'b1; b = 1'b1; #10;

    $finish;
end

endmodule