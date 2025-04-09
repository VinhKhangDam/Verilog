module machchuyen (
    input i,
    input [1:0] q,
    output [1:0] d
);

assign d[1]= (~i) & ~(q[1]) & q[0] | ~i & q[1] & ~(q[0]);
assign d[0] = ~i & q[1] | ~i & ~(q[0]);    
endmodule

module dff (
    input d, clk, rst,
    output reg q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 0;
    else 
        q <= d;
end
endmodule

module moore (
    input i, clk, rst,
    output y
);

wire [1:0] q, d;
machchuyen m1(i, q, d);
dff f1(d[1], clk, rst, q[1]);
dff f2(d[0], clk, rst, q[0]);
assign y = q[1] & q[0]; 

endmodule