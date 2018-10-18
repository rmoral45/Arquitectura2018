

module alu_mod
#(
 parameter BUS_LEN = 8,
 parameter OPCODE_LEN = 6
)
(
            input                            clk,
            input                            rst,
            input signed [BUS_LEN - 1 : 0]          i_ope1,
            input signed [BUS_LEN - 1 : 0]          i_ope2,
            input [OPCODE_LEN - 1 : 0]       i_opcode,
            output [BUS_LEN -1 : 0]          o_result
);

localparam ADD = 6'b100000;
localparam SUB = 6'b100010;
localparam AND = 6'b100100;
localparam OR = 6'b100101;
localparam XOR = 6'b100110;
localparam SRA = 6'b000011;
localparam SRL = 6'b000010;
localparam NOR = 6'b100111;


reg signed [BUS_LEN - 1 : 0] res;
reg [BUS_LEN - 1 : 0] shift_val;

assign o_result = res;

always @ * begin
    shift_val = i_ope2 ; // xq tiene que ser no signado y q consecuencias tiene? la operacion % es sintesisable?
    case (i_opcode) 
        ADD: 
            res = i_ope1 + i_ope2;
        SUB:
            res = i_ope1 - i_ope2;
        AND:
            res = i_ope1 & i_ope2;
        OR:
            res = i_ope1 | i_ope2;
        XOR:
            res = i_ope1 ^ i_ope2;
        SRA:
            res = i_ope1 >>> (shift_val%BUS_LEN) ;
                      //a ope2 lo shifteo ope1 veces a la derecha (aritmetico)
        SRL:
            res = i_ope1 >> (shift_val%BUS_LEN) ;                     //a ope2 lo shifteo ope1 veces a la derecha (logico)
        NOR:
            res = ~ (i_ope1 | i_ope2);
        default:
            res = {BUS_LEN{1'b0}};
    endcase

end


endmodule                                               //End of ALU module