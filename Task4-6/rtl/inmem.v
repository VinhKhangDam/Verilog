module inmem(
    input wire [31:0] inmem_address,
    output wire [31:0] inmem_instruction
);

reg [31:0] inmems [0:1023];

initial begin
    $readmemh("../testcase.txt", inmems);
    $display("Instruction memory is loading");
end

assign inmem_instruction = inmems[inmem_address[31:2]];

endmodule