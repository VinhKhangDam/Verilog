module dual_port_ram (
    input clk, we_a, we_b,
    input [3:0] addr_a, addr_b,
    input [7:0] din_a, din_b,
    output [7:0] dout_a, dout_b
);

reg [7:0] mem [15:0];
always @(posedge clk) begin
    if (we_a)
        mem[addr_a] <= din_a;
    if (we_b)
        mem[addr_b] <= din_b;
end
assign dout_a = mem[addr_a];   
assign dout_b = mem[addr_b];

endmodule