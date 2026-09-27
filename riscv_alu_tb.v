`timescale 1ns / 1ps

module riscv_alu_tb;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [3:0]  ALU_Control;
    wire [31:0] ALU_Result;
    wire        Zero;

    // DUT (Device Under Test) Instantiate karna
    riscv_alu uut (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .ALU_Result(ALU_Result),
        .Zero(Zero)
    );

    initial begin
        $display("----------------- STARTING ALU TEST -----------------");

        // Test 1: ADD (15 + 10 = 25)
        A = 32'd15; B = 32'd10; ALU_Control = 4'b0000;
        #10;
        $display("ADD: A=%0d, B=%0d | Result=%0d, Zero=%b", A, B, ALU_Result, Zero);

        // Test 2: SUB (20 - 20 = 0 -> Zero Flag check)
        A = 32'd20; B = 32'd20; ALU_Control = 4'b0001;
        #10;
        $display("SUB (Zero test): A=%0d, B=%0d | Result=%0d, Zero=%b", A, B, ALU_Result, Zero);

        // Test 3: SLL (Shift Left 1 by 3 bits = 8)
        A = 32'd1; B = 32'd3; ALU_Control = 4'b0010;
        #10;
        $display("SLL: A=%b, shift by %0d | Result=%b", A, B[4:0], ALU_Result);

        // Test 4: SLT Signed (-5 < 2 = true / 1)
        A = -32'd5; B = 32'd2; ALU_Control = 4'b0011;
        #10;
        $display("SLT (Signed): A=%0d, B=%0d | Result=%0d", $signed(A), $signed(B), ALU_Result);

        // Test 5: XOR (0xFF00 ^ 0xF0F0)
        A = 32'h0000FF00; B = 32'h0000F0F0; ALU_Control = 4'b0101;
        #10;
        $display("XOR: A=%h, B=%h | Result=%h", A, B, ALU_Result);

        // Test 6: SRA Arithmetic shift (Sign bit preserve test)
        A = 32'h80000004; B = 32'd2; ALU_Control = 4'b0111;
        #10;
        $display("SRA: A=%h, B=%0d | Result=%h", A, B[4:0], ALU_Result);

        $display("----------------- ALL TESTS COMPLETED -----------------");
        $finish;
    end

endmodule
