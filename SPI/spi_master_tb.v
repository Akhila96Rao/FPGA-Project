//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FPGA PROJECT
// Engineer: AKHILA K
// 
// Create Date:		07/19/2021 
// Design Name: 	SPI Master
// Module Name:		spi-master-tb 
// Project Name: 	SPI protocol
// Target Devices: Spartan 6 Evaluation Board
// Major Revision
// User		Date			Description
// Akhila	7/19/21		Initial Code
//////////////////////////////////////////////////////////////////////////////////
module spi_master_tb;

//Inputs
reg clk;
reg reset;
reg polarity;
reg phase;
reg miso;
reg [7:0]data_wr;

//Outputs
wire spi_clk;
wire cs;
wire mosi;
wire [3:0]state;
wire [3:0]count;


// Instantiate the Unit Under Test (UUT)
spi_master s1(
.clk(clk),
.spi_clk(spi_clk),
.reset(reset),
.cs(cs),
.miso(miso),
.mosi(mosi),
.data_wr(data_wr),
.state(state),
.count(count),
.polarity(polarity),
.phase(phase)
);

initial begin
	clk = 0;
	reset = 1;
	data_wr = 8'b10101011;
	polarity = 0;
	phase = 0;
	#400;
	reset = 0;
	#5400;
	reset = 1;
	polarity = 0;
	phase = 1;
	#5800;
	reset=0;

	end

always begin
	clk = ~clk;
	#50;
	end



endmodule
