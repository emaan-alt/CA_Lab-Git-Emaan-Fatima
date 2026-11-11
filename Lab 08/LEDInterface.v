`timescale 1ns / 1ps

module LEDInterface(
    input clk,
    input rst,
    input [15:0] btns,
    input [31:0] writeData,
    input writeEnable,
    input readEnable,
    input [29:0] memAddress,
    input [15:0] switches,
    output [31:0] readData
);

    // 16 switch bits in the lower half of readData
    assign readData = {16'd0, switches};

endmodule
