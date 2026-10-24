`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 05:26:26 PM
// Design Name: 
// Module Name: clock_divider
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

`timescale 1ns / 1ps

module clock_divider (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);

    reg [25:0] divider_count = 0;

    // Use 2 while simulating.
    // Change back to 50_000_000 - 1 for FPGA testing.
    localparam DIV_LIMIT = 50_000_000 - 1;

    always @(posedge clk_in) begin

        if (rst) begin
            divider_count <= 0;
            clk_out <= 0;
        end

        else if (divider_count == DIV_LIMIT) begin
            divider_count <= 0;
            clk_out <= ~clk_out;
        end

        else begin
            divider_count <= divider_count + 1'b1;
        end

    end

endmodule