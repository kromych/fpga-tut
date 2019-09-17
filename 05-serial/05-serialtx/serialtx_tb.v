`default_nettype none

// Timescale/precision

`timescale 1ns/10ps

`define TESTING

`include "uart_clock.v"
`include "uart_tx.v"
`include "input_data.v"

module serialtx_tb();

    reg         clk;

    wire        write;
    wire [7:0]  data;
    wire        busy;
    wire        uart_tx;

    // Device Under Test

    uart_tx     _dut(
        .i_uart_clk(clk),
        .i_write(write),
        .i_data(data),
        .o_busy(busy),
        .o_uart_tx(uart_tx));

    input_data  _dut_input(
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
        $display("\t\ttime,\trealtime,\tclk,\tbusy,\ttx");
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
