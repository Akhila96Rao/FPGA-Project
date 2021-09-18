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
reg miso;
reg [7:0]data_wr;

//Outputs
wire spi_clk;
wire cs;
wire mosi;
wire [3:0]state;

// Instantiate the Unit Under Test (UUT)
spi_master s1(
.clk(clk),
.spi_clk(spi_clk),
.reset(reset),
.cs(cs),
.miso(miso),
.mosi(mosi),
.data_wr(data_wr),
.state(state)
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
