`timescale 1ns / 1ps

module reg_file (
    input  wire        clk,         // Clock signal
    input  wire        rst,         // Synchronous or asynchronous reset
    input  wire        RegWrite,    // Write enable signal
    input  wire [4:0]  rs1,         // Source register 1 address (5-bit -> 0 to 31)
    input  wire [4:0]  rs2,         // Source register 2 address (5-bit -> 0 to 31)
    input  wire [4:0]  rd,          // Destination register address (5-bit)
    input  wire [31:0] WriteData,   // Data to write into rd
    output wire [31:0] ReadData1,   // Output data of rs1
    output wire [31:0] ReadData2    // Output data of rs2
);

    // 32 registers, each 32-bit wide
    reg [31:0] registers [31:0];
    integer i;

    // Synchronous Write Logic (Clock ke rising edge par write hoga)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (RegWrite && (rd != 5'd0)) begin
            // x0 hamesha 0 rehta hai, isliye rd != 0 check zaroori hai
            registers[rd] <= WriteData;
        end
    end

    // Asynchronous / Combinational Read Logic
    // Agar address 0 hai to hamesha 0 return karega
    assign ReadData1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
    assign ReadData2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];

endmodule