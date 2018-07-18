`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/18 14:19:29
// Design Name: 
// Module Name: EX
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


module EX(
    input clk,
    input rst,
    input [3:0] aluop,
    input [3:0] mult_div_op,
    input [31:0] data1,
    input [31:0] data2,
    output [31:0] hi,
    output [31:0] lo,
    output busy,
    output ALUResult,
    output overflow
    );
    
    ALU ALU(
        .data1(data1),
        .data2(data2),
        .aluop(aluop),
        .result(ALUResult),
        .overflow(overflow)
    );
    
    MULT_DIV MULT_DIV(
        .clk(clk),
        .reset(rst),
        .rs_E_i(data1),
        .rt_E_i(data1),
        .mult_div_op_i(mult_div_op),
        .hi_o(hi),
        .lo_o(lo),
        .busy_o(busy)
    );
    
endmodule
