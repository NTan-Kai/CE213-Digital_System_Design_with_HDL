`timescale 1ns/1ps

module top_system #(
    parameter IMG_W = 256,
    parameter IMG_H = 256
)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire filter_mode, // 0: 3x3, 1: 5x5
    
    output wire [15:0] ram_in_addr,
    input  wire [7:0]  ram_in_data,
    output wire [15:0] ram_out_addr,
    output wire [7:0]  ram_out_data,
    output wire        ram_out_we,
    output wire        done
);
    wire en_process;
    wire process_done;

    controller u_ctrl (
        .clk(clk), .rst(rst), .start(start),
        .process_done(process_done),
        .en_process(en_process), .done(done)
    );

    datapath #(.IMG_W(IMG_W), .IMG_H(IMG_H)) u_dp (
        .clk(clk), .rst(rst),
        .en_process(en_process),
        .filter_mode(filter_mode),
        .ram_addr_in(ram_in_addr), .ram_data_in(ram_in_data),
        .ram_addr_out(ram_out_addr), .ram_data_out(ram_out_data),
        .ram_we_out(ram_out_we),
        .process_done(process_done)
    );
endmodule
