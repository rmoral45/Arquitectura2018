
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
                        output [DATA_BITS-1 : 0] o_data,
                        output  reg [11:0] o_led
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
wire [DATA_BITS-1 : 0]result;

assign o_operando1 = operando1_reg;
assign o_operando2 = operando2_reg;
assign o_opcode = opcode_reg;
assign o_start_tx = start_tx;
assign result = i_alu_result;
assign o_data = result;

always @ (posedge i_clock,posedge i_reset) begin
   
   if(i_reset)begin
        operando1_reg       <= 0;
        operando2_reg       <= 0;
        opcode_reg          <= 0;
        state               <= SAVE_OP_1;
        start_tx            <= 1'b0;
    end
   
   else if (i_data_ready)
   begin
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
        endcase
    end
    else if (state == SIGNAL_READY)
    begin
    	state <= SAVE_OP_1;
                start_tx <=1;
    end

    else begin
        operando1_reg  <= operando1_reg;
        operando2_reg  <= operando2_reg;
        opcode_reg     <= opcode_reg;
        state          <= state;
        start_tx <= 1'b0;
    end
    

end
always @ *
begin
	o_led = {12{1'b0}};
	case (state)
		SAVE_OP_1: o_led={state,opcode_reg};
		SAVE_OP_2: o_led={state,operando1_reg};
		SAVE_OP_CODE: o_led={state,operando2_reg};

	endcase
end

endmodule
