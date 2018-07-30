`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/29 11:03:54
// Design Name: 
// Module Name: FORWARD_DATA_MUX
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


module FORWARD_DATA_MUX(
    input [31:0] alu_result,
    input [31:0] hi,
    input [31:0] lo,
    input [31:0] pc8,
    input [31:0] instr,
    output [31:0] data_o
    );
    
    assign data_o = (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MFHI)? hi:
                    (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MFLO)? lo:
                    instr[`OPCODE]==`JAL? pc8:
                    (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`JALR)? pc8:
                    {instr[`OPCODE], instr[`RT]}==`BGEZAL? pc8:
                    {instr[`OPCODE], instr[`RT]}==`BLTZAL? pc8:
                     alu_result;
    
endmodule
