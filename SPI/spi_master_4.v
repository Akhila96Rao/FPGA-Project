`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:23:06 09/18/2021 
// Design Name: 
// Module Name:    spi_master_4 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spi_master_4(clk, spi_clk, reset, cs, miso, mosi, data_wr, state, count);
	input clk, reset;
	output reg spi_clk;
	output reg cs;
	output reg mosi;
	input miso;
	input [7:0]data_wr;
	output reg [3:0]state;

//when cs change from 1 to 0, indicates transmission to begin
//By default, miso and mosi are in High impedance state ==> Pull up
//spi_clk is derived from clk 
//spi_clk is slower than clk 
//transmission occur at the rate of spi_clk
//Here only MOSI is handled as master is outputting the data

/*
Polarity = 1, Phase = 0
Data is output on Rising edge of SPICLK
Input data is latched on Falling edge of SPICLK
*/

//Define intermediate signals
	localparam DIVIDE_BY = 4;
	reg counter2 = 0;
	output reg [3:0]count;
	
	localparam START = 0;
	localparam WRITE = 1;
	localparam WRITE_DATA = 2;
	localparam ACK = 3;

//SPI clk	
	initial spi_clk = 1; //SPI Clk Idle state

	always @(posedge clk) begin
		if (counter2 == (DIVIDE_BY/2) - 1) begin
			spi_clk <= ~spi_clk;
			counter2 <= 0;
		end
		else counter2 <= counter2 + 1;
	end 

//state machine

	always @ (negedge spi_clk)
	begin
	if (reset == 1)
	begin
		state <= START;
		cs <= 1;
		count <= 8;
		//miso <= 8'b11111111;
		mosi <= 1;
	end
	
	else
	case(state)
	START:begin
			cs <=0 ; //Can start
			count <= 8;
			state <= WRITE;
	end
	WRITE:begin				
			if (count>0) //>=0 will cause Count to reset to 7		
			begin		
				if (count == 4'd1)
				begin
				cs <= 1;
				end
				mosi <= data_wr[count-1];
				count <= count - 1;
			end

			else
			begin
			state <= ACK;	
//			cs <= 1;
			end
			end
//	WRITE_DATA: begin		//This extra state will cause for extra clock cycle consumption		
//				mosi <= data_wr[count-1];
//				count <= count - 1;
//				state <= WRITE;					
//				end
	ACK:begin				
			cs <= 1;//Transaction Completed		
		 end
	default:begin
			cs <= 1; //Default Value
			end
	endcase
	end
	
endmodule
