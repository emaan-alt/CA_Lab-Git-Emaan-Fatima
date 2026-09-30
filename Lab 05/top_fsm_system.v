`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 03:41:16 PM
// Design Name: 
// Module Name: top_fsm_system
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


module top_fsm_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    wire reset_signal;
    wire [31:0] sw_value;
    wire divided_clk;

    reg [31:0] led_data = 32'd0;

    debouncer db_inst (
        .clk(clk),
        .pbin(pbin),
        .pbout(reset_signal)
    );

    leds input_interface (
        .clk(clk),
        .rst(reset_signal),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'd0),
        .switches(physical_sw),
        .readData(sw_value)
    );

    switches output_interface (
        .clk(clk),
        .rst(reset_signal),
        .writeData(led_data),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

    clock_divider clk_div (
        .clk_in(clk),
        .rst(reset_signal),
        .clk_out(divided_clk)
    );

    localparam WAIT_STATE  = 2'b00;
    localparam COUNT_STATE = 2'b01;
    localparam CLEAR_STATE = 2'b10;

    reg [1:0] current_state = WAIT_STATE;
    reg [15:0] count_reg = 16'd0;

    reg previous_slow_clk = 1'b0;

    always @(posedge clk)
        previous_slow_clk <= divided_clk;

    wire count_enable =
        divided_clk & ~previous_slow_clk;

    always @(posedge clk) begin

        case (current_state)

            WAIT_STATE: begin

                if (sw_value[15:0] != 16'd0) begin
                    count_reg <= sw_value[15:0];
                    led_data <= sw_value;
                    current_state <= COUNT_STATE;
                end

            end

            COUNT_STATE: begin

                if (reset_signal) begin
                    current_state <= CLEAR_STATE;
                end

                else if (count_enable) begin

                    if (count_reg == 16'd0) begin
                        current_state <= WAIT_STATE;
                    end

                    else begin
                        count_reg <= count_reg - 1'b1;
                        led_data <=
                            {16'd0, count_reg - 1'b1};
                    end

                end

            end

            CLEAR_STATE: begin
                count_reg <= 16'd0;
                led_data <= 32'd0;
                current_state <= WAIT_STATE;
            end

            default: begin
                current_state <= WAIT_STATE;
            end

        endcase

    end

endmodule