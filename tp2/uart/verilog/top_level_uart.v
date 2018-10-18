module top_level_uart#(
                        parameter DATA_BITS = 8
                       ) 
                       (
                        input  clock,
                        input  reset,
                        input  i_rx,
                        output o_tx,
                        output [10:0] led
                    
                       );


// wire's para conectar modulos
wire transmitted_data;
wire rx_data_ready;
wire [DATA_BITS-1 : 0] recived_data;
wire [DATA_BITS-1 : 0] operando1;
wire [DATA_BITS-1 : 0] operando2;
wire [5 : 0] opcode;
wire tick;
wire tx_data_ready;
wire [DATA_BITS-1 : 0] alu_out;//esto lo conecto a la salida de la alu
wire available_tx;
wire [DATA_BITS-1 : 0] resultado;
wire [2:0] intf_state;

//registros para sincronizar envio
reg operation_ready_reg;
reg enable_tx;
reg [7:0] led_reg;

assign led[7:0] = led_reg;
assign led [10:8] = intf_state;

assign o_tx = transmitted_data;
//assign o_pin_tx = transmitted_data;
assign tx_data_ready = enable_tx;
assign alu_out = operando1 & operando2;//lo pongo asi para probar


always @ (posedge clock)begin
    operation_ready_reg <= operation_ready;
    led_reg <= operando2;
    if(reset)begin
        
        enable_tx <= 0;
    end
    else if(operation_ready_reg == 0 && operation_ready == 1 && available_tx)begin
        enable_tx <= 1;
        
        end
    else begin
        enable_tx <= 0;
        end
end








tx_uart#()
        tx(
            .i_clock(clock),
            .i_reset(reset),
            .i_tick(tick),
            .i_data(resultado),
            .i_data_ready(tx_data_ready),
            .o_data(transmitted_data), //asigno  puerto de salida
            .o_available_tx(available_tx)
          );

rx_uart#()
        rx(
            .i_clock(clock),
            .i_reset(reset),
            .i_tick(tick),
            .i_rx(i_rx), //asigno puerto de entrada
            .o_data(recived_data),
            .o_data_ready(rx_data_ready)
          );

rx_interface#() // agregar una salida que se ponga en 1 cuando esten los 3 operandos
    interface(
                .i_clk(clock),
                .i_rst(reset),
                .i_data_ready(rx_data_ready),
                .i_data(recived_data),
                .o_operando1(operando1),
                .o_operando2(operando2),
                .o_opcode(opcode),
                .o_operation_ready(operation_ready),
                .o_state(intf_state)
             );

tick_gen#()
    tick_generator(
                    .i_clock(clock),
                    .i_reset(reset),
                    .o_tick(tick)
                  );
alu_mod#()
    alu(
        .i_ope1(operando1),
        .i_ope2(operando2),
        .i_opcode(opcode),
        .o_result(resultado)
       );

endmodule
