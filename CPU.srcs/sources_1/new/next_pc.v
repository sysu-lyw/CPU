`timescale 1ns / 1ps
module next_pc(
input reset,
input branch, 
input zero, 
input sign,
input jmp, 
input jr,
input jal,
input [1:0] condition,
input clkin,
input [31:0] expand,
input [31:0] instruction,
input [31:0] RsData,
output reg[31:0] pc,
output reg[31:0] add4
); 
    reg[31:0] next_pc;
    wire PCSrc1, PCSrc2;
    wire [31:0] J_Addr,branch_Addr;
    assign branch_Addr = add4 + (expand << 2);
    assign J_Addr =jr ? RsData:{add4[31:28], instruction[25:0], 2'b00}; 
    //PCµÄ¶àÑ¡Æ÷
        assign PCSrc1 = (condition == 2'b01 & branch & ~zero) || (condition == 2'b00 & branch & zero) || 
            (condition == 2'b10 && branch && sign == 1 )? 1'b1:1'b0;
    assign PCSrc2 = (jmp | jr | jal)? 1'b1:1'b0;
    always@(*)begin
        casex({PCSrc2, PCSrc1})
            2'b00:next_pc<=add4;
            2'b01:next_pc<=branch_Addr;
            2'b1x:next_pc<=J_Addr;
            default:next_pc<=add4;
        endcase
end

initial begin
    pc = 32'h0; add4 = 0;
    end
always@ (posedge clkin)
begin
if(reset) begin pc = 32'h0; add4 = 32'h0; end
else begin pc = next_pc;add4 = pc+4;  end
end

endmodule
