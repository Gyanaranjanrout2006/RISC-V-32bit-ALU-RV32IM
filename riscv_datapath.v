`timescale 1ns / 1ps

module riscv_datapath (
    input  wire        clk,
    input  wire        rst,
    // Register File Controls
    input  wire        RegWrite,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,
    // ALU Decoder Controls
    input  wire [1:0]  ALUOp,
    input  wire [2:0]  funct3,
    input  wire        funct7_5,
    // Status & Observation Outputs
    output wire [31:0] ALU_Result,
    output wire        Zero,
    output wire [31:0] RegData1,
    output wire [31:0] RegData2
);

    wire [3:0]  alu_ctrl;
    wire [31:0] src_a;
    wire [31:0] src_b;

    // 1. Register File
    // ALU_Result wapas rd me write ho raha hai (R-type instruction execution loop)
    reg_file u_regfile (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(ALU_Result),
        .ReadData1(src_a),
        .ReadData2(src_b)
    );

    // 2. ALU Decoder
    alu_decoder u_decoder (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALU_Control(alu_ctrl)
    );

    // 3. 32-bit ALU
    riscv_alu u_alu (
        .A(src_a),
        .B(src_b),
        .ALU_Control(alu_ctrl),
        .ALU_Result(ALU_Result),
        .Zero(Zero)
    );

    // Debugging ke liye data tap out karna
    assign RegData1 = src_a;
    assign RegData2 = src_b;

endmodule