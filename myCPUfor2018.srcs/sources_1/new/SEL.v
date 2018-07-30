`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/16 14:06:30
// Design Name: 
// Module Name: SEL
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


module SEL(
    input [31:0] instr_in,
    input [31:0] unsign_imme,
    input [31:0] sign_imme,
    input [31:0] imme_tohigh,
    input [31:0] pc4_in,
    input [31:0] rd_1,
    input [31:0] rd_2,
    output grfwen,
    output mwen,
    output [31:0] data1,
    output [31:0] data2,
    output [31:0] newpc,
    output jump,
    output [31:0] pc8_out,
    output [3:0] aluop,
    output [3:0] mult_div_op,
    output [1:0] memop,
    output [32:0] harzard_ctrl,
    input [4:0] regd_1,
    input [2:0] T_new_1,
    input [31:0] data_1,
    input [4:0] regd_2,
    input [2:0] T_new_2,
    input [31:0] data_2,
    input [4:0] regd_3,
    input [2:0] T_new_3,
    input [31:0] data_3,
    input [4:0] regd_4,
    input [2:0] T_new_4,
    input [31:0] data_4,
    output not_jump
    );
    
    wire data1_sel, data2_sel;
    wire [1:0] ext_sel;
    wire [31:0] data2_imme;
    wire [31:0] data1_i, data2_i;
    
    assign pc8_out = pc4_in + 4;
    
    DECODER DECODER(
        .instr(instr_in),
        .aluop(aluop),
        .grfwen(grfwen),
        .mwen(mwen),
        .data1_sel(data1_sel),
        .data2_sel(data2_sel),
        .ext_sel(ext_sel),
        .mult_div_op(mult_div_op),
        .memop(memop),
        .harzard_ctrl(harzard_ctrl)
    );
    
    MUX_EXT MUX_EXT(
        .unsign_imme(unsign_imme),
        .sign_imme(sign_imme),
        .imme_tohigh(imme_tohigh),
        .ext_sel(ext_sel),
        .data2_imme(data2_imme)
    );
    
    MUX_DATA1 MUX_DATA1(
        .rd_1(rd_1),
        .sa(instr_in[`SA]),
        .data1_sel(data1_sel),
        .data_1(data1)
    );
    
    MUX_DATA2 MUX_DATA2(
        .rd_2(rd_2),
        .ext_out(data2_imme),
        .data2_sel(data2_sel),
        .data_2(data2)
    );
    
    HAZARD_FORWARD HARZARD_FORWARD_SEL_rs(
        .r(harzard_ctrl[`RS]),
        .data_in(data1),
        .rd_1(regd_1),
        .T_new_1(T_new_1),
        .data_1(data_1),
        .rd_2(regd_2),
        .T_new_2(T_new_2),
        .data_2(data_2),
        .rd_3(regd_3),
        .T_new_3(T_new_3),
        .data_3(data_3),
        .rd_4(regd_4),
        .T_new_4(T_new_4),
        .data_4(data_4),
        .data_out(data1_i)
    );
    
    HAZARD_FORWARD HARZARD_FORWARD_SEL_rt(
        .r(harzard_ctrl[`RT]),
        .data_in(data2),
        .rd_1(regd_1),
        .T_new_1(T_new_1),
        .data_1(data_1),
        .rd_2(regd_2),
        .T_new_2(T_new_2),
        .data_2(data_2),
        .rd_3(regd_3),
        .T_new_3(T_new_3),
        .data_3(data_3),
        .rd_4(regd_4),
        .T_new_4(T_new_4),
        .data_4(data_4),
        .data_out(data2_i)
    );
    
    Branch Branch(
        .instr(instr_in),
        .data1(data1_i),
        .data2(data2_i),
        .pc4(pc4_in),
        .newpc(newpc),
        .jump(jump),
        .not_jump(not_jump)
    );
    
endmodule
