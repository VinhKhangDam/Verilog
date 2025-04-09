module fa_1bit (
    input a, b, cin,
    output sum, cout 
);

assign sum = a ^ b ^ cin;
assign cout = a & b | cin & (a ^ b);
endmodule


module fa_4bit (
    input [3:0] s1, s2,
    input cin4,
    output [3:0] sum4, 
    output cout4
);
wire w1, w2, w3;
fa_1bit fa1(s1[0], s2[0], cin4, sum4[0], w1);
fa_1bit fa2(s1[1], s2[1], w1, sum4[1], w2);
fa_1bit fa3(s1[2], s2[2], w2, sum4[2], w3);
fa_1bit fa4(s1[3], s2[3], w3, sum4[3], cout4);
    
endmodule