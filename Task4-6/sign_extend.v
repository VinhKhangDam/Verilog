module sign_extend(
    input [15:0] signextend_in,
    output [31:0] signextend_out
);
assign signextend_out = {{16{signextend_in[15]}}, signextend_in};
endmodule