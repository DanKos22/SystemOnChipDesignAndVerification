`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Stopwatch testbench
// Dan Koskiranta
//////////////////////////////////////////////////////////////////////////////////

module StopWatchTestbench(
);
    
    localparam T = 10; // Clock period
    reg clk, rst, btn;  // Internal testbench signals to connect to uut
    wire [3:0] an;
    wire [6:0] sseg;
    
    // Instantiate design under test
    StopWatchTop uut(.clk(clk), .rst(rst), .btn(btn), .an(an), .sseg(sseg));
    
    // Clock
    always
    begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);
    end
    
    // Reset
    initial
    begin
        rst = 1'b0;
        #T;
        rst = 1'b1;
        #(2*T);
        rst = 1'b0;
    end
    
    // Go
    initial
    begin
        btn = 1'b0;
        #(10*T);
        btn = 1'b1;
    end
    
endmodule
