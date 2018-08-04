`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/14 11:26:38
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] data1,
    input [31:0] data2,
    input [3:0] aluop,
    output [31:0] result,
    output overflow
    );
    wire [32:0] tmp;
    assign tmp = aluop==0? {data1[31],data1}+{data2[31],data2}:
                 aluop==1? {data1[31],data1}-{data2[31],data2}:
                 0;
    assign result = aluop==0? tmp[31:0]:  //��������ļӷ�
                    aluop==1? tmp[31:0]:  //��������ļ���
                    aluop==2? data1&data2:
                    aluop==3? data1|data2:
                    aluop==4? data1^data2:
                    aluop==5? ($signed(data1)<$signed(data2)?1:0):
                    aluop==6? data2 << data1[4:0]:
                    aluop==7? data2 >> data1[4:0]:
                    aluop==8? $signed($signed(data2)>>>data1[4:0]):
                    aluop==9? data1+data2:  //����������ļӷ�
                    aluop==10? data1-data2: //����������ļ���
                    aluop==11? (data1<data2?1:0):
                    aluop==12? ~(data1|data2):
                    aluop==13? data2:
                    0;
     assign overflow = (aluop==1 | aluop==0) & (tmp[32]!=tmp[31]);
                    
endmodule
