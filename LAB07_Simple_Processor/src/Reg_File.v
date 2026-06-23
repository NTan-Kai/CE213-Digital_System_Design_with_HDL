`timescale 1ns/1ps
module Reg_File (
    input [4:0] ReadAddress1,
    input [4:0] ReadAddress2,        
    input [4:0] WriteAddress,
    input [31:0] WriteData,    
    input RegWrite,             
    input clock,                                      
    output [31:0] ReadData1,
    output [31:0] ReadData2     
);
    reg [31:0] mem [0:31];
    assign ReadData1 = (ReadAddress1 == 5'b0) ? 32'b0 : mem[ReadAddress1];
    assign ReadData2 = (ReadAddress2 == 5'b0) ? 32'b0 : mem[ReadAddress2];
    always @(posedge clock) begin
        if (RegWrite && (WriteAddress != 5'b0)) begin
            mem[WriteAddress] <= WriteData;
        end
    end
endmodule