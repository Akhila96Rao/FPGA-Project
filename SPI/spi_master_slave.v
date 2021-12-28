`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FPGA Project
// Engineer: AKHILA K 
// 
// Create Date:    13:33:26 12/28/2021 
// Design Name: 	 SPI Master and Slave - Combined
// Module Name:    spi_master_slave 
// Project Name: 	 SPI Protocol
// Target Devices: 	Spartan 6 Evaluation board
// Tool versions: 
// Description: 
// Polarity		Phase		SPICLK_IDLE_state		MOSI(Data Output)		MISO(Input Data)
// 0				0			0							Rising					Falling
// 0				1			0							Falling					Rising
// 1				0			1							Rising					Falling
// 1				1			1							Falling					Rising
//
// Dependencies: 
//
// Major Revision
// User		Date			Description
// Akhila	12/28/21		Initial Code
//
//////////////////////////////////////////////////////////////////////////////////
module spi_master_slave(clk, spi_clk, reset, cs, miso, mosi, data_wr, data_rd, state, count, polarity, phase);
	input clk, reset, polarity, phase;
	output reg spi_clk;
	output reg cs;
	output reg mosi;
	input miso;
	input [7:0]data_wr;
	output reg [7:0]data_rd;
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

//Inital value for CS and MOSI
initial begin
cs = 1;
mosi = 1;
spi_clk = 0;
state = 4'd0;
//miso = 0;
end

	always @(posedge reset, posedge clk) 
	begin
	if (reset == 1)
	begin
		case(spi_mode)
		2'b00: begin
				spi_clk <= 0;
				count <= 8;
				cs <= 1;
				data_rd <= 8'bxxxxxxxx;
				state <= START_A;
				end
		2'b01: begin
				spi_clk <= 0;
				count <= 8;
				cs <= 1;
				data_rd <= 8'bxxxxxxxx;
				state <= START_B;
				end
		2'b10: begin
				spi_clk <= 1;
				count <= 8;
				cs <= 1;
				data_rd <= 8'bxxxxxxxx;
				state <= START_A;
				end
		2'b11: begin
				spi_clk <= 1;
				count <= 8;
				cs <= 1;
				data_rd <= 8'bxxxxxxxx;
				state <= START_B;
				end
		endcase
	end
	else
	begin
		if (counter2 == (DIVIDE_BY/2) - 1) 
		begin
		spi_clk <= ~spi_clk;
		counter2 <= 0;
		end
		else 
		counter2 <= counter2 + 1;
	end
	end 

//Rising case : Polarity, Phase = 00,10
	always @ (posedge spi_clk)
	begin
	if (spi_mode == 2'b00 || spi_mode == 2'b10)
	begin
	case(state)
	START_A:begin
	if (reset == 0) begin
	cs <= 0 ;
	count <= 8;
	mosi <= data_wr[count-1];
	data_rd[count-1] <= miso;
	count <= count - 1;
	state <= WRITE_A;
	end
	end
	WRITE_A:begin	
	if (count > 0) begin	
	mosi <= data_wr[count-1];
	data_rd[count-1] <= miso;
	count <= count - 1;
	end		
	else begin
	cs <= 1;	
	end		
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
	case(state)
	START_B:begin
	if (reset == 0) begin
	cs <= 0;
	count <= 8;
	mosi <= data_wr[count-1];
	data_rd[count-1] <= miso;
	count <= count - 1;
	state <= WRITE_B;
	end
	end
	WRITE_B:begin	
	if (count > 0) begin		
	mosi <= data_wr[count-1];
	data_rd[count-1] <= miso;
	count <= count - 1;
	end		
	else begin
	cs <= 1;
	end		
	end
	default:begin
	cs <= 1;
	end
	endcase
	end
	end

endmodule
