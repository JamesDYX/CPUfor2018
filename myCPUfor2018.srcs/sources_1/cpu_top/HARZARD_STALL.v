`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/25 20:33:29
// Design Name: 
// Module Name: HARZARD_STALL
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


module HARZARD_STALL(
    input [4:0] rs,
    input [4:0] rt,
    input [2:0] T_use_rs,
    input [2:0] T_use_rt,
    input [4:0] rd_1,
    input [2:0] T_new_1,
    input [4:0] rd_2,
    input [2:0] T_new_2,
    input [4:0] rd_3,
    input [2:0] T_new_3,
    input [3:0] mult_div_op,
    input busy_EX,
    
    //ERET
    input [31:0] instr_SEL,
    input [31:0] instr_EX,
    input [31:0] instr_MEM1,
    output stall
    );
    
    assign stall = (mult_div_op!=0 & busy_EX) |
                   (rs==rd_1 & rs!=0 & T_use_rs<T_new_1) | 
                   (rt==rd_1 & rt!=0 & T_use_rt<T_new_1) | 
                   (rs==rd_2 & rs!=0 & T_use_rs<T_new_2) | 
                   (rt==rd_2 & rt!=0 & T_use_rt<T_new_2) |
                   (rs==rd_3 & rs!=0 & T_use_rs<T_new_3) | 
                   (rt==rd_3 & rt!=0 & T_use_rt<T_new_3) |
                   (instr_SEL==`ERET  & instr_EX[31:21]==`MTC0 & instr_EX[`RD]==5'b01110 & instr_EX[2:0]==3'b000) | 
                   (instr_SEL==`ERET  & instr_MEM1[31:21]==`MTC0 & instr_MEM1[`RD]==5'b01110 & instr_MEM1[2:0]==3'b000);
endmodule
