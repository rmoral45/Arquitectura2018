`define OP_LEN 6


module toplevel
#(
    parameter BUS_LEN = 8
)
(
                input   [ BUS_LEN - 1 : 0 ] sw,
                input                       btnC,               //Latch opcode
                input                       btnL,               //Latch ope1
                input                       btnR,               //Latch ope2
                input                       btnU,               //Reset
                input                       clk,                //Clock
                output  [ BUS_LEN - 1 : 0 ] led
);


    reg [ BUS_LEN - 1 : 0 ]           datoA;
    reg [ BUS_LEN - 1 : 0 ]           datoB;
    reg [ `OP_LEN - 1 : 0 ]           opcode;
    reg latchA;
    reg latchB;
    reg latchOP;       
    wire reset;
    wire saveA;
    wire saveB;
    wire saveOP;
    wire [ BUS_LEN - 1 : 0 ]           ope1;
    wire [ BUS_LEN - 1 : 0 ]           ope2;
    wire [ `OP_LEN - 1 : 0 ]           code;
    wire [ BUS_LEN - 1 : 0 ]           resultado;
    
    
    assign saveA  = (latchA == 0 &&  btnL == 1) ? 1'b1 : 1'b0;
    assign saveB  = (latchB == 0 &&  btnR == 1) ? 1'b1 : 1'b0;
    assign saveOP = (latchOP == 0 &&  btnC == 1) ? 1'b1 : 1'b0;
    assign reset = btnU;
    assign ope1 = datoA;
    assign ope2 = datoB;
    assign code = opcode;
    assign led = resultado;
    
    
    always @ (posedge clk or posedge reset) begin
    
        latchA  <= btnL;
        latchB  <= btnR;
        latchOP <= btnC;
    
        if(reset) begin
            datoA <=  {BUS_LEN{1'b0}};
            datoB <=  {BUS_LEN{1'b0}};
            opcode <= {`OP_LEN{1'b0}};
        end
        else if (saveA)
            datoA <= sw;
        
        else if (saveB)
            datoB <= sw;
            
        else if (saveOP)
             opcode <= sw [`OP_LEN - 1 : 0];
             
        else begin
            datoA  <= datoA;
            datoB  <= datoB;
            opcode <= opcode;
        end
    end


alu_mod #(
            )
 alu1 (
        .i_opcode(code),
        .i_ope1(ope1),
        .i_ope2(ope2),
        .o_result(resultado),
        .clk(clk),
        .rst(reset)
        );         
        
endmodule                                           //End of toplevel module