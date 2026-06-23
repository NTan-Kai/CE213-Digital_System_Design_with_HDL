`timescale 1ns/1ps
module Datapath(
    input clock,
    input [31:0] Inst,
    input RegDst,
    input RegWrite,
    input ALUSrc,
    input M,          
    input S1,         
    input S0,        
    input MemWrite,
    input MemRead,
    input MemToReg
);
    wire [4:0]  WriteReg_Addr;       
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] SignExt_Out;         
    wire [31:0] ALU_In_B;            
    wire [31:0] ALU_Result;          
    wire ALU_Overflow;        
    wire [31:0] Mem_ReadData;        
    wire [31:0] Reg_WriteData;       
    assign WriteReg_Addr = RegDst ? Inst[15:11] : Inst[20:16];

    Reg_File reg_file_inst (
        .ReadAddress1(Inst[25:21]), 
        .ReadAddress2(Inst[20:16]), 
        .WriteAddress(WriteReg_Addr),
        .WriteData(Reg_WriteData),
        .RegWrite(RegWrite),
        .clock(clock),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    SignEx sign_ext_inst (
        .In(Inst[15:0]),
        .Out(SignExt_Out)
    );

    Mux2_1 mux_alu_src (
        .A(ReadData2),
        .B(SignExt_Out),
        .Sel(ALUSrc),
        .Y(ALU_In_B)
    );

    ALU alu_inst (
        .A(ReadData1),
        .B(ALU_In_B),
        .M(M),
        .S0(S0),          
        .S1(S1),          
        .result(ALU_Result),
        .Overflow(ALU_Overflow)
    );

    SRAM data_memory_inst (
        .Address(ALU_Result),      
        .WriteData(ReadData2),     
        .WriteEn(MemWrite),
        .ReadEn(MemRead),
        .clock(clock),
        .ReadData(Mem_ReadData)
    );

    Mux2_1 mux_mem_to_reg (
        .A(ALU_Result),
        .B(Mem_ReadData),
        .Sel(MemToReg),
        .Y(Reg_WriteData)
    );
endmodule