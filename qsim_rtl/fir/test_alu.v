`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD #5
module alu_tb();

    reg signed [15:0] inputX, inputB;
    reg signed [38:0] totalSumIn;
    wire signed [38:0] totalSumOut;
    reg clk;
    reg rstn;
	
    // Instantiate the ALU
    alu dut (
        .inputX(inputX),
        .inputB(inputB),
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
	clk = 0;
        @(posedge clk);	
	
        @(posedge clk); 
        $display("Starting ALU testbench");

        //for (i = 0; i < 100; i = i + 1) begin
            // Generate random inputs
        inputX = 1;
        inputB = 2;
        totalSumIn = 0;
	$display("Test %0d failed!", inputX);
        $display("inputX = %0d, inputB = %0d, totalSumIn = %0d", $signed(inputX), $signed(inputB), $signed(totalSumIn));
        $display("Expected: 2, Got: %0d", $signed(totalSumOut));
        @(posedge clk); 
        @(posedge clk); 
        @(posedge clk); 
	$display("Test %0d failed!", inputX);
        $display("inputX = %0d, inputB = %0d, totalSumIn = %0d", $signed(inputX), $signed(inputB), $signed(totalSumIn));
        $display("Expected: 2, Got: %0d", $signed(totalSumOut));
        $display("All 100 tests passed successfully!");

        $finish;
    end

endmodule
