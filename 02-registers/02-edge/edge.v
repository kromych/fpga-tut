`default_nettype none

module edge_detector(i_clk, in, o_rising_edge, o_falling_edge);

    input i_clk;
    input in;
    output o_rising_edge;
    output o_falling_edge;

    reg in_q;

    always @(posedge i_clk) 
    begin
        in_q <= in;
    end

    always @(posedge i_clk) 
    begin
        o_rising_edge <= !in_q && in;
        o_falling_edge <= in_q && !in;
    end
endmodule
