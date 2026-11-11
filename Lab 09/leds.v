`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 04:26:38 PM
// Design Name: 
// Module Name: leds
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


module leds (
    input             clk, rst,
    input      [15:0] btns,
    input      [31:0] writeData,
    input             writeEnable,
    input             readEnable,
    input      [29:0] memAddress,
    input      [15:0] switches,
    output reg [31:0] readData
);
    always @(posedge clk)
        if (rst)             readData <= 32'b0;
        else if (readEnable) readData <= {16'b0, switches};
endmodule

// Drives the physical LEDs.
module switches (
    input             clk, rst,
    input      [31:0] writeData,
    input             writeEnable,
    input             readEnable,
    input      [29:0] memAddress,
    output reg [31:0] readData = 0,
    output reg [15:0] leds
);
    always @(posedge clk)
        if (rst)              leds <= 16'b0;
        else if (writeEnable) leds <= writeData[15:0];
endmodule

// Debouncer stand-in: 2-FF synchroniser only (no long delay, keeps sim short).
module debouncer (
    input  clk,
    input  pbin,
    output pbout
);
    reg [1:0] s = 2'b00;
    always @(posedge clk) s <= {s[0], pbin};
    assign pbout = s[1];
endmodule
