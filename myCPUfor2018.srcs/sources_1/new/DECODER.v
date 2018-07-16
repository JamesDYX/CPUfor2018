`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/14 11:20:44
// Design Name: 
// Module Name: DECODER
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

module DECODER(
    input [31:0] instr,
    output [3:0] aluop,
    output grfwen,
    output mwen,
    output data1_sel,
    output data2_sel,
    output [1:0] ext_sel
    );
    assign {aluop,grfwen, mwen} = 
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`ADD)? {4'd0,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`ADDU)? {4'd9,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SUB)? {4'd1,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SUBU)? {4'd10,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SLT)? {4'd5,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SLTU)? {4'd11,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`AND)? {4'd2,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`NOR)? {4'd12,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`OR)? {4'd3,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`XOR)? {4'd4,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SLL)? {4'd6,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SLLV)? {4'd6,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SRAV)? {4'd8,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SRA)? {4'd8,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SRLV)? {4'd7,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SRL)? {4'd7,2'b10}:
                   (instr[`OPCODE]==`ADDI)? {4'd0,2'b10}:
                   (instr[`OPCODE]==`ADDIU)? {4'd9,2'b10}:
                   (instr[`OPCODE]==`SLTI)? {4'd5,2'b10}:
                   (instr[`OPCODE]==`SLTIU)? {4'd11,2'b10}:
                   (instr[`OPCODE]==`ANDI)? {4'd2,2'b10}:
                   (instr[`OPCODE]==`ORI)? {4'd3,2'b10}:
                   (instr[`OPCODE]==`XORI)? {4'd4,2'b10}:
                   (instr[`OPCODE]==`LB || instr[`OPCODE]==`LBU || instr[`OPCODE]==`LH || instr[`OPCODE]==`LHU || instr[`OPCODE]==`LW)? {4'd9,2'b01}:
                   (instr[`OPCODE]==`SB || instr[`OPCODE]==`SH || instr[`OPCODE]==`SW)? {4'd9,2'b00}:
                   ({instr[`OPCODE],instr[`RT]}==`BGEZAL)? {4'd15,2'b10}:
                   ({instr[`OPCODE],instr[`RT]}==`BLTZAL)? {4'd15,2'b10}:
                   (instr[`OPCODE]==`JALR)? {4'd15,2'b10}:
                   (instr[`OPCODE]==`JAL)? {4'd15,2'b10}:
                   {4'd15,2'b00};
    assign data1_sel = (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SLL)? 1:
                       (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SRL)? 1:
                       (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SRA)? 1:
                       0;
    assign data2_sel = (instr[`OPCODE]==6'b000000)? 0:1;
    assign ext_sel = (instr[`OPCODE]==`ADDI)? 1:
                          (instr[`OPCODE]==`ADDIU)? 1:
                          (instr[`OPCODE]==`SLTI)? 1:
                          (instr[`OPCODE]==`SLTIU)? 1:
                          (instr[`OPCODE]==`ANDI)? 0:
                          (instr[`OPCODE]==`LUI)? 2:
                          (instr[`OPCODE]==`ORI)? 0:
                          (instr[`OPCODE]==`XORI)? 0:
                          (instr[`OPCODE]==`LB)? 1:
                          (instr[`OPCODE]==`LBU)? 1:
                          (instr[`OPCODE]==`LH)? 1:
                          (instr[`OPCODE]==`LHU)? 1:
                          (instr[`OPCODE]==`LW)? 1:
                          (instr[`OPCODE]==`SW)? 1:
                          (instr[`OPCODE]==`SB)? 1:
                          (instr[`OPCODE]==`SH)? 1:
                          0;
endmodule
