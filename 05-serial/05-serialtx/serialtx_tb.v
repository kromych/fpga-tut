`default_nettype none

// Timescale/precision

`timescale 1ns/10ps

`define TESTING

`include "uart_tx.v"
`include "input_data.v"

module serialtx_tb();

    reg         clk;
    wire        write;
    reg [7:0]   data;
    reg         busy;
    reg         uart_tx;

    // Device Under Test

    uart_tx     dut(
        .i_clk(clk),
        .i_write(write),
        .i_data(data),
        .o_busy(busy),
        .o_uart_tx(uart_tx));

    input_data  dut_input(
        .i_clk(clk),
        .i_get_next(write),
        .o_data(data));

    // Initialization tasks

    initial
    begin
        clk = 1'b0;
    end

    initial
    begin
        $dumpfile ("serial.vcd");
        $dumpvars;
    end

    initial
    begin
        $display("\t\ttime,\trealtime,\tclk,\tbusy,\tuart_tx");
        $monitor("%d,\t%d,\t\t%b,\t%b,\t%b,",$time, $realtime, clk, busy, uart_tx);
    end

    initial
    begin
        #400 $finish;
    end

    // Tasks to always run

    always
    begin
        #5 clk <= ~clk;
    end

    assign write = !busy;

endmodule
