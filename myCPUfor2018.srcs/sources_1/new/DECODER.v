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
    output [3:0] mult_div_op,
    output grfwen,
    output mwen,
    output data1_sel,
    output data2_sel,
    output [1:0] ext_sel,
    output [1:0] memop,
    output [31:0] harzard_ctrl,
    output reserved_ins_exl
    );
    
    assign reserved_ins_exl = harzard_ctrl[8:0]==9'b111111111;
    
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
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MFHI)? {4'd15,2'b10}:
                   (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MFLO)? {4'd15,2'b10}:
                   (instr[`OPCODE]==`ADDI)? {4'd0,2'b10}:
                   (instr[`OPCODE]==`ADDIU)? {4'd9,2'b10}:
                   (instr[`OPCODE]==`SLTI)? {4'd5,2'b10}:
                   (instr[`OPCODE]==`SLTIU)? {4'd11,2'b10}:
                   (instr[`OPCODE]==`ANDI)? {4'd2,2'b10}:
                   (instr[`OPCODE]==`ORI)? {4'd3,2'b10}:
                   (instr[`OPCODE]==`XORI)? {4'd4,2'b10}:
                   (instr[`OPCODE]==`LUI)? {4'd13,2'b10}:
                   (instr[`OPCODE]==`LB || instr[`OPCODE]==`LBU || instr[`OPCODE]==`LH || instr[`OPCODE]==`LHU || instr[`OPCODE]==`LW)? {4'd9,2'b10}:
                   (instr[`OPCODE]==`SB || instr[`OPCODE]==`SH || instr[`OPCODE]==`SW)? {4'd9,2'b01}:
                   ({instr[`OPCODE],instr[`RT]}==`BGEZAL)? {4'd15,2'b10}:
                   ({instr[`OPCODE],instr[`RT]}==`BLTZAL)? {4'd15,2'b10}:
                   (instr[`OPCODE]==`JALR)? {4'd15,2'b10}:
                   (instr[`OPCODE]==`JAL)? {4'd15,2'b10}:
                   (instr[31:21]==`MFC0)? {4'd15,2'b10}:
                   {4'd15,2'b00};
    assign data1_sel = (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SLL)? 1:
                       (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SRL)? 1:
                       (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`SRA)? 1:
                       0;
    assign data2_sel = (instr[`OPCODE]==`BEQ)? 0:
                       (instr[`OPCODE]==`BNE)? 0:
                       (instr[31:21]==`MFC0)? 0:
                       (instr[`OPCODE]==6'b000000)? 0:1;
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
     assign mult_div_op = (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MULT)? 4'b0001:
                          (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MULTU)? 4'b0010:
                          (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`DIV)? 4'b0011:
                          (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`DIVU)? 4'b0100:
                          (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MFHI)? 4'b0101:
                          (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MFLO)? 4'b0110:
                          (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MTHI)? 4'b0111:
                          (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MTLO)? 4'b1000:
                          4'b0000;
      
     assign memop = (instr[`OPCODE]==`SH || instr[`OPCODE]==`LH || instr[`OPCODE]==`LHU)? 2'b01:
                    (instr[`OPCODE]==`SB || instr[`OPCODE]==`LB || instr[`OPCODE]==`LBU)? 2'b10:
                    2'b00;
    
    assign harzard_ctrl[`RS] = (instr[`OPCODE]==`J | instr[`OPCODE]==`JAL)? 5'b00000:
                               instr==`ERET? 5'b00000:
                               instr[31:21]==`MTC0? 5'b00000:
                               instr[31:21]==`MFC0? 5'b00000:
                               (instr[31:21]==6'b000000 & (instr[`FUNC]==`BREAK | instr[`FUNC]==`SYSCALL | instr[`FUNC]==`MFHI | instr[`FUNC]==`MFLO))? 5'b00000:
                               instr[`RS];
    assign harzard_ctrl[`RT] = (instr[`OPCODE]==6'b000000 & instr[`FUNC]!=`BREAK & instr[`FUNC]!=`SYSCALL)? instr[`RT]:
                               (instr[`OPCODE]==`BEQ | instr[`OPCODE]==`BNE | instr[`OPCODE]==`SW | instr[`OPCODE]==`SH | instr[`OPCODE]==`SB)? instr[`RT]:
                               instr[31:21]==`MTC0? instr[`RT]:
                               5'b00000;
                               
    assign harzard_ctrl[`RD] = (instr[`OPCODE]==6'b000000 & instr[`FUNC]==`DIV)? 5'b00000:
                               (instr[`OPCODE]==6'b000000 & instr[`FUNC]==`DIVU)? 5'b00000:
                               (instr[`OPCODE]==6'b000000 & instr[`FUNC]==`MULT)? 5'b00000:
                               (instr[`OPCODE]==6'b000000 & instr[`FUNC]==`MULTU)? 5'b00000:
                               (instr[`OPCODE]==6'b000000 & instr[`FUNC]==`BREAK)? 5'b00000:
                               (instr[`OPCODE]==6'b000000 & instr[`FUNC]==`SYSCALL)? 5'b00000:
                               (instr[`OPCODE]==`SW | instr[`OPCODE]==`SH | instr[`OPCODE]==`SB)? 5'b00000:
                               (instr[`OPCODE]==`BEQ | instr[`OPCODE]==`BNE)? 5'b00000:
                               ({instr[`OPCODE],instr[`RT]}==`BGEZ)? 5'b00000:
                               ({instr[`OPCODE],instr[`RT]}==`BGTZ)? 5'b00000:
                               ({instr[`OPCODE],instr[`RT]}==`BLEZ)? 5'b00000:
                               ({instr[`OPCODE],instr[`RT]}==`BLTZ)? 5'b00000:
                               instr[`OPCODE]==`J? 5'b00000:
                               instr==`ERET? 5'b00000:
                               instr[31:21]==`MTC0? 5'b00000:
                               instr[`OPCODE]==`JAL? 5'b11111:
                               ({instr[`OPCODE],instr[`RT]}==`BGEZAL)? 5'b11111:
                               ({instr[`OPCODE],instr[`RT]}==`BLTZAL)? 5'b11111:
                               (instr[`OPCODE]==5'b00000)? instr[`RD]:
                               instr[`RT];
    assign harzard_ctrl[8:0] = (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`ADD)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`ADDU)? {3'd1, 3'd1, 3'd2}:  
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SUB)? {3'd1, 3'd1, 3'd2}:   
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SUBU)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SLT)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SLTU)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`DIV)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`DIVU)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`MULT)? {3'd1, 3'd1, 3'd2}:    
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`MULTU)? {3'd1, 3'd1, 3'd2}:     
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`AND)? {3'd1, 3'd1, 3'd2}: 
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`NOR)? {3'd1, 3'd1, 3'd2}: 
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`OR)? {3'd1, 3'd1, 3'd2}:      
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`XOR)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SLLV)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SLL)? {3'd0, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SRAV)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SRA)? {3'd0, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SRLV)? {3'd1, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SRL)? {3'd0, 3'd1, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`JR)? {3'd0, 3'd0, 3'd0}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`JALR)? {3'd0, 3'd0, 3'd1}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`MFHI)? {3'd0, 3'd0, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`MFLO)? {3'd0, 3'd0, 3'd2}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`MTHI)? {3'd1, 3'd0, 3'd0}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`MTLO)? {3'd1, 3'd0, 3'd0}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`BREAK)? {3'd0, 3'd0, 3'd0}:
                               (instr[`OPCODE]==6'b000000 &&  instr[`FUNC]==`SYSCALL)? {3'd0, 3'd0, 3'd0}:
                               (instr[`OPCODE]==`ADDI)? {3'd1, 3'd0, 3'd2}:
                               (instr[`OPCODE]==`ADDIU)? {3'd1, 3'd0, 3'd2}:
                               (instr[`OPCODE]==`SLTI)? {3'd1, 3'd0, 3'd2}:
                               (instr[`OPCODE]==`SLTIU)? {3'd1, 3'd0, 3'd2}:
                               (instr[`OPCODE]==`ANDI)? {3'd1, 3'd0, 3'd2}:
                               (instr[`OPCODE]==`LUI)? {3'd1, 3'd0, 3'd2}:
                               (instr[`OPCODE]==`ORI)? {3'd1, 3'd0, 3'd2}:
                               (instr[`OPCODE]==`XORI)? {3'd1, 3'd0, 3'd2}:
                               (instr[`OPCODE]==`LB)? {3'd1, 3'd0, 3'd4}:
                               (instr[`OPCODE]==`LBU)? {3'd1, 3'd0, 3'd4}:
                               (instr[`OPCODE]==`LH)? {3'd1, 3'd0, 3'd4}:
                               (instr[`OPCODE]==`LHU)? {3'd1, 3'd0, 3'd4}:
                               (instr[`OPCODE]==`LW)? {3'd1, 3'd0, 3'd4}:
                               (instr[`OPCODE]==`SB)? {3'd1, 3'd2, 3'd0}:
                               (instr[`OPCODE]==`SH)? {3'd1, 3'd2, 3'd0}:
                               (instr[`OPCODE]==`SW)? {3'd1, 3'd2, 3'd0}:
                               (instr[`OPCODE]==`BEQ)? {3'd0, 3'd0, 3'd0}:
                               (instr[`OPCODE]==`BNE)? {3'd0, 3'd0, 3'd0}:
                               ({instr[`OPCODE],instr[`RT]}==`BGEZ)? {3'd0, 3'd0, 3'd0}:
                               ({instr[`OPCODE],instr[`RT]}==`BGTZ)? {3'd0, 3'd0, 3'd0}:
                               ({instr[`OPCODE],instr[`RT]}==`BLEZ)? {3'd0, 3'd0, 3'd0}:
                               ({instr[`OPCODE],instr[`RT]}==`BLTZ)? {3'd0, 3'd0, 3'd0}:
                               ({instr[`OPCODE],instr[`RT]}==`BGEZAL)? {3'd0, 3'd0, 3'd1}:
                               ({instr[`OPCODE],instr[`RT]}==`BLTZAL)? {3'd0, 3'd0, 3'd0}:
                               (instr[`OPCODE]==`J)? {3'd0, 3'd0, 3'd0}:
                               (instr[`OPCODE]==`JAL)? {3'd0, 3'd0, 3'd1}:
                               (instr==`ERET)? {3'd0, 3'd0, 3'd0}:
                               instr[31:21]==`MFC0? {3'd0, 3'd0, 3'd3}:
                               instr[31:21]==`MTC0? {3'd0, 3'd2, 3'd0}:
                               9'b111111111;
    assign {harzard_ctrl[`OPCODE],harzard_ctrl[10:9]} = 8'b0;
endmodule
