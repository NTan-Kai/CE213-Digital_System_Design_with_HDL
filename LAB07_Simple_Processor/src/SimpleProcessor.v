`timescale 1ns/1ps

module SimpleProcessor(
    input clock,
    input [31:0] Inst
);
    wire RegDst;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire RegWrite;
    wire [3:0] ALUControl;

    Control_Unit control_block (
        .Opcode(Inst[31:26]),
        .RegDst(RegDst),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl)
    );

    Datapath datapath_block (
        .clock(clock),
        .Inst(Inst),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .M(ALUControl[2]),   
        .S1(ALUControl[1]),  
        .S0(ALUControl[0]),  
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemToReg(MemToReg)
    );

endmodule
