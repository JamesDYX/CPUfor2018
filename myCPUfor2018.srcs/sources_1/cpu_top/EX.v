`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/18 14:19:29
// Design Name: 
// Module Name: EX
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


module EX(
    input clk,
    input rst,
    input [3:0] aluop,
    input [3:0] mult_div_op,
    input [31:0] data1,
    input [31:0] data2,
    input data1_sel,
    input data2_sel,
    input [31:0] data2_imme,
    input [4:0] sa,
    input [31:0] hi_MEM1,
    input [31:0] lo_MEM1,
    output [31:0] hi,
    output [31:0] lo,
    output busy,
    output [31:0] ALUResult,
    output overflow,
    input withdraw
    );
    
    wire [31:0] alu_data1, alu_data2;
    
    MUX_DATA1 MUX_DATA1(
        .rd_1(data1),
        .sa(sa),
        .data1_sel(data1_sel),
        .data_1(alu_data1)
    );
    
    MUX_DATA2 MUX_DATA2(
        .rd_2(data2),
        .ext_out(data2_imme),
        .data2_sel(data2_sel),
        .data_2(alu_data2)
    );
    
    ALU ALU(
        .data1(alu_data1),
        .data2(alu_data2),
        .aluop(aluop),
        .result(ALUResult),
        .overflow(overflow)
    );
    
    MULT_DIV MULT_DIV(
        .clk(clk),
        .reset(rst),
        .rs_E_i(alu_data1),
        .rt_E_i(alu_data2),
        .mult_div_op_E_i(mult_div_op),
        .hi_o(hi),
        .lo_o(lo),
        .busy_o(busy),
        .withdraw(withdraw),
        .hi_MEM(hi_MEM1),
        .lo_MEM(lo_MEM1)
    );
    
endmodule
