`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/17 16:01:11
// Design Name: 
// Module Name: DE_SEL
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


module DE_SEL(
    input clk,
    input rst,
    input en,
    input [31:0] instr_DE,
    input [31:0] pc4_DE,
    input [31:0] rd1_DE,
    input [31:0] rd2_DE,
    input [31:0] unsign_imme_DE,
    input [31:0] sign_imme_DE,
    input [31:0] imme_tohigh_DE,
    input ins_addr_exl_DE,
    input ins_in_delay_DE,
    output reg [31:0] instr_SEL,
    output reg [31:0] pc4_SEL,
    output reg [31:0] rd1_SEL,
    output reg [31:0] rd2_SEL,
    output reg [31:0] unsign_imme_SEL,
    output reg [31:0] sign_imme_SEL,
    output reg [31:0] imme_tohigh_SEL,
    output reg ins_addr_exl_SEL,
    output reg ins_in_delay_SEL
    );
    
    always @(posedge clk) begin
        if(rst) begin
            instr_SEL<=0;
            pc4_SEL<=0;
            rd1_SEL<=0;
            rd2_SEL<=0;
            unsign_imme_SEL<=0;
            sign_imme_SEL<=0;
            imme_tohigh_SEL<=0;
            ins_addr_exl_SEL<=0;
            ins_in_delay_SEL<=0;
        end
        else if(en) begin
            instr_SEL<=instr_DE;
            pc4_SEL<=pc4_DE;
            rd1_SEL<=rd1_DE;
            rd2_SEL<=rd2_DE;
            unsign_imme_SEL<=unsign_imme_DE;
            sign_imme_SEL<=sign_imme_DE;
            imme_tohigh_SEL<=imme_tohigh_DE;
            ins_addr_exl_SEL<=ins_addr_exl_DE;
            ins_in_delay_SEL<=ins_in_delay_DE;
        end
    end
    
endmodule
