`timescale 1ns / 1ps

module instruction_memory (
    input  wire [31:0] pc,
    output wire [31:0] instruction
);

    // 64 instructions ki memory (256 bytes)
    reg [31:0] mem [0:63];

    initial begin
        // Program file se hex instructions load karega
        $readmemh("instructions.mem", mem);
    end

    // Word-aligned access (pc >> 2 yaani pc / 4)
    assign instruction = mem[pc[7:2]];

endmodule