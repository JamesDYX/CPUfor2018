`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/17 17:22:18
// Design Name: 
// Module Name: SEL_EX
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


module SEL_EX(
    input clk,
    input rst,
    input clr,
    input [31:0] rd2_SEL,
    input [3:0] aluop_SEL,
    input [31:0] alu_data1_SEL,
    input [31:0] alu_data2_SEL,
    input [3:0] mult_div_op_SEL,
    input reg_wen_SEL,
    input mwen_SEL,
    input [31:0] pc8_SEL,
    input [31:0] instr_SEL,
    input [1:0] memop_SEL,
    input [31:0] harzard_ctrl_SEL,
    input not_jump,     //bgezal, bltzal没有跳转时
    output reg [31:0] alu_data1_EX,
    output reg [31:0] alu_data2_EX,
    output reg [3:0] aluop_EX,
    output reg [31:0] rd2_EX,
    output reg [31:0] mult_div_op_EX,
    output reg [31:0] pc8_EX,
    output reg [31:0] instr_EX,
    output reg reg_wen_EX,
    output reg mwen_EX,
    output reg [1:0] memop_EX,
    output reg [31:0] harzard_ctrl_EX
    );
    
    wire reg_wen_SEL_temp;
    wire [31:0] harzard_ctrl_SEL_temp;
    
    assign reg_wen_SEL_temp = (not_jump)? 0:reg_wen_SEL;
    assign harzard_ctrl_SEL_temp = (not_jump)?{harzard_ctrl_SEL[31:16], 5'b0, harzard_ctrl_SEL[10:0]}:harzard_ctrl_SEL;
    
    always @(posedge clk) begin
        if(rst | clr) begin
            alu_data1_EX<=0;
            alu_data2_EX<=0;
            aluop_EX<=0;
            rd2_EX<=0;
            mult_div_op_EX <=0;
            pc8_EX<=0;
            instr_EX<=0;
            reg_wen_EX<=0;
            mwen_EX<=0;
            memop_EX<=0;
            harzard_ctrl_EX<=0;
        end
        else begin
            alu_data1_EX<=alu_data1_SEL;
            alu_data2_EX<=alu_data2_SEL;
            aluop_EX<=aluop_SEL;
            rd2_EX<=rd2_SEL;
            mult_div_op_EX <= mult_div_op_SEL;
            pc8_EX<=pc8_SEL;
            instr_EX<=instr_SEL;
            reg_wen_EX<=reg_wen_SEL_temp;
            mwen_EX<=mwen_SEL;
            memop_EX<=memop_SEL;
            harzard_ctrl_EX<=harzard_ctrl_SEL[2:0]==0?harzard_ctrl_SEL_temp:(harzard_ctrl_SEL_temp-1);
        end
    end
endmodule
