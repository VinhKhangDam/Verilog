module controlunit(
    input [5:0] controlunit_opcode,
    input [5:0] controlunit_funct,
    output reg controlunit_RegDst, controlunit_MemRead, controlunit_MemWrite, controlunit_MemToReg, controlunit_ALUSrc, controlunit_RegWrite,
    output reg [3:0] controlunit_alu_control
);

always @(*) begin
    controlunit_RegDst = 0;
    controlunit_ALUSrc = 0;
    controlunit_MemToReg = 0;
    controlunit_RegWrite = 1;
    controlunit_MemRead = 0;
    controlunit_MemWrite = 0;
    controlunit_alu_control = 4'b0000;

    case(controlunit_opcode) 
        6'b000000 : begin //NOP
            controlunit_RegDst = 0;
            controlunit_ALUSrc = 0;
            controlunit_MemToReg = 0;
            controlunit_RegWrite = 0;
            controlunit_MemRead = 0;
            controlunit_MemWrite = 0;
            controlunit_alu_control = 4'b0000;
        end
        6'b000001 : begin //R-Type(ADD)
            controlunit_RegDst = 1;
            controlunit_ALUSrc = 0;
            controlunit_MemToReg = 0;
            controlunit_RegWrite = 1;
            controlunit_MemRead = 0;
            controlunit_MemWrite = 0;
            case (controlunit_funct) 
                6'b100000 : controlunit_alu_control = 4'b0101;
                default   : controlunit_alu_control = 4'b0000;
            endcase
        end
        6'b000100 : begin//LW
            controlunit_RegDst = 0;
            controlunit_ALUSrc = 1;
            controlunit_MemToReg = 1;
            controlunit_RegWrite = 1;
            controlunit_MemRead = 1;
            controlunit_MemWrite = 0;
            controlunit_alu_control =  4'b0101;
        end
        6'b000010 : begin//SW
            controlunit_RegDst = 0;
            controlunit_ALUSrc = 1;
            controlunit_MemToReg = 0;
            controlunit_RegWrite = 0;
            controlunit_MemRead = 0;
            controlunit_MemWrite = 1;
            controlunit_alu_control =  4'b0101;
        end
        default: begin
            controlunit_RegDst = 0;
            controlunit_ALUSrc = 0;
            controlunit_MemToReg = 0;
            controlunit_RegWrite = 0;
            controlunit_MemRead = 0;
            controlunit_MemWrite = 0;
            controlunit_alu_control = 4'b0000;
        end
    endcase
end
endmodule