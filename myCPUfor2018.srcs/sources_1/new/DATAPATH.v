`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/15 11:02:49
// Design Name: 
// Module Name: DATAPATH
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


module DATAPATH(
    input clk,
    input rst
    );
    
    wire [31:0] pc_IF1, pc_IF2;
    wire [31:0] pc4_IF2;
    wire [31:0] instr_IF2;
    IF1 IF1(
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .instr_addr(pc_IF1)
    );
    
    IF1_IF2 IF1_IF2(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .pc_in(pc_IF1),
        .pc_out(pc_IF2),
        .pc4_out(pc4_IF2)
    );
    
    IF2 IF2(
        .clk(clk),
        .instr_we(4'b0000),
        .instr_addr(pc_IF2),
        .instr_in(32'h0000_0000),
        .instr_out(instr_IF2)
    );
endmodule
