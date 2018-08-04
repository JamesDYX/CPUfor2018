`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/15 10:33:51
// Design Name: 
// Module Name: IF1_IF2
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


module IF1_IF2(
    input clk,
    input rst,
    input en,
    input clrIF2_IF1,
    input [31:0] pc_in,
    input ins_addr_exl_IF1,
    output reg [31:0] pc4_out,
    output reg clrIF2_IF2,
    output reg ins_addr_ex1_IF2
    );
    
    always @(posedge clk) begin
        if(rst) begin
            pc4_out<=0;
            clrIF2_IF2<=0;
            ins_addr_ex1_IF2<=0;
        end
        else if(en) begin
            pc4_out<=pc_in+4;
            clrIF2_IF2<=clrIF2_IF1;
            ins_addr_ex1_IF2<=ins_addr_exl_IF1;
        end
    end
endmodule
