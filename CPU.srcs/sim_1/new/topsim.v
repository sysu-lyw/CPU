`timescale 1ns / 1ps
module topsim; 
// Inputs 
reg clkin; 
reg reset; 
wire [31:0]PC;
wire [6:0] sm_duan;//¶ÎÂë
wire [3:0] sm_wei;//ÄÄ¸öÊıÂë¹Ü
wire [31:0]aluRes;
wire [31:0]instruction;
wire [31:0]DMdata;
// Instantiate the Unit Under Test (UUT) 
top uut ( 
.clkin(clkin), 
.reset(reset) ,
.PC(PC),
.aluRes(aluRes),
.instruction(instruction),
.sm_duan(sm_duan),
.sm_wei(sm_wei),
.memreaddata(DMdata)
); 
//wire reg_dst,jmp,branch, memread, memwrite, memtoreg,alu_src; 
//ire[1:0] aluop;

initial begin 
// Initialize Inputs 
clkin = 0; 
reset = 1; 
//PC=0;
// Wait 100 ns for global reset to finish 
#10; 
reset = 0; 
end 
parameter PERIOD = 20; 
always begin 
clkin = 1'b1; 
#(PERIOD / 2) clkin = 1'b0; 
#(PERIOD / 2) ; 
//PC=PC+1;
end 
endmodule 
