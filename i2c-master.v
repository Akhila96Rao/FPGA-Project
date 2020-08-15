`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FPGA PROJECT
// Engineer: AKHILA K
// 
// Create Date:    15:36:04 08/15/2020 
// Design Name: 	I2C Master
// Module Name:   i2c-master 
// Project Name: 	I2C protocol
// Target Devices: Spartan 6 Evaluation Board
// Major Revision
// User		Date			Description
//	Akhila	15/8/20		Initial Code
// Akhila	15/8/20		Correction for SDA
//////////////////////////////////////////////////////////////////////////////////
module i2c_master(clk, reset, addr, data_wr, data_rd, rw,scl,sda,busy,state,count);
	 						
	input clk, reset,rw;					
	input [2:0]addr;					
	input [7:0]data_wr, data_rd;	
	output reg busy;					
	output reg scl, sda;					
	output reg [3:0]count;					
						
	output reg [5:0]state;					
	localparam START = 0;					
	localparam WRITE = 1;					
	localparam WRITE_DATA = 2;					
	localparam ACK = 3;					
	//localparam START = 0;					
						
	/*					
	reg [20:0]div_reg;					
	wire nclk;					
	always@(posedge clk)					
	div_reg=div_reg+1;					
	assign nclk=div_reg[5];					
	*/					
						
	always @ (posedge clk)					
	begin					
		if (reset == 1)				
		begin				
		scl <= 1;				
		sda <= 1;				
		busy <= 0;				
		count <= 8;				
		state <= START;				
		end				
		else				
		case (state)				
		START:begin				
				busy = 1;		
				sda <= 0;		
				count <= 8;		
				state = WRITE;		
				end		
		WRITE:begin				
				if (count>0) //>=0 will cause Count to reset to 7		
				begin		
				scl<=0;		
				state <= WRITE_DATA;		
				end		
				else		
				state <= ACK;		
				end		
		WRITE_DATA: begin				
						sda <= data_wr[count-1];
						scl<=1;
						count <= count - 1;
						state <= WRITE;
						end
		ACK:begin				
			 scl <= 1;			
			 sda <= 1;			
			 busy <= 0;			
			 state <= START;			
			 end			
		endcase				
	end //end of always					
						
						
	endmodule