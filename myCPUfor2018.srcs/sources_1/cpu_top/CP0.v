`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/02 13:50:38
// Design Name: 
// Module Name: CP0
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CP0(
    input clk,
    input reset,
    input StallF,               //δʹ��
    input icache_ins_addr_ok_i, //δʹ��
    
    //Ӳ���ж��ź�
    input [5:0] hdint,
    
    //�쳣�ź�
    input ins_addr_exl_M,
    input [31:0] error_ins_addr_M,
    input ins_in_delay_M,   //ָ����ӳٲ���
    input overflow_M,
    input MemWrite_M,
    input data_addr_exl_M,
    input [31:0] error_data_addr_M,
    input syscall_exl_M,
    input break_exl_M,
    input reserved_ins_exl_M,
    input [31:0] pc_M,
    
    output reg [31:0] EPC,
    output Exl_set,
    
    //�쳣����������
    input eret_M,
    
    //mtc0
    input CP0_we_M_i,
    input [4:0] rd_addr_M_i,
    input [2:0] sel_M_i,
    input [31:0] rt_M_i,
    //mfc0
//    input [15:11] rd_addr_M_i,
//    input [2:0] sel_M_i,
    output [31:0] dout
    
    );
    
    wire local_Exl_set;
    //CP0�Ĵ���
    reg [31:0] BadVAddr;    //���8��ֻ������������һ�ε�ַ�쳣����ָ�����õ��Ĵ������ַ
    reg [31:0] Status;      //12���ɶ�д��
    // Status[15:8]:�����ж�����λ��1���ж����� 0���ж�����
    //Status[1]: 0: ��������  1����������    1��״̬�����������쳣���жϣ��쳣������򷵻�ʱ��0
    //Status[0] : ȫ���ж�ʹ�� 1�����������ж�  0�����������ж�
    reg [31:0] Cause;       //13, �жϵȴ���ʶ��  ֻ��дCause[9:8]         Cause[31]:��ʶ�������������ָ���Ƿ����ӳٲ���
    wire [31:0] local_EPC;
    
    wire [6:2] ExcCode;     //�������
    wire Int_set;    //�����жϣ�ͨ��Cause�Ĵ���IP�����еȴ��������жϺ�Status�е��ж�ʹ���ж��ж��Ƿ���
    wire Exc_set;   //��������
    
    reg mark;
    reg stall_mark;
    
    assign dout = (rd_addr_M_i == 5'b01000 && sel_M_i == 3'b000) ? BadVAddr :
                (rd_addr_M_i == 5'b01100 && sel_M_i == 3'b000 ) ? Status :
                (rd_addr_M_i == 5'b01101 && sel_M_i == 3'b000) ? Cause :
                (rd_addr_M_i == 5'b01110 && sel_M_i == 3'b000) ? EPC :
                32'h0000_0000;
    
    //ȫ���ж�ʹ��+û�������ڴ���
    assign Int_set = (Status[0] == 1'b1) && (Status[1] == 1'b0) && ((Status[15:8] & Cause[15:8]) != 8'b0000_0000) ;
    assign Exc_set = Int_set | ins_addr_exl_M | overflow_M | syscall_exl_M | break_exl_M | reserved_ins_exl_M | data_addr_exl_M;
    //�����������ȼ�����
    assign ExcCode = Int_set ? 5'h00 :
                   ins_addr_exl_M ? 5'h04 :
                   reserved_ins_exl_M ? 5'ha :
                   overflow_M ? 5'h0c :
                   break_exl_M ? 5'h09 :
                   syscall_exl_M ? 5'h08 :
                   (data_addr_exl_M & ~MemWrite_M) ? 5'h04 :
                   (data_addr_exl_M & MemWrite_M) ? 5'h05 :
                   5'h00;
    //���ⷢ��
    assign local_Exl_set = (Status[1] == 1'b0) && Exc_set;
    assign Exl_set = local_Exl_set || mark || stall_mark;
    assign local_EPC = ins_in_delay_M ? (pc_M - 32'd4) : pc_M;
    
    always@(posedge clk)
        begin
            if(reset)
                begin
                    BadVAddr <= 32'h0000_0000;
                    Status[31:23] <= 9'b000000000;
                    Status[22]<=1'b1;
                    Status[21:16]<=6'b000000;
                    Status[15:8] <= 8'b1111_1111;
                    Status[7:2] <= 6'b000000;
                    Status[1] <= 1'b0;
                    Status[0] <= 1'b1;
                    Cause <= 32'h0000_0000;
                    EPC <= 32'hbfc0_0000; 
                end
            else begin
                Cause[15:10]<=hdint;
                if(local_Exl_set)
                    begin
                    Status[1] <= 1;
                    Cause[6:2] <= ExcCode;
                    EPC <= local_EPC;
                    BadVAddr <= (ExcCode == 5'h04 && ins_addr_exl_M) ? error_ins_addr_M :
                                (ExcCode == 5'h04 && data_addr_exl_M) ? error_data_addr_M :
                                (ExcCode == 5'h05) ? error_data_addr_M :
                                BadVAddr;
                    Cause[31] <= ins_in_delay_M;
                    end
                else if(eret_M)
                    begin
                    Status[1] <= 0;
                    end
                else if(CP0_we_M_i && (rd_addr_M_i == 5'b01100)  && (sel_M_i == 3'b000))
                    begin
                    Status[15:8] <= rt_M_i[15:8];
                    Status[1:0] <= rt_M_i[1:0];
                    end
                else if(CP0_we_M_i && (rd_addr_M_i == 5'b01101) && (sel_M_i == 3'b000))
                    begin
                    Cause[9:8] <= rt_M_i[9:8];
                    end
                else if(CP0_we_M_i && (rd_addr_M_i == 5'b01110) && (sel_M_i == 3'b000))
                    begin
                    EPC <= rt_M_i;
                    end
            end
        end
    
    always@(posedge clk)
        begin
            if(reset)
                begin
                    mark <= 0;
                    stall_mark <= 0;
                end
            else if(local_Exl_set & ~icache_ins_addr_ok_i)
                begin
                    mark <= 1;
                end
            else if(mark && icache_ins_addr_ok_i)
                begin
                    mark <= 0;
                end
            else if(local_Exl_set & StallF)
                begin
                    stall_mark <= 1;
                end
            else if(stall_mark && ~StallF)
                begin
                    stall_mark <= 0;
                end
                
        end
   
    
endmodule
