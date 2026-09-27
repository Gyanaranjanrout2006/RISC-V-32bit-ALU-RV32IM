`timescale 1ns / 1ps

module riscv_alu_top_m_tb;

    reg         clk;
    reg         rst;
    reg  [31:0] A;
    reg  [31:0] B;
    reg  [4:0]  ALU_Control;
    reg         start_div;

    wire [31:0] ALU_Result;
    wire        Zero;
    wire        Negative;
    wire        Overflow;
    wire        div_ready;
    wire        div_busy;

    riscv_alu_top_m uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .start_div(start_div),
        .ALU_Result(ALU_Result),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .div_ready(div_ready),
        .div_busy(div_busy)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start_div = 0;
        A = 0; B = 0; ALU_Control = 0;
        #15;
        rst = 0;
        #10;

        // 1. ADD test (30 + 70 = 100 / 0x64)
        A = 32'd30; B = 32'd70; ALU_Control = 5'b00000; #10;

        // 2. Hardware MUL test (15 * 6 = 90 / 0x5A)
        A = 32'd15; B = 32'd6; ALU_Control = 5'b01010; #10;

        // 3. Barrel Shifter SLL (4 << 3 = 32 / 0x20)
        A = 32'd4; B = 32'd3; ALU_Control = 5'b00010; #10;

        // 4. Hardware DIV test (100 / 5 = 20 / 0x14)
        // Bit 4 = 1 (Division family), lower bits 3'b000 (Signed DIV)
        A = 32'd100; B = 32'd5; ALU_Control = 5'b10000;
        start_div = 1; #10; start_div = 0;
        @(posedge div_ready); #10;

        $finish;
    end

endmodule