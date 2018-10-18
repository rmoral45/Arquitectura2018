
module rx_interface #(
                        parameter DATA_BITS = 8
                     )
                     
                     (
                        input  i_clk,
                        input  i_rst,
                        input  i_data_ready,
                        input  [DATA_BITS-1 : 0] i_data,
                        output [DATA_BITS-1 : 0] o_operando1,
                        output [DATA_BITS-1 : 0] o_operando2,
                        output [5 : 0] o_opcode,
                        output o_operation_ready,
                        output [2:0] o_state
                     );

localparam STATE_0 = 3'b001;
localparam STATE_1 = 3'b010;
localparam STATE_2 = 3'b100;

reg data_ready_reg;
reg operation_ready_reg;
reg [DATA_BITS-1 : 0] operando1_reg;
reg [DATA_BITS-1 : 0] operando2_reg;
reg [DATA_BITS-1 : 0] opcode_reg;
reg [2 : 0]state;


assign o_operando1 = operando1_reg;
assign o_operando2 = operando2_reg;
assign o_opcode = opcode_reg[5:0];
assign o_operation_ready = operation_ready_reg;
assign o_state = state;

always @ (posedge i_clk) begin
    data_ready_reg <= i_data_ready;
   
   if(i_rst)begin
        operando1_reg       <= 0;
        operando2_reg       <= 0;
        opcode_reg          <= 0;
        state               <= 3'b001;
        operation_ready_reg <= 0;
    end
   
   else if (data_ready_reg == 0 && i_data_ready == 1'b1)begin
        case(state)
            STATE_0:begin
                operando1_reg <= i_data;
                state <= STATE_1;
                operation_ready_reg <= 0;
            end
            STATE_1:begin 
                operando2_reg <= i_data;
                state <= STATE_2;
                operation_ready_reg <= 0;
            end
            STATE_2:begin
                opcode_reg <= i_data;
                state <= STATE_0;
                operation_ready_reg <= 1;
            end

        endcase
    end
    else begin
        operando1_reg  <= operando1_reg;
        operando2_reg  <= operando2_reg;
        opcode_reg     <= opcode_reg;
        state          <= state;
        operation_ready_reg <= operation_ready_reg;
    end
    

end


endmodule
