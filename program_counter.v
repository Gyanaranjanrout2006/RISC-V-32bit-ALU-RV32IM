`timescale 1ns / 1ps

module program_counter (
    input  wire        clk,
    input  wire        rst,
    output reg  [31:0] pc
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'd0;
        else
            pc <= pc + 32'd4; // RISC-V me har instruction 4 bytes (32 bits) ka hota hai
    end

endmodule
