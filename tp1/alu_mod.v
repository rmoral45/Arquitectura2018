`timescale 1ns / 1ps



module alu_mod#
    (
     parameter BUS_LEN = 8,
     parameter OPCODE_LEN = 6
    )(
        input signed    [BUS_LEN-1 : 0] i_ope1,
        input signed    [BUS_LEN-1 : 0] i_ope2,
        input signed [OPCODE_LEN-1 : 0] i_opcode,
        output reg    [BUS_LEN - 1 : 0] o_result
	
	
	 
    );

	
	//Codificacion de operaciones: parametros internos del modulo
	localparam ADD    = 6'b100000;
    localparam SUB    = 6'b100010;
    localparam AND    = 6'b100100;
    localparam OR     = 6'b100101;
    localparam XOR    = 6'b100110;
    localparam SRA    = 6'b000011;
    localparam SRL    = 6'b000010;
    localparam NOR    = 6'b100111;

	

	always @(*)
	begin
		case (i_opcode)
			ADD: o_result = i_ope1 + i_ope2;
			SUB: o_result = i_ope1 - i_ope2;
			AND: o_result = i_ope1 & i_ope2;
			OR:  o_result = i_ope1 | i_ope2;
			XOR: o_result = i_ope1 ^ i_ope2;
			SRA: o_result = i_ope1 >>> i_ope2;
			SRL: o_result = i_ope1 >> i_ope2;
			NOR: o_result = ~(i_ope1 | i_ope2);
			default: o_result = 0;
		endcase	
	end //End always

endmodule
