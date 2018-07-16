`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/16 16:00:37
// Design Name: 
// Module Name: Branch
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
module Branch(
    input [31:0] instr,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] pc4,
    output [31:0] newpc,
    output jump
    );
    
    wire [31:0] newpc_1,newpc_2;
    assign newpc_1 = pc4 + {{14{instr[15]}},instr[`IMME],2'b00};
    assign newpc_2 = {pc4[31:28],instr[`INSTR_INDEX],2'b00};
    assign {newpc,jump} = (instr[`OPCODE]==`BEQ && data1==data2)? {newpc_1,1'b1}:
                          (instr[`OPCODE]==`BNE && data1!=data2)? {newpc_1,1'b1}:
                          ({instr[`OPCODE],instr[`RT]}==`BGEZ && $signed(data1)>=0)? {newpc_1,1'b1}:
                          ({instr[`OPCODE],instr[`RT]}==`BGTZ && $signed(data1)>0)? {newpc_1,1'b1}:
                          ({instr[`OPCODE],instr[`RT]}==`BLEZ && $signed(data1)<=0)? {newpc_1,1'b1}:
                          ({instr[`OPCODE],instr[`RT]}==`BLTZ && $signed(data1)<0)? {newpc_1,1'b1}:
                          ({instr[`OPCODE],instr[`RT]}==`BGEZAL && $signed(data1)>=0)? {newpc_1,1'b1}:
                          ({instr[`OPCODE],instr[`RT]}==`BLTZAL && $signed(data1)<0)? {newpc_1,1'b1}:
                          (instr[`OPCODE]==`J)? {newpc_2,1'b1}:
                          (instr[`OPCODE]==`JAL)? {newpc_2,1'b1}:
                          (instr[`OPCODE]==`JR)? {data1,1'b1}:
                          (instr[`OPCODE]==`JALR)? {data1,1'b1}:
                          {32'h0000_0000,1'b0};
    
endmodule
