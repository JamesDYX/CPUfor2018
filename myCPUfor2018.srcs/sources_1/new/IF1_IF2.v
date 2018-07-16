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
    input [31:0] pc_in,
    output reg [31:0] pc_out,
    output reg [31:0] pc4_out
    );
    
    always @(posedge clk) begin
        if(rst) begin
            pc_out<=0;
            pc4_out<=0;
        end
        else if(en) begin
            pc_out<=pc_in;
            pc4_out<=pc_in+4;
        end
    end
endmodule
