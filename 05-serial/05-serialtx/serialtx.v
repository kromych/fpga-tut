`default_nettype none

module serialtx(i_clk, o_uart_tx);

    input           i_clk;
    output          o_uart_tx;

    reg [7:0]       data;
    reg             data_enable;
    reg             uart_enable;
    wire            uart_busy;
    wire            rst;

    reset #(.RST_WIDTH(5)) reset(i_clk, rst);

    input_data i_data(
        .i_clk(i_clk),
        .i_rst(rst),
        .i_enable(data_enable),
        .o_data(data));

    txuart uart(
        .i_clk(i_clk),
        .i_rst(rst),
        .i_enable(uart_enable),
        .i_data(data),
        .o_busy(uart_busy),
        .o_uart_tx(o_uart_tx));

    always @(posedge i_clk)
    begin
        uart_enable  <= 1'b1;
        data_enable <= ~uart_busy;
    end

endmodule
