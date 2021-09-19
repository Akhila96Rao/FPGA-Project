//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FPGA PROJECT
// Engineer: AKHILA K
// 
// Create Date:		06/30/2021 
// Design Name: 	SPI Master
// Module Name:		spi-master 
// Project Name: 	SPI protocol
// Target Devices: Spartan 6 Evaluation Board
// Description : 
// when cs change from 1 to 0, indicates transmission to begin
// By default, miso and mosi are in High impedance state ==> Pull up
// spi_clk is derived from clk 
// spi_clk is slower than clk 
// transmission occur at the rate of spi_clk
// Here only MOSI is handled as master is outputting the data
//
// Polarity		Phase		SPICLK_IDLE_state		MOSI(Data Output)		MISO(Input Data)
// 0				0			0							Rising					Falling
// 0				1			0							Falling					Rising
// 1				0			1							Rising					Falling
// 1				1			1							Falling					Rising
//
// Major Revision
// User		Date			Description
// Akhila	6/30/21		Initial Code
//////////////////////////////////////////////////////////////////////////////////
module spi_master(clk, spi_clk, reset, cs, miso, mosi, data_wr, state, count, polarity, phase);
	input clk, reset, polarity, phase;
	output reg spi_clk;
	output reg cs;
	output reg mosi;
	input miso;
	input [7:0]data_wr;
	output reg [3:0]state;
	output reg [3:0]count;
	
//Define intermediate signals
	localparam DIVIDE_BY = 4;
	reg counter2 = 0;
	
	localparam START_A = 0;
	localparam WRITE_A = 1;
	localparam WRITE_DATA_A = 2;
	localparam ACK_A = 3;
	localparam START_B = 4;
	localparam WRITE_B = 5;
	localparam WRITE_DATA_B = 6;
	localparam ACK_B = 7;
	
	reg [1:0]spi_mode;
	reg spi_clk_edge;
	

	always @(polarity,phase)
	begin
	spi_mode = {polarity,phase} ;
	end
	
//SPI clk	
	always@(spi_mode)
	begin
	case(spi_mode)
	2'b00: spi_clk = 0;
	2'b01: spi_clk = 0;
	2'b10: spi_clk = 1;
	2'b11: spi_clk = 1;
	endcase
	end

	always @(posedge clk) 
	begin
	if (counter2 == (DIVIDE_BY/2) - 1) 
	begin
	spi_clk <= ~spi_clk;
	counter2 <= 0;
	end
	else 
	counter2 <= counter2 + 1;
	end 

/*
//Rising case : Polarity, Phase = 00,10
	always @ (posedge spi_clk, spi_mode == 2'b00, spi_mode == 2'b10)
	begin
	if (reset == 1)
	begin
	cs <= 1;
	count <= 8;
	mosi <= 1;
//	if (spi_mode == 2'b00 | spi_mode == 2'b10) begin
	state <= START_A;
//	end
	end
	
	else
	case(state)
	START_A:begin
			cs <=0 ; //Can start
			count <= 8;
			state <= WRITE_A;
			end
	WRITE_A:begin	
	
			if (count>0) begin		
			if (count == 4'd1)begin
			cs <= 1;
			end
			mosi <= data_wr[count-1];
			count <= count - 1;
			end
			
			else begin
			state <= ACK_A;	
			end
			
			end
	ACK_A:begin 
			cs <= 1;		
		 end
	default:begin
				cs <= 1;
			  end
	endcase
	end

//Falling case : Polarity, Phase = 01,11
	always @ (negedge spi_clk, spi_mode == 2'b01, spi_mode == 2'b11)
	begin
	if (reset == 1)
	begin
	cs <= 1;
	count <= 8;
	mosi <= 1;
//	if (spi_mode == 2'b01 | spi_mode == 2'b11) begin
	state <= START_B;
//	end
	end
	
	else
	case(state)
	START_B:begin
			cs <=0 ; //Can start
			count <= 8;
			state <= WRITE_B;
			end
	WRITE_B:begin	
			if (count>0) begin		
			if (count == 4'd1) begin
			cs <= 1;
			end
			mosi <= data_wr[count-1];
			count <= count - 1;
			end	
			else begin
			state <= ACK_B;	
			end
			
			end
	ACK_B:begin 
			cs <= 1;		
		 end
	default:begin
				cs <= 1;
			  end
	endcase
	end
*/

//Rising case : Polarity, Phase = 00,10, //Falling case : Polarity, Phase = 01,11
	always @ (posedge spi_clk)
	begin
	if (spi_mode == 2'b00 || spi_mode == 2'b10)
	begin
	if (reset == 1)
	begin
	cs <= 1;
	count <= 8;
	mosi <= 1;
	state <= START_A;
	end
	else
	case(state)
	START_A:begin
	cs <=0 ;
	count <= 8;
	state <= WRITE_A;
	end
	WRITE_A:begin	
	if (count>0) begin		
	if (count == 4'd1)begin
	cs <= 1;
	end
	mosi <= data_wr[count-1];
	count <= count - 1;
	end		
	else begin
	state <= ACK_A;	
	end		
	end
	ACK_A:begin 
	cs <= 1;		
	end
	default:begin
	cs <= 1;
	end
	endcase
	end
	end

//Falling case : Polarity, Phase = 01,11
	always @ (negedge spi_clk)
	begin
	if (spi_mode == 2'b01 || spi_mode == 2'b11)
	begin
	if (reset == 1)
	begin
	cs <= 1;
	count <= 8;
	mosi <= 1;
	state <= START_B;
	end
	else
	case(state)
	START_B:begin
	cs <=0 ;
	count <= 8;
	state <= WRITE_B;
	end
	WRITE_B:begin	
	if (count>0) begin		
	if (count == 4'd1)begin
	cs <= 1;
	end
	mosi <= data_wr[count-1];
	count <= count - 1;
	end		
	else begin
	state <= ACK_B;	
	end		
	end
	ACK_B:begin 
	cs <= 1;		
	end
	default:begin
	cs <= 1;
	end
	endcase
	end
	end

endmodule
