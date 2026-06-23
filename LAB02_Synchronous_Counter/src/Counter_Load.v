`timescale 1ns/1ps

module Counter_Load(
    input [2:0] Input,
    input Clr, Prs, Clk,
    output reg [2:0] q
);

    wire [2:0] next_q;
    assign next_q = (q == 3'b000) ? 3'b110 :
                    (q == 3'b110) ? 3'b100 :
                    (q == 3'b100) ? 3'b111 :
                    (q == 3'b111) ? 3'b011 :
                    (q == 3'b011) ? 3'b000 :
                    (q == 3'b101) ? 3'b111 : 
                    (q == 3'b010) ? 3'b111 : 
                    (q == 3'b001) ? 3'b110 : 
                    3'b000;

    always @(posedge Clk or posedge Clr or posedge Prs) begin
        if (Clr) 
            q <= 3'b000;          
        else if (Prs) 
            q <= Input;           
        else 
            q <= next_q;          
    end

endmodule
