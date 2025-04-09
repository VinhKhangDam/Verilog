module counter4bit (
    input clk, rst, up_down,
    output reg [3:0] result
);

always @(posedge clk) begin
    if (rst)
        result <= 4'b0000;
    else
        if (up_down == 1'b0) begin
            result <= result + 1'b1;
        end
        else    
            result <= result - 1'b1;
end
    
endmodule