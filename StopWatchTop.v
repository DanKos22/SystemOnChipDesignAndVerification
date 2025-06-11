`timescale 1ns / 1ps
// Stopwatch top level 
// Dan Koskiranta

module StopWatchTop(
   input wire clk,
   input wire rst, btn,
   output wire [3:0] an,
   output wire [6:0] sseg
   );
    
// Internal signals
wire [3:0] d3, d2, d1, d0;
wire start_stop;
    
// Switch debounce
DebounceFSM i_DebounceFSM ( .clk(clk), .rst(rst), .sw_in(btn), .sw_out(start_stop) ); 

// Stopwatch counter
StopWatchCounter i_StopWatchCounter ( .clk(clk), .rst(rst), .start_stop(start_stop), .d3(d3), .d2(d2), .d1(d1), .d0(d0) ); 
 
// Seven segment display driver
SSegDisplay i_SSegDisplay (
   .clk(clk), .rst(rst), .d3(d3), .d2(d2), .d1(d1), .d0(d0), .an(an), .sseg(sseg) );
       
endmodule
