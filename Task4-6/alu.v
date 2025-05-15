module alu (
    input wire [31:0] op1, op2,
    input wire [3:0] alu_control,
    output reg [31:0] result,
    output zero
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
        COMPLEMENT: result = ~op1;
        AND       : result = op1 & op2;
        XOR       : result = op1 ^ op2;
        OR        : result = op1 | op2;
        DECREMENT : result = op1 - 32'd1;
        ADD       : result = op1 + op2;
        SUB       : result = op1 - op2;
        INCREMENT : result = op1 + 1;
        default: result = 0;
    endcase
end
assign zero = (result == 0);
endmodule