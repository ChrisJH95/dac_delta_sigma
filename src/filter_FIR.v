`timescale 1 ns / 1 ns
 
 
  module filter_FIR
 #(
 parameter BW = 16// optional parameter
 ) (
 // define I /O ’ s of the module
 input clk_i , // clock
 input rst_i , // reset
 input signed [BW-1:0] filter_i, //input
 output wire signed [ BW-1:0] filter_o
 );

 // start the module implementation
 //the module can be set to implement a moving average or a more general FIR filter
 reg signed [BW-1:0] d0, d1, d2, d3, d4, d5, d6, d7, d8;   //shift register
 //reg signed [2*BW-1:0] mul0, mul1, mul2, mul3, mul4, mul5, mul6, mul7, mul8;   
 //wire signed [BW-1:0] b0, b1, b2, b3, b4, b5, b6, b7, b8;
 reg signed [2*BW-1:0] sum;
 wire signed [2*BW-1:0] sum_shift;

 // assign values to the filter constants
 //assign b0 = $signed(8'b00000001);
 //assign b1 = $signed(8'b00000001);
 //assign b2 = $signed(8'b00000001);
 //assign b3 = $signed(8'b00000001);
 //assign b4 = $signed(8'b00000001);
 //assign b5 = $signed(8'b00000001);
 //assign b6 = $signed(8'b00000001);
 //assign b7 = $signed(8'b00000001);

 
 always @ ( posedge clk_i ) begin
 // gets active always when a positive edge of the clock signal occours
 if ( rst_i == 1'b1 ) begin // if reset is enabled
  //set all registers to 0 when reset is enabled
  d0 <= { BW {1'b0 }};
  d1 <= { BW {1'b0 }};
  d2 <= { BW {1'b0 }};
  d3 <= { BW {1'b0 }};
  d4 <= { BW {1'b0 }};
  d5 <= { BW {1'b0 }};
  d6 <= { BW {1'b0 }};
  d7 <= { BW {1'b0 }};
  d8 <= { BW {1'b0 }};
  end else begin
  //shifting the values from one register to the next, forming a shift register 
  d0 <= filter_i; //the input value is assigned to the first register, every clock cycle
  d1 <= d0;
  d2 <= d1;
  d3 <= d2;
  d4 <= d3;
  d5 <= d4;
  d6 <= d5;
  d7 <= d6;
  d8 <= d7;
  end
 end
 
 //optional section to turn the moving average filter into a more general FIR filter
 // always @ ( posedge clk_i ) begin
 // gets active always when a positive edge of the clock signal occours
 //if ( rst_i == 1'b1 ) begin
 // if reset is enabled
 // mul0 <= {2*BW {1'b0}};
 // mul1 <= {2*BW {1'b0}};
 // mul2 <= {2*BW {1'b0}};
 // mul3 <= {2*BW {1'b0}};
 // mul4 <= {2*BW {1'b0}};
 // mul5 <= {2*BW {1'b0}};
 // mul6 <= {2*BW {1'b0}};
 // mul7 <= {2*BW {1'b0}};

 // end else begin
  //multiply the register values with the filter constants
 // mul0 <= d0*b0;
 // mul1 <= d1*b1;
 // mul2 <= d2*b2;
 // mul3 <= d3*b3;
 // mul4 <= d4*b4;
 // mul5 <= d5*b5;
 // mul6 <= d6*b6;
 // mul7 <= d7*b7;

  //end
 //end

  always @ ( posedge clk_i ) begin
  // gets active always when a positive edge of the clock signal occours
  if (rst_i == 1'b1) begin
   sum <= {2*BW {1'b0}};
   end else begin
   //sum <= mul0 + mul1 + mul2 + mul3 + mul4 + mul5 + mul6 + mul7;
   //since all the samples saved in the registered are equally weighted, the summing up of samples can be optimized to:
   sum <= sum + {{BW{d0[BW-1]}}, d0} - {{BW{d8[BW-1]}}, d8}; //the input sample is added to the sum while the last sample in the shift register is subtracted. The register values are padded for the correct bit width.
   end
  end
  
 assign sum_shift = sum >>> (3); //shifting the sum of the sample values by 3, which equals a division by 8
 assign filter_o = sum_shift[BW-1:0]; //truncating the sum vector to bit width BW and assigning the shifted sum to the filter output
  
 endmodule //filter
 
 
