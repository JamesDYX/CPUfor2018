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


module mycpu_top(
    input clk,
    input resetn,       //低电平有效
    input [5:0] int,
    
    output inst_sram_en,
    output [3:0] inst_sram_wen,
    output [31:0] inst_sram_addr,
    output [31:0] inst_sram_wdata,
    input [31:0] inst_sram_rdata,
    
    output data_sram_en,
    output [3:0] data_sram_wen,
    output [31:0] data_sram_addr,
    output [31:0] data_sram_wdata,
    input [31:0] data_sram_rdata,
    
    //共验证平台使用的信号
    output [31:0] debug_wb_pc,
    output [3:0] debug_wb_rf_wen,
    output [4:0] debug_wb_rf_wnum,
    output [31:0] debug_wb_rf_wdata
    );
    
    //Sram接口
    wire rst;
    wire ena_IF1, ena_MEM1;
    wire [31:0] pc_IF1, aluresult_MEM1;
    wire [31:0] instr_IF2, mdata_MEM2;
    wire [3:0] wea_MEM1;
    wire [31:0] rd2_MEM1_in;
    assign rst = ~resetn;
    assign inst_sram_en = ena_IF1;
    assign inst_sram_wen = 4'b0;
    assign inst_sram_addr = pc_IF1;
    assign inst_sram_wdata = 32'b0;
    assign instr_IF2 = inst_sram_rdata;
    
    assign data_sram_en = ena_MEM1;
    assign data_sram_wen = wea_MEM1;
    assign data_sram_addr = aluresult_MEM1;
    assign mdata_MEM2 = data_sram_rdata;
    
    wire [31:0] pc4_IF2, pc4_DE, pc4_SEL, pc8_SEL, pc8_EX, pc8_MEM1, pc8_MEM2, pc8_WB;
    wire [31:0] instr_DE, instr_SEL, instr_EX, instr_MEM1, instr_MEM2, instr_WB;
    
    wire [31:0] rd1_DE, rd2_DE, sign_imme_DE, unsign_imme_DE, imme_tohigh_DE, rd1_SEL, rd2_SEL, sign_imme_SEL, unsign_imme_SEL, imme_tohigh_SEL, rd2_EX, rd2_MEM1;
    
    wire [31:0] reg_data_EX, reg_data_MEM1, reg_data_MEM2, reg_data_WB;
    wire reg_wen_SEL, reg_wen_EX, reg_wen_MEM1, reg_wen_MEM2, reg_wen_WB;
    wire [4:0] wreg;
    wire mwen_SEL, mwen_EX, mwen_MEM1;
    wire [31:0] data1_SEL, data2_SEL, data1_EX, data2_EX, data1_EX_in, data2_EX_in;
    
    wire [31:0] newpc;
    wire jump;
    wire [3:0] aluop_SEL, aluop_EX, mult_div_op_SEL, mult_div_op_EX, mult_div_op_MEM1;
    wire [1:0] memop_SEL, memop_EX, memop_MEM1;
    
    wire [31:0] hi_EX, lo_EX, aluresult_EX, hi_MEM1, lo_MEM1, hi_MEM2, lo_MEM2, aluresult_MEM2, hi_WB, lo_WB, aluresult_WB;
    wire busy_EX, overflow_EX, overflow_MEM1;
    
    wire [31:0] mdata_WB;
    
    wire [31:0] harzard_ctrl_SEL, harzard_ctrl_EX, harzard_ctrl_MEM1, harzard_ctrl_MEM2, harzard_ctrl_WB;
    
    wire stall, wrong_guess, not_jump, clrIF2_IF2, trap, withdraw_mult_div;
    
    wire ins_addr_exl_IF1, ins_addr_exl_IF2, ins_addr_exl_DE, ins_addr_exl_SEL, ins_addr_exl_EX, ins_addr_exl_MEM1;
    wire ins_in_delay_DE, ins_in_delay_SEL, ins_in_delay_EX, ins_in_delay_MEM1;
    wire reserved_ins_exl_SEL, reserved_ins_exl_EX, reserved_ins_exl_MEM1;
    wire [31:0] EPC;
    wire [31:0] CP0_MEM1, CP0_MEM2, CP0_WB;
    
    assign ena_IF1 = ~rst & ~stall;
    assign ena_MEM1 = ~rst;
    
    IF1 IF1(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .trap(trap),
        .jump(jump),
        .newpc(newpc),
        .instr_addr(pc_IF1),
        .wrong_guess(wrong_guess),
        .ins_addr_exl(ins_addr_exl_IF1)
    );
    
    IF1_IF2 IF1_IF2(
        .clk(clk),
        .rst(rst),
        .en(~stall | trap),
        .clrIF2_IF1((wrong_guess & ~stall) | trap),
        .clrIF2_IF2(clrIF2_IF2),
        .pc_in(pc_IF1),
        .pc4_out(pc4_IF2),
        .ins_addr_exl_IF1(ins_addr_exl_IF1),
        .ins_addr_ex1_IF2(ins_addr_exl_IF2)
    );
    
    IF2_DE IF2_DE(
        .clk(clk),
        .rst(rst),
        .en(~stall),
        .clr((wrong_guess & ~stall) | clrIF2_IF2 | trap),
        .instr_IF2(instr_IF2),
        .pc4_IF2(pc4_IF2),
        .instr_DE(instr_DE),
        .pc4_DE(pc4_DE),
        .ins_addr_exl_IF2(ins_addr_exl_IF2),
        .ins_addr_exl_DE(ins_addr_exl_DE)
    );
    
    DE DE(
        .clk(clk),
        .rst(rst),
        .instr_in(instr_DE),
        .pc4_in(pc4_DE),
        .data(reg_data_WB),
        .wen(reg_wen_WB),
        .wreg(wreg),
        .rd1(rd1_DE),
        .rd2(rd2_DE),
        .sign_imme(sign_imme_DE),
        .unsign_imme(unsign_imme_DE),
        .imme_tohigh(imme_tohigh_DE)
    );
    
    wire forward_WB_rs, forward_WB_rt, clr_delay_slot;
    
    DE_SEL DE_SEL(
        .clk(clk),
        .rst(rst),
        .en(~stall),
        .clr(trap | (clr_delay_slot & ~stall)),
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
        .imme_tohigh_SEL(imme_tohigh_SEL),
        .ins_addr_exl_DE(ins_addr_exl_DE),
        .ins_addr_exl_SEL(ins_addr_exl_SEL),
        .ins_in_delay_DE(ins_in_delay_DE),
        .ins_in_delay_SEL(ins_in_delay_SEL),
        .reg_data_WB(reg_data_WB),
        .forward_WB_rs(forward_WB_rs),
        .forward_WB_rt(forward_WB_rt)
    );
    
    wire [31:0] data2_imme_SEL, data2_imme_EX;
    wire data1_sel_SEL, data1_sel_EX;
    wire data2_sel_SEL, data2_sel_EX;
    
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
        .data1(data1_SEL),
        .data2(data2_SEL),
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
        .not_jump(not_jump),
        .next_in_delay(ins_in_delay_DE),
        .reserved_ins_exl(reserved_ins_exl_SEL),
        .data1_sel(data1_sel_SEL),
        .data2_sel(data2_sel_SEL),
        .data2_imme(data2_imme_SEL),
        .EPC(EPC),
        .forward_WB_rs(forward_WB_rs),
        .forward_WB_rt(forward_WB_rt),
        .clr_delay_slot(clr_delay_slot)
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
        .rd_3(harzard_ctrl_MEM2[`RD]),
        .T_new_3(harzard_ctrl_MEM2[2:0]),
        .mult_div_op(mult_div_op_SEL),
        .busy_EX(busy_EX),
        .instr_SEL(instr_SEL),
        .instr_EX(instr_EX),
        .instr_MEM1(instr_MEM1),
        .stall(stall)
    );
    
    SEL_EX SEL_EX(
        .clk(clk),
        .rst(rst),
        .clr(stall | trap),
        .aluop_SEL(aluop_SEL),
        .mult_div_op_SEL(mult_div_op_SEL),
        .data1_SEL(data1_SEL),
        .data2_SEL(data2_SEL),
        .aluop_EX(aluop_EX),
        .mult_div_op_EX(mult_div_op_EX),
        .data1_EX(data1_EX),
        .data2_EX(data2_EX),
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
        .harzard_ctrl_EX(harzard_ctrl_EX),
        .ins_addr_exl_SEL(ins_addr_exl_SEL),
        .ins_in_delay_SEL(ins_in_delay_SEL),
        .reserved_ins_exl_SEL(reserved_ins_exl_SEL),
        .ins_addr_exl_EX(ins_addr_exl_EX),
        .ins_in_delay_EX(ins_in_delay_EX),
        .reserved_ins_exl_EX(reserved_ins_exl_EX),
        .data1_sel_SEL(data1_sel_SEL),
        .data2_sel_SEL(data2_sel_SEL) ,
        .data2_imme_SEL(data2_imme_SEL),
        .data1_sel_EX(data1_sel_EX),
        .data2_sel_EX(data2_sel_EX) ,
        .data2_imme_EX(data2_imme_EX)       
    );
    
    FORWARD_DATA_MUX FORWARD_DATA_MUX_EX(
        .alu_result(32'h0000_0000),
        .hi(32'h0000_0000),
        .lo(32'h0000_0000),
        .pc8(pc8_EX),
        .instr(instr_EX),
        .CP0(32'h0000_0000),
        .data_o(reg_data_EX)
    );
    
    HAZARD_FORWARD HAZARD_FORWARD_EX_rs(
        .r(harzard_ctrl_EX[`RS]),
        .data_in(data1_EX),
        .rd_1(harzard_ctrl_MEM1[`RD]),
        .T_new_1(harzard_ctrl_MEM1[2:0]),
        .data_1(reg_data_MEM1),
        .rd_2(harzard_ctrl_MEM2[`RD]),
        .T_new_2(harzard_ctrl_MEM2[2:0]),
        .data_2(reg_data_MEM2),
         .rd_3(harzard_ctrl_WB[`RD]),
        .T_new_3(harzard_ctrl_WB[2:0]),
        .data_3(reg_data_WB),
        .rd_4(5'b0),
        .T_new_4(3'b0),
        .data_4(32'b0),
        .data_out(data1_EX_in)
    );
     
     HAZARD_FORWARD HAZARD_FORWARD_EX_rt(
        .r(harzard_ctrl_EX[`RT]),
        .data_in(data2_EX),
        .rd_1(harzard_ctrl_MEM1[`RD]),
        .T_new_1(harzard_ctrl_MEM1[2:0]),
        .data_1(reg_data_MEM1),
        .rd_2(harzard_ctrl_MEM2[`RD]),
        .T_new_2(harzard_ctrl_MEM2[2:0]),
        .data_2(reg_data_MEM2),
         .rd_3(harzard_ctrl_WB[`RD]),
        .T_new_3(harzard_ctrl_WB[2:0]),
        .data_3(reg_data_WB),
        .rd_4(5'b0),
        .T_new_4(3'b0),
        .data_4(32'b0),
        .data_out(data2_EX_in)
    );
    
    EX EX(
        .clk(clk),
        .rst(rst),
        .aluop(aluop_EX),
        .mult_div_op(trap? 4'b0 : mult_div_op_EX),
        .data1(data1_EX_in),
        .data2(data2_EX_in),
        .data1_sel(data1_sel_EX),
        .data2_sel(data2_sel_EX),
        .data2_imme(data2_imme_EX),
        .sa(instr_EX[`SA]),
        .hi(hi_EX),
        .lo(lo_EX),
        .hi_MEM1(hi_MEM1),
        .lo_MEM1(lo_MEM1),
        .ALUResult(aluresult_EX),
        .busy(busy_EX),
        .overflow(overflow_EX),
        .withdraw(withdraw_mult_div)
    );
    
    assign rd2_EX = data2_EX_in;
    
    EX_MEM1 EX_MEM1(
        .clk(clk),
        .rst(rst),
        .clr(trap),
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
        .harzard_ctrl_MEM1(harzard_ctrl_MEM1),
        .ins_addr_exl_EX(ins_addr_exl_EX),
        .ins_in_delay_EX(ins_in_delay_EX),
        .reserved_ins_exl_EX(reserved_ins_exl_EX),
        .ins_addr_exl_MEM1(ins_addr_exl_MEM1),
        .ins_in_delay_MEM1(ins_in_delay_MEM1),
        .reserved_ins_exl_MEM1(reserved_ins_exl_MEM1),
        .mult_div_op_EX(mult_div_op_EX),
        .mult_div_op_MEM1(mult_div_op_MEM1)  
    );
    
    FORWARD_DATA_MUX FORWARD_DATA_MUX_MEM1(
        .alu_result(aluresult_MEM1),
        .hi(hi_MEM1),
        .lo(lo_MEM1),
        .pc8(pc8_MEM1),
        .instr(instr_MEM1),
        .CP0(32'h0000_0000),
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
         .rd_3(5'b0),
        .T_new_3(3'b0),
        .data_3(32'b0),
        .rd_4(5'b0),
        .T_new_4(3'b0),
        .data_4(32'b0),
        .data_out(rd2_MEM1_in)
    );
    
    wire data_addr_exl;
    wire syscall_exl;
    wire break_exl;
    wire eret;
    wire CP0_we;
    
    MEM1 MEM1(
        .instr(instr_MEM1),
        .mwen(mwen_MEM1),
        .memop(memop_MEM1),
        .aluresult(aluresult_MEM1),
        .wea(wea_MEM1),
        .data_addr_exl(data_addr_exl),
        .syscall_exl(syscall_exl),
        .break_exl(break_exl),
        .eret(eret),
        .CP0_we(CP0_we),
        .rd2_MEM1(rd2_MEM1_in),
        .wdata(data_sram_wdata)
    );
    
    wire [31:0] PC_MEM1;
    assign PC_MEM1 = pc8_MEM1-8;
    assign withdraw_mult_div = trap & mult_div_op_MEM1!=4'b0 & mult_div_op_MEM1!=4'b0101 & mult_div_op_MEM1!=4'b0110;
    
    CP0 CP0(
        .clk(clk),
        .reset(rst),
        .StallF(1'b0),
        .icache_ins_addr_ok_i(1'b1),
        .hdint(int),
        .ins_addr_exl_M(ins_addr_exl_MEM1),
        .error_ins_addr_M(PC_MEM1),
        .ins_in_delay_M(ins_in_delay_MEM1),
        .overflow_M(overflow_MEM1),
        .MemWrite_M(mwen_MEM1),
        .data_addr_exl_M(data_addr_exl),
        .error_data_addr_M(aluresult_MEM1),
        .syscall_exl_M(syscall_exl),
        .break_exl_M(break_exl),
        .reserved_ins_exl_M(reserved_ins_exl_MEM1),
        .pc_M(PC_MEM1),
        .Exl_set(trap),
        .EPC(EPC),
        .eret_M(eret),
        .CP0_we_M_i(CP0_we),
        .rd_addr_M_i(instr_MEM1[`RD]),
        .sel_M_i(instr_MEM1[2:0]),
        .rt_M_i(rd2_MEM1_in),
        .dout(CP0_MEM1)
    );
    
    MEM1_MEM2 MEM1_MEM2(
        .clk(clk),
        .rst(rst),
        .clr(trap),
        .pc8_MEM1(pc8_MEM1),
        .instr_MEM1(instr_MEM1),
        .aluresult_MEM1(aluresult_MEM1),
        .hi_MEM1(hi_MEM1),
        .lo_MEM1(lo_MEM1),
        .reg_wen_MEM1(reg_wen_MEM1),
        .pc8_MEM2(pc8_MEM2),
        .instr_MEM2(instr_MEM2),
        .aluresult_MEM2(aluresult_MEM2),
        .hi_MEM2(hi_MEM2),
        .lo_MEM2(lo_MEM2),
        .reg_wen_MEM2(reg_wen_MEM2),
        .harzard_ctrl_MEM1(harzard_ctrl_MEM1),
        .harzard_ctrl_MEM2(harzard_ctrl_MEM2),
        .CP0_MEM1(CP0_MEM1),
        .CP0_MEM2(CP0_MEM2)
    );
    
    FORWARD_DATA_MUX FORWARD_DATA_MUX_MEM2(
        .alu_result(aluresult_MEM2),
        .hi(hi_MEM2),
        .lo(lo_MEM2),
        .pc8(pc8_MEM2),
        .instr(instr_MEM2),
        .CP0(CP0_MEM2),
        .data_o(reg_data_MEM2)
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
        .harzard_ctrl_WB(harzard_ctrl_WB),
        .CP0_MEM2(CP0_MEM2),
        .CP0_WB(CP0_WB)
    );
    
    WB WB(
        .instr(instr_WB),
        .pc8(pc8_WB),
        .aluresult(aluresult_WB),
        .mdata(mdata_WB),
        .hi(hi_WB),
        .lo(lo_WB),
        .CP0(CP0_WB),
        .reg_data(reg_data_WB),
        .wreg(wreg)
    );
    
   //debug锟脚猴拷
    assign debug_wb_pc = pc8_WB-8;
    assign debug_wb_rf_wen = {4{reg_wen_WB}};
    assign debug_wb_rf_wnum = wreg;
    assign debug_wb_rf_wdata = reg_data_WB;
    
endmodule
