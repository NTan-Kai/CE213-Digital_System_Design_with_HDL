`timescale 1ns/1ps

module tb_top_system();
    parameter IMG_W = 256;
    parameter IMG_H = 256;
    
    reg clk, rst, start;
    reg filter_mode; 
    
    wire [15:0] ram_in_addr; wire [7:0] ram_in_data;
    wire [15:0] ram_out_addr; wire [7:0] ram_out_data;
    wire        ram_out_we, done;

    initial begin
        clk = 0; forever #5 clk = ~clk;
    end

    top_system #(.IMG_W(IMG_W), .IMG_H(IMG_H)) u_top (
        .clk(clk), .rst(rst), .start(start), .filter_mode(filter_mode),
        .ram_in_addr(ram_in_addr), .ram_in_data(ram_in_data),
        .ram_out_addr(ram_out_addr), .ram_out_data(ram_out_data),
        .ram_out_we(ram_out_we), .done(done)
    );

    outsource_bram u_bram_in (
        .clk(clk), .we(1'b0), .addr(16'd0), .data_in(8'd0),         
        .read_addr(ram_in_addr), .data_out(ram_in_data)
    );

    outsource_bram u_bram_out (
        .clk(clk), .we(ram_out_we), .addr(ram_out_addr),    
        .data_in(ram_out_data), .read_addr(16'd0), .data_out()             
    );

    integer file_out, i;
    
    initial begin
        rst = 1; start = 0;
        filter_mode = 1'b0; 

        $readmemh("input_image.hex", u_bram_in.ram);
        $display("--- Load image_in.hex successfully! ---");

        #20; rst = 0;
        #20; start = 1;
        #10; start = 0;
        $display("--- Processing Started ---");
      
        wait(done == 1'b1);
        $display("--- Processing Finished ---");

        file_out = $fopen("image_out.hex", "w");
        for (i = 0; i < IMG_W * IMG_H; i = i + 1) begin
            $fdisplay(file_out, "%02h", u_bram_out.ram[i]);
        end
        $fclose(file_out);
        $display("--- Saved to image_out.hex successfully! ---");

        #100; $stop;
    end
endmodule
