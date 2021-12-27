`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:24:22 12/27/2021
// Design Name:   spi_slave
// Module Name:   F:/FPGA-2020/SPI/SPI_PROTOCOL_1/spi_slave_tb.v
// Project Name:  SPI_PROTOCOL_1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi_slave
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module spi_slave_tb;

	// Inputs
	reg clk;
	reg reset;
	reg miso;
	reg [7:0] data_wr;
	reg polarity;
	reg phase;

	// Outputs
	wire spi_clk;
	wire cs;
	wire mosi;
	wire [7:0] data_rd;
	wire [3:0] state;
	wire [3:0] count;
	
	localparam x = 8'b10101111;

	// Instantiate the Unit Under Test (UUT)
	spi_slave uut (
		.clk(clk), 
		.spi_clk(spi_clk), 
		.reset(reset), 
		.cs(cs), 
		.miso(miso), 
		.mosi(mosi), 
		.data_wr(data_wr), 
		.data_rd(data_rd), 
		.state(state), 
		.count(count), 
		.polarity(polarity), 
		.phase(phase)
	);

	initial begin
	clk = 0;
	reset = 1;
	polarity = 1;
	phase = 1;
	miso = 0;
	#400;
	reset = 0;
	miso = x[7];
	#400;
	miso = x[6];
	#400;
	miso = x[5];
	#400;
	miso = x[4];
	#400;
	miso = x[3];
	#400;
	miso = x[2];
	#400;
	miso = x[1];
	#400;
	miso = x[0];
	#400;
	
	end
	
   always begin
	clk = ~ clk;
	#50;
	end

endmodule

