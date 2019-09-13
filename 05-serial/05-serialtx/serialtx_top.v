`default_nettype none

module serialtx_top(i_clk, o_uart_tx);

    input       i_clk;
    output      o_uart_tx;

    wire [7:0]  data;
    wire        uart_busy;
    wire        transmit;

    input_data  data_source(
                            .i_clk(i_clk),
                            .i_get_next(transmit),
                            .o_data(data));

    uart_tx     uart(
                    .i_clk(i_clk),
                    .i_write(transmit),
                    .i_data(data),
                    .o_busy(uart_busy),
                    .o_uart_tx(o_uart_tx));

    assign transmit = !uart_busy;

endmodule
