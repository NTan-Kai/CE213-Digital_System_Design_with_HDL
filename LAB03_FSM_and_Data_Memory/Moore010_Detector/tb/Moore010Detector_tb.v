`timescale 1ns/1ps

module Moore010Detector_tb;

    reg  dataIn;
    reg  clock;
    reg  reset;
    wire found;

    Moore010Detector uut (
        .dataIn(dataIn),
        .clock(clock),
        .reset(reset),
        .found(found)
    );

    always #5 clock = ~clock;

    initial begin
        clock = 0;
        reset = 1;
        dataIn = 0;
        #20 reset = 0;    
        @(posedge clock); dataIn = 0; 
        @(posedge clock); dataIn = 1; 
        @(posedge clock); dataIn = 0;                 
        @(posedge clock); dataIn = 1; 
        @(posedge clock); dataIn = 0; 
        @(posedge clock); dataIn = 1;
        @(posedge clock); dataIn = 1; 
        @(posedge clock); dataIn = 0;
        #50;
    end
    initial begin
        $monitor("Time=%0t | Reset=%b | Data=%b | State=%b | Found=%b", 
                 $time, reset, dataIn, uut.state, found);
    end
endmodule
