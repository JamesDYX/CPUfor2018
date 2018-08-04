`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/18 16:17:57
// Design Name: 
// Module Name: EX_MEM1
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


module EX_MEM1(
    input clk,
    input rst,
    input clr,
    input [31:0] pc8_EX,
    input [31:0] instr_EX,
    input [31:0] aluresult_EX,
    input [31:0] hi_EX,
    input [31:0] lo_EX,
    input reg_wen_EX,
    input mwen_EX,
    input overflow_EX,
    input [1:0] memop_EX,
    input [31:0] rd2_EX,
    input [31:0] harzard_ctrl_EX,
    input ins_addr_exl_EX,
    input ins_in_delay_EX,
    input reserved_ins_exl_EX, 
    input [3:0] mult_div_op_EX, 
    output reg [31:0] pc8_MEM1,
    output reg [31:0] instr_MEM1,
    output reg [31:0] aluresult_MEM1,
    output reg [31:0] hi_MEM1,
    output reg [31:0] lo_MEM1,
    output reg reg_wen_MEM1,
    output reg mwen_MEM1,
    output reg overflow_MEM1,
    output reg [1:0] memop_MEM1,
    output reg [31:0] rd2_MEM1,
    output reg [31:0] harzard_ctrl_MEM1,
    output reg ins_addr_exl_MEM1,
    output reg ins_in_delay_MEM1,
    output reg reserved_ins_exl_MEM1,
    output reg [3:0] mult_div_op_MEM1
    );
    
    always @(posedge clk) begin
        if(rst | clr) begin
            pc8_MEM1<=0;
            instr_MEM1<=0;
            aluresult_MEM1<=0;
            hi_MEM1<=0;
            lo_MEM1<=0;
            reg_wen_MEM1<=0;
            mwen_MEM1<=0;
            overflow_MEM1<=0;
            memop_MEM1<=0;
            rd2_MEM1<=0;
            harzard_ctrl_MEM1<=0;
            ins_addr_exl_MEM1<=0;
            ins_in_delay_MEM1<=0;
            reserved_ins_exl_MEM1<=0;
            mult_div_op_MEM1<=0;
        end
        else begin
            pc8_MEM1<=pc8_EX;
            instr_MEM1<=instr_EX;
            aluresult_MEM1<=aluresult_EX;
            hi_MEM1<=hi_EX;
            lo_MEM1<=lo_EX;
            reg_wen_MEM1<=reg_wen_EX;
            mwen_MEM1<=mwen_EX;
            overflow_MEM1<=overflow_EX;
            memop_MEM1<=memop_EX;
            rd2_MEM1<=rd2_EX;
            harzard_ctrl_MEM1<=harzard_ctrl_EX[2:0]==0?harzard_ctrl_EX:(harzard_ctrl_EX-1);
            ins_addr_exl_MEM1<=ins_addr_exl_EX;
            ins_in_delay_MEM1<=ins_in_delay_EX;
            reserved_ins_exl_MEM1<=reserved_ins_exl_EX;
            mult_div_op_MEM1<=mult_div_op_EX;
        end
    end
    
endmodule
