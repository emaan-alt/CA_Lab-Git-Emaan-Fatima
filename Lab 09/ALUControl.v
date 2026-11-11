`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 04:23:14 PM
// Design Name: 
// Module Name: ALUControl
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


module ALUControl (
    input      [1:0] ALUOp,
    input      [2:0] funct3,
    input      [6:0] funct7,
    output reg [3:0] ALUControl
);
    // ALU operation codes (P&H style; edit to match your Lab 6 ALU.v)
    localparam ALU_AND = 4'b0000;
    localparam ALU_OR  = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_XOR = 4'b0011;
    localparam ALU_SLL = 4'b0100;
    localparam ALU_SRL = 4'b0101;
    localparam ALU_SUB = 4'b0110;

    // Only bit 5 of funct7 (instruction bit 30) separates ADD/SUB (and SRL/SRA).
    wire f7b5 = funct7[5];

    always @(*) begin
        ALUControl = ALU_ADD;                 // safe default
        case (ALUOp)
            2'b00: ALUControl = ALU_ADD;      // LW/LH/LB/SW/SH/SB: address calc
            2'b01: ALUControl = ALU_SUB;      // BEQ: rs1 - rs2, check Zero
            2'b10: begin                      // R-type
                case (funct3)
                    3'b000: ALUControl = f7b5 ? ALU_SUB : ALU_ADD;
                    3'b001: ALUControl = ALU_SLL;
                    3'b100: ALUControl = ALU_XOR;
                    3'b101: ALUControl = ALU_SRL;
                    3'b110: ALUControl = ALU_OR;
                    3'b111: ALUControl = ALU_AND;
                    default: ALUControl = ALU_ADD;
                endcase
            end
            2'b11: begin                      // I-type ALU (ADDI)
                // funct7 is NOT checked: for ADDI those bits are part of the
                // immediate, so a negative imm would otherwise look like SUB.
                case (funct3)
                    3'b000:  ALUControl = ALU_ADD;   // ADDI
                    default: ALUControl = ALU_ADD;
                endcase
            end
        endcase
    end
endmodule
