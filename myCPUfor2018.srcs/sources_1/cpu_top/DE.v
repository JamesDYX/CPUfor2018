`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/15 11:46:47
// Design Name: 
// Module Name: DE
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

module DE(
    input clk,
    input rst,
    input [31:0] instr_in,
    input [31:0] pc4_in,
    input [31:0] data,
    input wen,
    input [4:0] wreg,
    output [31:0] rd1,
    output [31:0] rd2,
    output [31:0] sign_imme,
    output [31:0] unsign_imme,
    output [31:0] imme_tohigh
    );
    
    
    GRF GRF(
        .clk(clk),
        .rst(rst),
        .wen(wen),
        .r1(instr_in[`RS]),
        .r2(instr_in[`RT]),
        .wreg(wreg),
        .data(data),
        .rd1(rd1),
        .rd2(rd2)
    );
    
    SEXT SEXT(
        .imme(instr_in[`IMME]),
        .sign_imme(sign_imme),
        .unsign_imme(unsign_imme),
        .imme_tohigh(imme_tohigh)
    );
    
endmodule
