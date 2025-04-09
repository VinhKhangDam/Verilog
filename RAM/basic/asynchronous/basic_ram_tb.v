`timescale 1ps/1ps

module basic_ram_tb;
    reg clk, we;
    reg [3:0] addr;
    reg [7:0] in;
    wire [7:0] out;

    basic_ram bsr(
        .clk(clk),
        .we(we),
        .addr(addr),
        .in(in),
        .out(out)
    );

always #5 clk = ~clk;

initial begin
    $dumpfile("basic_ram_tb.vcd");
    $dumpvars(0, basic_ram_tb);

    clk = 0;
    //write
    we = 1;
    addr = 4'b0000; in = 8'h81; #10;
    addr = 4'b0001; in = 8'hEA; #10;
    addr = 4'b0010; in = 8'hFF; #10;

    //read
    we = 0;
    addr = 4'b0000; #1;
    addr = 4'b0001; #1;
    addr = 4'b0010; #1;

    $finish;
end
endmodule