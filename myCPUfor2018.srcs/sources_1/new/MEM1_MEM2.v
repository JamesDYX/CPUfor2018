`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/18 16:43:42
// Design Name: 
// Module Name: MEM1_MEM2
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


module MEM1_MEM2(
    input clk,
    input rst,
    input [31:0] pc8_MEM1,
    input [31:0] instr_MEM1,
    input [31:0] aluresult_MEM1,
    input [31:0] hi_MEM1,
    input [31:0] lo_MEM1,
    input reg_wen_MEM1,
    input mwen_MEM1,
    input overflow_MEM1,
    input [1:0] memop_MEM1,
    input rd2_MEM1,
    output reg [31:0] pc8_MEM2,
    output reg [31:0] instr_MEM2,
    output reg [31:0] aluresult_MEM2,
    output reg [31:0] hi_MEM2,
    output reg [31:0] lo_MEM2,
    output reg reg_wen_MEM2,
    output reg mwen_MEM2,
    output reg overflow_MEM2,
    output reg [1:0] memop_MEM2,
    output reg rd2_MEM2
    );
    
    always @(posedge clk) begin
        if(rst) begin
            pc8_MEM2<=0;
            instr_MEM2<=0;
            aluresult_MEM2<=0;
            hi_MEM2<=0;
            lo_MEM2<=0;
            reg_wen_MEM2<=0;
            mwen_MEM2<=0;
            overflow_MEM2<=0;
            memop_MEM2<=0;
            rd2_MEM2<=0;
        end
        else begin
            pc8_MEM2<=pc8_MEM1;
            instr_MEM2<=instr_MEM1;
            aluresult_MEM2<=aluresult_MEM1;
            hi_MEM2<=hi_MEM1;
            lo_MEM2<=lo_MEM1;
            reg_wen_MEM2<=reg_wen_MEM1;
            mwen_MEM2<=mwen_MEM1;
            overflow_MEM2<=overflow_MEM1;
            memop_MEM2<=memop_MEM1;
            rd2_MEM2<=rd2_MEM1;
        end
    end
endmodule
