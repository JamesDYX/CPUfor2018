`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/31 21:55:55
// Design Name: 
// Module Name: soc_sram
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

module soc_sram(
    input clk,
    input rstn
    );
    
    wire inst_sram_en;
    wire [3:0] inst_sram_wen;
    wire[31:0] inst_sram_addr;
    wire [31:0] inst_sram_wdata;
    wire [31:0] inst_sram_rdata;
    
    wire data_sram_en;
    wire [3:0] data_sram_wen;
    wire [31:0] data_sram_addr;
    wire [31:0] data_sram_wdata;
    wire [31:0] data_sram_rdata;
    
    
    mycpu_top DATAPATH(
        .clk(clk),
        .resetn(rstn),
        .int(6'b0),
        .inst_sram_en(inst_sram_en),
        .inst_sram_wen(inst_sram_wen),
        .inst_sram_addr(inst_sram_addr),
        .inst_sram_wdata(inst_sram_wdata),
        .inst_sram_rdata(inst_sram_rdata),
        .data_sram_en(data_sram_en),
        .data_sram_wen(data_sram_wen),
        .data_sram_addr(data_sram_addr),
        .data_sram_wdata(data_sram_wdata),
        .data_sram_rdata(data_sram_rdata)
    );
    
     IM IM
    (
        .addra (inst_sram_addr[19:2]),
        .clka (clk),
        .dina (inst_sram_wdata),
        .douta (inst_sram_rdata),
        .ena(inst_sram_en),
        .wea (inst_sram_wen)
    );
    
    DM DM(
        .addra(data_sram_addr[17:2]),
        .clka(clk),
        .dina(data_sram_wdata),
        .douta(data_sram_rdata),
        .ena(data_sram_en),
        .wea(data_sram_wen)
    );
    
endmodule
