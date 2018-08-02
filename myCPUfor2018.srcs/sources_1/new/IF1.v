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
    input jump,
    input [31:0] newpc,
    output [31:0] instr_addr,
    output wrong_guess,
    output ins_addr_exl
    );
    
    reg [31:0] PC;
    assign instr_addr = PC;
    assign ins_addr_exl = instr_addr[1:0]!=2'b0;
    assign wrong_guess = jump & (newpc!=PC-4);
    always @(posedge clk) begin
        if (rst) begin
            PC <= `INIT_PC;
        end
        else if(~stall) begin
            if(wrong_guess)
                PC <= newpc;
            else 
                PC <= PC+4;
        end
    end
    
endmodule
