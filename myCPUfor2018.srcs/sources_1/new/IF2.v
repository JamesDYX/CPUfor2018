`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/13 11:07:47
// Design Name: 
// Module Name: IF2
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


module IF2(
    input clk,
    input  [3:0] instr_we,
    input [31:0] instr_addr,
    input [31:0] instr_in,
    output [31:0] instr_out
    );
    IM IM
    (
        .addra (instr_addr[17:0]),
        .clka (clk),
        .dina (instr_in),
        .douta (instr_out),
        .wea (instr_we)
    );
endmodule
