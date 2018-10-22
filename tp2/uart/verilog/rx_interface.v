
module rx_interface #(
                        parameter DATA_BITS = 8
                     )
                     
                     (
                        input  i_clock,
                        input  i_reset,
                        input  i_data_ready,
                        input  [DATA_BITS-1 : 0] i_data,
                        input  [DATA_BITS-1 : 0] i_alu_result,

                        output  [DATA_BITS-1 : 0] o_operando1,
                        output  [DATA_BITS-1 : 0] o_operando2,
                        output  [5 : 0] o_opcode,
                        output  o_start_tx,
                        output  o_data
                     );

localparam SAVE_OP_1 = 4'b0001;
localparam SAVE_OP_2 = 4'b0010;
localparam SAVE_OP_CODE = 4'b0100;
localparam SIGNAL_READY = 4'b1000;

reg [DATA_BITS-1 : 0] operando1_reg;
reg [DATA_BITS-1 : 0] operando2_reg;
reg [DATA_BITS-1 : 0] opcode_reg;
reg [3 : 0]state;
reg start_tx;

assign o_operando1 = operando1_reg;
assign o_operando2 = operando2_reg;
assign o_opcode = opcode_reg;
assign o_start_tx = start_tx;
assign o_data = i_alu_result;

always @ (posedge i_clock,posedge i_reset) begin
    data_ready_reg <= i_data_ready;
   
   if(i_rst)begin
        operando1_reg       <= 0;
        operando2_reg       <= 0;
        opcode_reg          <= 0;
        state               <= SAVE_OP_1;
        start_tx            <= 1'b0;
    end
   
   else if (i_data_ready)begin
        case(state)
            SAVE_OP_1:
            begin
                operando1_reg <= i_data;
                state <= SAVE_OP_2;
            end
            SAVE_OP_2:
            begin 
                operando2_reg <= i_data;
                state <= SAVE_OP_CODE;
            end
            SAVE_OP_CODE:
            begin
                opcode_reg <= i_data;
                state <= SIGNAL_READY;
            end
            SIGNAL_READY:
            begin
                state <= SAVE_OP_1;
                start_tx <=1;
            end

        endcase
    end
    else begin
        operando1_reg  <= operando1_reg;
        operando2_reg  <= operando2_reg;
        opcode_reg     <= opcode_reg;
        state          <= state;
        start_tx <= 1'b0;
    end
    

end


endmodule
