module shift_left_4bit (
    input [3:0] in,
    input [1:0] n,
    output [3:0] out
);
    
assign out = in << n;
endmodule