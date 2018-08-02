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
    input rst
    );
    
    wire [31:0] addra_im, addra_dm;
    wire [31:0] douta_im, douta_dm;
    wire [31:0] dina_dm;
    wire [3:0] wea_dm;
    wire ena_im, ena_dm;
    
    DATAPATH DATAPATH(
        .clk(clk),
        .rst(rst),
        .pc_IF1(addra_im),
        .instr_IF2(douta_im),
        .wea_MEM1(wea_dm),
        .aluresult_MEM1(addra_dm),
        .rd2_MEM1_in(dina_dm),
        .mdata_MEM2(douta_dm),
        .ena_IF1(ena_im),
        .ena_MEM1(ena_dm)
    );
    
     IM IM
    (
        .addra (addra_im[11:2]),
        .clka (clk),
        .dina (32'h0000_0000),
        .douta (douta_im),
        .ena(ena_im),
        .wea (4'b0000)
    );
    
    DM DM(
        .addra(addra_dm[19:2]),
        .clka(clk),
        .dina(dina_dm),
        .douta(douta_dm),
        .ena(ena_dm),
        .wea(wea_dm)
    );
    
endmodule
