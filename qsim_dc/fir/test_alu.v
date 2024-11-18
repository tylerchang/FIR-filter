`timescale 1ns/1ps
`define SD #0.010
`define HALF_CLOCK_PERIOD #10
module testbench();

    reg [15:0] inputX, inputB;
    reg [38:0] totalSumIn;
    wire [38:0] totalSumOut;
    reg clk;
    reg rstn;
    // Instantiate the ALU
    alu alu (
        .inputX(inputX),
        .inputB(inputB),
	.clk(clk),
	.rstn(rstn),
        .totalSumIn(totalSumIn),
        .totalSumOut(totalSumOut)
    );
    always begin
	`HALF_CLOCK_PERIOD;
	clk = ~clk;
    end
    integer i;
    reg [38:0] expected_result;

    initial begin
        $dumpfile("./alu.vcd");
        $dumpvars(0,testbench.alu);
	clk = 0;
	rstn = 0;
        totalSumIn = 0;
        @(posedge clk);	
	@(negedge clk);
	rstn = 1;

        @(posedge clk); 
        $display("Starting ALU testbench");

        for (i = 0; i < 5; i = i + 1) begin
            // Generate random inputs
        	inputX = $random;
        	inputB = $random;
		expected_result = inputX * inputB + totalSumIn;
        	@(posedge clk);
        	@(posedge clk);
        	$display("inputX = %0d, inputB = %0d, totalSumIn = %0d", inputX, inputB, totalSumIn);
        	$display("Expected: %0d, Got: %0d", expected_result, totalSumOut);
		totalSumIn = totalSumOut;
	end
        $dumpall;
        $dumpflush;
        $finish;
    end

endmodule

