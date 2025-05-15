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

   // Test stimulus
   initial begin
        $dumpfile("../vcd/datapath.vcd");
        $dumpvars(0, datapath_tb);
       $display("Starting Testbench...");

       // Initialize inputs
       clk = 0;
       rst = 0; // Start with reset asserted (active-low)

       // Apply reset sequence
       #20; 
       rst = 1; // Release reset
       #10; // Wait one more cycle for PC to update to 0 and fetch first instruction

       // Display initial state
       $display("--- Initial State After Reset ---");
       $display("Time | PC       | Instruction | RegWrite | MemRead | MemWrite | ALU Result | Rd1 Addr | Rd2 Addr | Read Data1 | Read Data2 | Reg Write Data");
       $display("--------------------------------------------------------------------------------------------------------------------------------------------------------------------");
       $display("%4d | %8h | %11h | %8b | %7b | %8b | %10h | %8d | %8d | %10h | %10h | %14h",
                $time, pc, instruction, RegWrite, MemRead, MemWrite, ALU_Result,
                dut.rf.regfile_ReadReg1, dut.rf.regfile_ReadReg2, dut.rf.regfile_ReadData1, dut.rf.regfile_ReadData2, dut.rf.regfile_WriteData);

       // Initialize Data Memory
       $display("--- Initializing Data Memory ---");
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
       $display("--- Initializing Registers ---");
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

       $display("--- Executing Instructions ---");
       // Execute 111 instructions
       repeat (111) begin
           @(posedge clk);
           $display("Time | PC       | Instruction | RegWrite | MemRead | MemWrite | ALU Result | Rd1 Addr | Rd2 Addr | Read Data1 | Read Data2 | Reg Write Data");
           $display("--------------------------------------------------------------------------------------------------------------------------------------------------------------------");
           $display("%4d | %8h | %11h | %8b | %7b | %8b | %10h | %8d | %8d | %10h | %10h | %14h",
                    $time, pc, instruction, RegWrite, MemRead, MemWrite, ALU_Result,
                    dut.rf.regfile_ReadReg1, dut.rf.regfile_ReadReg2, dut.rf.regfile_ReadData1, dut.rf.regfile_ReadData2, dut.rf.regfile_WriteData);
           // Display register file read data
           $display("       | Register File Read Data 1: %h, Read Data 2: %h",
                    dut.rf.regfile_ReadData1, dut.rf.regfile_ReadData2);
           // Display key register contents
           $display("       | $t0 (R8): %h, $t1 (R9): %h, $t2 (R10): %h, $t3 (R11): %h",
                    dut.rf.Regs[8], dut.rf.Regs[9], dut.rf.Regs[10], dut.rf.Regs[11]);
           $display("       | $t4 (R12): %h, $t5 (R13): %h, $t6 (R14): %h, $t7 (R15): %h",
                    dut.rf.Regs[12], dut.rf.Regs[13], dut.rf.Regs[14], dut.rf.Regs[15]);
           $display("       | $s0 (R16): %h, $s1 (R17): %h, $s2 (R18): %h, $s3 (R19): %h",
                    dut.rf.Regs[16], dut.rf.Regs[17], dut.rf.Regs[18], dut.rf.Regs[19]);
           $display("       | $s4 (R20): %h, $s5 (R21): %h, $s6 (R22): %h, $s7 (R23): %h",
                    dut.rf.Regs[20], dut.rf.Regs[21], dut.rf.Regs[22], dut.rf.Regs[23]);
           // Display key memory locations
           $display("       | Mem[Word 64 (0x100)]: %h, Mem[Word 65 (0x104)]: %h, Mem[Word 66 (0x108)]: %h",
                    dut.dm.Mem[64], dut.dm.Mem[65], dut.dm.Mem[66]);
           $display("       | Mem[Word 67 (0x10C)]: %h, Mem[Word 68 (0x110)]: %h, Mem[Word 69 (0x114)]: %h",
                    dut.dm.Mem[67], dut.dm.Mem[68], dut.dm.Mem[69]);
           $display("       | Mem[Word 70 (0x118)]: %h, Mem[Word 71 (0x11C)]: %h, Mem[Word 72 (0x120)]: %h, Mem[Word 73 (0x124)]: %h",
                    dut.dm.Mem[70], dut.dm.Mem[71], dut.dm.Mem[72], dut.dm.Mem[73]);
       end

       $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
       $display("MIPS Datapath Testbench finished.");
       
       $finish; // End simulation
   end

endmodule