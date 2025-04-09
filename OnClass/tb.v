`timescale 1ps/1ps

module counter_7seg_tb;
  reg clk, rst;
  wire [6:0] seg1, seg2;
  
  counter uut (
    .clk(clk), 
    .rst(rst),  
    .seg1(seg1), 
    .seg2(seg2)
  );
  
   always #5 clk = ~clk;  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, counter_7seg_tb);
    clk = 0;
    rst = 1;
    #10 rst = 0;
    #1000;
  $finish;
  end
endmodule
