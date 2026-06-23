`timescale 1ns/1ps

module CLA_3b_tb();
    reg [2:0] A, B;
    reg Cin;
    wire [3:0] S;
    CLA_3b uut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .S(S)
    );

    initial begin
        A = 0; B = 0; Cin = 0;
        $monitor("Time=%0t | A=%d B=%d Cin=%b | Tong S=%d", $time, A, B, Cin, S);

        repeat (15) begin
            A   = $urandom_range(0, 7); 
            B   = $urandom_range(0, 7);
            Cin = $urandom_range(0, 1);
            #( $urandom_range(10, 60) );
        end
        #50;
        $display("Hoàn thành mô ph?ng ng?u nhiên.");
        $stop;
    end
endmodule