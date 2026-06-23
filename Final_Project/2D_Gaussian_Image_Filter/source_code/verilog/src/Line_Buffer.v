`timescale 1ns / 1ps
module line_buffer_multi #(
    parameter IMG_W = 256,
    parameter IMG_H = 256
)(
    input wire clk,
    input wire rst,
    input wire in_en,
    input wire [7:0] data_in,
    output wire out_en,
    output reg [199:0] window_flat
);

    localparam PTR_W = $clog2(IMG_W);
    localparam CNT_W = 22;
    localparam START_DELAY = (IMG_W * 2) + 2;   
    reg [7:0] lb_1 [0:IMG_W-1];
    reg [7:0] lb_2 [0:IMG_W-1];
    reg [7:0] lb_3 [0:IMG_W-1];
    reg [7:0] lb_4 [0:IMG_W-1];

    integer i_ram;
    initial begin
        for (i_ram = 0; i_ram < IMG_W; i_ram = i_ram + 1) begin
            lb_1[i_ram] = 8'h00; lb_2[i_ram] = 8'h00;
            lb_3[i_ram] = 8'h00; lb_4[i_ram] = 8'h00;
        end
    end

    reg [PTR_W-1:0] pixel_col, pixel_col_d1;
    reg [CNT_W-1:0] pixel_count;
    reg [7:0] data_in_d1;
    reg [7:0] rd1, rd2, rd3, rd4;

    wire window_ready = (pixel_count >= START_DELAY);

    reg [PTR_W-1:0] out_x;
    reg [$clog2(IMG_H)-1:0] out_y;
    reg window_ready_d1;
    reg window_ready_d2;         
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            window_ready_d1 <= 0;
            window_ready_d2 <= 0;
        end else begin
            window_ready_d1 <= window_ready;
            window_ready_d2 <= window_ready_d1;   
        end
    end

    assign out_en = window_ready_d2 && (out_y < IMG_H) && in_en;   

    reg [7:0] raw_window [0:4][0:4];

    integer r, c;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pixel_col <= 0; pixel_col_d1 <= 0;
            pixel_count <= 0; data_in_d1 <= 0;
            out_x <= 0; out_y <= 0;
            for(r=0; r<5; r=r+1)
                for(c=0; c<5; c=c+1)
                    raw_window[r][c] <= 0;
        end else if (in_en) begin
            pixel_col_d1 <= pixel_col;
            rd1 <= lb_1[pixel_col]; rd2 <= lb_2[pixel_col];
            rd3 <= lb_3[pixel_col]; rd4 <= lb_4[pixel_col];

            lb_1[pixel_col_d1] <= data_in_d1;
            lb_2[pixel_col_d1] <= rd1;
            lb_3[pixel_col_d1] <= rd2;
            lb_4[pixel_col_d1] <= rd3;

            pixel_col <= (pixel_col == IMG_W - 1) ? 0 : pixel_col + 1;
            data_in_d1 <= data_in;

            if (pixel_count < (IMG_W * IMG_H + START_DELAY))
                pixel_count <= pixel_count + 1;

            // shift window
            for(r=0; r<5; r=r+1)
                for(c=0; c<4; c=c+1)
                    raw_window[r][c] <= raw_window[r][c+1];

            raw_window[0][4] <= rd4;
            raw_window[1][4] <= rd3;
            raw_window[2][4] <= rd2;
            raw_window[3][4] <= rd1;
            raw_window[4][4] <= data_in_d1;

            if (window_ready_d2) begin          
                if (out_x == IMG_W - 1) begin
                    out_x <= 0;
                    out_y <= out_y + 1;
                end else begin
                    out_x <= out_x + 1;
                end
            end
        end
    end

    integer idx_c, idx_r;
    integer map_c [0:4];
    integer map_r [0:4];

    always @(*) begin
        for (idx_c = 0; idx_c < 5; idx_c = idx_c + 1) begin
            if (out_x < 2 && idx_c < 2 - out_x) begin
                map_c[idx_c] = 4 - idx_c - (out_x << 1);
            end else if (out_x + idx_c >= IMG_W + 2) begin
                map_c[idx_c] = 4 - idx_c + ((IMG_W - 1 - out_x) << 1);
            end else begin
                map_c[idx_c] = idx_c;
            end
        end

        for (idx_r = 0; idx_r < 5; idx_r = idx_r + 1) begin
            if (out_y < 2 && idx_r < 2 - out_y) begin
                map_r[idx_r] = 4 - idx_r - (out_y << 1);
            end else if (out_y + idx_r >= IMG_H + 2) begin
                map_r[idx_r] = 4 - idx_r + ((IMG_H - 1 - out_y) << 1);
            end else begin
                map_r[idx_r] = idx_r;
            end
        end

        for(r = 0; r < 5; r = r + 1) begin
            for(c = 0; c < 5; c = c + 1) begin
                window_flat[(r*5 + c)*8 +: 8] = raw_window[map_r[r]][map_c[c]];
            end
        end
    end
endmodule