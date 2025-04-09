module add_sub_4bit (
    input [3:0] a, b,
    input select, 
    output reg [3:0] result
);

always @(*) begin
    if (select == 1'b0)
        result = a + b;
    else
        result = a - b;
end

endmodule
