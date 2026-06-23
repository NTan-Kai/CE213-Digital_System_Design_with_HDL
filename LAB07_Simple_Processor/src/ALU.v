`timescale 1ns/1ps
module ALU(
    input [31:0] A,
    input [31:0] B,
    input M,
    input S0,
    input S1,
    output reg [31:0] result,
    output reg Overflow
);

wire [2:0] sel = {M, S1, S0};
always@(*) begin
    Overflow = 1'b0;
    case (sel)
        3'b000: result = ~A;
        3'b001: result = A & B;
        3'b010: result = A ^ B;
        3'b011: result = A | B;
        3'b100: result = A - 1;
        3'b101: begin
            result = A + B;
            Overflow = (A[31] & B[31] & ~result [31])|(~A[31] & ~B[31] & result[31]);
        end
        3'b110: begin
            result = A - B;
            Overflow = (A[31] & ~B[31] & ~result [31])|(~A[31] & B[31] & result[31]);            
        end
        3'b111: result = A + 1;
        default: result = 32'b0;
    endcase
end
endmodule


