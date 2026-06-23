`timescale 1ns/1ps

module Counter_Load_tb();
    reg [2:0] Input;
    reg Clr, Prs, Clk;
    wire [2:0] q;

    Counter_Load uut (
        .Input(Input),
        .Clr(Clr),
        .Prs(Prs),
        .Clk(Clk),
        .q(q)
    );

    initial Clk = 0;
    always #10 Clk = ~Clk;

    initial begin
        Input = 3'b000;
        Prs = 0;
        Clr = 1;       
        #20;           
        
        Clr = 0;       
        #60;    	
	//Test chuc nang nap bat dong bo       
        Input = 3'b101; 
        Prs = 1;       
        @(posedge Clk);
        Prs = 0;       
        #55;
	

        Input = 3'b111; 
        Prs = 1;       

        Prs = 0;       
        #50;


        Clr = 1;
        #10;
        Clr = 0;

        #50;
        $display("Mo phong hoan tat!");
        $stop;       
    end

    initial begin
        $monitor("At time %t: Clr=%b, Prs=%b, Input=%b, q=%b (%d)", 
                 $time, Clr, Prs, Input, q, q);

        Prs = 0;       
        #50;
	

        Input = 3'b111; 
        Prs = 1;       

        Prs = 0;       
        #50;


        Clr = 1;
        #10;
        Clr = 0;

        #50;
        $display("Mo phong hoan tat!");
        $stop;       
    end

    initial begin
        $monitor("At time %t: Clr=%b, Prs=%b, Input=%b, q=%b (%d)", 
                 $time, Clr, Prs, Input, q, q);
    end

endmodule
