`default_nettype none `timescale 1ns / 1ps
//`include "tt_um_delta_sigma.v"
/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();
   parameter BW = 16;
  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Replace tt_um_example with your module name:
  wire [15:0] ui16_in;
  wire uo1_out;
  wire rst_in;
  assign rst_in = ~rst_n;
  assign ui16_in = {uio_in, ui_in};
  assign uo1_out = uo_out[0];
  
  tt_um_delta_sigma 
  #( BW )
  dut(

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif

      //.ui_in  (ui_in),    // Dedicated inputs
      //.uo_out (uo_out),   // Dedicated outputs
      //.uio_in (uio_in),   // IOs: Input path
      .dac_i(ui16_in),
      .dac_o(uo1_out),  // IOs: Output path
      //.uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      //.ena    (ena),      // enable - goes high when design is selected
      .clk_i  (clk),      // clock
      .rst_i  (rst_in)    // not reset
  );

 //input clk_i , // clock
 //input rst_i , // reset
 //input signed [BW-1:0] dac_i, //input
 //output wire dac_o
 
endmodule
