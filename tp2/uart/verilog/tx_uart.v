
module tx_uart #(
                parameter DATA_BITS = 8,
                parameter STOP_BITS = 1
                )

                (
                input i_clock,
                input i_reset,
                input i_tick,
                input [DATA_BITS-1 : 0] i_data,
                input i_data_ready,
                output o_data,
                output o_available_tx
                );

localparam IDLE = 4'b0001;
localparam START = 4'b0010;
localparam SEND_DATA = 4'b0100;
localparam STOP = 4'b1000;
localparam STOP_TICKS = 16*STOP_BITS;
localparam NTICK = 16;
localparam NSTATES = 4;

reg [DATA_BITS : 0] data_reg;
reg [DATA_BITS : 0] data_reg_next;
reg [$clog2(NTICK) : 0] tick_reg;
reg [$clog2(NTICK) : 0] tick_next;
reg [$clog2(DATA_BITS) : 0] send_ctr;
reg [$clog2(DATA_BITS) : 0] send_next;
reg [NSTATES - 1 : 0] state_reg;
reg [NSTATES - 1 : 0] state_next;

assign o_data = (state_reg == IDLE) ? 1'b1 : data_reg[0];
assign o_available_tx = (state_reg == IDLE ) ? 1'b1 : 1'b0;


always @(posedge i_clock or posedge i_reset)begin

    if(i_reset)begin
        tick_reg <= 0;
        send_ctr <= 0;
        state_reg <= IDLE;
        data_reg <= 0;
        
    end
    else if(i_data_ready)begin
        
        data_reg <= {i_data[DATA_BITS-1 : 0],1'b0};
        tick_reg <= 0;
        state_reg <= state_next;
        send_ctr <= 0;

    end
    else begin
        tick_reg <= tick_next;
        send_ctr <= send_next;
        state_reg <= state_next;
        data_reg <= data_reg_next;
    end

end

always @ * begin


   state_next = state_reg;
   tick_next = tick_reg;
   data_reg_next = data_reg;
   send_next = send_ctr;

   case (state_reg)

        IDLE:
            if(i_data_ready)begin
                state_next = START;
            end
        
        START:begin
            if(i_tick) begin
                
                if(tick_reg == 15) begin
                   
                    data_reg_next = {1'b0,data_reg[DATA_BITS:1]};
                    state_next = SEND_DATA;
                    tick_next = 0;
                end
                else begin
                    
                    tick_next = tick_reg + 1;

                end


            end
        end
        SEND_DATA:begin
           
            if(i_tick) begin

                if(tick_reg == 15) begin
                    
                    data_reg_next = {1'b0,data_reg[DATA_BITS:1]};
                    tick_next = 0;

                    if(send_ctr == 7) begin
                        
                        state_next = STOP;
                        
                        data_reg_next = 1;
                        
                    end
                    else 
                        
                        send_next = send_ctr + 1;

                end

                else begin
                    
                    tick_next = tick_reg + 1; 

                end
            
            end
        end
        STOP:begin
            
            if(i_tick) begin
               
                 if(tick_reg == STOP_TICKS - 1) begin
                
                   state_next = IDLE;
                   tick_next = 0;
                   

                 end
                 else begin
                    
                    tick_next = tick_reg + 1;     
                    
                 end
            
            end  
         end             

   endcase

end

endmodule

