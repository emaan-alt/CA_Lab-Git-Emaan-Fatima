`timescale 1ns / 1ps

module AddressDecoderTop(
    input wire clk,
    input wire rst,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] writeData,
    input wire [15:0] switches,
    output reg [31:0] readData,
    output wire [15:0] leds
);

    wire DataMemSelect;
    wire LEDSelect;
    wire SwitchSelect;
    wire DataMemRead;
    wire DataMemWrite;
    wire LEDWrite;
    wire SwitchReadEnable;
    wire [31:0] memoryReadData;
    wire [31:0] switchReadData;

    // Address decoder
    AddressDecoder decoder (
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .DataMemSelect(DataMemSelect),
        .LEDSelect(LEDSelect),
        .SwitchSelect(SwitchSelect),
        .DataMemRead(DataMemRead),
        .DataMemWrite(DataMemWrite),
        .LEDWrite(LEDWrite),
        .SwitchReadEnable(SwitchReadEnable)
    );

    // Data Memory: addresses 0-511
    DataMemory data_memory (
        .clk(clk),
        .reset(rst),
        .memwrite(DataMemWrite),
        .addr(address[8:0]),
        .writedata(writeData),
        .datamemout(memoryReadData)
    );

    // reusing lab 5 modules here
    LEDInterface switch_reader (
        .clk(clk),
        .rst(rst),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(SwitchReadEnable),
        .memAddress(30'd0),
        .switches(switches),
        .readData(switchReadData)
    );
    SwitchInterface led_writer (
        .clk(clk),
        .rst(rst),
        .writeData(writeData),
        .writeEnable(LEDWrite),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(leds)
    );

// now selecting the particular data source
    always @(*) begin
        if (DataMemRead)
            readData = memoryReadData;
        else if (SwitchReadEnable)
            readData = switchReadData;
        else
            readData = 32'd0;
    end

endmodule
