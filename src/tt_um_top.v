`timescale 1 ns / 1 ns
 
 //`include "filter_FIR.v"

 module tt_um_top
  #(
 parameter BW = 16 // optional parameter
 ) (
 // define I /O ’ s of the module
 input clk, // clock
 input rst_n, // reset
 input ena,
 input [7:0] ui_in,
 input [7:0] uio_in,
 output [7:0] uo_out,
 output [7:0] uio_oe,
 output [7:0] uio_out
 //input signed [BW-1:0] dac_i, //input
 //output wire dac_o
 );

 //wire rst_i;
 //wire clk_i;
 //wire signed [BW-1:0] filter_s;
 wire signed[BW-1:0] filter_to_dac_s;
 wire signed [BW-1:0] dac_i;
 wire rst_i;
 wire dac_o;
 
 assign rst_i = ~rst_n;
 assign uo_out[0] = dac_o;
 assign dac_i = {uio_in, ui_in};

 filter_FIR
 #(BW)
 filter_dut (
 .clk_i (clk),
 .rst_i (rst_i),
 .filter_i (dac_i),
 .filter_o (filter_to_dac_s)
 );
 
 dac_sigma_delta
 #( BW )
 sigma_delta_dut (
 .clk_i ( clk ),
 .rst_i ( rst_i ),
 .dac_i (filter_to_dac_s),
 .dac_o (dac_o)
 );

 endmodule // top
 