`timescale 1ns / 1ps

module riscv_datapath_tb;

    reg        clk;
    reg        rst;
    reg        RegWrite;
    reg  [4:0] rs1;
    reg  [4:0] rs2;
    reg  [4:0] rd;
    reg  [1:0] ALUOp;
    reg  [2:0] funct3;
    reg        funct7_5;

    wire [31:0] ALU_Result;
    wire        Zero;
    wire [31:0] RegData1;
    wire [31:0] RegData2;

    riscv_datapath uut (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALU_Result(ALU_Result),
        .Zero(Zero),
        .RegData1(RegData1),
        .RegData2(RegData2)
    );

    // Clock generation (10ns period -> 100MHz)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        RegWrite = 0;
        rs1 = 0; rs2 = 0; rd = 0;
        ALUOp = 2'b00; funct3 = 3'b000; funct7_5 = 0;

        #20;
        rst = 0; // Reset release

        // Step A: Register x1 aur x2 me values initialize karna
        // Vivado simulation me direct register inject kar rahe hain
        uut.u_regfile.registers[1] = 32'd15; // x1 = 15
        uut.u_regfile.registers[2] = 32'd25; // x2 = 25
        #10;

        // Step B: R-type ADD: x3 = x1 + x2 (15 + 25 = 40)
        rs1 = 5'd1;          // Read x1
        rs2 = 5'd2;          // Read x2
        rd  = 5'd3;          // Write into x3
        ALUOp = 2'b10;       // R-type
        funct3 = 3'b000;     // ADD/SUB funct3
        funct7_5 = 1'b0;     // 0 = ADD
        RegWrite = 1'b1;     // Enable write
        #10;                 // Clock edge par x3 me write ho jayega

        // Step C: R-type SUB: x4 = x3 - x1 (40 - 15 = 25)
        rs1 = 5'd3;          // Read x3 (ab 40 hona chahiye)
        rs2 = 5'd1;          // Read x1 (15)
        rd  = 5'd4;          // Write into x4
        ALUOp = 2'b10;
        funct3 = 3'b000;
        funct7_5 = 1'b1;     // 1 = SUB
        RegWrite = 1'b1;
        #10;

        // Step D: Disable write aur read check
        RegWrite = 0;
        rs1 = 5'd4;          // Read x4 (25 hona chahiye)
        #10;

        $display("Execution Complete! Check Waveform.");
        $finish;
    end

endmodule