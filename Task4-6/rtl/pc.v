module pc (
   input wire        clk,    
   input wire        rst,
   output reg [31:0] pc_out 
);
    initial begin
        pc_out = 32'b0;
    end

   always @(posedge clk or negedge rst) begin
      if (!rst)
        begin
           pc_out <= 32'b0;
        end
      else
        begin
           pc_out <= pc_out + 32'd4;
        end
   end

endmodule