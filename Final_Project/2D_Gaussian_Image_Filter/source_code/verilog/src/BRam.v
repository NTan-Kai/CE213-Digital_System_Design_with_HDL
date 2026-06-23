`timescale 1ns/1ps

module outsource_bram (
    input  wire clk,
    input  wire we,
    input  wire [15:0] addr,
    input  wire [7:0]  data_in,
    input  wire [15:0] read_addr,
    output reg  [7:0]  data_out
);
    reg [7:0] ram [0:65535];

    always @(posedge clk) begin
        if (we) ram[addr] <= data_in;
    end

    always @(posedge clk) begin
        data_out <= ram[read_addr];
    end
endmodule
