`timescale 1ns/100ps
`define SD #0.010
`define HALF_CLOCK_PERIOD #100
module testbench();

    reg [15:0] Data;
    reg [5:0] Address;
    
    reg [15:0] data_in [0: 63];
    reg [15:0] data_out [0:63];
    wire [15:0] Q;
    reg clk, WE, CE;
    // Instantiate the ALU
    cmem_large cmem_large(Q, clk, CE, WE, Address, Data);
    initial begin
    	data_in[0] = 16'h00; data_out[0] = 16'h00;
	data_in[1] = 16'h01; data_out[1] = 16'h01;
	data_in[2] = 16'h02; data_out[2] = 16'h02;
	data_in[3] = 16'h03; data_out[3] = 16'h03;
	data_in[4] = 16'h04; data_out[4] = 16'h04;
	data_in[5] = 16'h05; data_out[5] = 16'h05;
	data_in[6] = 16'h06; data_out[6] = 16'h06;
	data_in[7] = 16'h07; data_out[7] = 16'h07;
	data_in[8] = 16'h08; data_out[8] = 16'h08;
	data_in[9] = 16'h09; data_out[9] = 16'h09;
    end	
    always begin
	`HALF_CLOCK_PERIOD;
	clk = ~clk;
    end
    integer i;

    initial begin
	#5000;
        $dumpfile("./cmem.vcd");
        $dumpvars(0,testbench.cmem_large);
	clk = 0;
        WE = 0;
	CE = 0;
        Data = 0;
	Address = 0;
        @(posedge clk);
	@(negedge clk);
        @(posedge clk); 
        $display("Starting cmem testbench");

        for (i = 0; i < 10; i = i + 1) begin
            // Generate random inputs
        	Data = data_in[i];
                Address = i;
        	@(posedge clk);
        	@(posedge clk);
        	$display("dataIn = %0d, Address = %0d", Data, Address);
        	$display("Expected: %0d, Got: %0d", data_out[i], Q);
	end
        $dumpall;
        $dumpflush;
        $finish;
    end

endmodule
