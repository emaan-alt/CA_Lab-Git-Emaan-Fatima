`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 04:23:14 PM
// Design Name: 
// Module Name: MainControl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MainControl (
    input      [6:0] opcode,
    output reg       RegWrite,
    output reg       ALUSrc,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       MemtoReg,
    output reg       Branch,
    output reg [1:0] ALUOp
);
    // RV32I opcodes
    localparam OP_R      = 7'b0110011; // ADD, SUB, SLL, SRL, AND, OR, XOR
    localparam OP_I_ALU  = 7'b0010011; // ADDI
    localparam OP_LOAD   = 7'b0000011; // LW, LH, LB
    localparam OP_STORE  = 7'b0100011; // SW, SH, SB
    localparam OP_BRANCH = 7'b1100011; // BEQ

    always @(*) begin
        // Safe defaults: an unknown opcode becomes a NOP (writes nothing).
        RegWrite = 1'b0;
        ALUSrc   = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 1'b0;
        Branch   = 1'b0;
        ALUOp    = 2'b00;

        case (opcode)
            OP_R: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b0;      // second operand = rs2
                ALUOp    = 2'b10;
            end
            OP_I_ALU: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;      // second operand = immediate
                ALUOp    = 2'b11;
            end
            OP_LOAD: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;      // address = rs1 + imm
                MemRead  = 1'b1;
                MemtoReg = 1'b1;      // write-back data comes from memory
                ALUOp    = 2'b00;
            end
            OP_STORE: begin
                ALUSrc   = 1'b1;      // address = rs1 + imm
                MemWrite = 1'b1;
                ALUOp    = 2'b00;     // MemtoReg = X -> 0
            end
            OP_BRANCH: begin
                ALUSrc   = 1'b0;      // compare rs1 with rs2
                Branch   = 1'b1;
                ALUOp    = 2'b01;     // MemtoReg = X -> 0
            end
            default: ; // keep safe defaults
        endcase
    end
endmodule
