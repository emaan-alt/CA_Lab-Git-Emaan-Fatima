`timescale 1ns / 1ps

module TopFPGA (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // Reset button conditioning
    wire rst_clean;

    Debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );

    wire slow_clk; // Slow clock for the demonstration FSM
    ClockDivider ticker (
        .clk_in(clk),
        .rst(rst_clean),
        .clk_out(slow_clk)
    );

    // Generate one pulse on each rising edge of slow_clk
    reg slow_clk_d = 1'b0;

    always @(posedge clk)
        slow_clk_d <= slow_clk;

    wire tick = slow_clk & ~slow_clk_d;

    // FSM states
    localparam WRITE_MEM   = 3'd0;
    localparam READ_MEM    = 3'd1;
    localparam WRITE_LED   = 3'd2;
    localparam READ_SWITCH = 3'd3;
    localparam DISPLAY_SW  = 3'd4;
    localparam DISPLAY_MEM  = 3'd5;

    reg [2:0] state = WRITE_MEM;

    // Interface signals for the memory system
    reg [31:0] address;
    reg readEnable;
    reg writeEnable;
    reg [31:0] writeData;

    wire [31:0] readData;
    wire [15:0] leds;

    // Saved values for verification and display
    reg [31:0] savedMemoryData = 32'd0;
    reg [15:0] savedSwitchData = 16'd0;

    // Connect the memory system
    AddressDecoderTop memory_system (
        .clk(clk),
        .rst(rst_clean),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches(physical_sw),
        .readData(readData),
        .leds(leds)
    );

    // Route the selected operation to the memory system
    always @(*) begin
        address     = 32'd0;
        readEnable  = 1'b0;
        writeEnable = 1'b0;
        writeData   = 32'd0;

        case (state)

            WRITE_MEM: begin
                address     = 32'd10;
                writeEnable = 1'b1;
                writeData   = 32'h12345678;
            end

            READ_MEM: begin
                address    = 32'd10;
                readEnable = 1'b1;
            end

            WRITE_LED: begin
                address     = 32'd512;
                writeEnable = 1'b1;
                writeData   = 32'h0000A55A;
            end

            READ_SWITCH: begin
                address    = 32'd768;
                readEnable = 1'b1;
            end

            DISPLAY_SW: begin
                address     = 32'd512;
                writeEnable = 1'b1;
                writeData   = {16'd0, savedSwitchData};
            end
            
            DISPLAY_MEM: begin
                address     = 32'd512;
                writeEnable = 1'b1;
                writeData   = {16'd0, savedMemoryData[15:0]};
            end
            

            default: begin
                address     = 32'd0;
                readEnable  = 1'b0;
                writeEnable = 1'b0;
                writeData   = 32'd0;
            end

        endcase
    end

    // Advance through each demonstration step
    always @(posedge clk) begin
        if (rst_clean) begin
            state            <= WRITE_MEM;
            savedMemoryData <= 32'd0;
            savedSwitchData <= 16'd0;
        end
        else if (tick) begin
            case (state)

                WRITE_MEM: begin
                    state <= READ_MEM;
                end

                READ_MEM: begin
                    savedMemoryData <= readData;
                    state <= WRITE_LED;
                end

                WRITE_LED: begin
                    state <= READ_SWITCH;
                end

                READ_SWITCH: begin
                    savedSwitchData <= readData[15:0];
                    state <= DISPLAY_SW;
                end

                DISPLAY_SW: begin
                    state <= DISPLAY_MEM;
                    
                end
                DISPLAY_MEM: begin
                    state <= WRITE_MEM;
                end

                default: begin
                    state <= WRITE_MEM;
                end

            endcase
        end
    end

    // Physical LED output comes from the LED driver
    assign physical_leds = leds;

endmodule
