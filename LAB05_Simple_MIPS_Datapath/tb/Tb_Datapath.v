`timescale 1ns/1ps
module tb_Datapath();
    reg clock;
    reg [31:0] Inst;
    reg RegDst;
    reg RegWrite;
    reg ALUSrc;
    reg M;
    reg S1;
    reg S0;
    reg MemWrite;
    reg MemRead;
    reg MemToReg;
    Datapath dut (
        .clock(clock),
        .Inst(Inst),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .M(M),
        .S1(S1),
        .S0(S0),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemToReg(MemToReg)
    );
    always #5 clock = ~clock;
    initial begin
        clock = 0;
        Inst = 32'b0;
        RegDst = 0; RegWrite = 0; ALUSrc = 0;
        M = 0; S1 = 0; S0 = 0;
        MemWrite = 0; MemRead = 0; MemToReg = 0;
        dut.reg_file_inst.mem[2] = 32'd10; 
        dut.reg_file_inst.mem[3] = 32'd15;
        dut.data_memory_inst.mem[10] = 32'd999; 
        $display("-------------------------------------------------------------------------");
        $display("Time | $1 (rd/rt) | $2 (rs) | $3 (rt) |  SRAM[10] ");
        $display("-------------------------------------------------------------------------");
        $monitor("%4t | %15d | %15d | %15d | %9d", 
                 $time, dut.reg_file_inst.mem[1], dut.reg_file_inst.mem[2], dut.reg_file_inst.mem[3], dut.data_memory_inst.mem[10]);
        #10;
        $display("\n---> Thuc thi: add $1, $2, $3 ($1 = $2 + $3 = 10 + 15 = 25)");
        Inst = 32'h0043_0820;
        RegDst = 1; ALUSrc = 0; MemToReg = 0; RegWrite = 1; MemRead = 0; MemWrite = 0;
        {M, S1, S0} = 3'b101; 
        #10; 
        $display("\n---> Thuc thi: lw $1, 0($2) (Doc SRAM[10 + 0] ghi vao $1. $1 se la 999)");
        Inst = 32'h8C41_0000;
        RegDst = 0; ALUSrc = 1; MemToReg = 1; RegWrite = 1; MemRead = 1; MemWrite = 0;
        {M, S1, S0} = 3'b101; 
        #10; 
        dut.reg_file_inst.mem[1] = 32'd777; 
        $display("\n---> Thuc thi: sw $1, 0($2) (Ghi $1=777 vao SRAM[10]. SRAM[10] se doi thanh 777)");
        Inst = 32'hAC41_0000;
        RegDst = 0; ALUSrc = 1; MemToReg = 0; RegWrite = 0; MemRead = 0; MemWrite = 1;
        {M, S1, S0} = 3'b101; 
        #10; 
        $display("\n-------------------- KET THUC MO PHONG --------------------");
        #20;
        $stop;
    end
endmodule
