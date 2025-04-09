module decoder2to4 (
    input a, b,
    output [3:0] de2to4_result
);
wire an, bn;
not n1(an, a);
not n2(bn, b);
and a3(de2to4_result[3],a, b);
and a2(de2to4_result[2], a, bn);
and a1(de2to4_result[1], an, b);
and a0(de2to4_result[0], an, bn);
    
endmodule