`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:54:35 12/28/2021
// Design Name:   spi_master_slave
// Module Name:   F:/FPGA-2020/SPI/SPI_PROTOCOL_1/spi_master_slvae_tb.v
// Project Name:  SPI_PROTOCOL_1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi_master_slave
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module spi_master_slave_tb;

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
	spi_master_slave uut (
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
	//data_wr = 8'b10101011;
	//data_wr = 8'b10101111;
	data_wr = 8'b11001010;

	//Case - 1 : Polarity = 0, Phase = 0
	polarity = 0;
	phase = 0;
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

	// Case - 2 : Polarity = 0, Phase = 1
	reset = 1;
	polarity = 0;
	phase = 1;
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

	// Case - 3 : Polarity = 1, Phase = 0
	reset = 1;
	polarity = 1;
	phase = 0;
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

	// Case - 4 : Polarity = 1, Phase = 1
	reset = 1;
	polarity = 1;
	phase = 1;
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
	
	reset = 1;
	end

always begin
	clk = ~clk;
	#50;
	end

endmodule
