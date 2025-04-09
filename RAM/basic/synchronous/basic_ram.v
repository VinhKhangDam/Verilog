module basic_ram (
    input clk, we,
    input [3:0] addr,
    input [7:0] in,
    output reg [7:0] out
);

reg [7:0] mem [15:0];

always @(posedge clk) begin
    if (we)
        mem [addr] <= in;
    else
        out <= mem[addr];
end
endmodule