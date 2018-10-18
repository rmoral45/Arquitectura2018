`timescale 1ns/100ps

module tb_alu_mod;
                    
reg [5:0] opcode;
reg [7:0] ope1;
reg [7:0] ope2;
wire [7:0] resultado;
reg         clk;
reg         rst;

initial begin
clk = 1'b0;
rst = 1'b0;
#5 rst = 1'b1;
    ope1 = 8'hF1;
    ope2 = 8'hFF;
#10 opcode = 6'b100000;
#5  opcode = 6'b100010;
#5  opcode = 6'b100100;
#5  opcode = 6'b100101;
#5  opcode = 6'b100110;
#5  opcode = 6'b000011;
#5  opcode = 6'b000010;
#5  opcode = 6'b100111;
#1000 $finish;
end



always #1 clk = ~clk;                    
                    


alu_mod #(
            )
 alu1 (
        .i_opcode(opcode),
        .i_ope1(ope1),
        .i_ope2(ope2),
        .o_result(resultado),
        .clk(clk),
        .rst(rst)
        );             
endmodule