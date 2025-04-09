module mealy (
    input clk, rst,
    input [2:0] mssv_mealy,
    output reg [1:0] done_mealy
);
reg [1:0] presentstate, nextstate;
parameter S0 = 2'd0;
parameter S1 = 2'd1;
parameter S2 = 2'd2;
parameter S3 = 2'd3;
    
always @(posedge clk or posedge rst) begin
    if (rst)
        presentstate <= S0;
    else    
        presentstate <= nextstate;
end

always @(*) begin
    case (presentstate)
        S0: begin
            if (mssv_mealy == 3'b000) begin
                nextstate = S1;
                done_mealy = 2'b00;
            end
            else begin
                nextstate = S0;
                done_mealy = 2'b00;
            end
        end 
        S1 : begin
            if (mssv_mealy == 3'b110) begin
                nextstate = S2;
                done_mealy = 2'b00;
            end
            else if (mssv_mealy == 3'b000) begin
                nextstate = S1;
                done_mealy = 2'b00;
            end
            else begin
                nextstate = S0;
                done_mealy = 2'b00;
            end
        end
        S2 : begin
            if (mssv_mealy == 3'b000) begin
                nextstate = S3;
                done_mealy = 2'b00;
            end
            else begin
                nextstate = S0;
                done_mealy = 2'b00;
            end 
        end
        S3 : begin
            if (mssv_mealy % 2 == 1'b0 ) begin
                done_mealy = 2'b01;
                nextstate = S0;
            end
            else begin
                done_mealy = 2'b10;
                nextstate = S0;
                
            end
        end
        default: begin
            nextstate = S0;
            done_mealy = 2'b00;
        end
    endcase
end
endmodule

module mealy_tb;
    reg clk, rst;
    reg [2:0] mssv_mealy;
    wire [1:0] done_mealy; 

    mealy uut (
        .clk(clk),
        .rst(rst),
        .mssv_mealy(mssv_mealy),
        .done_mealy(done_mealy)
    );

 
    always #5 clk = ~clk;

    initial begin
        $dumpfile("mealy.vcd");
        $dumpvars(0, mealy_tb);
        
    
        clk = 0;
        rst = 1;
        mssv_mealy = 3'b000;
        
   
        #10 rst = 0;


        #10 mssv_mealy = 3'b000;
        #10 mssv_mealy = 3'b110; 
        #10 mssv_mealy = 3'b000;
        #10 mssv_mealy = 3'b110; 
        
        
        #10 mssv_mealy = 3'b110; // State S3 (done_mealy should still be 01)
        #10 mssv_mealy = 3'b000; // State S0 (reset to S0)
        
        // Test case 2: Going back to S1, S2 and then checking S3 behavior
        #10 mssv_mealy = 3'b000; // State S0 -> S1
        #10 mssv_mealy = 3'b110; // State S1 -> S2
        #10 mssv_mealy = 3'b000; // State S2 -> S3
        #10 mssv_mealy = 3'b110; // State S3 (done_mealy should be 01)
        
        // Test case 3: mssv_mealy % 2 == 0 in S3
        #10 mssv_mealy = 3'b000; // State S0 -> S1
        #10 mssv_mealy = 3'b110; // State S1 -> S2
        #10 mssv_mealy = 3'b000; // State S2 -> S3
        #10 mssv_mealy = 3'b000; // State S3 (done_mealy should be 10 because mssv_mealy % 2 == 0)

        // Test case 4: mssv_mealy % 2 == 1 in S3
        #10 mssv_mealy = 3'b000; // State S0 -> S1
        #10 mssv_mealy = 3'b110; // State S1 -> S2
        #10 mssv_mealy = 3'b000; // State S2 -> S3
        #10 mssv_mealy = 3'b001; // State S3 (done_mealy should be 11 because mssv_mealy % 2 == 1)

        // Test case 5: Triggering reset during S3
        #10 mssv_mealy = 3'b110; // State S3 (done_mealy should be 01)
        #10 rst = 1;             // Reset to S0
        #10 rst = 0;             // Back to normal state
        #10 mssv_mealy = 3'b000; // State S0 -> S1

        #20 $finish;
    end
endmodule
