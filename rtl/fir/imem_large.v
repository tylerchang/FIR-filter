module imem_large( Q, CLK, CEN, WEN, A, D);
	output [15:0] Q;
	input CLK;
	input CEN;
	input WEN;	
	input [5:0] A;
	input [15:0] D;
	
	
	imem memory(.Q(Q), .CLK(CLK), .CEN(CEN), .WEN(WEN), .A(A), .D(D));


endmodule
