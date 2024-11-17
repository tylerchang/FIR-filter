`timescale 1ns/1ps

module alu_tb;

    reg signed [15:0] inputX, inputB;
    reg signed [38:0] totalSumIn;
    wire signed [38:0] totalSumOut;

    // Instantiate the ALU
    alu dut (
        .inputX(inputX),
        .inputB(inputB),
        .totalSumIn(totalSumIn),
        .totalSumOut(totalSumOut)
    );

    // Random number generation
    function [15:0] random_input;
        random_input = $random;
    endfunction

    integer i;
    reg [38:0] expected_result;

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        $display("Starting ALU testbench");

        for (i = 0; i < 100; i = i + 1) begin
            // Generate random inputs
            inputX = random_input();
            inputB = random_input();
            totalSumIn = {random_input(), random_input(), 7'b0};

            // wait to settle
            #1;

            // Calculate expected result
            expected_result = totalSumIn + (inputX * inputB);

            // Check result
            if (totalSumOut !== expected_result) begin
                $display("Test %0d failed!", i);
                $display("inputX = %0d, inputB = %0d, totalSumIn = %0d", $signed(inputX), $signed(inputB), $signed(totalSumIn));
                $display("Expected: %0d, Got: %0d", $signed(expected_result), $signed(totalSumOut));
                $finish;
            end
        end

        $display("All 100 tests passed successfully!");
        $finish;
    end

endmodule

