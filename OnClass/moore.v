module fsm_moore(
    input clk, rst,
    input [2:0] mssv_moore,
    output reg [1:0] done_moore
);
    reg [2:0] presentstate, nextstate;
    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter S4 = 4'd4;
always @(posedge clk or posedge rst) begin
    if (rst)
        presentstate <= S0;
    else
        presentstate <= nextstate;
end
always @(*) begin
    case (presentstate)
        S0 : begin
          done_moore = 2'b00;
            if (mssv_moore == 3'b000)
                nextstate = S1;
            else
                nextstate = S0;  
        end 
        S1 : begin
            done_moore = 2'b00;
            if (mssv_moore == 3'b110) 
                nextstate = S2;
            else if (mssv_moore == 3'b000)
                nextstate = S1;
            else    
                nextstate = S0;
        end
        S2 : begin
            done_moore = 2'b00;
            if (mssv_moore == 3'b000) 
                nextstate = S3;
            else    
                nextstate = S0;
        end
        S3 : begin
            done_moore = 2'b00;
            if (mssv_moore == 3'b110)
                nextstate = S4;
            else if (mssv_moore == 3'b000)
                nextstate = S1;
            else
                nextstate = S0;
        end
        S4 : begin
            if (mssv_moore % 2 == 0) 
                done_moore = 2'b11; 
            else if (mssv_moore %2 != 0)
                done_moore = 2'b10; 

            if (mssv_moore == 3'b000)
                nextstate = S3;
            else 
                nextstate = S4;
        end
        default: begin
            nextstate = S0;
            done_moore = 2'b00;
        end
    endcase    
end
endmodule



module fsm_moore_tb;
    reg clk, rst;
    reg [2:0] mssv_moore;
    wire [1:0] done_moore;

    fsm_moore uut (
        .clk(clk),
        .rst(rst),
        .mssv_moore(mssv_moore),
        .done_moore(done_moore)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        $dumpfile("moore.vcd");
        $dumpvars(0, fsm_moore_tb);
       
        clk = 0;
        rst = 1;
        mssv_moore = 3'b000;
        
        
        #10 rst = 0;


        #10 mssv_moore = 3'b000; 
        #10 mssv_moore = 3'b110; 
        #10 mssv_moore = 3'b000;
        #10 mssv_moore = 3'b110; 
        
        #10 mssv_moore = 3'b000; 
        #10 mssv_moore = 3'b110; 
        #10 mssv_moore = 3'b000; 
        #10 mssv_moore = 3'b111; 

        #10 mssv_moore = 3'b000; 
        #10 mssv_moore = 3'b110; 
        #10 mssv_moore = 3'b000; 
        #10 mssv_moore = 3'b001; 

        #10 mssv_moore = 3'b000; 
        #10 mssv_moore = 3'b110; 
        #10 mssv_moore = 3'b000; 
        #10 mssv_moore = 3'b010; 
        
        #20 $finish;
    end
endmodule
