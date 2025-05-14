module ControlUnit(
    input [5:0] Opcode,
    output reg RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite,
    output reg [1:0] ALU_Op
  );
  
  always @(*) begin
    case(Opcode)
      6'b000000 : begin //R-Type
        RegDst = 1;
        ALUSrc = 0;
        MemToReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        ALU_Op = 2'b00;
      end
      6'b100011: begin //LW
        RegDst = 0;
        ALUSrc = 1;
        MemToReg = 1;
        RegWrite = 1;
        MemRead = 1;
        MemWrite = 0;
        ALU_Op = 2'b11;
      end
      6'b101011: begin //SW
        RegDst = 0;
        ALUSrc = 1;
        MemToReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 1;
        ALU_Op = 2'b11;
      end
  
      default: begin
        RegDst = 0;
        ALUSrc = 0;
        MemToReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        ALU_Op = 2'b00;
      end
    endcase
  end
  endmodule
  
  
  