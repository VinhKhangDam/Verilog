module  encoder4to2 (
    input a, b, c, d,
    output [1:0] out
);

assign out[1] = a + b;
assign out[0] = a + c;

endmodule