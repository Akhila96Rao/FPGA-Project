`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:57:34 08/23/2020 
// Design Name: 
// Module Name:    i2c_slave_1 
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
module i2c_slave_1(clk, reset, addr, data_wr, data_rd, rw,scl,sda,busy,state,count,i2c_clk);
	 						
	input clk, reset,rw;					
	input [2:0]addr;					
	input [7:0]data_wr;
	input scl, sda;
	output reg [7:0]data_rd;	
	output reg busy;										
	output reg [3:0]count;									
	output reg [6:0]state;	
	output reg i2c_clk;	
	
	localparam START = 0;					
	localparam READ = 1;					
	localparam READ_DATA = 2;			
	localparam ACK = 3;					
	localparam DIVIDE_BY = 4;

	reg counter2 = 0;
	reg data_rd_temp[7:0];
	initial i2c_clk = 1;

	always @(posedge clk) begin
		if (counter2 == (DIVIDE_BY/2) - 1) begin
			i2c_clk <= ~i2c_clk;
			counter2 <= 0;
		end
		else counter2 <= counter2 + 1;
	end 

//As I2C slave controller, based on scl and sda need to take the data on data_rd	
//	always @ (negedge i2c_clk, posedge reset)//wiht i2c_clk the data sampling is not proper, going with scl
//	always @ (negedge scl, posedge reset) 
	always @ (posedge i2c_clk, posedge reset) //going with scl does not make the change as scl is changed in this block
//	always @ (posedge reset) //it seems to be slower with clock try without <-- This method does not work
	
	begin					
		if (reset == 1)				
		begin							
		count <= 8;	//To delay by 1 clock changing from 8 to 9
		data_rd <= 0;	
		busy <= 0;
		state <= START;				
		end				
		else if (rw == 1) //rw = 1 --> Read			
		case (state)				
		START:begin		
				busy <= 1;		
				if (sda == 1 && scl ==1 && count == 0)
				begin
				count <= 0;
				state <= START;
				end
				if (count == 8)
				begin
				if (sda == 0 && scl == 1) //sda transition from 1 to 0 and scl = 1
				begin
//				count <= 8; //No need to set it here
				state <= READ;		 
				end
				end
				end		
		READ:begin				
				if (count>0) //>=0 will cause Count to reset to 7 //count>0 is sampling stop bit also	
				begin				
				state <= READ_DATA;		
				end		
//				else if (count == 0)	//to reset to initial state	
//				state <= ACK;		
				end		
		READ_DATA:begin				
					data_rd[count-1] <= sda;
					count <= count - 1;
					if (scl == 0) //Need to read new data when scl=0
					state <= READ;
					else if (count == 0)	//to reset to initial state	
					state <= ACK;		
					end		
		ACK:begin	 
			 busy <= 0;
			 //state <= START; //No need to go back to start			
			 end
		default:begin
				busy <= 0;
				end
				
		endcase				
	end //end of always		
endmodule
