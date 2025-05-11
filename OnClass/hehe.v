module test (clk, a, b, f, g);
input clk, a, b;
output f, g;
reg f, g;

lways @(negedge clk) begin
  f <= #5 a|b;
end
always @(posedge clk) begin
  g <= #10 f ^ b;
end
endmodule

module tb;
  reg clk, a, b;
  wire f, g;
 
  test t(
    .clk(clk),
    .a(a),
    .b(b),
    .f(f),
    .g(g)
  );

always #5 clk = ~clk;

initial begin
  $dumpfile ("dump.vcd");
  $dumpvars(0, tb);

  clk = 0; #10;
  a = 0; b = 0; #10;
  a = 0; b = 1; #10;
  a = 1; b = 0; #10;
  a = 1; b = 1; #10;
  
  $finish;
end
endmodule

