module counter (
  input clk, rst,
  output reg [6:0] seg1, seg2
);
reg [3:0] out1, out2;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    out1 <= 4'b0000;
    out2 <= 4'b0001; //bắt đầu từ 1
  end
  else begin  
    if (out2 == 4'b1001) begin
        out2 <= 4'b0000;
        out1 <= out1 + 4'b0001;
    end
    else begin
        out2 <= out2 + 4'b0001;
    end

   if (out1 == 4'b1001 && out2 == 4'b1001) begin
     out1 <= 4'b0000;
     out2 <= 4'b0001;
   end
  end 
end 
function [6:0] decode_7seg;
    input [3:0] num;
    case (num)
      4'b0000: decode_7seg = 7'b0111111; // 0
      4'b0001: decode_7seg = 7'b0000110; // 1
      4'b0010: decode_7seg = 7'b1011011; // 2
      4'b0011: decode_7seg = 7'b1001111; // 3
      4'b0100: decode_7seg = 7'b1100110; // 4
      4'b0101: decode_7seg = 7'b1101101; // 5
      4'b0110: decode_7seg = 7'b1111101; // 6
      4'b0111: decode_7seg = 7'b0000111; // 7
      4'b1000: decode_7seg = 7'b1111111; // 8
      4'b1001: decode_7seg = 7'b1101111; // 9
      default: decode_7seg = 7'b0000000;
    endcase
  endfunction

always @(*) begin
  seg1 = decode_7seg(out1);
  seg2 = decode_7seg(out2);
    
end
 endmodule
