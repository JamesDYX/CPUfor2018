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
    
    wire [31:0] rd1_DE, rd2_DE, sign_imme_DE, unsign_imme_DE, imme_tohigh_DE, rd1_SEL, rd2_SEL, sign_imme_SEL, unsign_imme_SEL, imme_tohigh_SEL, rd2_EX, rd2_MEM1_in, rd2_MEM1, rd2_MEM2;
    
    wire [31:0] reg_data_EX, reg_data_MEM1, reg_data_MEM2, reg_data_WB;
    wire reg_wen_SEL, reg_wen_EX, reg_wen_MEM1, reg_wen_MEM2, reg_wen_WB;
    wire [1:0] reg_sel_WB;
    wire [4:0] reg_rt_WB, reg_rd_WB;
    wire mwen_SEL, mwen_EX, mwen_MEM1, mwen_MEM2;
    wire [31:0] alu_data1_SEL, alu_data2_SEL, alu_data1_EX, alu_data2_EX, alu_data1_EX_in, alu_data2_EX_in;
    
    wire [31:0] newpc;
    wire jump;
    wire [3:0] aluop_SEL, aluop_EX, mult_div_op_SEL, mult_div_op_EX;
    wire [1:0] memop_SEL, memop_EX, memop_MEM1, memop_MEM2;
    
    wire [31:0] hi_EX, lo_EX, aluresult_EX, hi_MEM1, lo_MEM1, aluresult_MEM1, hi_MEM2, lo_MEM2, aluresult_MEM2, hi_WB, lo_WB, aluresult_WB;
    wire busy_EX, overflow_EX, overflow_MEM1, overflow_MEM2;
    
    wire [31:0] mdata_MEM2, mdata_WB;
    
    wire [31:0] harzard_ctrl_SEL, harzard_ctrl_EX, harzard_ctrl_MEM1, harzard_ctrl_MEM2, harzard_ctrl_WB;
    
    wire stall, wrong_guess, not_jump;
    
    IF1 IF1(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .jump(jump),
        .newpc(newpc),
        .instr_addr(pc_IF1),
        .wrong_guess(wrong_guess)
    );
    
    IF1_IF2 IF1_IF2(
        .clk(clk),
        .rst(rst),
        .en(~stall),
        .clr(wrong_guess),
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
        .en(~stall),
        .clr(wrong_guess),
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
        .en(~stall),
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
        .memop(memop_SEL),
        .harzard_ctrl(harzard_ctrl_SEL),
        .regd_1(harzard_ctrl_EX[`RD]),
        .T_new_1(harzard_ctrl_EX[2:0]),
        .data_1(reg_data_EX),
        .regd_2(harzard_ctrl_MEM1[`RD]),
        .T_new_2(harzard_ctrl_MEM1[2:0]),
        .data_2(reg_data_MEM1),
        .regd_3(harzard_ctrl_MEM2[`RD]),
        .T_new_3(harzard_ctrl_MEM2[2:0]),
        .data_3(reg_data_MEM2),
        .regd_4(harzard_ctrl_WB[`RD]),
        .T_new_4(harzard_ctrl_WB[2:0]),
        .data_4(reg_data_WB),
        .not_jump(not_jump)
    );
    
    HARZARD_STALL HARZARD_STALL(
        .rs(harzard_ctrl_SEL[`RS]),
        .rt(harzard_ctrl_SEL[`RT]),
        .T_use_rs(harzard_ctrl_SEL[8:6]),
        .T_use_rt(harzard_ctrl_SEL[5:3]),
        .rd_1(harzard_ctrl_EX[`RD]),
        .T_new_1(harzard_ctrl_EX[2:0]),
        .rd_2(harzard_ctrl_MEM1[`RD]),
        .T_new_2(harzard_ctrl_MEM1[2:0]),
        .rd_e(harzard_ctrl_MEM2[`RD]),
        .T_new_3(harzard_ctrl_MEM2[2:0]),
        .mult_div_op(mult_div_op_SEL),
        .busy_EX(busy_EX),
        .stall(stall)
    );
    
    SEL_EX SEL_EX(
        .clk(clk),
        .rst(rst),
        .clr(stall),
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
        .not_jump(not_jump),
        .reg_wen_EX(reg_wen_EX),
        .mwen_SEL(mwen_SEL),
        .mwen_EX(mwen_EX),
        .memop_SEL(memop_SEL),
        .memop_EX(memop_EX),
        .harzard_ctrl_SEL(harzard_ctrl_SEL),
        .harzard_ctrl_EX(harzard_ctrl_EX)
    );
    
    FORWARD_DATA_MUX FORWARD_DATA_MUX_EX(
        .alu_result(32'h0000_0000),
        .hi(32'h0000_0000),
        .lo(32'h0000_0000),
        .pc8(pc8_EX),
        .instr(instr_EX),
        .data_o(reg_data_EX)
    );
    
    HAZARD_FORWARD HAZARD_FORWARD_EX_rs(
        .r(harzard_ctrl_EX[`RS]),
        .data_in(alu_data1_EX),
        .rd_1(harzard_ctrl_MEM1[`RD]),
        .T_new_1(harzard_ctrl_MEM1[2:0]),
        .data_1(reg_data_MEM1),
        .rd_2(harzard_ctrl_MEM2[`RD]),
        .T_new_2(harzard_ctrl_MEM2[2:0]),
        .data_2(reg_data_MEM2),
         .rd_3(harzard_ctrl_WB[`RD]),
        .T_new_3(harzard_ctrl_WB[2:0]),
        .data_3(reg_data_WB),
        .data_out(alu_data1_EX_in)
    );
    
     HAZARD_FORWARD HAZARD_FORWARD_EX_rt(
        .r(harzard_ctrl_EX[`RT]),
        .data_in(alu_data2_EX),
        .rd_1(harzard_ctrl_MEM1[`RD]),
        .T_new_1(harzard_ctrl_MEM1[2:0]),
        .data_1(reg_data_MEM1),
        .rd_2(harzard_ctrl_MEM2[`RD]),
        .T_new_2(harzard_ctrl_MEM2[2:0]),
        .data_2(reg_data_MEM2),
         .rd_3(harzard_ctrl_WB[`RD]),
        .T_new_3(harzard_ctrl_WB[2:0]),
        .data_3(reg_data_WB),
        .data_out(alu_data2_EX_in)
    );
    
    EX EX(
        .clk(clk),
        .rst(rst),
        .aluop(aluop_EX),
        .mult_div_op(mult_div_op_EX),
        .data1(alu_data1_EX_in),
        .data2(alu_data2_EX_in),
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
        .rd2_MEM1(rd2_MEM1),
        .harzard_ctrl_EX(harzard_ctrl_EX),
        .harzard_ctrl_MEM1(harzard_ctrl_MEM1)
    );
    
    FORWARD_DATA_MUX FORWARD_DATA_MUX_MEM1(
        .alu_result(aluresult_MEM1),
        .hi(hi_MEM1),
        .lo(lo_MEM1),
        .pc8(pc8_MEM1),
        .instr(instr_MEM1),
        .data_o(reg_data_MEM1)
    );
    
    HAZARD_FORWARD HAZARD_FORWARD_MEM1_rt(
        .r(harzard_ctrl_MEM1[`RT]),
        .data_in(rd2_MEM1),
        .rd_1(harzard_ctrl_MEM2[`RD]),
        .T_new_1(harzard_ctrl_MEM2[2:0]),
        .data_1(reg_data_MEM2),
        .rd_2(harzard_ctrl_WB[`RD]),
        .T_new_2(harzard_ctrl_WB[2:0]),
        .data_2(reg_data_WB),
        .data_out(rd2_MEM1_in)
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
        .rd2_MEM1(rd2_MEM1_in),
        .rd2_MEM2(rd2_MEM2),
        .harzard_ctrl_MEM1(harzard_ctrl_MEM1),
        .harzard_ctrl_MEM2(harzard_ctrl_MEM2)
    );
    
    FORWARD_DATA_MUX FORWARD_DATA_MUX_MEM2(
        .alu_result(aluresult_MEM2),
        .hi(hi_MEM2),
        .lo(lo_MEM2),
        .pc8(pc8_MEM2),
        .instr(instr_MEM2),
        .data_o(reg_data_MEM2)
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
        .lo_WB(lo_WB),
        .harzard_ctrl_MEM2(harzard_ctrl_MEM2),
        .harzard_ctrl_WB(harzard_ctrl_WB)
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
