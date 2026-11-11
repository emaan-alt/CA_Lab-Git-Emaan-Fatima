`timescale 1ns / 1ps

module AddressDecoder(
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
output wire DataMemSelect,
    output wire LEDSelect,
    output wire SwitchSelect,
output wire DataMemRead,
    output wire DataMemWrite,
    output wire LEDWrite,
    output wire SwitchReadEnable
);

wire [9:0] local_addr;
    assign local_addr = address[9:0];
    assign DataMemSelect = (local_addr[9] == 1'b0);
assign LEDSelect = (local_addr[9:8] == 2'b10);
assign SwitchSelect =(local_addr[9:8] == 2'b11);
assign DataMemRead  = DataMemSelect && readEnable;
assign DataMemWrite = DataMemSelect && writeEnable;
assign LEDWrite = LEDSelect && writeEnable;
assign SwitchReadEnable =SwitchSelect && readEnable;

endmodule
