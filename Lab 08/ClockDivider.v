`timescale 1ns / 1ps
module ClockDivider (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);
 
    reg [25:0] divider_count = 0;
    localparam DIV_LIMIT = 49999999;
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
