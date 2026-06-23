`timescale 1ns/1ps
module SRAM (
	input [9:0] Address,      
	input [31:0] WriteData,    
	input WriteEn,             
	input ReadEn,              
	input clock,                              
    output [31:0] ReadData     
);
    reg [31:0] mem [0:1023];
	assign ReadData = (ReadEn) ? mem[Address[31:0]] : 32'b0;
    always @(posedge clock) begin
 		if (WriteEn) begin
            		mem[Address[31:0]] <= WriteData;
        end
    end
endmodule

