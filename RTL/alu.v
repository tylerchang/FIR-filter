module alu (inputX, inputB, totalSumIn, totalSumOut);

input signed [15:0] inputX, inputB;
output wire signed [38:0] totalSumIn, totalSumOut;

wire signed [31:0] result;

assign result = inputX * inputB;
assign totalSumOut = totalSumIn + totalSumOut;

endmodule
