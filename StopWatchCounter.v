`timescale 1ns / 1ps
// Stopwatch counter
// Dan Koskiranta

module StopWatchCounter(
    input wire clk, rst,
    input wire start_stop,
    output wire [3:0] d3, d2, d1, d0 // d0 is rightmost on board, d3 leftmost 
    );
    
// Constants
localparam NUM_CLK_CYCLES = 10;  // 10 is a good choice for simulation
//localparam NUM_CLK_CYCLES = 10000000; // 10,000,000 with a 100MHz clock sets d0 tick at 0.1s

// Internal signals
reg [3:0] d3_reg, d2_reg, d1_reg, d0_reg;
reg [3:0] d3_next, d2_next, d1_next, d0_next;
reg [24:0] count_reg;
wire[24:0] count_next;
wire tick, go;

assign go = start_stop;
// Next state logic for counter & tick signal
assign count_next = (rst || (count_reg == NUM_CLK_CYCLES && go)) ? 4'b0 : (go) ? count_reg + 1 : count_reg;
assign tick = (count_reg == NUM_CLK_CYCLES) ? 1'b1 : 1'b0;

// Calculate digits for display
always @* begin
   // Default digit next values are set to be current registered values
    d0_next = d0_reg;
    d1_next = d1_reg;
    d2_next = d2_reg;
    d3_next = d3_reg;
    // If reset is high, reset the next digit values
    // else if tick is high, increment the digit counters
    if (rst) begin
        d0_next = 4'b0000;
        d1_next = 4'b0000;
        d2_next = 4'b0000;
        d3_next = 4'b0000;
    end
    else begin
        if (tick) begin
            if (d0_reg != 9) begin            // d0 has not yet reached 9, keep incrementing
                d0_next = d0_reg + 1;
            end
            else begin                        // d0 is 9, number is xxx9
                d0_next = 4'b0000;            // reset d0
                if(d1_reg != 9) begin             // now check d1, increment if not yet 9
                    d1_next = d1_reg + 1;
                end               
                else begin                    // d1 is 9, number is xx99
                    d1_next = 4'b0000;        // reset d1
                    if(d2_reg != 9) begin         // now check d2, increment if not yet 9
                        d2_next = d2_reg + 1;
                    end
                    else begin                    // d2 is 9, number is x999
                        d2_next = 4'b0000;        // reset d2
                    end
                end
            end
        end // end if(tick)    
    end // end else if(rst) 
end
 
// Digit registers
always @(posedge rst, posedge clk) begin
    if(rst) begin
        d3_reg <= 0;
        d2_reg <= 0;
        d1_reg <= 0;
        d0_reg <= 0;
    end
    else begin
        d3_reg <= d3_next;
        d2_reg <= d2_next;
        d1_reg <= d1_next;
        d0_reg <= d0_next;
    end
end
       
// Counter register
always @(posedge rst, posedge clk) begin
    if(rst)
       count_reg <= 0;
     else
       count_reg <= count_next;
 end
    
// Assign outputs to registered digit values
assign d0 = d0_reg;
assign d1 = d1_reg;
assign d2 = d2_reg;
assign d3 = d3_reg;
    
endmodule