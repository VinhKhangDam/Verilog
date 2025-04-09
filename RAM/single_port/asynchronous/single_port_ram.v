module single_port_ram (
    input clk, we,
    input [3:0] addr,
    input [7:0] din,
    output [7:0] dout
);

reg [7:0] mem [15:0];

initial begin
    mem[0] = 8'hE8;
end

always @(posedge clk) begin
    if (we)
        mem[addr] <= din;
end 
 
assign dout = mem[addr];
    
endmodule