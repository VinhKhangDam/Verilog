`timescale 1ps/1ps

module dual_port_ram_tb;
    reg clk, we_a, we_b;
    reg [3:0] addr_a, addr_b;
    reg [7:0] din_a, din_b;
    wire [7:0] dout_a, dout_b;

    dual_port_ram dpr(
        .clk(clk),
        .we_a(we_a),
        .we_b(we_b),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .din_a(din_a),
        .din_b(din_b),
        .dout_a(dout_a),
        .dout_b(dout_b)
    );

always #5 clk = ~clk;

initial begin
    $dumpfile("dual_port_ram_tb.vcd");
    $dumpvars(0, dual_port_ram_tb);

    clk = 0;
    //write a and b
    we_a = 1; 
    addr_a = 4'b0000; din_a = 8'hEA; #10;
    addr_a = 4'b0010; din_a = 8'h12; #10;
    we_b = 1;
    addr_b = 4'b0100; din_b = 8'h32; addr_a = 4'b0011; din_a = 8'h11; #10;
    addr_b = 4'b0111; din_b = 8'hFF; addr_a = 4'b1000; din_a = 8'h00; #10;
    //read a and write b
    we_a = 0;
    addr_b = 4'b1001; din_b = 8'h21; addr_a = 4'b0000; #10;
    addr_b = 4'b1111; din_b = 8'hAA; addr_a = 4'b0010; #10;
    //read b and read a
    we_b = 0;
    addr_b = 4'b0100; addr_a = 4'b0011; #10;
    addr_b = 4'b0111; addr_a = 4'b1000; #10;
    //read b
    addr_b = 4'b1001; #10;
    addr_b = 4'b1111; #10;

    $finish;
end
endmodule