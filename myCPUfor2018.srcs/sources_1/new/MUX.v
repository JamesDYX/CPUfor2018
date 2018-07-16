`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/15 16:32:15
// Design Name: 
// Module Name: MUX_GRF
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


module MUX_GRF(
    input [1:0] reg_sel,
    input [4:0] rt,
    input [4:0] rd,
    output [4:0] wreg
    );
    
    assign wreg = reg_sel==0? rd:
                  reg_sel==1? rt:
                  reg_sel==2? 5'd31:
                  rd;
                  
endmodule

module MUX_EXT(
    input [31:0] unsign_imme,
    input [31:0] sign_imme,
    input [31:0] imme_tohigh,
    input [1:0] ext_sel,
    output [31:0] data2_imme
    );
    
    assign data2_imme = ext_sel==0? unsign_imme:
                        ext_sel==1? sign_imme:
                        imme_tohigh;
endmodule

module MUX_DATA1(
    input [31:0] rd_1,
    input [4:0] sa,
    input data1_sel,
    output [31:0] data_1
    );
    
    assign data_1 = data1_sel==1? rd_1: {27'd0,sa};
    
endmodule

module MUX_DATA2(
        input [31:0] rd_2,
        input [31:0] ext_out,
        input data2_sel,
        output [31:0] data_2
    );
    
    assign data_2 = data2_sel==0? rd_2 : ext_out;
    
endmodule