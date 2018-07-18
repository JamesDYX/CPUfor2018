`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/18 22:32:56
// Design Name: 
// Module Name: MEM2
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


module MEM2(
    input clk,
    input mwen,
    input [1:0] memop,
    input [31:0] aluresult,
    input [31:0] rd2,
    output [31:0] mdata
    );
    
    wire [3:0] wea;
    
    assign wea[0] = mwen & ~aluresult[1] & ~aluresult[0];
    assign wea[1] = mwen & ((aluresult[1:0]==2'b00 & memop==2'b00) | (aluresult[1:0]==2'b00 & memop==2'b01) | (aluresult[1:0]==2'b01 & memop==2'b10));
    assign wea[2] = mwen & ((aluresult[1:0]==2'b00 & memop==2'b00) | (aluresult[1:0]==2'b10 & memop==2'b01) | (aluresult[1:0]==2'b10 & memop==2'b10));
    assign wea[3] = mwen & ((aluresult[1:0]==2'b00 & memop==2'b00) | (aluresult[1:0]==2'b10 & memop==2'b01) | (aluresult[1:0]==2'b11 & memop==2'b10));
    
    DM DM(
        .addra({aluresult[15:2],2'b00}),
        .clka(clk),
        .dina(rd2),
        .douta(mdata),
        .wea(wea)
    );
endmodule
