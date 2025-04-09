`timescale 1ps/1ps

module single_port_ram_tb;
    reg clk, we;
    reg [3:0] addr;
    reg [7:0] din;
    wire [7:0] dout;

    single_port_ram sgr(
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

always #5 clk = ~clk;

initial begin
    $dumpfile("single_port_ram_tb.vcd");
    $dumpvars(0, single_port_ram_tb);

    clk = 0;
    //write
    we = 1;
    addr = 4'b0000; din = 8'h81; #10;
    addr = 4'b0001; din = 8'hEA; #10;
    addr = 4'b0010; din = 8'hFF; #10;

    //read
    we = 0;
    addr = 4'b0000; #1;
    addr = 4'b0001; #1;
    addr = 4'b0010; #1;

    $finish;
end

endmodule