`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:46:10 09/18/2021
// Design Name:   spi_master_2
// Module Name:   F:/FPGA-2020/SPI/SPI_PROTOCOL_1/spi_master_2_tb.v
// Project Name:  SPI_PROTOCOL_1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi_master_2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module spi_master_2_tb;

	// Inputs
	reg clk;
	reg reset;
	reg miso;
	reg [7:0] data_wr;

	// Outputs
	wire spi_clk;
	wire cs;
	wire mosi;
	wire [3:0] state;
	wire [3:0] count;

	// Instantiate the Unit Under Test (UUT)
	spi_master_2 uut (
		.clk(clk), 
		.spi_clk(spi_clk), 
		.reset(reset), 
		.cs(cs), 
		.miso(miso), 
		.mosi(mosi), 
		.data_wr(data_wr), 
		.state(state), 
		.count(count)
	);

initial begin
	//Initialise inputs
	clk = 0;
	reset = 1;
	data_wr = 0;
	#100; //Wait for 100ns for global reset to finish
	end

always begin
	clk = ~clk;
	#50;
	end

initial begin
	reset = 1;
	data_wr = 8'b10101011;
	#400; //Need to give atleast 1clock pulse time as the state gets assigned for posedge of spi_clk and not actual clock
	
	reset = 0;	
	end
      
endmodule

