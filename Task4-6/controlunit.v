module controlunit(
    input [5:0] opcode,
    input [5:0] funct,
    output reg RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite,
    output reg [3:0] ALU_Control
);

always @(*) begin
    RegDst = 0;
    ALUSrc = 0;
    MemToReg = 0;
    RegWrite = 1;
    MemRead = 0;
    MemWrite = 0;
    ALU_Control = 4'b0000;

    case(opcode) 
        6'b000001 : begin
            RegDst = 1;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            case (funct) 
                6'b100000 : ALU_Control = 4'b0101;
                default   : ALU_Control = 4'b0000;
            endcase
        end
        6'b000100 : begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            ALU_Control =  4'b0101;
        end
        6'b000010 : begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            ALU_Control =  4'b0101;
        end
        default: begin
            RegDst = 'bx;
            ALUSrc = 'bx;
            MemToReg = 'bx;
            RegWrite = 'bx;
            MemRead = 'bx;
            MemWrite = 'bx;
            ALU_Control = 'bxxxx;
        end
    endcase
end
endmodule