module top_level_uart#(
                        parameter DATA_BITS = 8
                       ) 
                       (
                        input  clock,
                        input  reset,
                        input  i_rx,
                        output o_tx,
                        output [11:0] led
                       );


// wire's para conectar modulos
wire transmitted_data;
wire rx_data_ready;
wire [DATA_BITS-1 : 0] recived_data;
wire [DATA_BITS-1 : 0] operando1;
wire [DATA_BITS-1 : 0] operando2;
wire [DATA_BITS-1 : 0] data_to_send;
wire [5 : 0] opcode;
wire tick;
wire tx_data_ready;
wire [DATA_BITS-1 : 0] alu_out;//esto lo conecto a la salida de la alu
wire available_tx;
wire [DATA_BITS-1 : 0] resultado;
wire start_tx;
wire  [11:0]led_wire;
wire in_rx;
assign in_rx = i_rx;
assign o_tx = transmitted_data;

assign led = led_wire;



tx_uart#()
        tx(
            .i_clock(clock),
            .i_reset(reset),
            .i_tick(tick),
            .i_data(data_to_send),
            .i_start(start_tx),
            .o_data(transmitted_data), //asigno  puerto de salida
            .o_available_tx(available_tx)
          );

rx_uart#()
        rx(
            .i_clock(clock),
            .i_reset(reset),
            .i_tick(tick),
            .i_rx(in_rx), //asigno puerto de entrada
            .o_data(recived_data),
            .o_data_ready(rx_data_ready)
          );

rx_interface#() // agregar una salida que se ponga en 1 cuando esten los 3 operandos
    interface(
                .i_clock(clock),
                .i_reset(reset),
                .i_data_ready(rx_data_ready),
                .i_data(recived_data),
                .i_alu_result(resultado),
                
                .o_operando1(operando1),
                .o_operando2(operando2),
                .o_opcode(opcode),
                .o_start_tx(start_tx),
                .o_data(data_to_send),
                .o_led(led_wire)
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
