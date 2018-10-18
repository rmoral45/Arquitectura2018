`define OP_LEN 6


module toplevel
#(
    parameter BUS_LEN = 8
)
(
                input   [ BUS_LEN - 1 : 0 ] i_sw,
                input                       i_btnC,               //Latch opcode
                input                       i_btnL,               //Latch ope1
                input                       i_btnR,               //Latch ope2
                input                       i_btnU,               //Reset
                input                       i_clk,                //Clock
                output  [ BUS_LEN - 1 : 0 ] o_led,
                output             [ 2 : 0 ] debug_led
);

    //Registros de trabajo
    reg [ BUS_LEN - 1 : 0 ]           datoA;
    reg [ BUS_LEN - 1 : 0 ]           datoB;
    reg [ `OP_LEN - 1 : 0 ]           opcode;
    
    //Para deteccion de flanco
    reg latchA;
    reg latchB;
    reg latchOP;  
    
    //HW debug para indicar ingresos
    reg [2:0] in_saved;
         
    wire reset;
    wire saveA;
    wire saveB;
    wire saveOP;
    wire [ BUS_LEN - 1 : 0 ]           ope1;
    wire [ BUS_LEN - 1 : 0 ]           ope2;
    wire [ `OP_LEN - 1 : 0 ]           code;
    wire [ BUS_LEN - 1 : 0 ]           resultado;
    
    
    assign saveA  = (latchA == 0 &&  i_btnL == 1) ? 1'b1 : 1'b0;
    assign saveB  = (latchB == 0 &&  i_btnR == 1) ? 1'b1 : 1'b0;
    assign saveOP = (latchOP == 0 &&  i_btnC == 1) ? 1'b1 : 1'b0;
    assign reset = i_btnU;
    assign ope1 = datoA;
    assign ope2 = datoB;
    assign code = opcode;
    assign o_led = resultado;
    assign debug_led = in_saved;
    
    
    always @ (posedge i_clk or posedge reset) begin
    
        latchA  <= i_btnL;
        latchB  <= i_btnR;
        latchOP <= i_btnC;
    
        if(reset) begin
            latchA   <=              'd0;
            latchB   <=              'd0;
            latchOP  <=              'd0;
            in_saved <=           3'b000;
            datoA    <=  {BUS_LEN{1'b0}};
            datoB    <=  {BUS_LEN{1'b0}};
            opcode   <=  {`OP_LEN{1'b0}};
        end
        else if (saveA)begin
            datoA    <= i_sw;
            in_saved <=3'b001;
        
        end        
        else if (saveB) begin
            datoB    <= i_sw;
            in_saved <=3'b011;
        end            
        else if (saveOP) begin
             opcode   <= i_sw [`OP_LEN - 1 : 0];
             in_saved <=3'b111;
        end             
        else begin
            datoA  <= datoA;
            datoB  <= datoB;
            opcode <= opcode;
        end
    end


alu_mod #(
            )
 u_alu (
        .i_opcode(code),
        .i_ope1(ope1),
        .i_ope2(ope2),
        .o_result(resultado)
        
        );         
        
endmodule                                           //End of toplevel module