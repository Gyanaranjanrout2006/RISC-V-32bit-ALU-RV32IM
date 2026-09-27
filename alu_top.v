`timescale 1ns / 1ps

module alu_top (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [1:0]  ALUOp,
    input  wire [2:0]  funct3,
    input  wire       funct7_5,
    output wire [31:0] ALU_Result,
    output wire        Zero
);

    wire [3:0] alu_control_wire;

    // Instantiate ALU Decoder
    alu_decoder u_decoder (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALU_Control(alu_control_wire)
    );

    // Instantiate 32-bit ALU (jo aapne pehle banaya tha)
    riscv_alu u_alu (
        .A(A),
        .B(B),
        .ALU_Control(alu_control_wire),
        .ALU_Result(ALU_Result),
        .Zero(Zero)
    );

endmodule
