`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/25 21:49:29
// Design Name: 
// Module Name: HAZARD_FORWARD
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


module HAZARD_FORWARD(
    input [4:0] r,
    input [31:0] data_in,
    input [4:0] rd_1,
    input [2:0] T_new_1,
    input [31:0] data_1,
    input [4:0] rd_2,
    input [2:0] T_new_2,
    input [31:0] data_2,
    input [4:0] rd_3,
    input [2:0] T_new_3,
    input [31:0] data_3,
    input [4:0] rd_4,
    input [2:0] T_new_4,
    input [31:0] data_4,
    output [31:0] data_out
    );
    
    assign data_out = (r==rd_1 & r!=0 & T_new_1==0)? data_1:
                      (r==rd_2 & r!=0 & T_new_2==0)? data_2:
                      (r==rd_3 & r!=0 & T_new_3==0)? data_3:
                      (r==rd_4 & r!=0 & T_new_4==0)? data_4:
                      data_in;
endmodule
