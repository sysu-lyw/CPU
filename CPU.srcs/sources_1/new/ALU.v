`timescale 1ns / 1ps

module ALU(aluCtr,A,B,F,ZF,CF,OF,SF,PF
    );
    parameter SIZE = 32;//运算位数
      //  input clkin;
      //  integer clk_cnt = 0;
     //     reg clk = 0; 
       //   always @(posedge clkin)
        //  if(clk_cnt== 100000)
         //    begin clk_cnt <= 1'b0; clk <= ~clk; end 
         // else clk_cnt <= clk_cnt + 1'b1;
          
          
        input [3:0] aluCtr;//运算操作
        input [SIZE-1:0] A;//左运算数
        input [SIZE-1:0] B;//右运算数
        output  [SIZE-1:0] F;
        //output [SIZE-1:0] HI, LO;//运算结果
        output       ZF, //0标志位, 运算结果为0(全零)则置1, 否则置0
                     CF, //进借位标志位, 取最高位进位C,加法时C=1则CF=1表示有进位,减法时C=0则CF=1表示有借位
                       OF, //溢出标志位，对有符号数运算有意义，溢出则OF=1，否则为0                     
                       SF, //符号标志位，与F的最高位相同
                     PF; //奇偶标志位，F有奇数个1，则PF=1，否则为0    
       reg [SIZE-1:0] F;
        reg C,ZF,CF,OF,SF,PF;//C为最高位进位
        //reg clken;
       // mult Mult(.CE(1'b1),.CLK(clk),.A(A), .B(B), .P({HI, LO}));
        
        always@(*)
        begin
            C=0;
            case(aluCtr)
                4'b0000: begin F=A&B; end    //按位与
                4'b0001: begin F=A|B; end    //按位或 
                4'b0010: begin {C,F}=A+B; end //加法
                4'b0011: begin F=(B<<A); end   //将B左移A位
                4'b0100: begin F = $signed(($signed(B)) >>> A); end // 算术右移
                4'b0101: begin F= (B>>A); end //将B右移A位
                4'b0110: begin {C,F}=A-B; end //减法
                4'b0111: begin F=(A<B); end//A<B则F=1，否则F=0 slt  
                4'b1000: begin  F= A*B;end
                4'b1100: begin F=(A^B); end    //按位异或   
                4'b1101: begin F = ~(A|B); end // 按位或非  
            endcase
            ZF = (F == 0);//F全为0，则ZF=1
            CF = C; //进位借位标志
            OF = A[SIZE-1]^B[SIZE-1]^F[SIZE-1]^C;//溢出标志公式
            SF = F[SIZE-1];//符号标志,取F的最高位
            PF = ~^F;//奇偶标志，F有奇数个1，则F=1；偶数个1，则F=0
        end
    
endmodule
