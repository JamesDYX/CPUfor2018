`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/15 11:02:49
// Design Name: 
// Module Name: DATAPATH
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


module DATAPATH(
    input clk,
    input rst
    );
    
    wire [31:0] pc_IF1, pc_IF2;
    wire [31:0] pc4_IF2, pc4_DE, pc4_SEL, pc8_SEL, pc8_EX, pc8_MEM1, pc8_MEM2, pc8_WB;
    wire [31:0] instr_IF2, instr_DE, instr_SEL, instr_EX, instr_MEM1, instr_MEM2, instr_WB;
    
    wire [31:0] rd1_DE, rd2_DE, sign_imme_DE, unsign_imme_DE, imme_tohigh_DE, rd1_SEL, rd2_SEL, sign_imme_SEL, unsign_imme_SEL, imme_tohigh_SEL, rd2_EX, rd2_MEM1, rd2_MEM2;
    
    wire [31:0] reg_data_WB;
    wire reg_wen_SEL, reg_wen_EX, reg_wen_MEM1, reg_wen_MEM2, reg_wen_WB;
    wire [1:0] reg_sel_WB;
    wire [4:0] reg_rt_WB, reg_rd_WB;
    wire mwen_SEL, mwen_EX, mwen_MEM1, mwen_MEM2;
    wire [31:0] alu_data1_SEL, alu_data2_SEL, alu_data1_EX, alu_data2_EX;
    
    wire [31:0] newpc;
    wire jump;
    wire [3:0] aluop_SEL, aluop_EX, mult_div_op_SEL, mult_div_op_EX;
    wire [1:0] memop_SEL, memop_EX, memop_MEM1, memop_MEM2;
    
    wire [31:0] hi_EX, lo_EX, aluresult_EX, hi_MEM1, lo_MEM1, aluresult_MEM1, hi_MEM2, lo_MEM2, aluresult_MEM2, hi_WB, lo_WB, aluresult_WB;
    wire busy_EX, overflow_EX, overflow_MEM1, overflow_MEM2;
    
    wire [31:0] mdata_MEM2, mdata_WB;
    IF1 IF1(
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .jump(jump),
        .newpc(newpc),
        .instr_addr(pc_IF1)
    );
    
    IF1_IF2 IF1_IF2(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .pc_in(pc_IF1),
        .pc_out(pc_IF2),
        .pc4_out(pc4_IF2)
    );
    
    IF2 IF2(
        .clk(clk),
        .instr_we(4'b0000),
        .instr_addr(pc_IF2),
        .instr_in(32'h0000_0000),
        .instr_out(instr_IF2)
    );
    
    IF2_DE IF2_DE(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .instr_IF2(instr_IF2),
        .pc4_IF2(pc4_IF2),
        .instr_DE(instr_DE),
        .pc4_DE(pc4_DE)
    );
    
    DE DE(
        .clk(clk),
        .rst(rst),
        .instr_in(instr_DE),
        .pc4_in(pc4_DE),
        .data(reg_data_WB),
        .wen(reg_wen_WB),
        .reg_sel(reg_sel_WB),
        .rt(reg_rt_WB),
        .rd(reg_rd_WB),
        .rd1(rd1_DE),
        .rd2(rd2_DE),
        .sign_imme(sign_imme_DE),
        .unsign_imme(unsign_imme_DE),
        .imme_tohigh(imme_tohigh_DE)
    );
    
    DE_SEL DE_SEL(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .instr_DE(instr_DE),
        .pc4_DE(pc4_DE),
        .rd1_DE(rd1_DE),
        .rd2_DE(rd2_DE),
        .unsign_imme_DE(unsign_imme_DE),
        .sign_imme_DE(sign_imme_DE),
        .imme_tohigh_DE(imme_tohigh_DE),
        .instr_SEL(instr_SEL),
        .pc4_SEL(pc4_SEL),
        .rd1_SEL(rd1_SEL),
        .rd2_SEL(rd2_SEL),
        .unsign_imme_SEL(unsign_imme_SEL),
        .sign_imme_SEL(sign_imme_SEL),
        .imme_tohigh_SEL(imme_tohigh_SEL)
    );
    
    SEL SEL(
        .instr_in(instr_SEL),
        .unsign_imme(unsign_imme_SEL),
        .sign_imme(sign_imme_SEL),
        .imme_tohigh(imme_tohigh_SEL),
        .pc4_in(pc4_SEL),
        .rd_1(rd1_SEL),
        .rd_2(rd2_SEL),
        .grfwen(reg_wen_SEL),
        .mwen(mwen_SEL),
        .data1(alu_data1_SEL),
        .data2(alu_data2_SEL),
        .newpc(newpc),
        .jump(jump),
        .pc8_out(pc8_SEL),
        .aluop(aluop_SEL),
        .mult_div_op(mult_div_op_SEL),
        .memop(memop_SEL)
    );
    
    SEL_EX SEL_EX(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .rd2_SEL(rd2_SEL),
        .aluop_SEL(aluop_SEL),
        .mult_div_op_SEL(mult_div_op_SEL),
        .alu_data1_SEL(alu_data1_SEL),
        .alu_data2_SEL(alu_data2_SEL),
        .rd2_EX(rd2_EX),
        .aluop_EX(aluop_EX),
        .mult_div_op_EX(mult_div_op_EX),
        .alu_data1_EX(alu_data1_EX),
        .alu_data2_EX(alu_data2_EX),
        .pc8_SEL(pc8_SEL),
        .pc8_EX(pc8_EX),
        .instr_SEL(instr_SEL),
        .instr_EX(instr_EX),
        .reg_wen_SEL(reg_wen_SEL),
        .reg_wen_EX(reg_wen_EX),
        .mwen_SEL(mwen_SEL),
        .mwen_EX(mwen_EX),
        .memop_SEL(memop_SEL),
        .memop_EX(memop_EX)
    );
    
    EX EX(
        .clk(clk),
        .rst(rst),
        .aluop(aluop_EX),
        .mult_div_op(mult_div_op_EX),
        .data1(alu_data1_EX),
        .data2(alu_data2_EX),
        .hi(hi_EX),
        .lo(lo_EX),
        .ALUResult(aluresult_EX),
        .busy(busy_EX),
        .overflow(overflow_EX)
    );
    
    EX_MEM1 EX_MEM1(
        .clk(clk),
        .rst(rst),
        .pc8_EX(pc8_EX),
        .instr_EX(instr_EX),
        .aluresult_EX(aluresult_EX),
        .hi_EX(hi_EX),
        .lo_EX(lo_EX),
        .reg_wen_EX(reg_wen_EX),
        .mwen_EX(mwen_EX),
        .overflow_EX(overflow_EX),
        .pc8_MEM1(pc8_MEM1),
        .instr_MEM1(instr_MEM1),
        .aluresult_MEM1(aluresult_MEM1),
        .hi_MEM1(hi_MEM1),
        .lo_MEM1(lo_MEM1),
        .reg_wen_MEM1(reg_wen_MEM1),
        .mwen_MEM1(mwen_MEM1),
        .overflow_MEM1(overflow_MEM1),
        .memop_EX(memop_EX),
        .memop_MEM1(memop_MEM1),
        .rd2_EX(rd2_EX),
        .rd2_MEM1(rd2_MEM1)
    );
    
    MEM1_MEM2 MEM1_MEM2(
        .clk(clk),
        .rst(rst),
        .pc8_MEM1(pc8_MEM1),
        .instr_MEM1(instr_MEM1),
        .aluresult_MEM1(aluresult_MEM1),
        .hi_MEM1(hi_MEM1),
        .lo_MEM1(lo_MEM1),
        .reg_wen_MEM1(reg_wen_MEM1),
        .mwen_MEM1(mwen_MEM1),
        .overflow_MEM1(overflow_MEM1),
        .memop_MEM1(memop_MEM1),
        .pc8_MEM2(pc8_MEM2),
        .instr_MEM2(instr_MEM2),
        .aluresult_MEM2(aluresult_MEM2),
        .hi_MEM2(hi_MEM2),
        .lo_MEM2(lo_MEM2),
        .reg_wen_MEM2(reg_wen_MEM2),
        .mwen_MEM2(mwen_MEM2),
        .overflow_MEM2(overflow_MEM2),
        .memop_MEM2(memop_MEM2),
        .rd2_MEM1(rd2_MEM1),
        .rd2_MEM2(rd2_MEM2)
    );
    
    MEM2 MEM2(
        .clk(clk),
        .mwen(mwen_MEM2),
        .memop(memop_MEM2),
        .aluresult(aluresult_MEM2),
        .rd2(rd2_MEM2),
        .mdata(mdata_MEM2)
    );
    
    MEM2_WB MEM2_WB(
        .clk(clk),
        .rst(rst),
        .reg_wen_MEM2(reg_wen_MEM2),
        .instr_MEM2(instr_MEM2),
        .pc8_MEM2(pc8_MEM2),
        .aluresult_MEM2(aluresult_MEM2),
        .mdata_MEM2(mdata_MEM2),
        .hi_MEM2(hi_MEM2),
        .lo_MEM2(lo_MEM2),
        .reg_wen_WB(reg_wen_WB),
        .instr_WB(instr_WB),
        .pc8_WB(pc8_WB),
        .aluresult_WB(aluresult_WB),
        .mdata_WB(mdata_WB),
        .hi_WB(hi_WB),
        .lo_WB(lo_WB)
    );
    
    WB WB(
        .instr(instr_WB),
        .pc8(pc8_WB),
        .aluresult(aluresult_WB),
        .mdata(mdata_WB),
        .hi(hi_WB),
        .lo(lo_WB),
        .reg_data(reg_data_WB),
        .reg_rt(reg_rt_WB),
        .reg_rd(reg_rd_WB),
        .reg_sel(reg_sel_WB)
    );
endmodule
