`default_nettype none

module serialtx(i_clk, o_uart_tx, o_uart_clk);

    input       i_clk;
    output      o_uart_tx;
    output      o_uart_clk;

    reg [7:0]   data;
    wire        data_end;
    reg         data_get_next;
    reg         uart_busy;

    reg         transmit;

    input_data  data_source(
                            .i_clk(i_clk),
                            .i_get_next(data_get_next),
                            .o_data(data),
                            .o_data_end(data_end));

    txuart      uart(
                    .i_clk(i_clk),
                    .i_enable(transmit),
                    .i_data(data),
                    .o_busy(uart_busy),
                    .o_uart_tx(o_uart_tx),
                    .o_uart_clk(o_uart_clk));

    always @(posedge i_clk)
    begin
        data_get_next = ~uart_busy;
        transmit = ~data_end;
    end

endmodule
