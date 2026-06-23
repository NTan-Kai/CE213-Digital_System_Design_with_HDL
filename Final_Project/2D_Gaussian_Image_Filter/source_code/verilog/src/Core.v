`timescale 1ns / 1ps

module gaussian_filter_multi (
    input  wire clk,
    input  wire rst, 
    input  wire filter_mode,   // 0: 3x3, 1: 5x5
    input  wire [199:0] window_flat,
    input  wire valid_in,

    output reg  [7:0] pixel_out,
    output reg  valid_out
);
    wire [7:0] p [0:4][0:4];
    genvar r, c;
    generate
        for(r=0; r<5; r=r+1) begin : gen_row
            for(c=0; c<5; c=c+1) begin : gen_col
                assign p[r][c] = window_flat[(r*5 + c)*8 +: 8];
            end
        end
    endgenerate

    reg filter_mode_d1, filter_mode_d2;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            filter_mode_d1 <= 0;
            filter_mode_d2 <= 0;
        end else begin
            filter_mode_d1 <= filter_mode;
            filter_mode_d2 <= filter_mode_d1;
        end
    end

    wire [11:0] grp_corner_3x3 = p[1][1] + p[1][3] + p[3][1] + p[3][3]; 
    wire [11:0] grp_edge_3x3   = p[1][2] + p[2][1] + p[2][3] + p[3][2]; 

    wire [11:0] grp_1_5x5  = p[0][0] + p[0][4] + p[4][0] + p[4][4];
    wire [11:0] grp_4_5x5  = p[0][1] + p[0][3] + p[1][0] + p[1][4]
                            + p[3][0] + p[3][4] + p[4][1] + p[4][3];
    wire [11:0] grp_6_5x5  = p[0][2] + p[4][2] + p[2][0] + p[2][4];
    wire [11:0] grp_16_5x5 = p[1][1] + p[1][3] + p[3][1] + p[3][3];
    wire [11:0] grp_24_5x5 = p[1][2] + p[2][1] + p[2][3] + p[3][2];

    reg [21:0] sum_stage1;
    reg valid_d1, valid_d2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_stage1 <= 0;
            valid_d1   <= 0;
        end else begin
            valid_d1 <= valid_in;
            if (valid_in) begin
                case (filter_mode)
                    1'b0: begin
                        sum_stage1 <= grp_corner_3x3
                                    + (grp_edge_3x3 <<1 )
                                    + (p[2][2]<<2);
                    end
                    1'b1: begin
                        sum_stage1 <= grp_1_5x5
                                    + (grp_4_5x5  << 2)
                                    + (grp_6_5x5  << 2) + (grp_6_5x5 << 1)
                                    + (grp_16_5x5 << 4)
                                    + (grp_24_5x5 << 4) + (grp_24_5x5 << 3)
                                    + (p[2][2]    << 5) + (p[2][2] << 2);
                    end
                endcase
            end
        end
    end

    reg [21:0] sum_stage2;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_stage2 <= 0;
            valid_d2   <= 0;
        end else begin
            sum_stage2 <= sum_stage1;
            valid_d2   <= valid_d1;
        end
    end

    wire [21:0] final_val_3x3 = (sum_stage2 + 8) >> 4;   
    wire [21:0] final_val_5x5 = (sum_stage2 + 128) >> 8;  

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pixel_out <= 0;
            valid_out <= 0;
        end else begin
            valid_out <= valid_d2;
            if (valid_d2) begin
                case (filter_mode_d2)
                    1'b0: pixel_out <= (final_val_3x3 > 255) ? 8'd255 : final_val_3x3[7:0];
                    1'b1: pixel_out <= (final_val_5x5 > 255) ? 8'd255 : final_val_5x5[7:0];
                endcase
            end
        end
    end
endmodule