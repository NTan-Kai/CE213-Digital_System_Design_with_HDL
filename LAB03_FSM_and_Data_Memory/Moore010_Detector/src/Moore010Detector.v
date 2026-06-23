`timescale 1ns/1ps
module Moore010Detector (
    input  dataIn,
    input  clock,
    input  reset,
    output found
);


parameter RESET = 2'b00,
          GOT0  = 2'b01,
          GOT01 = 2'b11,
	  GOT010 = 2'b10;


reg [1:0] state, next_state;


always @(state or dataIn) 
    case (state)
        RESET: 
            if (dataIn)
                next_state = RESET;
            else
                next_state = GOT0;
        GOT0: 
            if (dataIn)
                next_state = GOT01;
            else
                next_state = GOT0;
        GOT01: 
            if (dataIn)
                next_state = RESET;
            else
                next_state = GOT010;				 
        GOT010:
            if (dataIn)
                next_state = GOT01;
            else
                next_state = GOT0;
        default: next_state = RESET;
    endcase

always @(posedge clock) begin
    if (reset)
        state <= RESET;
    else
        state <= next_state;
end


assign found = (state == GOT010)?1:0;

endmodule