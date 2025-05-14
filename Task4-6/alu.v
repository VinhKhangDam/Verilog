module alu (
    input signed [31:0] operand1, operand2,
    input [3:0] aluop,
    output reg signed [31:0] alu_out,
    output reg add_sub_overflow,
    output zero
  );
  
  reg signed [31:0] alu_tmp;
  
  parameter COMPLEMENT = 4'b0000;
  parameter AND        = 4'b0001;
  parameter XOR        = 4'b0010;
  parameter OR         = 4'b0011;
  parameter DECREMENT  = 4'b0100;
  parameter ADD        = 4'b0101;
  parameter SUB        = 4'b0110;
  parameter INCREMENT  = 4'b0111;
  
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
  assign zero = (alu_out == 0);
  endmodule
  