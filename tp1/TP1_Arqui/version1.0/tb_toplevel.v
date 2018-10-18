`timescale 1ns/100ps

module tb_toplevel;
                    
reg     [7 : 0]   sw; 
reg               btnC;
reg               btnL;
reg               btnR;
reg               clk;
reg               rst;
wire     [7 : 0]  led;

initial begin
clk  = 1'b0;
rst  = 1'b0;
btnL = 1'b0;
btnR = 1'b0;
btnC = 1'b0;
#5 rst = 1'b1;
#1 rst = 1'b0;
#5 sw = 8'hFF;
   btnL = 1'b1;
#1 btnL = 1'b0;
#5 sw = 8'hF0;
   btnR = 1'b1;
#1 btnR = 1'b0;
#5 sw = 8'b00100100;
   btnC = 1'b1;
#1 btnC = 1'b0;
#1000 $finish;
end

always #1 clk = ~clk;                    
                    
toplevel #(
            )
 toplevel1 (
        .sw(sw),
        .btnC(btnC),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(rst),
        .clk(clk),
        .led(led)
        );             
endmodule