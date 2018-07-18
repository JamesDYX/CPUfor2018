`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/01 11:31:39
// Design Name: 
// Module Name: MULT_DIV
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


module MULT_DIV(
    input clk,
    input reset,
    
    input [31:0] rs_E_i,
    input [31:0] rt_E_i,
//    input [31:0] ALUResult_ED_i,
//    input [31:0] ALUResult_M_i,
//    input [31:0] DataToReg_W_i,
//    input [1:0] Forward_rs_E_i,     //00:rs_E 01:ALUResult_ED_i  11:ALUResult_m_i   10:DataToReg_W_i
//    input [1:0] Forward_rt_E_i,
    input [3:0] mult_div_op_E_i,      //0000:非乘除相关指令 0001:mult 0010:multu  0011:div  0100:divu  0101:mfhi  0110:mflo  0111:mthi  1000:mtlo
    output reg [31:0] hi_o,
    output reg [31:0] lo_o,
    output busy_o
    );
    reg local_busy;
    wire div_en;
    wire mult_en;
    
    assign mult_en = (mult_div_op_E_i  == 4'b0001 || mult_div_op_E_i  == 4'b0010);
    assign div_en = (mult_div_op_E_i  == 4'b0011 || mult_div_op_E_i  == 4'b0100);
    
    assign busy_o = (mult_en | div_en) ? 1'b1 : local_busy;
    
    
    reg [31:0] rs;
    reg [31:0] rt;
   
    reg mult_start;
    reg mult_op;
    wire mult_result_ok;
    wire [31:0] mult_hi;
    wire [31:0] mult_lo;
   
   
    reg div_start;
    reg div_op;
    wire div_result_ok;
    wire [31:0] div_hi;
    wire [31:0] div_lo;
     
//    wire [31:0] temp_rs;
//    wire [31:0] temp_rt;
//    wire rt_e_zero;     //rt为0信号
//    assign temp_rs = (Forward_rs_E_i == 2'b00) ? rs_E_i :
//                       (Forward_rs_E_i == 2'b01) ? ALUResult_ED_i :
//                       (Forward_rs_E_i == 2'b11) ? ALUResult_M_i :
//                       (Forward_rs_E_i == 2'b10) ? DataToReg_W_i :
//                        32'd0;
//    assign temp_rt = (Forward_rt_E_i == 2'b00) ? rt_E_i :
//                       (Forward_rt_E_i == 2'b01) ? ALUResult_ED_i :
//                       (Forward_rt_E_i == 2'b11) ? ALUResult_M_i :
//                       (Forward_rt_E_i == 2'b10) ? DataToReg_W_i :
//                        32'd1;
    
    div_model div(
        .clk(clk),
        .reset(reset),
        .start(div_start),    //开始计算
        .div_op(div_op),   //0: 无符号  1：有符号
        .divisor(rt),
        .dividend(rs),
        .result_ok(div_result_ok),
        .remainder(div_hi),   //余数
        .quotient(div_lo)    //商
        );
       
    mult_model mul(
            .clk(clk),
            .reset(reset),
            .start(mult_start),
            .mult_op(mult_op),   //0: 无符号  1：有符号
            .rs(rs),
            .rt(rt),
            .result_ok(mult_result_ok),
            .hi(mult_hi),   
            .lo(mult_lo) 
            );
    
    always@(posedge clk)
        begin
            if(reset)
                begin
                    rs <= 0;
                    rt <= 1;
                    hi_o <= 0;
                    lo_o <= 0;
                    local_busy <= 0;
                    div_start <= 0;
                    div_op <= 0;
                    mult_start <= 0;
                    mult_op <= 0;
                end
            //乘除法 0001:mult 0010:multu 0011:div  0100:divu
            else if((mult_en | div_en) && ~local_busy)
                begin
//                    rs <= temp_rs;
//                    rt <= temp_rt;
                    rs <= rs_E_i;
                    rt <= rt_E_i;
                    
                    mult_start <= mult_en;
                    mult_op <= (mult_div_op_E_i == 4'b0001) ? 1'b1 : 1'b0;
                    
                    div_start <= div_en;
                    div_op <= (mult_div_op_E_i == 4'b0011) ? 1'b1 : 1'b0;
                    
                    local_busy <= 1;
                end
            else if(local_busy)
                begin
                    div_start <= 0;
                    mult_start <= 0;
                    if(div_result_ok)
                        begin
                            hi_o <= div_hi;
                            lo_o <= div_lo;
                            local_busy <= 0;
                        end
                    else if(mult_result_ok)
                        begin
                            hi_o <= mult_hi;
                            lo_o <= mult_lo;
                            local_busy <= 0;
                        end
                end
            //mthi
            else if(mult_div_op_E_i == 4'b0111)
                begin
                    hi_o <= rs_E_i;
//                    hi_o <= (Forward_rs_E_i == 2'b00) ? rs_E_i :
//                            (Forward_rs_E_i == 2'b01) ? ALUResult_ED_i :
//                            (Forward_rs_E_i == 2'b11) ? ALUResult_M_i :
//                            (Forward_rs_E_i == 2'b10) ? DataToReg_W_i :
//                            32'd0;
//                    hi_o <=  rs_E_i;
                end
            //mtlo
            else if(mult_div_op_E_i == 4'b1000)
                begin
                    lo_o <= rs_E_i;
//                    lo_o <= (Forward_rs_E_i == 2'b00) ? rs_E_i :
//                            (Forward_rs_E_i == 2'b01) ? ALUResult_ED_i :
//                            (Forward_rs_E_i == 2'b11) ? ALUResult_M_i :
//                            (Forward_rs_E_i == 2'b10) ? DataToReg_W_i :
//                            32'd0;
//                    lo_o <= rs_E_i;
                end
        end
    
    
    
endmodule
