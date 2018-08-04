`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/14 11:10:00
// Design Name: 
// Module Name: SEXT
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


module SEXT(
    input [15:0] imme,
    output [31:0] sign_imme,
    output [31:0] unsign_imme,
    output [31:0] imme_tohigh
    );
    assign sign_imme = {{16{imme[15]}},imme};
    assign unsign_imme = {16'h0000, imme};
    assign imme_tohigh = {imme, 16'h0000};
endmodule
