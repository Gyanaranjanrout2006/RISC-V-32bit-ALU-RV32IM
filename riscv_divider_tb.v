`timescale 1ns / 1ps

module riscv_divider_tb;

    reg         clk;
    reg         rst;
    reg         start;
    reg  [2:0]  div_op;
    reg  [31:0] dividend_in;
    reg  [31:0] divisor_in;
    wire [31:0] result;
    wire        ready;
    wire        busy;

    riscv_divider uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .div_op(div_op),
        .dividend_in(dividend_in),
        .divisor_in(divisor_in),
        .result(result),
        .ready(ready),
        .busy(busy)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        div_op = 0;
        dividend_in = 0;
        divisor_in = 0;
        #15;
        rst = 0;
        #10;

        // Test 1: Signed Division: 50 / 7 = 7 (div_op = 000)
        dividend_in = 32'd50; divisor_in = 32'd7; div_op = 3'b000;
        start = 1; #10; start = 0;
        @(posedge ready); #10;

        // Test 2: Signed Remainder: 50 % 7 = 1 (div_op = 010)
        dividend_in = 32'd50; divisor_in = 32'd7; div_op = 3'b010;
        start = 1; #10; start = 0;
        @(posedge ready); #10;

        // Test 3: Negative Division: -40 / 5 = -8 (div_op = 000)
        dividend_in = -32'd40; divisor_in = 32'd5; div_op = 3'b000;
        start = 1; #10; start = 0;
        @(posedge ready); #10;

        // Test 4: RISC-V Corner Case: Divide by Zero (32'd10 / 0 -> Expected -1 / 0xFFFFFFFF)
        dividend_in = 32'd10; divisor_in = 32'd0; div_op = 3'b000;
        start = 1; #10; start = 0;
        @(posedge ready); #10;

        $finish;
    end

endmodule