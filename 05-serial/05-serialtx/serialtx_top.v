`default_nettype none

module serialtx_top(i_clk, o_uart_tx);

    input       i_clk;
    output      o_uart_tx;

    wire [7:0]  data;
    wire        uart_busy;
    wire        uart_clk;
    wire        transmit;

    input_data  _data_source(
                    .i_get_next(transmit),
                    .o_data(data));

    uart_clock  #(.CLOCK_MHZ(16),.BAUD_RATE(115200)) _uart_clk(
                    i_clk, uart_clk);

    uart_tx     _uart(
                    .i_uart_clk(uart_clk),
                    .i_write(transmit),
                    .i_data(data),
                    .o_busy(uart_busy),
                    .o_uart_tx(o_uart_tx));

    assign transmit = !uart_busy;

endmodule
