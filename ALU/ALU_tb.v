`timescale 1ps/1ps

module ALU_tb;
    reg [3:0] a, b;
    reg [2:0] sel;
    wire [4:0] out;

    ALU ALU_inst (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );

initial begin
    $dumpfile("ALU_tb.vcd");
    $dumpvars(0, ALU_tb);

    a = 4'b1011; b = 4'b0111; sel = 3'b000; #10; 
    a = 4'b1011; b = 4'b0111; sel = 3'b001; #10;
    a = 4'b1011; b = 4'b0111; sel = 3'b010; #10;       
    a = 4'b1011; b = 4'b0111; sel = 3'b011; #10;
    a = 4'b1011; b = 4'b0111; sel = 3'b100; #10;
    a = 4'b1011; b = 4'b0111; sel = 3'b101; #10;
    a = 4'b1011; b = 4'b0111; sel = 3'b110; #10;
    a = 4'b1011; b = 4'b0111; sel = 3'b111; #10;

    $finish;
end

endmodule