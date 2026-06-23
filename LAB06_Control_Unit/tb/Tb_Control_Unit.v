`timescale 1ns/1ps
module tb_Control_Unit();
    reg [5:0] Opcode;  
    wire RegDst;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire RegWrite;
    wire [3:0] ALUControl;
    Control_Unit dut (
        .Opcode(Opcode),
        .RegDst(RegDst),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl)
    );
    initial begin
        $monitor("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Opcode, RegDst, MemRead, MemWrite, MemToReg, ALUOp, ALUSrc, RegWrite, ALUControl);
        #10;
        Opcode = 6'b000001; 
        
        #10;
        Opcode = 6'b000010;

        #10;
        Opcode = 6'b000100;

        #10;
        Opcode = 6'b111111;

        #10;
        $stop;
    end
endmodule
