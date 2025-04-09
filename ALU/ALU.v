module ALU (
    input [3:0] a, b,
    input [2:0] sel,
    output reg [4:0] out
);

always @(*) begin
    if (sel == 3'b000)
        out = a + b;
    else if (sel == 3'b001)
        out = a + 4'b0001;
    else if (sel == 3'b010)
        out = a - b;
    else if (sel == 3'b011)
        out = a - 4'b0001;
    else if (sel == 3'b100)
        out = a & b;
    else if (sel == 3'b101)
        out = ~(a & b);
    else if (sel == 3'b110)
        out = a | b;
    else if (sel == 3'b111)
        out = a ^ b;
    else
        out = 4'b0000;
end
