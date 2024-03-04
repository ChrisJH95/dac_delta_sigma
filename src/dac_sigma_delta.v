`timescale 1 ns / 1 ns
 
 
  module dac_sigma_delta
 #(
 parameter BW = 16 // optional parameter
 ) (
 // define I /O ’ s of the module
 input clk_i , // clock
 input rst_i , // reset
 input signed [BW-1:0] dac_i, //input
 output wire dac_o
 ) ;

 // start the module implementation
 localparam BW_diff = 2;
 localparam BW_2 = BW + BW_diff;        //set the internally used bitwidth to BW + 2 to deal with overflow
 
 wire signed [BW_2-1:0] delta_in; //input into the delta
 wire signed [BW_2-1:0] delta_1;  //adder 1 output
 wire signed [BW_2-1:0] sigma_1;  //accumulator 1 output
 wire signed [BW_2-1:0] adc;      //ADC value to be subtracted from the input at the adder stage
 wire signed [BW_2-1:0] val_min;  //lowest number to be represented
 wire signed [BW_2-1:0] val_max;  //highest number to be represented

 reg signed [BW_2-1:0] int1_reg; //register for the integrator
 reg dac_reg; //output register for the DAC

 // assign the counter value to the output

 assign delta_in = {{2{dac_i[BW-1]}}, dac_i}; //padding the input to the internally used bit-width, while keeping the sign bits for s's complement
 assign dac_o = dac_reg;
 //assign val_max = $signed({{(BW_diff + 1){1'b0}},{(BW-1){1'b1}}});
 //assign val_min = $signed({{(BW_diff + 1){1'b1}},{(BW-1){1'b0}}});
 assign val_min = -(2**(BW-1)); //assigning the lowest value in 2's complement
 assign val_max = (2**(BW-1)-1);
 assign adc = (dac_o == 1'b0) ? val_max : val_min; //assign either the max or min value as ADC output 
 assign delta_1 = delta_in + $signed(adc);            //subracting the adc output from the input
 assign sigma_1 = int1_reg + delta_1;


 always @ ( posedge clk_i ) begin
 // gets active always when a positive edge of the clock signal occours
 
  if ( rst_i == 1'b1 ) begin
   // if reset is enabled, all registers are set to 0
   int1_reg <= {BW_2 {1'b0}};
   dac_reg <= 1'b0;
  end else begin
   int1_reg <= sigma_1;
   dac_reg <= sigma_1[BW_2-1]; //use the sign bit to set the dac output register to either 1 or 0
  end //if(rst_i == 1'b1 )
 end //always

 endmodule // delta_sigma_dac
 

 
 
