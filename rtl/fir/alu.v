`timescale 1ns/1ps
module alu (inputX, inputB, totalSumIn, totalSumOut);
	input [15:0] inputX, inputB; 
	input [38:0] totalSumIn; 
	output wire [38:0] totalSumOut;
	wire [31:0] result;
	wire [38:0] temp;
	
	assign result = inputX * inputB;
    	assign totalSumOut = totalSumIn + result;

endmodule
