`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 05:09:52 PM
// Design Name: 
// Module Name: top_alu_fsm
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

module top_alu_fsm (
    input  wire        clk,
    input  wire        pbin,
    input  wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // -- Reuse Lab 5 debouncer for the reset button --
    wire rst_clean;

    debouncer rst_db (
        .clk   (clk),
        .pbin  (pbin),
        .pbout (rst_clean)
    );

    // -- Reuse Lab 5 "leds" module to read the physical switches --
    wire [31:0] switch_data;

    leds switch_reader (
        .clk         (clk),
        .rst         (rst_clean),
        .btns        (16'd0),
        .writeData   (32'd0),
        .writeEnable (1'b0),
        .readEnable  (1'b1),
        .memAddress  (30'd0),
        .switches    (physical_sw),
        .readData    (switch_data)
    );

    // -- Reuse Lab 5 "switches" module to drive the physical LEDs --
    reg [31:0] led_write_data = 32'd0;

    switches led_writer (
        .clk         (clk),
        .rst         (rst_clean),
        .writeData   (led_write_data),
        .writeEnable (1'b1),
        .readEnable  (1'b0),
        .memAddress  (30'd0),
        .readData    (),
        .leds        (physical_leds)
    );

    // -- Reuse Lab 5 clock divider for a visible 1Hz FSM tick --
    wire slow_clk;

    clock_divider ticker (
        .clk_in  (clk),
        .rst     (rst_clean),
        .clk_out (slow_clk)
    );

    reg slow_clk_d = 1'b0;

    always @(posedge clk)
        slow_clk_d <= slow_clk;

    wire tick = slow_clk & ~slow_clk_d;


    // -- ALU with fixed operands --
    localparam [31:0] OPERAND_A = 32'h10101010;
    localparam [31:0] OPERAND_B = 32'h10101011;

    wire [3:0]  ALUControl = switch_data[3:0];
    wire [31:0] ALUResult;
    wire        Zero;

    ALU_top u_alu (
        .A         (OPERAND_A),
        .B         (OPERAND_B),
        .ALUControl(ALUControl),
        .ALUResult (ALUResult),
        .Zero      (Zero)
    );


    // -- FSM: SAMPLE switches -> SHOW result on LEDs, once per tick --
    localparam SAMPLE = 1'b0;
    localparam SHOW   = 1'b1;

    reg state = SAMPLE;

    reg half_sel_reg  = 1'b0;
    reg show_zero_reg = 1'b0;


    always @(posedge clk) begin

        if (rst_clean) begin

            state          <= SAMPLE;
            led_write_data <= 32'd0;

        end
        else begin

            case (state)

                SAMPLE: begin

                    // latch display-mode switches, then move on
                    half_sel_reg  <= switch_data[4];
                    show_zero_reg <= switch_data[5];

                    if (tick)
                        state <= SHOW;

                end

                SHOW: begin

                    if (show_zero_reg)
                        led_write_data <= {16{Zero}};            // broadcast Zero flag
                    else if (half_sel_reg)
                        led_write_data <= {16'd0, ALUResult[31:16]}; // upper half
                    else
                        led_write_data <= {16'd0, ALUResult[15:0]};  // lower half

                    if (tick)
                        state <= SAMPLE;

                end

                default:
                    state <= SAMPLE;

            endcase

        end

    end

endmodule
