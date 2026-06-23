`timescale 1ns/1ps
module Mux2_1(
    input [31:0] A,
    input [31:0] B,
    input Sel,
    output reg [31:0] Y
);
    assign Y = Sel ? B : A;
endmodule
