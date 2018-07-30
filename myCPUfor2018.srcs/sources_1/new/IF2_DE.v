`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/17 15:23:03
// Design Name: 
// Module Name: IF2_DE
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


module IF2_DE(
    input clk,
    input rst,
    input clr,
    input en,
    input [31:0] instr_IF2,
    input [31:0] pc4_IF2,
    output reg [31:0] instr_DE,
    output reg [31:0] pc4_DE
    );
    
    always @(posedge clk) begin
        if(rst | clr) begin
            instr_DE <=0 ;
            pc4_DE <=0;
        end
        else if(en) begin
            instr_DE <= instr_IF2;
            pc4_DE <= pc4_IF2;
        end
    end
endmodule
