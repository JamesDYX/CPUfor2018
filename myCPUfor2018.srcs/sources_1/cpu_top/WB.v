`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/19 00:15:39
// Design Name: 
// Module Name: WB
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

module WB(
    input [31:0] instr,
    input [31:0] pc8,
    input [31:0] aluresult,
    input [31:0] mdata,
    input [31:0] hi,
    input [31:0] lo,
    input [31:0] CP0,
    output [31:0] reg_data,
    output [4:0] wreg
    );
    
    wire [15:0] hdata_tmp;
    wire [7:0] bdata_tmp;
    
    assign hdata_tmp = aluresult[1]? mdata[31:16] : mdata[15:0];
    assign bdata_tmp = (aluresult[1:0]==2'b00)? mdata[7:0]:
                       (aluresult[1:0]==2'b01)? mdata[15:8]:
                       (aluresult[1:0]==2'b10)? mdata[23:16]:
                       mdata[31:24];
    
    assign reg_data = instr[`OPCODE]==`LW? mdata:
                      instr[`OPCODE]==`LHU? {16'h0000, hdata_tmp}:
                      instr[`OPCODE]==`LH? {{16{hdata_tmp[15]}}, hdata_tmp}:
                      instr[`OPCODE]==`LBU? {24'h0000_00, bdata_tmp}:
                      instr[`OPCODE]==`LB? {{24{bdata_tmp[7]}}, bdata_tmp}:
                      (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MFHI)? hi:
                      (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`MFLO)? lo:
                      instr[`OPCODE]==`JAL? pc8:
                      (instr[`OPCODE]==6'b000000 && instr[`FUNC]==`JALR)? pc8:
                      {instr[`OPCODE], instr[`RT]}==`BGEZAL? pc8:
                      {instr[`OPCODE], instr[`RT]}==`BLTZAL? pc8:
                      (instr[31:21]==`MFC0)? CP0:
                      aluresult;
                      
     assign wreg = (instr[`OPCODE]==6'b000000)? instr[`RD]:
                   instr[`OPCODE]==`JAL? 5'd31:
                   {instr[`OPCODE], instr[`RT]}==`BGEZAL? 5'd31:
                   {instr[`OPCODE], instr[`RT]}==`BLTZAL? 5'd31:
                   instr[`RT];
endmodule
