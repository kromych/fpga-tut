`default_nettype none

module input_data(i_clk, i_get_next, o_data);

    input           i_clk;
    input           i_get_next;
    output [7:0]    o_data;

    // reg [4'hd*8:1] data = "Hello, world! ";

    wire [7:0]  data[0:4'hd];

    assign      data[4'h0] = "H";
    assign      data[4'h1] = "e";
    assign      data[4'h2] = "l";
    assign      data[4'h3] = "l";
    assign      data[4'h4] = "o";
    assign      data[4'h5] = ",";
    assign      data[4'h6] = " ";
    assign      data[4'h7] = "w";
    assign      data[4'h8] = "o";
    assign      data[4'h9] = "r";
    assign      data[4'ha] = "l";
    assign      data[4'hb] = "d";
    assign      data[4'hc] = "!";
    assign      data[4'hd] = " ";

    reg [3:0]   index   = 4'h0;
    assign      o_data  = data[index];

    always @(posedge i_clk)
    begin
        if (i_get_next)
        begin
            if (index == 4'hd)
            begin
                index <= '0;
            end
            else
            begin
                index <= index + 1'b1;
            end
        end
    end

endmodule
