module inmem(
    input wire [31:0] Address,
    output wire [31:0] instruction
);

reg [31:0] inmems [0:1023];

initial begin
    $readmemh("../testcase.txt", inmems);
    $display("Instruction memory is loading");
end

assign instruction = inmems[Address[31:2]];

endmodule