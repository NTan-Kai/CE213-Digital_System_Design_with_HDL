`timescale 1ns/1ps

module controller (
    input  wire clk,
    input  wire rst,
    input  wire start,         
    input  wire process_done,    
    output reg  en_process,      
    output reg  done        
);
    localparam IDLE    = 2'b00;
    localparam PROCESS = 2'b01;
    localparam DONE    = 2'b10;
    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    always @(*) begin
        next_state = state;
        en_process = 0;
        done       = 0;
        case (state)
            IDLE: begin
                if (start) next_state = PROCESS;
            end
            PROCESS: begin
                en_process = 1;
                if (process_done) next_state = DONE;
            end
            DONE: begin
                done = 1;
                next_state = IDLE; 
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
