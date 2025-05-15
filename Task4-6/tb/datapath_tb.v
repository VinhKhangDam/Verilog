`timescale 1ns / 1ps
`include "../datapath.v"
module datapath_tb;

   // Clock and reset signals
   reg clk;
   reg rst;

   // Wires to connect to the datapath outputs
   wire RegWrite;
   wire MemWrite;
   wire MemRead;
   wire [31:0] pc;
   wire [31:0] instruction;
   wire [31:0] ReadData2;
   wire [31:0] ALU_Result;

   // Instantiate the datapath module
   datapath dut (
       .clk(clk),
       .rst(rst),
       .RegWrite(RegWrite),
       .MemWrite(MemWrite),
       .MemRead(MemRead),
       .pc(pc),
       .instruction(instruction),
       .ReadData2(ReadData2),
       .ALU_Result(ALU_Result)
   );

   // Clock generation
   always #5 clk = ~clk;

   // Function to get register name from index
   function [31:0] reg_name;
      input [4:0] reg_idx;
      begin
         case (reg_idx)
            5'd0:  reg_name = "$zero";
            5'd8:  reg_name = "$t0";
            5'd9:  reg_name = "$t1";
            5'd10: reg_name = "$t2";
            5'd11: reg_name = "$t3";
            5'd12: reg_name = "$t4";
            5'd13: reg_name = "$t5";
            5'd14: reg_name = "$t6";
            5'd15: reg_name = "$t7";
            5'd16: reg_name = "$s0";
            5'd17: reg_name = "$s1";
            5'd18: reg_name = "$s2";
            5'd19: reg_name = "$s3";
            5'd20: reg_name = "$s4";
            5'd21: reg_name = "$s5";
            5'd22: reg_name = "$s6";
            5'd23: reg_name = "$s7";
            default: reg_name = "unknown";
         endcase
      end
   endfunction

   // Test stimulus
   initial begin
        $dumpfile("../vcd/datapath.vcd");
        $dumpvars(0, datapath_tb);

        // Initialize inputs
        clk = 0;
        rst = 0; // Start with reset asserted (active-low)

        // Apply reset sequence
        #20; // Hold reset for 2 clock cycles
        rst = 1; // Release reset
        #10; // Wait one more cycle for PC to update to 0 and fetch first instruction

        // Initialize Data Memory
        dut.dm.Mem[0] = 32'h00000100; // Mem[0x00]
        dut.dm.Mem[1] = 32'h00000200; // Mem[0x04]
        dut.dm.Mem[2] = 32'h00000300; // Mem[0x08]
        dut.dm.Mem[3] = 32'h00000400; // Mem[0x0C]
        dut.dm.Mem[4] = 32'h00000500; // Mem[0x10]
        dut.dm.Mem[5] = 32'h00000600; // Mem[0x14]
        dut.dm.Mem[6] = 32'h00000700; // Mem[0x18]
        dut.dm.Mem[7] = 32'h00000800; // Mem[0x1C]
        dut.dm.Mem[8] = 32'h00000900; // Mem[0x20]
        dut.dm.Mem[9] = 32'h00000A00; // Mem[0x24]
        dut.dm.Mem[64] = 32'hDEADBEEF; // Mem[0x100]
        dut.dm.Mem[65] = 32'hCAFEF00D; // Mem[0x104]
        dut.dm.Mem[66] = 32'hF0F0F0F0; // Mem[0x108]
        dut.dm.Mem[67] = 32'hDEADBEEF; // Mem[0x10C]
        dut.dm.Mem[68] = 32'hCAFEF00D; // Mem[0x110]
        dut.dm.Mem[69] = 32'hF0F0F0F0; // Mem[0x114]
        dut.dm.Mem[70] = 32'hDEADBEEF; // Mem[0x118]
        dut.dm.Mem[71] = 32'hCAFEF00D; // Mem[0x11C]
        dut.dm.Mem[72] = 32'hF0F0F0F0; // Mem[0x120]
        dut.dm.Mem[73] = 32'hDEADBEEF; // Mem[0x124]

        // Initialize Register File
        dut.rf.Regs[8]  = 32'h00000000; // $t0 = 0
        dut.rf.Regs[9]  = 32'h0000000A; // $t1 = 10
        dut.rf.Regs[10] = 32'h00000014; // $t2 = 20
        dut.rf.Regs[11] = 32'h0000001E; // $t3 = 30
        dut.rf.Regs[12] = 32'h00000028; // $t4 = 40
        dut.rf.Regs[13] = 32'h00000032; // $t5 = 50
        dut.rf.Regs[14] = 32'h0000003C; // $t6 = 60
        dut.rf.Regs[15] = 32'h00000046; // $t7 = 70
        dut.rf.Regs[16] = 32'h00000050; // $s0 = 80
        dut.rf.Regs[17] = 32'h0000005A; // $s1 = 90
        dut.rf.Regs[18] = 32'h00000064; // $s2 = 100
        dut.rf.Regs[19] = 32'h0000006E; // $s3 = 110
        dut.rf.Regs[20] = 32'h00000078; // $s4 = 120
        dut.rf.Regs[21] = 32'h00000082; // $s5 = 130
        dut.rf.Regs[22] = 32'h0000008C; // $s6 = 140
        dut.rf.Regs[23] = 32'h00000096; // $s7 = 150
        dut.rf.Regs[0]  = 32'h00000000; // $zero = 0

        // Execute 111 instructions
        repeat (111) begin
            @(posedge clk);
            // Extract instruction fields
            if (instruction[31:26] == 6'b000001) begin // R-type (ADD)
               $display("Time: %4d, PC: %8h, ADD Instruction: %8h", 
                        $time, pc, instruction);
               $display("  %s (R%0d) = %8h, %s (R%0d) = %8h, %s (R%0d) = %8h",
                        reg_name(dut.rf.regfile_ReadReg1), dut.rf.regfile_ReadReg1, dut.rf.regfile_ReadData1,
                        reg_name(dut.rf.regfile_ReadReg2), dut.rf.regfile_ReadReg2, dut.rf.regfile_ReadData2,
                        reg_name(dut.rf.regfile_WriteReg), dut.rf.regfile_WriteReg, dut.rf.regfile_WriteData);
            end
            else if (instruction[31:26] == 6'b000100) begin // LW
               $display("Time: %4d, PC: %8h, LW Instruction: %8h", 
                        $time, pc, instruction);
               $display("  %s (R%0d) = %8h, %s (R%0d) = %8h",
                        reg_name(dut.rf.regfile_ReadReg1), dut.rf.regfile_ReadReg1, dut.rf.regfile_ReadData1,
                        reg_name(dut.rf.regfile_WriteReg), dut.rf.regfile_WriteReg, dut.rf.regfile_WriteData);
            end
            else if (instruction[31:26] == 6'b000010) begin // SW
               $display("Time: %4d, PC: %8h, SW Instruction: %8h", 
                        $time, pc, instruction);
               $display("  %s (R%0d) = %8h, %s (R%0d) = %8h",
                        reg_name(dut.rf.regfile_ReadReg1), dut.rf.regfile_ReadReg1, dut.rf.regfile_ReadData1,
                        reg_name(dut.rf.regfile_ReadReg2), dut.rf.regfile_ReadReg2, dut.rf.regfile_ReadData2);
            end
            else begin // NOP or unknown
               $display("Time: %4d, PC: %8h, Instruction: %8h (NOP or unknown)", 
                        $time, pc, instruction);
            end
        end

        $finish; // End simulation
   end

endmodule