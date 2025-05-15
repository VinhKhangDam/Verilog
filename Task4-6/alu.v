module alu (
    input wire [31:0] alu_op1, alu_op2,
    input wire [3:0] alu_control,
    output reg [31:0] alu_result,
    output alu_zero
);
parameter COMPLEMENT = 4'b0000;
parameter AND        = 4'b0001;
parameter XOR        = 4'b0010;
parameter OR         = 4'b0011;
parameter DECREMENT  = 4'b0100;
parameter ADD        = 4'b0101;
parameter SUB        = 4'b0110;
parameter INCREMENT  = 4'b0111;
always @(*) begin
    case(alu_control)
        COMPLEMENT: alu_result = ~alu_op1;
        AND       : alu_result = alu_op1 & alu_op2;
        XOR       : alu_result = alu_op1 ^ alu_op2;
        OR        : alu_result = alu_op1 | alu_op2;
        DECREMENT : alu_result = alu_op1 - 32'd1;
        ADD       : alu_result = alu_op1 + alu_op2;
        SUB       : alu_result = alu_op1 - alu_op2;
        INCREMENT : alu_result = alu_op1 + 1;
        default: alu_result = 0;
    endcase
end
assign alu_zero = (alu_result == 0);
endmodule