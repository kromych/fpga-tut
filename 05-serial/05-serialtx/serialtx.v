`default_nettype none

module serialtx(i_clk, o_uart_tx);

    input       i_clk;
    output      o_uart_tx;

    reg [7:0]   data;
    reg         data_get_next;
    reg         uart_busy;

    wire        transmit;

    assign      transmit = 1'b1;

    input_data  data_source(
                            .i_clk(i_clk),
                            .i_get_next(data_get_next),
                            .o_data(data));

    txuart      #(.CLOCK_FREQUENCY(16_000_000), 
                  .BAUD_RATE(115_200)) 
                uart(
                    .i_clk(i_clk),
                    .i_enable(transmit),
                    .i_data(data),
                    .o_busy(uart_busy),
                    .o_uart_tx(o_uart_tx));

    always @(posedge i_clk)
    begin
        data_get_next = ~uart_busy;
    end

endmodule
