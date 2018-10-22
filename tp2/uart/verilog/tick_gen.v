

module tick_gen
#(
  parameter BAUD_RATE = 9600,
  parameter BOARD_CLK = 100000000,
  parameter TICK_RATE = BOARD_CLK/(BAUD_RATE*16),
  parameter CONT_NBITS = $clog2(TICK_RATE)
 )
 (
  input  i_clock,
  input  i_reset,
  output o_tick
 );



reg [CONT_NBITS-1 : 0] counter;


always @ (posedge i_clock) begin
    if (i_reset)
       counter <= 0;
    else if (counter == (TICK_RATE - 1))
    	counter <= 0;
    else
       counter <= counter + 1;
end

assign o_tick = ((counter == TICK_RATE-1)) ? 1'b1 : 1'b0;

endmodule
