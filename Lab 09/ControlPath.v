`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 04:23:14 PM
// Design Name: 
// Module Name: ControlPath
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


module ControlPath (
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output       RegWrite,
    output       ALUSrc,
    output       MemRead,
    output       MemWrite,
    output       MemtoReg,
    output       Branch,
    output [1:0] ALUOp,
    output [3:0] ALUControl
);
    MainControl u_main (
        .opcode  (opcode),
        .RegWrite(RegWrite),
        .ALUSrc  (ALUSrc),
        .MemRead (MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch  (Branch),
        .ALUOp   (ALUOp)
    );

    ALUControl u_aluctl (
        .ALUOp     (ALUOp),
        .funct3    (funct3),
        .funct7    (funct7),
        .ALUControl(ALUControl)
    );
endmodule
