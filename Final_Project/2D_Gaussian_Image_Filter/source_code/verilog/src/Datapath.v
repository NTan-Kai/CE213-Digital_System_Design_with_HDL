`timescale 1ns/1ps

module datapath #(
    parameter IMG_W = 256,
    parameter IMG_H = 256
)(
    input  wire clk,
    input  wire rst,
    input  wire en_process,
    input  wire filter_mode, 
    output wire [15:0] ram_addr_in,
    input  wire [7:0]  ram_data_in,
    output wire [15:0] ram_addr_out,
    output wire [7:0]  ram_data_out,
    output wire        ram_we_out,
    output wire process_done
);
    reg en_process_d1;
    always @(posedge clk or posedge rst) begin
        if (rst) en_process_d1 <= 0;
        else     en_process_d1 <= en_process;
    end

    reg [15:0] read_addr_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst || !en_process) begin
            read_addr_cnt <= 0;
        end else if (en_process && read_addr_cnt < (IMG_W * IMG_H - 1)) begin
            read_addr_cnt <= read_addr_cnt + 1;
        end
    end
    assign ram_addr_in = read_addr_cnt;

    wire lb_out_en;
    wire [199:0] window_flat;
    
    line_buffer_multi #(.IMG_W(IMG_W), .IMG_H(IMG_H)) u_line_buffer (
        .clk(clk), 
        .rst(rst), 
        .in_en(en_process_d1),
        .data_in(ram_data_in),
        .out_en(lb_out_en), 
        .window_flat(window_flat)
    );

    wire [7:0] raw_pixel_out;
    gaussian_filter_multi u_gaussian (
        .clk(clk), 
        .rst(rst), 
        .filter_mode(filter_mode),
        .window_flat(window_flat), 
        .valid_in(lb_out_en),
        .pixel_out(raw_pixel_out), 
        .valid_out(ram_we_out)
    );

    assign ram_data_out = raw_pixel_out;

    reg [16:0] write_addr_cnt; 
    always @(posedge clk or posedge rst) begin
        if (rst || !en_process) 
            write_addr_cnt <= 0;
        else if (ram_we_out)    
            write_addr_cnt <= write_addr_cnt + 1;
    end
    
    assign ram_addr_out = write_addr_cnt[15:0];
    assign process_done = (write_addr_cnt == (IMG_W * IMG_H));
endmodule
