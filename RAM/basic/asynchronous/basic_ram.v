module basic_ram (
    input clk, we,
    input [3:0] addr,
    input [7:0] in,
    output [7:0] out
);

reg [7:0] mem [15:0];

always @(posedge clk) begin
    if (we)
        mem [addr] <= in;
end

assign out = mem[addr];

endmodule