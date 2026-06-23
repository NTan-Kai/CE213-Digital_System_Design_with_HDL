`timescale 1ns/1ps
module tb_SimpleProcessor();
    reg clock;
    reg [31:0] Inst;
    SimpleProcessor dut (
        .clock(clock),
        .Inst(Inst)
    );
    always #5 clock = ~clock;
    initial begin
        clock = 0;
        Inst = 32'b0;
        dut.datapath_block.reg_file_inst.mem[2] = 32'd10; 
        dut.datapath_block.reg_file_inst.mem[3] = 32'd15;
        dut.datapath_block.data_memory_inst.mem[10] = 32'd999; 
        $display("-------------------------------------------------------------------------");
        $display("Time | $1 (rd/rt) | $2 (rs) |  $3 (rt) | SRAM[10] ");
        $display("-------------------------------------------------------------------------");
        $monitor("%4t | %15d | %15d | %15d | %9d", $time, dut.datapath_block.reg_file_inst.mem[1], dut.datapath_block.reg_file_inst.mem[2], dut.datapath_block.reg_file_inst.mem[3], dut.datapath_block.data_memory_inst.mem[10]);
        #10;
        Inst = 32'h0443_0820; 
        #10; 
        Inst = 32'h1041_0000;
        #10;
        dut.datapath_block.reg_file_inst.mem[1] = 32'd777; 
        Inst = 32'h0841_0000;
        #10;
        $display("-------------------- KET THUC MO PHONG --------------------");
        #20;
        $stop;
    end
endmodule