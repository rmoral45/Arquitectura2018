`timescale 1ns/1ps


module tb_tx_uart();

reg clock;
reg reset;
reg [31:0] clock_counter;
reg rx;
wire tx;
wire tick;
reg tick_reg;

initial begin
clock = 1'b0;
reset = 1'b0;
clock_counter = 0;
rx = 1;
#4 reset = 1'b1;
#2  reset = 1'b0;
#100000000 $finish;
end

always @ (posedge clock)begin
tick_reg <=tick;
    if(tick_reg == 0 && tick == 1)
        clock_counter <= clock_counter + 1;
    else
        clock_counter <= clock_counter;
    case(clock_counter)
        
        32'd32:begin
            rx <= 0;
        end
        32'd48:begin
            rx <= 1;//bit 0 ope1
        end
        32'd64:begin
            rx <= 1;
        end
        32'd80:begin
            rx <= 0;
        end
        32'd96:begin
            rx <= 0;
        end
        32'd112:begin
            rx <= 0;
        end
        32'd128:begin
            rx <= 0;
        end
        32'd144:begin
            rx <= 0;
        end
        32'd160:begin
            rx <= 0;
        end
        32'd176:begin
            rx <= 1;//stop bits
        end

        32'd192:begin
            rx <= 0;//start bit
        end
        32'd208:begin
            rx <= 1; //bit 0 ope2
        end
        32'd224:begin
            rx <= 1;
        end
        32'd240:begin
            rx <= 0;
        end
        32'd256:begin
            rx <= 0;
        end
        32'd272:begin
            rx <= 0;
        end
        32'd288:begin
            rx <= 0;
        end
        32'd304:begin
            rx <= 0;
        end
        32'd320:begin
            rx <= 0;
        end
        32'd336:begin
            rx <= 1;//stop bit
        end
        32'd352:begin
            rx <= 0;//start bit
        end
        32'd368:begin
            rx <= 0; //bit 0 opcode
        end
        32'd384:begin
            rx <= 0;
        end
        32'd400:begin
            rx <= 0;
        end
        32'd416:begin
            rx <= 0;
        end
        32'd432:begin
            rx <= 0;
        end
        32'd448:begin
            rx <= 1;
        end
        32'd464:begin
            rx <= 0;
        end
        32'd480:begin
            rx <= 0;
        end
        32'd496:begin
            rx <= 1;//stop
        end
        32'd512:begin
            rx <= 1;//idle
        end
        32'd528:begin
            rx<= 1 ;//idle
        end
    endcase
end

always #1 clock = ~clock;

top_level_uart#()
              uart (
                .clock(clock),
                .reset(reset),
                .i_rx(rx),
                .o_tx(tx),
                //.o_pin_tx(tx),
                .o_tick(tick)
            );


endmodule
