module machchuyen (
    input i, q1, q0,
    output d1, d0
);
assign d1 = i & ~(q1) & q0 | i & q1 & ~(q0);
assign d0 = ~i & ~(q1) | ~i & q0 | i & q1 & ~(q0);

endmodule

module dff (
    input i, clk, rst,
    output reg o
);
always @(posedge clk or posedge rst) begin
    if (rst) o <= 0;
    else o <= i;
end

endmodule

module mealy (
    input i, clk, rst,
    output y
);

wire d1, d0, q1, q0;
machchuyen m1(i, q1, q0, d1, d0);
dff f1(d1, clk, rst, q1);
dff f2(d0, clk, rst, q0);

assign y = q1 & q0 & ~i;  // Điều kiện phát hiện 1101

endmodule