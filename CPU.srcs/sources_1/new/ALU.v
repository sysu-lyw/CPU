`timescale 1ns / 1ps

module ALU(aluCtr,A,B,F,ZF,CF,OF,SF,PF
    );
    parameter SIZE = 32;//����λ��
      //  input clkin;
      //  integer clk_cnt = 0;
     //     reg clk = 0; 
       //   always @(posedge clkin)
        //  if(clk_cnt== 100000)
         //    begin clk_cnt <= 1'b0; clk <= ~clk; end 
         // else clk_cnt <= clk_cnt + 1'b1;
          
          
        input [3:0] aluCtr;//�������
        input [SIZE-1:0] A;//��������
        input [SIZE-1:0] B;//��������
        output  [SIZE-1:0] F;
        //output [SIZE-1:0] HI, LO;//������
        output       ZF, //0��־λ, ������Ϊ0(ȫ��)����1, ������0
                     CF, //����λ��־λ, ȡ���λ��λC,�ӷ�ʱC=1��CF=1��ʾ�н�λ,����ʱC=0��CF=1��ʾ�н�λ
                       OF, //�����־λ�����з��������������壬�����OF=1������Ϊ0                     
                       SF, //���ű�־λ����F�����λ��ͬ
                     PF; //��ż��־λ��F��������1����PF=1������Ϊ0    
       reg [SIZE-1:0] F;
        reg C,ZF,CF,OF,SF,PF;//CΪ���λ��λ
        //reg clken;
       // mult Mult(.CE(1'b1),.CLK(clk),.A(A), .B(B), .P({HI, LO}));
        
        always@(*)
        begin
            C=0;
            case(aluCtr)
                4'b0000: begin F=A&B; end    //��λ��
                4'b0001: begin F=A|B; end    //��λ�� 
                4'b0010: begin {C,F}=A+B; end //�ӷ�
                4'b0011: begin F=(B<<A); end   //��B����Aλ
                4'b0100: begin F = $signed(($signed(B)) >>> A); end // ��������
                4'b0101: begin F= (B>>A); end //��B����Aλ
                4'b0110: begin {C,F}=A-B; end //����
                4'b0111: begin F=(A<B); end//A<B��F=1������F=0 slt  
                4'b1000: begin  F= A*B;end
                4'b1100: begin F=(A^B); end    //��λ���   
                4'b1101: begin F = ~(A|B); end // ��λ���  
            endcase
            ZF = (F == 0);//FȫΪ0����ZF=1
            CF = C; //��λ��λ��־
            OF = A[SIZE-1]^B[SIZE-1]^F[SIZE-1]^C;//�����־��ʽ
            SF = F[SIZE-1];//���ű�־,ȡF�����λ
            PF = ~^F;//��ż��־��F��������1����F=1��ż����1����F=0
        end
    
endmodule
