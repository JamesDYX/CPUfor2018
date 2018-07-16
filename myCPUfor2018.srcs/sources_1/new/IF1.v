`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/13 10:19:24
// Design Name: 
// Module Name: IF1
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
`include "define.v"

module IF1(
    input clk,
    input rst,
    input stall,
    output [31:0] instr_addr
    );
    
    reg [31:0] PC;
    assign instr_addr = PC;
    always @(posedge clk) begin
        if (rst) begin
            PC <= `INIT_PC;
        end
        else if(~stall) begin
            PC <= PC+4;
        end
    end
    
endmodule
