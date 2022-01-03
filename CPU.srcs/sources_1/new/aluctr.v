`timescale 1ns / 1ps
module aluctr(
input [3:0] ALUOp, input [5:0] funct, output reg [3:0]  ALUCtr, output reg [1:0] Asel, output reg jr, output reg [1:0] condition
);

always @(ALUOp or funct) begin //  如果操作码或者功能码变化执行操作
casex({ALUOp, funct}) // 拼接操作码和功能码便于下一步的判断
// R型指令
10'b1111000010: begin ALUCtr = 4'b1000;  Asel =  2'b00; jr = 0; end // mul
10'b1111100000: begin ALUCtr = 4'b0010;  Asel =  2'b00; jr = 0; end// add 
10'b1111100001: begin ALUCtr = 4'b0010;  Asel =  2'b00; jr = 0; end// addu
10'b1111100010: begin ALUCtr = 4'b0110;  Asel =  2'b00; jr = 0; end// sub
10'b1111100011: begin ALUCtr = 4'b0110;  Asel =  2'b00; jr = 0; end// subu
//10'b1111011010: begin ALUCtr = 4'b0000;  Asel =  2'b00; jr = 0; div_ = 1; end // div
10'b1111100100: begin ALUCtr = 4'b0000;  Asel =  2'b00; jr = 0; end// and 
10'b1111100101: begin ALUCtr = 4'b0001;  Asel =  2'b00; jr = 0; end// or 
10'b1111100110: begin ALUCtr = 4'b1100;  Asel =  2'b00; jr = 0; end // xor
10'b1111100111: begin ALUCtr = 4'b1101;  Asel =  2'b00; jr = 0; end // nor
10'b1111101010: begin ALUCtr = 4'b0111;  Asel =  2'b00; jr = 0; end// slt
10'b1111101011: begin ALUCtr = 4'b0111;  Asel =  2'b00; jr = 0; end// sltu

10'b1111000000: begin ALUCtr = 4'b0011;  Asel =  2'b01; jr = 0; end// sll
10'b1111000010: begin ALUCtr = 4'b0101;  Asel =  2'b01; jr = 0; end // srl
10'b1111000011: begin ALUCtr = 4'b0100;  Asel =  2'b01; jr = 0; end // sra
10'b1111000100: begin ALUCtr = 4'b0011;  Asel =  2'b00; jr = 0; end // sllv
10'b1111000110: begin ALUCtr = 4'b0101;  Asel =  2'b00; jr = 0; end // srlv
10'b1111000111: begin ALUCtr = 4'b0100;  Asel =  2'b00; jr = 0; end // srav
10'b1111001000: begin ALUCtr = 4'b0000;  Asel =  2'b00; jr = 1; end // jr

// I型指令
10'b0000xxxxxx: begin ALUCtr = 4'b0010;  Asel =  2'b00; jr = 0; end // lw，sw，addi 
10'b0001xxxxxx: begin ALUCtr = 4'b0110;  Asel =  2'b00; jr = 0; condition = 2'b00; end // beq
10'b0010xxxxxx: begin ALUCtr = 4'b0001;  Asel =  2'b00; jr = 0; end// ori
10'b0011xxxxxx: begin ALUCtr = 4'b0111;  Asel =  2'b00; jr = 0; end// slti
10'b0100xxxxxx: begin ALUCtr = 4'b0000; Asel = 2'b00; jr = 0; end // andi
10'b0101xxxxxx: begin ALUCtr = 4'b0110; Asel = 2'b00; jr = 0; condition = 2'b10; end // bltz
10'b0110xxxxxx: begin ALUCtr = 4'b0110;  Asel =  2'b00; jr = 0; condition = 2'b01; end// bne
10'b1000xxxxxx: begin ALUCtr = 4'b0010; Asel = 2'b00; jr = 0; end // addiu
10'b1011xxxxxx: begin ALUCtr = 4'b0011;  Asel =  2'b10; jr = 0; end // lui 
default:begin ALUCtr = 4'b0010;  Asel =  2'b00; jr = 0; end
endcase 
end
endmodule
