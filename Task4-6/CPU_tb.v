`timescale 1ns / 1ps
`include "CPU.v"

module CPU_tb;

// Inputse
reg clk;
reg [31:0] Instruction;

// Outputs
wire [31:0] ALU_Result;
wire zero;
wire overflow;

// Testbench variables
reg [31:0] instructions [0:110]; // 111 instructions
integer i, file, addr;
reg [31:0] expected_result;
reg [255:0] dummy_string;
integer scan_result;
// Instantiate the Unit Under Test (UUT)
CPU uut (
    .clk(clk),
    .Instruction(Instruction),
    .ALU_Result(ALU_Result),
    .zero(zero),
	.overflow(overflow)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock (10ns period)
end

// Test procedure
initial begin
    // Initialize inputs
    Instruction = 32'h00000000;

    // Read instructions from file
    file = $fopen("testcase.txt", "r");
    if (file == 0) begin
        $display("Error: Could not open testcase.txt");
        $finish;
    end
    i = 0;
    while (!$feof(file) && i < 111) begin
		scan_result = $fscanf(file, "%h\n", instructions[i]);
        if (scan_result == 1) begin
            i = i + 1;
        end else begin
            // Skip comments or empty lines
            scan_result = $fscanf(file, "%s\n", dummy_string);
        end
    end
    $fclose(file);
    $display("Loaded %0d instructions", i);

    // Initialize registers (as per testcase_datapath.txt)
    uut.dp.rf.Regs[8]  = 32'h00000000; // $t0
    uut.dp.rf.Regs[9]  = 32'h0000000A; // $t1
    uut.dp.rf.Regs[10] = 32'h00000014; // $t2
    uut.dp.rf.Regs[11] = 32'h0000001E; // $t3
    uut.dp.rf.Regs[12] = 32'h00000028; // $t4
    uut.dp.rf.Regs[13] = 32'h00000032; // $t5
    uut.dp.rf.Regs[14] = 32'h0000003C; // $t6
    uut.dp.rf.Regs[15] = 32'h00000046; // $t7
    uut.dp.rf.Regs[16] = 32'h00000050; // $s0
    uut.dp.rf.Regs[17] = 32'h0000005A; // $s1
    uut.dp.rf.Regs[18] = 32'h00000064; // $s2
    uut.dp.rf.Regs[19] = 32'h0000006E; // $s3
    uut.dp.rf.Regs[20] = 32'h00000078; // $s4
    uut.dp.rf.Regs[21] = 32'h00000082; // $s5
    uut.dp.rf.Regs[22] = 32'h0000008C; // $s6
    uut.dp.rf.Regs[23] = 32'h00000096; // $s7
    uut.dp.rf.Regs[0]  = 32'h00000000; // $zero

    // Initialize data memory (as per testcase_datapath.txt)
    uut.dp.dm.Mem[0]   = 32'h00000100; // Mem[0x00]
    uut.dp.dm.Mem[1]   = 32'h00000200; // Mem[0x04]
    uut.dp.dm.Mem[2]   = 32'h00000300; // Mem[0x08]
    uut.dp.dm.Mem[3]   = 32'h00000400; // Mem[0x0C]
    uut.dp.dm.Mem[4]   = 32'h00000500; // Mem[0x10]
    uut.dp.dm.Mem[5]   = 32'h00000600; // Mem[0x14]
    uut.dp.dm.Mem[6]   = 32'h00000700; // Mem[0x18]
    uut.dp.dm.Mem[7]   = 32'h00000800; // Mem[0x1C]
    uut.dp.dm.Mem[8]   = 32'h00000900; // Mem[0x20]
    uut.dp.dm.Mem[9]   = 32'h00000A00; // Mem[0x24]
    // SW locations (0x100 to 0x124)
    for (addr = 64; addr < 74; addr = addr + 1) begin
        uut.dp.dm.Mem[addr] = 32'hDEADBEEF; // Initialize with dummy values
    end

    // Wait for global reset
    #100;

    // Apply each instruction
    for (i = 0; i < 111; i = i + 1) begin
        Instruction = instructions[i];
        addr = i * 4; // Instruction address (4 bytes per instruction)

        // Determine expected result for ADD instructions
        if (Instruction[31:26] == 6'b000001 && Instruction[5:0] == 6'b100000) begin
            // ADD instruction: add rd, rs, rt
            case (i)
                1: expected_result = 32'h0000001E; // $t0 = 10 + 20 = 30
                2: expected_result = 32'h00000028; // $t3 = 30 + 10 = 40
                3: expected_result = 32'h0000003C; // $t4 = 20 + 40 = 60
                4: expected_result = 32'h00000064; // $t5 = 40 + 60 = 100
                5: expected_result = 32'h000000A0; // $t6 = 60 + 100 = 160
                6: expected_result = 32'h00000104; // $t7 = 100 + 160 = 260
                7: expected_result = 32'h000001A4; // $s0 = 160 + 260 = 420
                8: expected_result = 32'h000001A4; // $s1 = 420 + 0 = 420
                9: expected_result = 32'h000001C2; // $t0 = 420 + 30 = 450
                10: expected_result = 32'h000001CC; // $t1 = 450 + 10 = 460
                default: expected_result = 32'h00000000;
            endcase
        end else if (Instruction[31:26] == 6'b000100) begin
            // LW instruction: lw rt, offset(rs)
            expected_result = uut.dp.dm.Mem[Instruction[15:0] >> 2]; // Memory value at offset
        end else begin
            expected_result = 32'h00000000; // For SW or others, no direct ALU_Result check
        end

        // Wait for one clock cycle
        #10;

        // Display results
        $display("Instr #%0d @ 0x%08h: Instr=0x%08h, ALU_Result=0x%08h, Overflow = %b,Zero=%b",
                 i, addr, Instruction, ALU_Result,overflow ,zero);

        // Verify ADD instructions
        if (Instruction[31:26] == 6'b000001 && Instruction[5:0] == 6'b100000 && i <= 10) begin
            if (ALU_Result == expected_result) begin
                $display("ADD Test #%0d PASSED: Expected=0x%08h, Got=0x%08h", i, expected_result, ALU_Result);
            end else begin
                $display("ADD Test #%0d FAILED: Expected=0x%08h, Got=0x%08h", i, expected_result, ALU_Result);
            end
        end

        // For LW instructions (initial and verification)
        if (Instruction[31:26] == 6'b000100 && (i >= 11 && i <= 20)) begin
            if (ALU_Result == expected_result) begin
                $display("LW Test #%0d PASSED: Expected=0x%08h, Got=0x%08h", i, expected_result, ALU_Result);
            end else begin
                $display("LW Test #%0d FAILED: Expected=0x%08h, Got=0x%08h", i, expected_result, ALU_Result);
            end
        end
    end

    // Verify SW by checking memory contents after all instructions
    #10;
    $display("Verifying SW instructions (Mem[0x100] to Mem[0x124]):");
    for (addr = 64; addr < 74; addr = addr + 1) begin
        $display("Mem[0x%03h]=0x%08h", addr*4, uut.dp.dm.Mem[addr]);
    end

    // End simulation
    $display("Simulation completed.");
    $finish;
end

initial begin
	$dumpfile("CPU.vcd");
	$dumpvars(0, CPU_tb);
end

endmodule