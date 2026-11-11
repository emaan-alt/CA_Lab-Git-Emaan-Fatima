`timescale 1ns / 1ps

module DataMemory (
    input wire clk,
    input wire reset,
    input wire memwrite,
    input wire [8:0] addr,
    input wire [31:0] writedata,
    output reg [31:0] datamemout
);

    reg [31:0] mem [0:511];

    always @(posedge clk) begin
        if (reset) begin
            datamemout <= 32'd3260;
        end
        else if (memwrite) begin
            mem[addr] <= writedata;
        end
        else begin
            datamemout <= mem[addr];
        end
    end

endmodule
