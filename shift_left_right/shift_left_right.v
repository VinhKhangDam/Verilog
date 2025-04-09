module shift_left_right (
    input [3:0] in,
    input dir,
    input [1:0] num,
    output reg [3:0] out
);

always @(*) begin
    if (dir) //left
        out = in << num;
    else //right
        out = in >> num;
end
    
endmodule