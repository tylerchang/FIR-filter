module alu (input signed [15:0] inputX, inputB, input signed [38:0] totalSumIn, output wire signed [38:0] totalSumOut);

	wire signed [31:0] result;

	assign result = inputX * inputB;
    	assign totalSumOut = totalSumIn + result;

endmodule
