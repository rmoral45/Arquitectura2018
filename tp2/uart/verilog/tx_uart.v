
module tx_uart #(
                parameter DATA_BITS = 8,
                parameter STOP_BITS = 1,
                parameter N_TICK = 16,
                parameter LEN_TICK_COUNTER = $clog2(N_TICK),
                parameter LEN_DATA_COUNTER = $clog2(DATA_BITS)
                )

                (
                input i_clock,
                input i_reset,
                input i_tick,
                input [DATA_BITS-1 : 0] i_data,
                input i_start,
                output o_data,
                output reg o_available_tx
                );

localparam [3:0] IDLE = 4'b0001;
localparam [3:0] START = 4'b0010;
localparam [3:0] SEND_DATA = 4'b0100;
localparam [3:0] STOP = 4'b1000;


reg [DATA_BITS-1 : 0] data_reg;
reg [DATA_BITS-1 : 0] data_reg_next;
reg [LEN_TICK_COUNTER-1 : 0] tick_reg;
reg [LEN_TICK_COUNTER-1 : 0] tick_next;
reg [LEN_DATA_COUNTER-1 : 0] data_counter;
reg [LEN_DATA_COUNTER-1 : 0] data_counter_next;
reg [3 : 0] state_reg;
reg [3 : 0] state_next;
reg tx_reg,tx_next,

assign o_data = tx_reg;


always @(posedge i_clock or posedge i_reset)begin

    if(i_reset)
    begin
        tick_reg <= 0;
        send_ctr <= 0;
        state_reg <= IDLE;
        data_reg <= 0;
        
    end
    else
    begin
        tick_reg <= tick_next;
        data_counter <= data_counter_next;
        state_reg <= state_next;
        data_reg <= data_reg_next;
        tx_reg <= tx_next;
    end

end

always @ * begin


   state_next = state_reg;
   tick_next = tick_reg;
   data_reg_next = data_reg;
   data_counter_next = data_counter;
   o_available_tx = 0;
   tx_next = tx_reg;

   case (state_reg)

        IDLE:
        begin
        tx_next = 1'b1;
            if(i_start)
            begin
                state_next = START;
                tick_next = 0;
                data_reg_next = i_data;
            end
        end
        
        START:
        begin
            tx_next = 1'b0;
            if(i_tick)
            begin
                
                if(tick_reg == (N_TICK-1))
                begin
                    data_counter_next = 0;
                    state_next = SEND_DATA;
                    tick_next = 0;
                end
                else
                begin    
                    tick_next = tick_reg + 1;
                end


            end
        end
        SEND_DATA:
        begin
           tx_next = data_reg[0];
            if(i_tick) 
            begin

                if(tick_reg == (N_TICK - 1))
                begin
                    
                    data_reg_next = data >> 1;
                    tick_next = 0;

                    if(data_counter == (DATA_BITS - 1)) 
                    begin
                        state_next = STOP;
                    end
                    else
                    begin
                        data_counter_next = data_counter + 1;
                    end
                end
                else
                begin    
                    tick_next = tick_reg + 1; 
                end
            
            end
        end
        STOP:
        begin
            tx_next = 1'b1;
            if(i_tick) 
            begin   
                 if(tick_reg == STOP_TICKS - 1) 
                 begin
                   state_next = IDLE;
                   o_tx_available = 1'b1;
                 end
                 else
                 begin   
                    tick_next = tick_reg + 1;      
                 end
            
            end  
         end
        default:
        begin
            state_next = IDLE;
            tick_next = 0;
            data_counter_next = 0;
            data_reg_next = 0;
            tx_next = 1'b1;
        end

   endcase

end

endmodule

