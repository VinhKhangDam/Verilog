module mux2to1 (
    input a, b, sel,
    output s
);
    
assign s = (~sel) & a | sel & b; 

endmodule

