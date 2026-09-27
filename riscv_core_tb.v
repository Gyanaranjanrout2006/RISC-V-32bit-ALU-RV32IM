`timescale 1ns / 1ps

module riscv_core_tb;

    reg clk;
    reg rst;
    wire [31:0] pc_out;
    wire [31:0] instruction_out;
    wire [31:0] alu_result_out;

    riscv_core uut (
        .clk(clk),
        .rst(rst),
        .pc_out(pc_out),
        .instruction_out(instruction_out),
        .alu_result_out(alu_result_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #15;
        rst = 0; // Reset release

        // Register x1 aur x2 me values preload kar dete hain testing ke liye
        uut.u_regfile.registers[1] = 32'd10; // x1 = 10
        uut.u_regfile.registers[2] = 32'd20; // x2 = 20

        // 4 instructions run hone ke liye 40ns wait
        #50;
        $finish;
    end

endmodule