`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:38:44 08/15/2020
// Design Name:   i2c_master
// Module Name:   F:/FPGA-2020/I2C Bus/I2C FPGA Project/i2c-master/i2c_master_tb.v
// Project Name:  i2c-master
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: i2c_master
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module i2c_master_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [2:0] addr;
	reg [7:0] data_wr;
	reg [7:0] data_rd;
	reg rw;

	// Outputs
	wire scl;
	wire sda;
	wire busy;
	wire [5:0] state;
	wire [3:0] count;
	wire i2c_clk;

	// Instantiate the Unit Under Test (UUT)
	i2c_master uut (
		.clk(clk), 
		.reset(reset), 
		.addr(addr),  
		.data_wr(data_wr), 
		.data_rd(data_rd), 
		.rw(rw), 
		.scl(scl), 
		.sda(sda), 
		.busy(busy), 
		.state(state), 
		.count(count),
		.i2c_clk(i2c_clk)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		addr = 0;
		data_wr = 0;
		data_rd = 0;
		rw = 0;
		// Wait 100 ns for global reset to finish
		#100;
	end
	
	always
	begin
	clk = ~ clk;
	#50;
	end
	
	initial begin
	//Value set 0-100ns
	reset = 1;
	//data_wr = 8'b10101010;
	data_wr = 8'b10101011;
	rw = 0;
	#100; 
	
	reset = 0;
	rw=1;
	
	//#7200; //Actual = current + Previous
	//data_wr = 8'b11001100; 
	
	//#7600;
	//data_wr = 8'b11110000;
		
	end
	     
endmodule
