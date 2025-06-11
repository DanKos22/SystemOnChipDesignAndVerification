`timescale 1ns / 1ps
// DebounceFSM.v
// Dan Koskiranta

module DebounceFSM(
    input wire clk,
    input wire rst,
    input wire sw_in,
    output wire sw_out
    );
    
parameter IDLE = 0, READ = 1, DELAY = 2; 
reg[1:0] state, next_state;
reg sw_next, sw_reg;
reg[3:0] count, count_reg;

// Next state logic & output logic
always @* begin
    case(state)
        IDLE: begin
            next_state = READ;
            sw_next = 1'b0;
        end
        READ: begin
            next_state = DELAY;
            count = 0;
            if(sw_in)
                sw_next = 1'b1;
            else
                sw_next = 1'b0;
        end
        DELAY: begin
            if(count_reg == 4'b1010) begin
                next_state = READ;
                count = 4'b0000;
            end 
            else begin
                next_state = DELAY;
                count = count_reg + 1; 
            end  
        end
        default: begin
            next_state = IDLE;
            count = 4'b0000;
            sw_next = 1'b0;
         end      
    endcase
end

always@ (posedge rst, posedge clk) begin
    if(rst) begin
        state <= IDLE;
        sw_reg <= 0;
        count_reg <= 4'b0000;
    end
    else begin
        state <= next_state;
        sw_reg <= sw_next;
        count_reg <= count;
    end
end

// Assign the registered switch value to the debounced switch output signal 
assign sw_out = sw_reg;

endmodule