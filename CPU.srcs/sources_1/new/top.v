`timescale 1ns / 1ps
module top(
input clkin, input reset,input [2:0] SW,input button_,
//output ,
output [6:0] sm_duan,//����
output [3:0] sm_wei//�ĸ������
//output [31:0]aluRes,
//output [31:0]instruction,
//output [31:0] memreaddata
);
// �������ź���
//wire[31:0] expand2, mux4, mux5, address, jmpaddr;
//���ݴ洢��
wire [31:0]PC, aluRes, instruction, memreaddata;
wire button;
wire[31:0] add4;
// ָ��Ĵ���Addr 
//wire[31:0] instruction; 
//reg[6:0] Addr;
// CPU �����ź���
wire reg_dst, jmp,alusrc, branch, memread, memwrite, memtoreg,ExtOp, jr, lui, jal; 
wire [1:0] Asel;
//wire[3:0] aluop;
wire regWrite;
// ALU �����ź���
wire ZF,OF,CF,PF, SF;
wire [1:0]condition; //alu����Ϊ���־ alu������
// ALU�����ź���
wire[3:0] aluCtr;//����aluop��ָ���6λ ѡ��alu��������
//wire[31:0] aluRes; //alu������
wire[31:0] input2;
reg [15:0]data;
//wire [15:0] up;
//wire [15:0] low;
//assign data = switch ? up:low;

// �Ĵ����ź���
 wire[31:0] RsData, RtData;
 
   wire [4:0] regWriteAddr;
   wire [31:0] regWriteData; 
   assign regWriteAddr= jal ? 4'b1111 : reg_dst ? instruction[15:11] : instruction[20:16];
   assign regWriteData = jal ? add4: memtoreg ? memreaddata : aluRes; //д��Ĵ�������������ALU�����ݼĴ��� 
     
  // ALU�ź���
          wire[31:0] ALUSrcA, ALUSrcB;
         // wire ZF,CF,PF,OF,SF;
         // wire[31:0] aluRes; 
          // ALU�����ź���
        //  wire[3:0] aluCtr;
          wire[3:0] aluop; 
 
  wire[31:0] expand; wire[4:0] shamt;
  assign shamt=instruction[10:6];
  assign input2 = alusrc ? expand : RtData; //ALU�ĵڶ������������ԼĴ����������ָ���16λ�ķ�����չ
  assign ALUSrcA =(Asel==2'b00)?RsData: (Asel==2'b01)?shamt: (Asel==2'b10)?5'h10:RsData;


// ����ָ��洢��
Ins_Rom rom (
  .clka(clkin),    // input wire clka
  .ena(1'b1),
  .addra(PC[8:2]),  // input wire [6 : 0] addra
  .douta(instruction)  // output wire [31 : 0] douta
);

// ʵ����������ģ��
ctr mainctr(
.opCode(instruction[31:26]),
.regDst(reg_dst),
.aluSrc(alusrc),
.memToReg(memtoreg),
.regWrite(regWrite),
.memRead(memread),
.memWrite(memwrite),
.branch(branch),
.ExtOp(ExtOp),
.aluop(aluop),
.jmp(jmp),
.lui(lui),
.jal(jal)
);
//  ʵ���� ALU ����ģ��
aluctr aluctr1(
.ALUOp(aluop),
.funct(instruction[5:0]),
.ALUCtr(aluCtr),
.jr(jr),
.Asel(Asel),
.condition(condition)
);
eftBt bt(//��Ч�����ź�
.clk(clkin), .bt(!button_), .effectiveBt(button)
   );
//Debounce debounce(.clk(clkin), .button_(button_), .button(button));
// ��������������������������������������������������ʵ�����Ĵ���ģ��
RegFile regFile(
.Clk(button),.Clr(reset),.Write_Reg(regWrite),.R_Addr_A(instruction[25:21]),.R_Addr_B(instruction[20:16]),.W_Addr(regWriteAddr),.W_Data(regWriteData),.R_Data_A(RsData),.R_Data_B(RtData)
);

//ʵ����ALUģ��
ALU alu(.aluCtr(aluCtr),.A(ALUSrcA),.B(input2),.F(aluRes),.ZF(ZF),.CF(CF),.OF(OF),.SF(SF),.PF(PF)//, .HI(HI), .LO(LO)

    );
    
//mult Mult(.CLK(),.A(ALUSrcA), .B(input2), .P({HI, LO}));
//div Div(.aclk(clkin), .s_axis_divisor_tdata(input2), .s_axis_divisor_tvalid(1'b1), .s_axis_dividend_tdata(ALUSrcA), .s_axis_dividend_tvalid(1'b1), .m_axis_dout_tdata({HI, LO}));
//ʵ����������չģ��
signext signext(.inst(instruction[15:0]),.ExtOp(ExtOp), .data(expand));
//ʵ�������ݴ洢��
 DM_unit dm(.clk(button), .Wr(memwrite),
            .reset(reset),           
             .DMAdr(aluRes[15:0]), 
             .wd(RtData),
             .rd( memreaddata));
//...............................ʵ�����������ʾģ��
//display Smg(.clk(clkin),.sm_wei(sm_wei),.data(data),.sm_duan(sm_duan)); 
//�����������ʾ
   wire [31:0] display_content;
	wire [15:0] disp_num;
   //��ʾ����ѡ��	
	assign display_content = (SW[1:0] == 2'b00)? instruction:
	                    (SW[1:0] == 2'b01)? PC:
	                    (SW[1:0] == 2'b10)? aluRes: memreaddata;
	//�ߵ�16λѡ��					 
	assign disp_num = (SW[2] == 1)? display_content[31:16]:
display_content[15:0]; 
	//����������ʾ
display Smg(.clk(clkin),.sm_wei(sm_wei),.data(disp_num ),.sm_duan(sm_duan)); 

next_pc p(.reset(reset), .branch(branch), .zero(ZF),.sign(SF), .jmp(jmp), .jr(jr),.jal(jal), .condition(condition), .clkin(button), .expand(expand), .instruction(instruction),.RsData(RsData), .pc(PC),.add4(add4));
endmodule
