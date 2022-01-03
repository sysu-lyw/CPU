`timescale 1ns / 1ps
module DM_unit(input clk, Wr,
             input reset,
            input [15:0] DMAdr, 
		     input [31:0] wd,
			 output [31:0] rd);
			reg [31:0] RAM[15:0]; 
//read
assign rd=RAM[DMAdr];
//write
integer i;
always @ (posedge clk,posedge reset)
begin
    if(reset)begin
        for(i = 0; i < 256; i = i + 1) 
            RAM[i]=0;       
    end	
    else if (Wr) begin
      RAM[DMAdr] =wd;
        end           
    end  
 endmodule