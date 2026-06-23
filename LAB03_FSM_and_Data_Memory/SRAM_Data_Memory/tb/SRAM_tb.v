`timescale 1ns/1ps

module SRAM_tb;
	reg [31:0] Address, WriteData;
	reg WriteEn, ReadEn, clock;
	wire [31:0] ReadData;

SRAM uut (
        .Address(Address), .WriteData(WriteData),
        .WriteEn(WriteEn), .ReadEn(ReadEn),
        .clock(clock), .ReadData(ReadData)
);

    	always #10 clock = ~clock;
    	initial begin
        	clock = 0; WriteEn = 0; ReadEn = 0;
        	Address = 0; WriteData = 0;        
        	@(posedge clock);
        	#1; Address = 32'd32; WriteData = 32'd342; WriteEn = 1;
        	@(posedge clock);
        	#1; Address = 32'd16; WriteData = 32'd276; WriteEn = 1;
        	@(posedge clock);
        	#1; WriteEn = 0; ReadEn = 1; Address = 32'd32;
		@(posedge clock);
        	#1; WriteEn = 0; ReadEn = 1; Address = 32'd16;
		@(posedge clock);
        	#1; Address = 32'd16; WriteData = 32'd113; WriteEn = 1; ReadEn = 0;
		@(posedge clock);
        	#1; WriteEn = 0; ReadEn = 1; Address = 32'd16;
        	@(posedge clock);
        	#1; Address = 32'd22;
        	#20;
    end
endmodule
