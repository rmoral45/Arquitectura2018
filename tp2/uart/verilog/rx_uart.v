
module rx_uart
#(
  parameter DATA_BITS = 8,
  parameter STOP_BITS = 1,
  parameter LEN_TICK_COUNTER =$clog2(16),
  parameter LEN_DATA_COUNTER = $clog2(DATA_BITS)
 )
 (
  input  i_clock,
  input  i_reset,
  input  i_tick,
  input  i_rx,
  output reg o_data_ready,
  output [DATA_BITS-1 : 0] o_data
 );
localparam NSTATE = 4;
localparam NTICK = 16;
/////////  estados //////////

localparam [3:0] IDLE  = 4'b0001;
localparam [3:0] START = 4'b0010;
localparam [3:0] DATA  = 4'b0100;
localparam [3:0] STOP  = 4'b1000;



 
localparam STOP_TICKS = STOP_BITS * 16;

reg [NSTATE-1 : 0] state;
reg [NSTATE-1 : 0] state_next;
reg [LEN_TICK_COUNTER-1 : 0] tick_reg;
reg [LEN_TICK_COUNTER-1 : 0] tick_next;
reg [DATA_BITS-1 : 0] data_reg;
reg [DATA_BITS-1 : 0] data;
reg [LEN_DATA_COUNTER-1 : 0] data_counter;
reg [LEN_DATA_COUNTER-1 : 0] data_counter_next;


assign o_data = data_reg;

always @ (posedge i_clock or posedge i_reset) begin
    if(i_reset)begin
        state <= IDLE;
        data_reg <= 0;
        data_counter <= 0;
        tick_reg <= 0;
    end
    else begin
        state <= state_next;
        tick_reg <= tick_next;
        data_counter <= data_counter_next;
        data_reg <= data;
    end
end



always @ * begin
    
    tick_next  = tick_reg;
    state_next = state;
    data_counter_next = data_counter;
    data = data_reg;
    o_data_ready = 1'b0;
    case(state)
        
        IDLE:begin
            if(~i_rx )begin
                state_next = START;
                tick_next = 0;
            end
        end    
        START: begin
            if(i_tick)begin
            
                if(tick_reg == 7)begin
                    state_next = DATA;
                    tick_next = 0;
                    data_counter_next = 0;
                end
                else
                    tick_next = tick_reg + 1;

            end
       end     
       DATA:
       begin
           if(i_tick)
           begin
               if(tick_reg == 15)
               begin
                  //saco el bit
                   data ={i_rx,data[DATA_BITS-1:1]};
                   tick_next = 0;

                   if(data_counter == (DATA_BITS - 1))
                       state_next = STOP;
                   else 
                       data_counter_next = data_counter + 1;
               end

               else 
                   tick_next = tick_reg + 1;
           end
       end    
       STOP : 
       begin
           if(i_tick)
           begin
               if(tick_reg == STOP_TICKS - 1)
               begin
                   o_data_ready = 1'b1;
                   state_next = IDLE;
               end
               else 
                  tick_next = tick_reg + 1;
           end
       end
       default:
       begin
            state_next = IDLE;
            data_counter_next = 0;
            tick_next = 0;
            data = 0;
       end
        
    endcase

end

endmodule
