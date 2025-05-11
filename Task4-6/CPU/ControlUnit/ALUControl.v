module ALUControl(
  input [1:0] ALU_Op,
  input [5:0] Funct,
  output reg [3:0] ALUControl_o
);

always @(*) begin
  case(ALU_Op)
    2'b00 : ALUControl_o = 4'b0101;
    2'b01 : ALUControl_o = 4'b0110;
    2'b10 : begin
      case(Funct) 
        6'b100000: ALUControl_o = 4'b0101; // ADD
        6'b100010: ALUControl_o = 4'b0110; // SUB
        6'b100100: ALUControl_o = 4'b0001; // AND
        6'b100101: ALUControl_o = 4'b0011; // OR
        6'b100110: ALUControl_o = 4'b0010; // XOR
        6'b100111: ALUControl_o = 4'b0000; // COMPLEMENT 
        6'b001000: ALUControl_o = 4'b0111; // INCREMENT
        6'b001001: ALUControl_o = 4'b0100; // DECREMENT
        default:   ALUControl_o = 4'b1111; // undefined
      endcase
    end
    default : ALUControl_o = 4'b0000; 
  endcase
end
endmodule


