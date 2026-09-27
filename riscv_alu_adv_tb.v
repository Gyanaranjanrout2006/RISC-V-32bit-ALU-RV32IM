`timescale 1ns / 1ps

module riscv_alu_adv_tb;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [3:0]  ALU_Control;
    wire [31:0] ALU_Result;
    wire        Zero;
    wire        Negative;
    wire        Overflow;

    riscv_alu_adv uut (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .ALU_Result(ALU_Result),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow)
    );

    initial begin
        // 1. Hardware MUL Test: 200 * 300 = 60,000 (0xEA60)
        A = 32'd200; B = 32'd300; ALU_Control = 4'b1010; #10;

        // 2. MULH Upper 32-bit Signed Test: (0x7FFFFFFF * 2)
        A = 32'h7FFFFFFF; B = 32'd2; ALU_Control = 4'b1011; #10;

        // 3. Barrel Shifter SLL Test: 1 << 13
        A = 32'd1; B = 32'd13; ALU_Control = 4'b0010; #10;

        // 4. Overflow Flag Test: (0x7FFFFFFF + 1 -> Negative Result with Overflow)
        A = 32'h7FFFFFFF; B = 32'd1; ALU_Control = 4'b0000; #10;

        $finish;
    end

endmodule