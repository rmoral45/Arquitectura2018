`timescale 1ns/100ps

/*Todo puerto de salida es un wire*/

module tb_alu_mod();
                    
reg  [5:0] opcode;
reg  [7:0] ope1;
reg  [7:0] ope2;
wire [7:0] resultado;

parameter ADD    = 6'b100000;
parameter SUB    = 6'b100010;
parameter AND    = 6'b100100;
parameter OR     = 6'b100101;
parameter XOR    = 6'b100110;
parameter SRA    = 6'b000011;
parameter SRL    = 6'b000010;
parameter NOR    = 6'b100111;

initial begin

#5  opcode = 8'h00;
#5  ope1   = 8'h00;
#5  ope2 = 8'h00;

#10 ope1 = 8'hF1;
#10 ope2 = 8'hF2;
#10 opcode = ADD;
#5  opcode = SUB;
#5  opcode = AND;
#5  opcode = OR;
#5  opcode = XOR;
#5  opcode = SRA;
#5  opcode = SRL;
#5  opcode = NOR;
#10 ope1   = 8'h01;
#10 ope2   = 8'h0F;
#10 opcode = ADD;
#5  opcode = SUB;
#5  opcode = AND;
#5  opcode = OR;
#5  opcode = XOR;
#5  opcode = SRA;
#5  opcode = SRL;
#5  opcode = NOR;
#100 $finish;
end


alu_mod #(
            )
 alu1 (
        .i_opcode(opcode),
        .i_ope1(ope1),
        .i_ope2(ope2),
        .o_result(resultado)
       
        );             
endmodule