`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 04:23:14 PM
// Design Name: 
// Module Name: Lab9_Top
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


module Lab9_Top (
    input         clk,        // 100 MHz
    input         btnU,       // reset
    input         btnC,       // load
    input  [15:0] sw,
    output [15:0] led
);
    // ---------------------------------------------------------------- buttons
    wire rst, load_lvl;
    debouncer db_rst  (.clk(clk), .pbin(btnU), .pbout(rst));
    debouncer db_load (.clk(clk), .pbin(btnC), .pbout(load_lvl));

    // one-cycle pulse on the rising edge of the debounced load button
    reg load_d;
    always @(posedge clk) load_d <= load_lvl;
    wire load_pulse = load_lvl & ~load_d;

    // ------------------------------------------------------- switch interface
    // (Lab 5 module - the one that reads the physical switches)
    wire [31:0] sw_readData;
    reg         sw_readEnable;
    leds u_sw_if (
        .clk(clk), .rst(rst),
        .btns(16'b0),
        .writeData(32'b0), .writeEnable(1'b0),
        .readEnable(sw_readEnable),
        .memAddress(30'b0),
        .switches(sw),
        .readData(sw_readData)
    );

    // ---------------------------------------------------------- LED interface
    // (Lab 5 module - the one that drives the physical LEDs)
    reg  [31:0] led_writeData;
    reg         led_writeEnable;
    wire [31:0] led_readData_unused;
    switches u_led_if (
        .clk(clk), .rst(rst),
        .writeData(led_writeData), .writeEnable(led_writeEnable),
        .readEnable(1'b0),
        .memAddress(30'b0),
        .readData(led_readData_unused),
        .leds(led)
    );

    // ---------------------------------------------------- latched instruction
    reg [6:0] opcode_r;
    reg [2:0] funct3_r;
    reg [6:0] funct7_r;

    // ---------------------------------------------------------- control path
    wire RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    ControlPath u_ctrl (
        .opcode(opcode_r), .funct3(funct3_r), .funct7(funct7_r),
        .RegWrite(RegWrite), .ALUSrc(ALUSrc), .MemRead(MemRead),
        .MemWrite(MemWrite), .MemtoReg(MemtoReg), .Branch(Branch),
        .ALUOp(ALUOp), .ALUControl(ALUControl)
    );

    // -------------------------------------------------------------------- FSM
    localparam S_IDLE   = 3'd0,
               S_READ   = 3'd1,
               S_LATCH  = 3'd2,
               S_DECODE = 3'd3,
               S_SHOW   = 3'd4;

    reg [2:0]  state, next_state;
    reg [11:0] ctrl_bits;   // registered control word

    // next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE:   if (load_pulse) next_state = S_READ;
            S_READ:   next_state = S_LATCH;
            S_LATCH:  next_state = S_DECODE;
            S_DECODE: next_state = S_SHOW;
            S_SHOW:   next_state = S_IDLE;
            default:  next_state = S_IDLE;
        endcase
    end

    // output / datapath of the FSM
    always @(*) begin
        sw_readEnable   = (state == S_READ) || (state == S_LATCH);
        led_writeEnable = (state == S_SHOW);
        led_writeData   = {16'b0, 1'b1, 3'b000, ctrl_bits};
    end

    always @(posedge clk) begin
        if (rst) begin
            state     <= S_IDLE;
            opcode_r  <= 7'b0;
            funct3_r  <= 3'b0;
            funct7_r  <= 7'b0;
            ctrl_bits <= 12'b0;
        end else begin
            state <= next_state;
            case (state)
                S_LATCH: begin
                    opcode_r <= sw_readData[6:0];
                    funct3_r <= sw_readData[9:7];
                    funct7_r <= {1'b0, sw_readData[15:10]};
                end
                S_DECODE: begin
                    ctrl_bits <= {ALUControl, ALUOp, Branch, MemtoReg,
                                  MemWrite, MemRead, ALUSrc, RegWrite};
                end
                default: ;
            endcase
        end
    end
endmodule
