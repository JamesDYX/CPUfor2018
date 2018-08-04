`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/07 15:25:59
// Design Name: 
// Module Name: div_model
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

module div_model(
    input clk,
    input reset,
    input start,    //��ʼ����
    input div_op,   //0: �޷���  1���з���
    input [31:0] divisor,
    input [31:0] dividend,
    output reg result_ok,
    output reg [31:0] remainder,   //����
    output reg [31:0] quotient    //��
    );
    
    reg [63:0] local_divisor;
    reg [63:0] local_remainder;
    reg [31:0] local_quotient;
    reg local_start;
    reg finish;
    reg [31:0] i;
    
    //
    reg divisor_symbol;     //0:��  1����
    reg dividend_symbol;
    
    
    always@(posedge clk)
        begin
          if(reset)
            begin
                remainder <= 0;
                quotient <= 0;
                local_divisor <= 0;
                local_remainder <= 0;
                local_quotient <= 0;
                i <= 0;
                finish <= 0;
                result_ok <= 0;
                divisor_symbol <= 0;
                dividend_symbol <= 0;
            end  
          else if(start)
            begin
                i <= 0;
                local_quotient <= 0;
                local_start <= start;
                result_ok <= 0;
                if(div_op)
                    begin
                        divisor_symbol <= divisor[31];
                        dividend_symbol <= dividend[31];
                        local_divisor <= ~divisor[31] ? {divisor,32'd0} : {(~divisor + 32'd1),32'd0};
                        local_remainder <= ~dividend[31] ? {32'd0,dividend} : {32'd0,(~dividend + 32'd1)};
                    end
                else
                    begin
                        local_divisor <= {divisor,32'd0};
                        local_remainder <= {32'd0,dividend};
                    end
            end
          else if(local_start)
            begin
                if(local_remainder >= local_divisor)
                    begin
                        local_remainder <= local_remainder - local_divisor;
                        local_quotient <= {local_quotient[30:0],1'b1};
                    end
                else
                    begin
                        local_quotient <= {local_quotient[30:0],1'b0};
                    end
                    
                local_divisor <= {1'b0,local_divisor[63:1]};
                i <= i + 1;
                if(i == 32'd32)
                    begin
                        local_start <= 0;
                        finish <= 1;
                    end
            end
          else if(finish)
            begin
                remainder <= ~div_op ? local_remainder[31:0] :      //�޷���
                            ~dividend_symbol ? local_remainder[31:0] :  //�з��ţ�������Ϊ��
                            (local_remainder[31:0] == 32'd0) ? local_remainder[31:0] :     //�з��ţ�������Ϊ��������Ϊ0
                            ~(local_remainder[31:0] - 32'd1);                      //�з��ţ�������Ϊ����������Ϊ0            
                quotient <= ~div_op ? local_quotient :      //�޷���
                            (divisor_symbol == dividend_symbol) ? local_quotient :  //�з��ţ������뱻����������ͬ
                            (local_quotient == 32'd0) ? local_quotient :        //�з��ţ������뱻�������Ų�ͬ����Ϊ0
                            ~(local_quotient - 32'd1);                          //�з��ţ������뱻�������Ų�ͬ���̲�Ϊ0
                finish <= 0;
                result_ok <= 1;
                divisor_symbol <= 0;
                dividend_symbol <= 0;
            end
          else
            begin
                result_ok <= 0;
            end
        end
    
endmodule
