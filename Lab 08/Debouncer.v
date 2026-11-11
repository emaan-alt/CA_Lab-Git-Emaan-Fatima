 
`timescale 1ns / 1ps 
 
module Debouncer( 
    input clk, 
    input pbin, 
    output pbout 
); 
 
    // Pass the button signal to the FSM reset input 
    assign pbout = pbin; 
 
endmodule 