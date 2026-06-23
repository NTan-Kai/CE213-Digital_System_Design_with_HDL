`timescale 1ns/1ps
module Control_Unit(
    input [5:0] Opcode,
    output reg RegDst,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg RegWrite,
    output reg [3:0] ALUControl
);
    always @(*) begin
        RegDst   = 1'b0; 
        MemRead  = 1'b0; 
        MemWrite = 1'b0; 
        MemToReg = 1'b0;
        ALUSrc   = 1'b0; 
        RegWrite = 1'b0; 
        ALUOp    = 2'b00;
        case(Opcode)
            6'b000001: begin 
                RegDst   = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemToReg = 1'b0;
                ALUSrc   = 1'b0;
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end
            6'b000010: begin 
                RegDst   = 1'b0; 
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                MemToReg = 1'b0; 
                ALUSrc   = 1'b1;
                RegWrite = 1'b0;
                ALUOp    = 2'b00;
            end
            6'b000100: begin 
                RegDst   = 1'b0;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                MemToReg = 1'b1;
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 2'b00;
            end
            default: begin
            end
        endcase
    end
    always @(*) begin
        case(ALUOp)
            2'b00: ALUControl = 4'b0101; 
            2'b10: ALUControl = 4'b0101; 
            default: ALUControl = 4'b0000;
        endcase
    end
endmodule