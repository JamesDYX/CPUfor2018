`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/18 23:15:11
// Design Name: 
// Module Name: MEM2_WB
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


module MEM2_WB(
    input clk,
    input rst,
    input reg_wen_MEM2,
    input [31:0] instr_MEM2,
    input [31:0] pc8_MEM2,
    input [31:0] aluresult_MEM2,
    input [31:0] mdata_MEM2,
    input [31:0] hi_MEM2,
    input [31:0] lo_MEM2,
    input [31:0] harzard_ctrl_MEM2,
    input [31:0] CP0_MEM2,
    output reg reg_wen_WB,
    output reg [31:0] instr_WB,
    output reg [31:0] pc8_WB,
    output reg [31:0] aluresult_WB,
    output reg [31:0] mdata_WB,
    output reg [31:0] hi_WB,
    output reg [31:0] lo_WB,
    output reg [31:0] harzard_ctrl_WB,
    output reg [31:0] CP0_WB
    );
    
    always @(posedge clk) begin
        if(rst) begin
            reg_wen_WB <= 0;
            instr_WB<=0;
            pc8_WB<=0;
            aluresult_WB<=0;
            mdata_WB<=0;
            hi_WB<=0;
            lo_WB<=0;
            harzard_ctrl_WB<=0;
            CP0_WB<=0;
        end
        else begin
            reg_wen_WB <= reg_wen_MEM2;
            instr_WB<=instr_MEM2;
            pc8_WB<=pc8_MEM2;
            aluresult_WB<=aluresult_MEM2;
            mdata_WB<=mdata_MEM2;
            hi_WB<=hi_MEM2;
            lo_WB<=lo_MEM2;
            harzard_ctrl_WB<=harzard_ctrl_MEM2[2:0]==0?harzard_ctrl_MEM2:(harzard_ctrl_MEM2-1);
            CP0_WB<=CP0_MEM2;
        end
    end
    
endmodule
