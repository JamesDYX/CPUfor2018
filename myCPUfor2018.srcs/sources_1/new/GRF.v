`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/14 10:47:52
// Design Name: 
// Module Name: GRF
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


module GRF(
    input clk,
    input rst,
    input wen,
    input [4:0] r1,
    input [4:0] r2,
    input [4:0] wreg,
    input [31:0] data,
    output [31:0] rd1,
    output [31:0] rd2
    );
    
    integer i;
    reg [31:0] registers [31:0];
    assign rd1 = (wen && wreg==r1)? data : registers[r1];
    assign rd2 = (wen && wreg==r2)? data : registers[r2];
    
    always @(posedge clk) begin
        if(rst) begin
            for(i=0; i<32; i=i+1) begin
                registers[i]<=0;
            end
        end
        else if(wen && wreg!=0) begin
            registers[wreg] <= data;
        end
    end
endmodule
