`timescale 1ns / 1ps
// Seven Segment Display Driver
// Dan Koskiranta

module SSegDisplay(
   input  wire clk,
   input  wire rst,
   input  wire [3:0] d3, d2, d1, d0,
   output wire [3:0] an,
   output wire [7:0] sseg
   );
    
// Constant for N bit counter which will control multiplexing of digit displays
localparam N = 2; // 2 bits is a good choice for simulation
//localparam N = 18; // 18 bits is a good choice for real-time with a 100MHz clock

// Internal signals    
reg  [N-1:0] count_reg;
wire [N-1:0] count_next;
reg  [3:0]   d; 
reg  [3:0]   an_next, an_reg;
reg  [7:0]   sseg_next, sseg_reg;
        
// Increment counter, next value is current registered value + 1
assign count_next = count_reg + 1;
    
// Multiplexer for display multiplexing between 4 seven segment displays, where two
// MSBs of the counter control when the display changes - this just has to fast enough
// so the human eye will perceive that each digit is displaying all the time
always @* begin
   case(count_reg[N-1:N-2])
       2'b00: begin  // Rightmost digit display on 
           an_next = 4'b1110;
           d       = d0;
       end
       2'b01: begin  // Second display from right on
           an_next = 4'b1101;
           d       = d1;
       end
       2'b10: begin  // Third display from right on
           an_next = 4'b1011;
           d       = d2;
       end
       2'b11: begin  // Leftmost display on
           an_next = 4'b0111;
           d       = d3;
       end
       default: begin // Default, no display on
           an_next = 4'b1111;
           d       = 4'b0000;
       end
   endcase
end    
        
// Multiplexer for sseg cathode, where 7 leds assigned to display the digit required
always @* begin
   case(d)
       4'h0: sseg_next[6:0] = 7'b1000000; // all leds on, bar g, for digit 0
       4'h1: sseg_next[6:0] = 7'b1111001; // leds b, c on for digit 1
       4'h2: sseg_next[6:0] = 7'b0100100; // leds c, f off for digit 2
       4'h3: sseg_next[6:0] = 7'b0110000; // leds e, f off for digit 3
       4'h4: sseg_next[6:0] = 7'b0011001; 
       4'h5: sseg_next[6:0] = 7'b0010010; 
       4'h6: sseg_next[6:0] = 7'b0000010;
       4'h7: sseg_next[6:0] = 7'b1111000;
       4'h8: sseg_next[6:0] = 7'b0000000; // all leds on for digit 8
       4'h9: sseg_next[6:0] = 7'b0010000;
       4'ha: sseg_next[6:0] = 7'b0001000;
       4'hb: sseg_next[6:0] = 7'b0000011;
       4'hc: sseg_next[6:0] = 7'b1000110;
       4'hd: sseg_next[6:0] = 7'b0100001;
       4'he: sseg_next[6:0] = 7'b0000110;
       4'hf: sseg_next[6:0] = 7'b0001110; // leds b, c, d off for hex digit F
       default: sseg_next[6:0] = 7'b1111111; // all off
   endcase
   sseg_next[7] = 1'b1; // decimal point
end

// Registers
always @(posedge clk, posedge rst) begin
   if (rst)
   begin
       count_reg <= 0;
       sseg_reg  <= 0;
       an_reg    <= 0;
   end
   else
   begin
       count_reg <= count_next;
       sseg_reg  <= sseg_next;
       an_reg    <= an_next;
   end
end
 
 // Assign outputs             
assign sseg = sseg_reg;
assign an   = an_reg;               

endmodule
