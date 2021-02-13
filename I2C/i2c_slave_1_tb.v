`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:00:36 08/23/2020
// Design Name:   i2c_slave_1
// Module Name:   F:/FPGA-2020/I2C Bus/I2C FPGA Project/i2c-master/i2c_slave_1_tb.v
// Project Name:  i2c-master
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: i2c_slave_1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module i2c_slave_1_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [2:0] addr;
	reg [7:0] data_wr;
	reg rw;
	reg scl;
	reg sda;
	//reg busy;

	// Outputs
	wire [7:0] data_rd;
	wire [5:0] state;
	wire [3:0] count;
	wire i2c_clk;
	wire busy;
	
	localparam x = 8'b10101010;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	i2c_slave_1 uut (
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
		addr = 0;
		data_wr = 0;
		#100; // Wait 100 ns for global reset to finish
	end
	
	always
	begin
	clk=~clk;
	#50;
	end
	
	initial begin
	reset = 1;
	rw = 0;
	scl = 1;
	sda = 1;
	#100;
	
	reset = 0; //Enable Slave
	rw = 1; //Enable Read
	sda = 0; //sda 1 to 0 --> Start bit
	#400;
	
	
	scl = 0;
	#400; //Add another 100, 300ns also works
	sda = x[7];
	#200;
	scl = 1;
	#200;
	
	scl = 0;
	sda = x[6];
	#200;
	scl = 1;
	#200;

	scl = 0;
	sda = x[5];
	#200;
	scl = 1;
	#200;

	scl = 0;
	sda = x[4];
	#200;
	scl = 1;
	#200;

	scl = 0;
	sda = x[3];
	#200;
	scl = 1;
	#200;

	scl = 0;
	sda = x[2];
	#200;
	scl = 1;
	#200;
	
	scl = 0;
	sda = x[1];
	#200;
	scl = 1;
	#200;
	
	scl = 0;
	sda = x[0];
	#200;
	scl = 1;
	#200; 
	
	//scl = 0; //No need to bring down the SCL to 0 again
	sda = 1; // Stop Bit
	#200;
	//scl = 1;
	//#200;
	
	end
	
endmodule
 
