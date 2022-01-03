module eftBt(//有效按键信号
clk, bt, effectiveBt
    );
    input clk, bt;
    output reg effectiveBt;
    reg [31:0] btCount;
    
        //按键处理
    always@(posedge clk)begin
        if(bt) btCount= btCount+1;
        else
            btCount= 32'b0;
    end
    
    always@(btCount) begin
        if(btCount== 32'd10_000_000) effectiveBt= 'b0;//注意，参数可调，只有这里会发出一次脉冲
        else effectiveBt= 'b1;
    end
endmodule