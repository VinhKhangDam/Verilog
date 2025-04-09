`timescale 1ps/1ps

module decoder2to4_tb;
    reg a, b;
    wire [3:0] de2to4_result;

    decoder2to4 dec2to4(
        .a(a),
        .b(b),
        .de2to4_result(de2to4_result)
    );

initial begin
    $dumpfile("decoder2to4_tb.vcd");
    $dumpvars(0, decoder2to4_tb);

    $monitor ("Time = %0t | a = %b b = %b | result = %b", $time, a, b, de2to4_result);

    a = 0; b = 0; #10;
    a = 0; b = 1; #10;
    a = 1; b = 0; #10;
    a = 1; b = 1; #10; 
end
endmodule