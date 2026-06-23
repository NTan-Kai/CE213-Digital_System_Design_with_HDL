`timescale 1ns/1ps
module SignEx (
    input  [15:0] In,
    output [31:0] Out
);
    assign Out = { {16{In[15]}}, In };
endmodule
