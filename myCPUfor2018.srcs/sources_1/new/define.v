`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/13 10:50:53
// Design Name: 
// Module Name: define
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
`define INIT_PC 32'h0000_0000

`define OPCODE 31:26
`define RS 25:21
`define RT 20:16
`define RD 15:11
`define SA 10:6
`define FUNC 5:0
`define INSTR_INDEX 25:0
`define IMME 15:0

`define ADD 6'b100000       //IntegerOverflow
`define ADDU 6'b100001
`define SUB 6'b100010       //IntegerOverflow
`define SUBU 6'b100011
`define SLT 6'b101010
`define SLTU 6'b101011  
`define DIV 6'b011010       //
`define DIVU 6'b011011      //
`define MULT 6'b011000      //
`define MULTU 6'b011001     //
`define AND 6'b100100
`define NOR 6'b100111
`define OR 6'b100101
`define XOR 6'b100110
`define SLLV 6'b000100
`define SLL 6'b000000
`define SRAV 6'b000111
`define SRA 6'b000011
`define SRLV 6'b000110
`define SRL 6'b000010
`define JR 6'b001000
`define JALR 6'b001001
`define MFHI 6'b010000
`define MFLO 6'b010010
`define MTHI 6'b010001
`define MTLO 6'b010011
`define BREAK 6'b001101
`define SYSCALL 6'b001100


`define ADDI 6'b001000      //signed, IntegerOverflow
`define ADDIU 6'b001001     //signed
`define SLTI 6'b001010      //signed
`define SLTIU 6'b001011 //signed
`define ANDI 6'b001100
`define LUI 6'b001111
`define ORI 6'b001101
`define XORI 6'b001110
`define BEQ 6'b000100
`define BNE 6'b000101
`define BGEZ 11'b00000100001
`define BGTZ 11'b00011100000
`define BLEZ 11'b00011000000
`define BLTZ 11'b00000100000
`define BGEZAL 11'b00000110001
`define BLTZAL 11'b00000110000
`define LB 6'b100000    //signed
`define LBU 6'b100100
`define LH 6'b100001        //AddrError
`define LHU 6'b100101   //AddrError
`define LW 6'b100011    //AddrError
`define SB 6'b101000
`define SH 6'b101001    //AddrError
`define SW 6'b101011    //AddrError
`define MFC0 11'b01000000000
`define MTC0 11'b01000000100



`define J 6'b000010
`define JAL 6'b000011

`define ERET 32'h42000018