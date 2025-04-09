module mul4bit (
    input [3:0] a, b,
    output reg [7:0] mul
);

always @(*) begin
    mul = a * b;
end

endmodule