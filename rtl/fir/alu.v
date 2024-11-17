`timescale 1ns/1ps
module alu (inputX, inputB, clk, rstn, totalSumIn, totalSumOut);
	input [15:0] inputX, inputB; 
	input [38:0] totalSumIn; 
	input rstn;
	input clk;
	output reg [38:0] totalSumOut;
	wire [31:0] result;
	wire [38:0] temp;
	
	assign result = inputX * inputB;
    	assign temp = totalSumIn + result;
	
	always @(posedge clk) begin
		if(~rstn)
			totalSumOut <= 0;
		else
			totalSumOut <= temp;
	end

endmodule
