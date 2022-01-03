module eftBt(//��Ч�����ź�
clk, bt, effectiveBt
    );
    input clk, bt;
    output reg effectiveBt;
    reg [31:0] btCount;
    
        //��������
    always@(posedge clk)begin
        if(bt) btCount= btCount+1;
        else
            btCount= 32'b0;
    end
    
    always@(btCount) begin
        if(btCount== 32'd10_000_000) effectiveBt= 'b0;//ע�⣬�����ɵ���ֻ������ᷢ��һ������
        else effectiveBt= 'b1;
    end
endmodule