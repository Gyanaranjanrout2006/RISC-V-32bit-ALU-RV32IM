`timescale 1ns / 1ps

module riscv_core (
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] pc_out,
    output wire [31:0] instruction_out,
    output wire [31:0] alu_result_out
);

    wire [31:0] pc;
    wire [31:0] instr;
    wire [31:0] src_a, src_b, alu_res;
    wire [3:0]  alu_ctrl;
    wire        zero;

    // 1. Program Counter
    program_counter u_pc (
        .clk(clk),
        .rst(rst),
        .pc(pc)
    );

    // 2. Instruction Memory
    instruction_memory u_imem (
        .pc(pc),
        .instruction(instr)
    );

    // RISC-V R-Type Instruction Decoding:
    // opcode: instr[6:0]
    // rd:     instr[11:7]
    // funct3: instr[14:12]
    // rs1:    instr[19:15]
    // rs2:    instr[24:20]
    // funct7: instr[31:25]

    wire [4:0] rd       = instr[11:7];
    wire [2:0] funct3   = instr[14:12];
    wire [4:0] rs1      = instr[19:15];
    wire [4:0] rs2      = instr[24:20];
    wire       funct7_5 = instr[30];

    // R-type ke liye RegWrite hamesha 1 aur ALUOp 2'b10 hota hai
    wire is_rtype = (instr[6:0] == 7'b0110011);
    wire RegWrite = is_rtype;
    wire [1:0] ALUOp = is_rtype ? 2'b10 : 2'b00;

    // 3. Register File
    reg_file u_regfile (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(alu_res),
        .ReadData1(src_a),
        .ReadData2(src_b)
    );

    // 4. ALU Decoder
    alu_decoder u_decoder (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALU_Control(alu_ctrl)
    );

    // 5. ALU
    riscv_alu u_alu (
        .A(src_a),
        .B(src_b),
        .ALU_Control(alu_ctrl),
        .ALU_Result(alu_res),
        .Zero(zero)
    );

 assign pc_out          = pc;
assign instruction_out = instr;
assign alu_result_out  = alu_res;
endmodule