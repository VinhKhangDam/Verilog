module alu (
  input signed [31:0] operand1, operand2,
  input [2:0] aluop,
  output reg signed [31:0] alu_out,
  output reg add_sub_overflow
);

reg signed [31:0] alu_tmp;

parameter COMPLEMENT = 3'b000;
parameter AND        = 3'b001;
parameter XOR        = 3'b010;
parameter OR         = 3'b011;
parameter DECREMENT  = 3'b100;
parameter ADD        = 3'b101;
parameter SUB        = 3'b110;
parameter INCREMENT  = 3'b111;

always @(*) begin
  add_sub_overflow = 0;  // reset overflow flag
  case(aluop)
    COMPLEMENT  : alu_tmp = ~(operand1)+1;
    AND         : alu_tmp = operand1 & operand2;
    XOR         : alu_tmp = operand1 ^ operand2;
    OR          : alu_tmp = operand1 | operand2;
    DECREMENT   : alu_tmp = operand1 - 1;
    ADD         : begin
      alu_tmp = operand1 + operand2;
      add_sub_overflow = (operand1[31] == operand2[31]) && (alu_tmp[31] != operand1[31]);
    end
    SUB         : begin
      alu_tmp = operand1 - operand2;
      add_sub_overflow = (operand1[31] != operand2[31]) && (alu_tmp[31] != operand1[31]);
    end
    INCREMENT   : alu_tmp = operand1 + 1;
    default     : alu_tmp = 0;
  endcase
  alu_out = alu_tmp;
end

endmodule
