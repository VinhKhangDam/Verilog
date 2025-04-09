module fulladd (
    input a, b, cin,
    output sum, cout
);
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module fulladd_4 (
    input [3:0] add1, add2,
    input cin4,
    output [3:0] sum4,
    output cout4
);
wire [2:0] temp;
fulladd fa1(.a(add1[0]), .b(add2[0]), .cin(cin4), .sum(sum4[0]), .cout(temp[0]));
fulladd fa2(.a(add1[1]), .b(add2[1]), .cin(temp[0]), .sum(sum4[1]), .cout(temp[1]));
fulladd fa3(.a(add1[2]), .b(add2[2]), .cin(temp[1]), .sum(sum4[2]), .cout(temp[2]));
fulladd fa4(.a(add1[3]), .b(add2[3]), .cin(temp[2]), .sum(sum4[3]), .cout(cout4));
endmodule

module fullsub (
    input [3:0] sub1, sub2,
    output [3:0] sub,
    output cout_sub
);
wire [3:0] sub2_not;
not n1[3:0] (sub2_not[3:0], sub2[3:0]);
fulladd_4 fa5(
    .add1(sub1),
    .add2(sub2_not),
    .cin4(1'b1),
    .sum4(sub),
    .cout4(cout_sub)
);
endmodule