`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/31 22:19:57
// Design Name: 
// Module Name: MEM1
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


module MEM1(
    input [31:0] instr,
    input mwen,
    input [1:0] memop,
    input [31:0] aluresult,
    input [31:0] rd2_MEM1,
    output [3:0] wea,
    output data_addr_exl,
    output syscall_exl,
    output break_exl,
    output eret,
    output CP0_we,
    output [31:0] wdata
    );
    
    assign wea[0] = mwen & ~aluresult[1] & ~aluresult[0];
    assign wea[1] = mwen & ((aluresult[1:0]==2'b00 & memop==2'b00) | (aluresult[1:0]==2'b00 & memop==2'b01) | (aluresult[1:0]==2'b01 & memop==2'b10));
    assign wea[2] = mwen & ((aluresult[1:0]==2'b00 & memop==2'b00) | (aluresult[1:0]==2'b10 & memop==2'b01) | (aluresult[1:0]==2'b10 & memop==2'b10));
    assign wea[3] = mwen & ((aluresult[1:0]==2'b00 & memop==2'b00) | (aluresult[1:0]==2'b10 & memop==2'b01) | (aluresult[1:0]==2'b11 & memop==2'b10));
    
    assign data_addr_exl = (instr[`OPCODE]==`LW & aluresult[1:0]!=2'b00) |
                           (instr[`OPCODE]==`SW & aluresult[1:0]!=2'b00) |
                           (instr[`OPCODE]==`LH & aluresult[0]!=1'b0) |
                           (instr[`OPCODE]==`LHU & aluresult[0]!=1'b0) |
                           (instr[`OPCODE]==`SH & aluresult[0]!=1'b0);
    assign syscall_exl = instr[`OPCODE]==6'b0 && instr[`FUNC]==`SYSCALL;
    assign break_exl = instr[`OPCODE]==6'b0 && instr[`FUNC]==`BREAK;
    assign eret = instr==`ERET;
    assign CP0_we = instr[31:21]==`MTC0;
    
    assign wdata = instr[`OPCODE]==`SH? {2{rd2_MEM1[15:0]}}:
                   instr[`OPCODE]==`SB? {4{rd2_MEM1[7:0]}}:
                   rd2_MEM1;
    
endmodule
